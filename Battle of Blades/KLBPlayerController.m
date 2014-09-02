//
//  KLBPlayerController.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPlayerController.h"
#import "KLBJSONController.h"
#import "KLBPlayerStore.h"
#import "KLBPlayer.h"
#import "KLBNotifications.h"
#import "KLBEnemyStore.h"

NSUInteger const KLB_LEVEL_UP_SCALING_FACTOR = 2;
NSUInteger const KLB_LEVEL_UP_BASE_EXPERIENCE_NEEDED = 10;
CGFloat const KLB_LEVEL_UP_TIME_BONUS_GAINED = 0.25;
NSUInteger const KLB_LEVEL_UP_ENERGY_GAINED = 1;

NSUInteger const KLB_BATTLE_ENERGY_COST = 1;

NSUInteger const KLB_ZERO_INITIALIZER = 0;
CGFloat const KLB_ZERO_F_INITIALIZER = 0.0;

@interface KLBPlayerController () <UIAlertViewDelegate>

@end

@implementation KLBPlayerController

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_player release];
    [super dealloc];
}

#pragma mark - Initializers
- (instancetype) init {
    self = [super init];
    if (self) {
        if (!self.player) {
            //Load Player Data
            [self loadPlayerData];
            [self registerForNotifications];
        }
    }
    return self;
}

#pragma mark - Other Initialization Methods
- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleStartAttempt:)
                                                 name:KLB_NOTIFICATION_BATTLE_START_ATTEMPT
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleStarted:)
                                                 name:KLB_NOTIFICATION_BATTLE_START
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleEnded:)
                                                 name:KLB_NOTIFICATION_BATTLE_END
                                               object:nil];
}

#pragma mark - Data Loading from JSON
- (void)loadPlayerData {
    NSDictionary *jsonDictionary = [KLBJSONController loadJSONfromFile:KLB_JSON_FILENAME];
    NSDictionary *playerData = [jsonDictionary objectForKey:KLB_JSON_PLAYER_DATA];
    
    NSString *playerName = [playerData objectForKey:KLB_JSON_PLAYER_NAME];
    NSUInteger playerLevel = [[playerData objectForKey:KLB_JSON_PLAYER_LEVEL] integerValue];
    CGFloat playerTimeBonus = [[playerData objectForKey:KLB_JSON_PLAYER_TIME_BONUS] floatValue];
    NSUInteger playerExperience = [[playerData objectForKey:KLB_JSON_PLAYER_EXPERIENCE] integerValue];
    NSUInteger playerKills = [[playerData objectForKey:KLB_JSON_PLAYER_KILLS] integerValue];
    NSUInteger playerEnergyMaximum = [[playerData objectForKey:KLB_JSON_PLAYER_ENERGY_MAXIMUM] integerValue];
    NSUInteger playerEnergyCurrent = [[playerData objectForKey:KLB_JSON_PLAYER_ENERGY_CURRENT] integerValue];
    
    KLBPlayer *newPlayer = [[KLBPlayer alloc] initWithName:playerName
                                                     level:playerLevel
                                                 timeBonus:playerTimeBonus
                                                experience:playerExperience
                                                     kills:playerKills
                                             energyMaximum:playerEnergyMaximum
                                             energyCurrent:playerEnergyCurrent];
    self.player = newPlayer;
    
    [[KLBPlayerStore sharedStore] setPlayer:self.player];
    
    [self postNameUpdateNotice];
    [self postLevelUpdateNotice];
    [self postExperienceUpdateNotice];
    [self postEnergyUpdateNotice];
    
    [newPlayer release];
}

#pragma mark - Player Actions Performed
- (void)battleStartAttempt: (NSNotification *)notification {
    if (((NSInteger)self.player.energyCurrent - (NSInteger)KLB_BATTLE_ENERGY_COST) >= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_START
                                                            object:nil
                                                          userInfo:notification.userInfo];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Out of Energy!"
                                                        message:@"Energy replenishes over time. You may also pay $1000 for 1 energy."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Pay $1000",nil];
        [alert show];
    }
}
- (void)battleStarted: (NSNotification *)notification {
    [self reducePlayerEnergy:KLB_BATTLE_ENERGY_COST];
    [self postEnergyUpdateNotice];
}

- (void)battleEnded: (NSNotification *)notification {
    // Victory assumes that a defeated enemy exists
    if (notification.userInfo != nil) {
        NSString *enemyKey = [notification.userInfo objectForKey:KLB_JSON_ENEMY_KEY];
        KLBEnemy *defeatedEnemy = [[KLBEnemyStore sharedStore] enemyForKey:enemyKey];
        NSInteger difficultyMultiplier = [[notification.userInfo objectForKey:KLB_JSON_DIFFICULTY] integerValue];
        NSUInteger totalExperience = defeatedEnemy.level + (defeatedEnemy.level * difficultyMultiplier);
        [self gainExperience:totalExperience];
        [self postExperienceUpdateNotice];
    } else {
        // optional: handle any other player-related penalties here for losing
    }
}

#pragma mark - Post Notifications
- (void)postEnergyUpdateNotice {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_PLAYER_ENERGY_CHANGED
                                                        object:nil
                                                      userInfo:@{
                                                                 KLB_JSON_PLAYER_ENERGY_CURRENT:[NSNumber numberWithInteger:self.player.energyCurrent],
                                                                 KLB_JSON_PLAYER_ENERGY_MAXIMUM:[NSNumber numberWithInteger:self.player.energyMaximum]
                                                                 }];
}
- (void)postExperienceUpdateNotice {
    NSUInteger expToLevel = [self experienceNeededToLevelUp];
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_PLAYER_EXPERIENCE_CHANGED
                                                        object:nil
                                                      userInfo:@{
                                                                 KLB_JSON_PLAYER_EXPERIENCE:[NSNumber numberWithInteger:expToLevel]
                                                                 }];
}
- (void)postLevelUpdateNotice {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_PLAYER_LEVEL_CHANGED
                                                        object:nil
                                                      userInfo:@{
                                                                 KLB_JSON_PLAYER_LEVEL:[NSNumber numberWithInteger:self.player.level]
                                                                 }];
}
- (void)postNameUpdateNotice {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_PLAYER_NAME_CHANGED
                                                        object:nil
                                                      userInfo:@{
                                                                 KLB_JSON_PLAYER_NAME:self.player.name
                                                                 }];
}

#pragma mark - Level Management
- (NSUInteger)levelUp {
    // This method returns the number of levels gained upon checking total experience
    // versus experience to level. Player stats are updated accordingly.
    // Returns 0 if no levels were gained.
    // NOTE: This method is called by gainExperience below.
    NSUInteger levelsGained = 0;
    NSUInteger experienceToLevel = [self experienceToLevel];
    NSUInteger experienceNeededToLevel = [self experienceNeededToLevelUp];
    
    for (int i = experienceNeededToLevel; i <= 0; i+=experienceToLevel) {
        levelsGained++;
    }

    NSUInteger energyGained = KLB_ZERO_INITIALIZER;
    CGFloat timeBonusGained = KLB_ZERO_F_INITIALIZER;
    if (levelsGained > 0) {
        energyGained *= levelsGained;
        timeBonusGained *= levelsGained;
        
        [self increasePlayerEnergy:energyGained];
        [self increasePlayerTimeBonus:timeBonusGained];
        [self increasePlayerLevel:levelsGained];
        
        [self postLevelUpdateNotice];
    }
    
    return levelsGained;
}

- (void)gainExperience:(NSUInteger)amount {
    self.player.experience += amount;
    [self levelUp];
}

- (NSUInteger)experienceToLevel {
    NSUInteger computedExpIncrease = KLB_LEVEL_UP_SCALING_FACTOR * self.player.level;
    NSUInteger modifiedBaseExpToLevel = KLB_LEVEL_UP_BASE_EXPERIENCE_NEEDED * computedExpIncrease;
    return modifiedBaseExpToLevel;
}

- (NSUInteger)experienceNeededToLevelUp {
    NSUInteger experienceNeeded = [self experienceToLevel] - self.player.experience;
    return experienceNeeded;
}

#pragma mark - Update Player Stats
- (void)increasePlayerEnergy:(NSUInteger)gain {
    self.player.energyMaximum += gain;
    [self restorePlayerEnergy];
}

- (void)restorePlayerEnergy {
    self.player.energyCurrent = self.player.energyMaximum;
    [self postEnergyUpdateNotice];
}

- (void)reducePlayerEnergy:(NSUInteger)loss {
    self.player.energyCurrent -= loss;
    [self postEnergyUpdateNotice];
}

- (void)increasePlayerTimeBonus:(NSUInteger)gain {
    self.player.timeBonus += gain;
}

- (void)increasePlayerLevel:(NSUInteger)gain {
    self.player.level += gain;
}

#pragma mark - UIAlertViewDelegate (this is the low priority implementation)
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self restorePlayerEnergy];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Energy Restored!"
                                                        message:@"Thank you for your purchase."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
