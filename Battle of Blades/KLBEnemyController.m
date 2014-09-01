//
//  KLBEnemyController.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBEnemyController.h"
#import "KLBJSONController.h"
#import "KLBEnemyStore.h"
#import "KLBNotifications.h"

NSUInteger const KLB_ENEMY_TIME_REDUCTION_SPEED_SECONDS = 1; //reduce time by X every second
NSUInteger const KLB_ENEMY_HEALTH_LOSS_ON_ATTACK = 1; // reduce health by X on successful attack
NSUInteger const KLB_ENEMY_HEALTH_TO_DIE = 0; // if health remaining = X, die

@implementation KLBEnemyController

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    [self.timer release];
    
    [super dealloc];
}

#pragma mark - Initializers
// Designated Initializer
- (instancetype)initWithEnemyKey: (NSString *)key {
    self = [super init];
    if (self) {
        self.enemyKey = key;
        self.enemy = [[KLBEnemyStore sharedStore] enemyForKey:key];
        [self registerForNotifications];
    }
    return self;
}

- (instancetype)init {
    NSString *key = [self loadRandomEnemyData];
    return [self initWithEnemyKey:key];
}

#pragma mark - Other Initialization Methods
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startBattleCountdown) name:KLB_NOTIFICATION_BATTLE_START object:nil];
}

#pragma mark - Battle Methods
- (void)startBattleCountdown {
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
   self.timer = [NSTimer scheduledTimerWithTimeInterval:KLB_ENEMY_TIME_REDUCTION_SPEED_SECONDS
                                                      target:self
                                                    selector:@selector(performTimerTickActions)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)performTimerTickActions {
    if (self.enemy.timeLimitSeconds > 0) {
        self.enemy.timeLimitSeconds--;
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ENEMY_TIME_CHANGED
                                                            object:nil
                                                          userInfo:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ENEMY_TIME_OVER
                                                            object:nil
                                                          userInfo:nil];
        [self.timer invalidate];
    }
}

#pragma mark - Enemy Stats Management
- (void)attackSuccess {
    self.enemy.healthRemaining -= KLB_ENEMY_HEALTH_LOSS_ON_ATTACK;
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ENEMY_HEALTH_CHANGED
                                                        object:nil
                                                      userInfo:nil];
    [self checkAlive];
}
- (void)checkAlive {
    if (self.enemy.healthRemaining <= KLB_ENEMY_HEALTH_TO_DIE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ENEMY_HEALTH_ZERO
                                                            object:nil
                                                          userInfo:nil];
    }
}

#pragma mark - Enemy Loading
- (void)loadNewEnemyRandom {
    NSString *key = [self loadRandomEnemyData];
    self.enemy = [[KLBEnemyStore sharedStore] enemyForKey:key];
}

- (NSString *)loadRandomEnemyData {
    NSDictionary *jsonDictionary = [KLBJSONController loadJSONfromFile:KLB_JSON_FILENAME];
    NSDictionary *enemiesList = [jsonDictionary objectForKey:KLB_JSON_ENEMIES_LIST];
    
    NSArray *keys = [enemiesList allKeys];
    NSUInteger randomIndex = arc4random_uniform([keys count]);
    NSString *key = [keys objectAtIndex:randomIndex];
    
    NSString *enemyName = [enemiesList[key] objectForKey:KLB_JSON_ENEMY_NAME];
    NSUInteger enemyLevel = [[enemiesList[key] objectForKey:KLB_JSON_ENEMY_LEVEL] integerValue];
    NSUInteger enemyHealthMaximum = [[enemiesList[key] objectForKey:KLB_JSON_ENEMY_HEALTH_MAXIMUM] integerValue];
    NSUInteger timeLimitSeconds = [[enemiesList[key] objectForKey:KLB_JSON_ENEMY_TIME_LIMIT] integerValue];
    
    KLBEnemy *enemy = [[KLBEnemy alloc] initWithKey:key
                                               name:enemyName
                                              level:enemyLevel
                                      healthMaximum:enemyHealthMaximum
                                   timeLimitSeconds:timeLimitSeconds];
    
    [[KLBEnemyStore sharedStore] addEnemy:enemy forKey:key];
    
    // We return the key (not the retrieved dictionary) because we
    // want to restrict access to the EnemyStore only (which is done
    // via key).
    return key;
}

@end
