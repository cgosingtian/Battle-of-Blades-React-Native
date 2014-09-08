//
//  KLBBattleView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBBattleViewController.h"
#import "KLBJSONController.h"
#import "KLBEnemyStore.h"
#import "KLBEnemy.h"
#import "KLBNotifications.h"
#import "KLBAnimator.h"
#import "KLBPlayerStore.h"
#import "KLBAttackButton.h"
#import "KLBButtonSpawnController.h"
#import "KLBImageStore.h"

CGFloat const KLB_BATTLE_SPEED_SECONDS = 0.75;

NSString *const KLB_LABEL_HEALTH_TEXT_FORMAT = @"Health: ";
NSString *const KLB_LABEL_TIME_LEFT_TEXT_FORMAT = @"Time Left: ";
NSString *const KLB_LABEL_NAME_TEXT_FORMAT = @"";
NSString *const KLB_LABEL_LEVEL_TEXT_FORMAT = @"Level ";
NSString *const KLB_LABEL_EXPERIENCE_TEXT_FORMAT = @"Experience: +";

CGFloat const KLB_MAX_ALPHA = 1.0;
CGFloat const KLB_BUTTON_SPAWN_FADE_IN_DURATION = 0.35;
CGFloat const KLB_BUTTON_SPAWN_CONTROLLER_ALPHA = 0.0;

// Spawn chance percentages should match in terms of decimal places
// If max chance is 100, spawn chance per second should be within 0 - 100.
CGFloat const KLB_BUTTON_SHIELD_SPAWN_CHANCE_PER_SECOND = 0.05; //5%
CGFloat const KLB_BUTTON_SHIELD_SPAWN_CHANCE_MAX = 1.0; //100%
NSUInteger const KLB_BUTTON_SHIELD_SPAWN_MAXIMUM_PER_SECOND = 1;

CGFloat const KLB_VICTORY_FADE_IN_DURATION = 1;
CGFloat const KLB_VICTORY_FADE_OUT_DURATION = 2;
NSString *const KLB_VICTORY_GRADIENT_FILENAME = @"bluegradientbg.png";

CGFloat const KLB_DEFEAT_FADE_IN_DURATION = 1;
CGFloat const KLB_DEFEAT_FADE_OUT_DURATION = 2;
NSString *const KLB_DEFEAT_GRADIENT_FILENAME = @"redgradientbg.png";

NSString *const KLB_DEFEAT_HINT_1 = @"The enemy will heal if you fail to stop his attacks! Tap on the attack icons before they disappear.";
NSString *const KLB_DEFEAT_HINT_2 = @"The enemy can defend his attacks with the blue shield icon, but it can't be everywhere at once. Tapping the blue icon causes you to lose time.";
NSUInteger const KLB_HINT_CHANCE = 2; // random number between 0 and X. If 0, show hint 1, otherwise, show hint 2

NSString *const KLB_BATTLE_GRADIENT_RED_FILENAME = @"redgradientbg.png";
NSString *const KLB_BATTLE_GRADIENT_GREEN_FILENAME = @"greengradientbg.png";
NSString *const KLB_BATTLE_GRADIENT_BLUE_FILENAME = @"bluegradientbg.png";

NSString *const KLB_ENEMY_HARD_IMAGE_FILENAME = @"enemyhard.png";
NSString *const KLB_ENEMY_AVERAGE_IMAGE_FILENAME = @"enemyaverage.png";
NSString *const KLB_ENEMY_EASY_IMAGE_FILENAME = @"enemyeasy.png";

// Difficulty Modifiers
CGFloat const KLB_DIFFICULTY_EASY_SHIELD_SPAWN_CHANCE_MODIFIER = 0.5; // 50%
CGFloat const KLB_DIFFICULTY_AVERAGE_SHIELD_SPAWN_CHANCE_MODIFIER = 1.0; // 100%, same
CGFloat const KLB_DIFFICULTY_HARD_SHIELD_SPAWN_CHANCE_MODIFIER = 2.0; // 200%, double

NSInteger const KLB_ZERO = 0;

@implementation KLBBattleViewController

#pragma mark - Dealloc
- (void)dealloc {
    // Release Timers
    [_battleTimer invalidate];
    [_battleTimer release];
    
    // Release IBOutlet Image Views
    [_enemyImage release];
    [_battleInfoBackground release];
    [_coverView release];
    [_battleGradientBackground release];
    [_victoryImage release];
    
    // Release IBOutlet Labels
    [_healthLabel release];
    [_timeLeftLabel release];
    [_experienceLabel release];
    [_enemyNameLabel release];
    [_enemyLevelLabel release];
    [_defeatLabel release];
    [_defeatHintLabel release];
    
    // Release IBOutletCollection - Button Spawn Controllers
    [_buttonSpawnControllers release];
    
    // Release Enemy Controller
    [_enemyController release];
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self initializeVariables];
        [self instantiateEnemyController];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self initializeVariables];
        [self instantiateEnemyController];
    }
    return self;
}

#pragma mark - Other Initializing Methods
- (void)replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    KLBBattleViewController *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                           bundle:nil]
                                            instantiateWithOwner:self
                                            options:nil]
                                           objectAtIndex:0];
    [self addSubview:actualView];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startBattle:)
                                                 name:KLB_NOTIFICATION_BATTLE_START
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleTimeOver)
                                                 name:KLB_NOTIFICATION_ENEMY_TIME_OVER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleWin)
                                                 name:KLB_NOTIFICATION_ENEMY_HEALTH_ZERO
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondToEnemyNameChange:)
                                                 name:KLB_NOTIFICATION_ENEMY_NAME_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondToEnemyLevelModification:)
                                                 name:KLB_NOTIFICATION_ENEMY_LEVEL_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondToEnemyHealthModification:)
                                                 name:KLB_NOTIFICATION_ENEMY_HEALTH_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondToEnemyTimeModification:)
                                                 name:KLB_NOTIFICATION_ENEMY_TIME_CHANGED
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearShields)
                                                 name:KLB_NOTIFICATION_CHEAT_CLEAR_SHIELDS
                                               object:nil];
}


- (void)initializeVariables {
    //remove all animations - in case the user interrupts an animation mid-way when starting a battle
    [self.victoryImage.layer removeAllAnimations];
    [self.experienceLabel.layer removeAllAnimations];
    [self.defeatLabel.layer removeAllAnimations];
    [self.defeatHintLabel.layer removeAllAnimations];
    [self.battleGradientBackground.layer removeAllAnimations];
    [self.coverView.layer removeAllAnimations];
    
    [self.victoryImage.layer setHidden:YES];
    [self.experienceLabel.layer setHidden:YES];
    [self.defeatLabel.layer setHidden:YES];
    [self.defeatHintLabel.layer setHidden:YES];
    
    //initializations
    self.coverView.alpha = KLB_MAX_ALPHA;
    self.battleGradientBackground.alpha = KLB_ANIMATION_ZERO_F;
    self.battleGradientBackground.layer.opacity = KLB_ANIMATION_ZERO_F;
    self.defeatLabel.alpha = KLB_ANIMATION_ZERO_F;
    self.defeatHintLabel.alpha = KLB_ANIMATION_ZERO_F;
    self.victoryImage.alpha = KLB_ANIMATION_ZERO_F;
    self.victoryImage.layer.opacity = KLB_ANIMATION_ZERO_F;
    self.experienceLabel.alpha = KLB_ANIMATION_ZERO_F;
    self.shieldSpawnChance = KLB_BUTTON_SHIELD_SPAWN_CHANCE_PER_SECOND;
    
    //hide all button spawn controllers from view
    for (KLBButtonSpawnController *buttonSpawnController in self.buttonSpawnControllers) {
        buttonSpawnController.alpha = KLB_BUTTON_SPAWN_CONTROLLER_ALPHA;
    }
    
    self.battleIsActive = NO;
}

- (void)instantiateEnemyController {
    self.enemyController = [[KLBEnemyController alloc] init];
}

#pragma mark - Update Labels Upon Notice
- (void)respondToEnemyNameChange: (NSNotification *)notification {
    NSString *newName = [NSString string];
    if (notification.userInfo) {
        newName = [notification.userInfo objectForKey:KLB_JSON_ENEMY_NAME];
    }
    if (!newName || !notification.userInfo) {
        newName = self.enemyController.enemy.enemyName;
    }
    self.enemyNameLabel.text = [NSString stringWithFormat:@"%@%@",
                                KLB_LABEL_NAME_TEXT_FORMAT,
                                newName];
}
- (void)respondToEnemyLevelModification: (NSNotification *)notification {
    NSUInteger enemyLevel = KLB_ZERO;
    if (notification.userInfo) {
        enemyLevel = [[notification.userInfo objectForKey:KLB_JSON_ENEMY_LEVEL] integerValue];
    }
    if (!enemyLevel || !notification.userInfo) {
        enemyLevel = self.enemyController.enemy.level;
    }
    self.enemyLevelLabel.text = [NSString stringWithFormat:@"%@%lu",
                                 KLB_LABEL_LEVEL_TEXT_FORMAT,
                                 (unsigned long)enemyLevel];
}
- (void)respondToEnemyHealthModification: (NSNotification *)notification {
    NSInteger enemyHealthRemaining = KLB_ZERO;
    if (notification.userInfo) {
        enemyHealthRemaining = (NSInteger)[[notification.userInfo objectForKey:KLB_JSON_ENEMY_HEALTH_REMAINING] integerValue];
    }
    if (!enemyHealthRemaining || !notification.userInfo) {
        enemyHealthRemaining = (NSInteger)self.enemyController.enemy.healthRemaining;
    }
    if (enemyHealthRemaining < KLB_ZERO) {
        enemyHealthRemaining = KLB_ZERO;
    }
    self.healthLabel.text = [NSString stringWithFormat:@"%@%ld",
                             KLB_LABEL_HEALTH_TEXT_FORMAT,
                             (long)enemyHealthRemaining];
}
- (void)respondToEnemyTimeModification: (NSNotification *)notification {
    NSInteger enemyTimeLimit = KLB_ZERO;
    if (!notification.userInfo) {
        enemyTimeLimit = (NSInteger)[[notification.userInfo objectForKey:KLB_JSON_ENEMY_TIME_LIMIT] integerValue];
    }
    if (!enemyTimeLimit || !notification.userInfo) {
        enemyTimeLimit = (NSInteger)self.enemyController.enemy.timeLimitSeconds;
    }
    if (enemyTimeLimit < KLB_ZERO) {
        enemyTimeLimit = KLB_ZERO;
    }
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%@%ld",
                               KLB_LABEL_TIME_LEFT_TEXT_FORMAT,
                               (long)enemyTimeLimit];
}

#pragma mark - Battle Control
- (void)startBattle:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^() {
        if (!self.battleIsActive) {
            [self initializeVariables];
            [self setupButtonSpawnControllers];
    
            NSInteger difficulty = [[notification.userInfo objectForKey:@"difficulty"] integerValue];
            UIImage *enemyImage = nil;
            switch (difficulty) {
                case 0: {
                    self.selectedDifficulty = Easy;
                    enemyImage = [[KLBImageStore sharedStore] imageForFilename:KLB_ENEMY_EASY_IMAGE_FILENAME];
                    self.shieldSpawnChance *= KLB_DIFFICULTY_EASY_SHIELD_SPAWN_CHANCE_MODIFIER;
                } break;
                case 1: {
                    self.selectedDifficulty = Average;
                    enemyImage = [[KLBImageStore sharedStore] imageForFilename:KLB_ENEMY_AVERAGE_IMAGE_FILENAME];
                    self.shieldSpawnChance *= KLB_DIFFICULTY_AVERAGE_SHIELD_SPAWN_CHANCE_MODIFIER;
                } break;
                case 2: {
                    self.selectedDifficulty = Hard;
                    enemyImage = [[KLBImageStore sharedStore] imageForFilename:KLB_ENEMY_HARD_IMAGE_FILENAME];
                    self.shieldSpawnChance *= KLB_DIFFICULTY_HARD_SHIELD_SPAWN_CHANCE_MODIFIER;
                } break;
            }
            if (enemyImage) {
                self.enemyImage.image = enemyImage;
            }
    
            //apply a fade out animation to the coverView, and apply the changes
            [KLBAnimator fadeOutCALayer:self.coverView.layer applyChanges:YES];

            //get the player's time bonus and add it later to the enemy's total time
            KLBPlayer *player = [[KLBPlayerStore sharedStore] player];
            //load an enemy
            self.enemyController.selectedDifficulty = self.selectedDifficulty;
            [self.enemyController loadNewEnemyRandom];
            self.enemyController.enemy.timeLimitSeconds += player.timeBonus;
    
            //configure the screen labels - USE A DELEGATE FOR THIS LATER (low priority)
            [self respondToEnemyHealthModification:nil];
            [self respondToEnemyLevelModification:nil];
            [self respondToEnemyNameChange:nil];
            [self respondToEnemyTimeModification:nil];

            self.battleTimer = [NSTimer scheduledTimerWithTimeInterval:KLB_BATTLE_SPEED_SECONDS
                                                                target:self
                                                              selector:@selector(timePassed)
                                                              userInfo:nil
                                                               repeats:YES];
            self.battleIsActive = YES;
        }
    });
}

- (void)setupButtonSpawnControllers {
    // For each Button Spawn Controller in our IBOutletCollection, set their button Class and Frame
    for (KLBButtonSpawnController *buttonSpawnController in self.buttonSpawnControllers) {
        buttonSpawnController.alpha = KLB_BUTTON_SPAWN_CONTROLLER_ALPHA;
        CGRect spawnFrame = [self generateAttackButtonFrameForSpawnerFrame:buttonSpawnController.frame];
        [buttonSpawnController initializeSpawnerWithButtonClass:[KLBAttackButton class]
                                                          frame:spawnFrame];
    }
}

- (void)timePassed {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BUTTON_SPAWN_START
                                                        object:nil
                                                      userInfo:nil];
    
    // Create shields to block attack buttons based on chance
    NSUInteger numberOfShields = KLB_BUTTON_SHIELD_SPAWN_MAXIMUM_PER_SECOND;
    for (int i = 0; i < numberOfShields; i++) {
        if (arc4random_uniform(KLB_BUTTON_SHIELD_SPAWN_CHANCE_MAX) <= self.shieldSpawnChance) {
            [self spawnShieldButton];
        }
    }
}

- (void)spawnShieldButton {
    // Shield spawns in random location
    CGRect frame = [self generateRandomAttackButtonFrame];
    KLBAttackButton *shieldButton = [[KLBAttackButton alloc] initWithFrame:frame];
    shieldButton.delegate = self;
    [shieldButton setAlpha:KLB_FADE_IN_OPACITY_START];
    [shieldButton convertToShield];
    [self addSubview:shieldButton];
    [KLBAnimator fadeInCALayer:shieldButton.layer duration:KLB_BUTTON_SPAWN_FADE_IN_DURATION applyChanges:YES];
    
    [shieldButton allowMovement];
}

- (CGRect)generateAttackButtonFrameForSpawnerFrame:(CGRect)spawnerFrame {
    CGFloat attackButtonWidth = KLB_ATTACK_BUTTON_WIDTH;
    CGFloat attackButtonHeight = KLB_ATTACK_BUTTON_HEIGHT;
    CGRect attackButtonFrame = CGRectMake(spawnerFrame.origin.x, spawnerFrame.origin.y, attackButtonWidth, attackButtonHeight);
    
    return attackButtonFrame;
}

- (CGRect)generateRandomAttackButtonFrame {
    CGFloat attackButtonWidth = KLB_ATTACK_BUTTON_WIDTH;
    CGFloat attackButtonHeight = KLB_ATTACK_BUTTON_HEIGHT;
    CGFloat topYBuffer = self.battleInfoBackground.frame.size.height;
    
    CGFloat randomX = arc4random_uniform(self.frame.size.width - attackButtonWidth);
    CGFloat randomY = arc4random_uniform(self.frame.size.height - attackButtonHeight - topYBuffer);
    
    randomY += topYBuffer;
    
    CGRect frame = CGRectMake(randomX, randomY, attackButtonWidth, attackButtonHeight);
    return frame;
}

- (void)battleWin {
    // win due to enemy losing health before time runs out
    NSNumber *difficultyValue = [NSNumber numberWithInteger:self.selectedDifficulty];
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_END
                                                        object:nil
                                                      userInfo:@{KLB_JSON_ENEMY_KEY:self.enemyController.enemyKey,
                                                                 KLB_JSON_DIFFICULTY:difficultyValue}];
    [self battleCleanUp:YES];
}
- (void)battleTimeOver {
    // lose due to time running out
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_END
                                                        object:nil
                                                      userInfo:nil];
    [self battleCleanUp:NO];
}

- (void)battleCleanUp:(BOOL)didWin {
    [self.battleTimer invalidate];
    [KLBAnimator fadeInCALayer:self.coverView.layer applyChanges:YES];
    if (didWin) {
        // load the proper gradient for the gradient image view, then apply the flash effect on it
        UIImage *gradientImage = [[KLBImageStore sharedStore] imageForFilename:KLB_VICTORY_GRADIENT_FILENAME];
        self.battleGradientBackground.image = gradientImage;
        [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer
                        fadeInDuration:KLB_VICTORY_FADE_IN_DURATION
                       fadeOutDuration:KLB_VICTORY_FADE_OUT_DURATION
                    applyChangesFadeIn:NO
                   applyChangesFadeOut:YES];
        
        // Experience calculation from Player Controller
        NSUInteger totalExperience = self.enemyController.enemy.level + (self.enemyController.enemy.level * self.selectedDifficulty);
        
        // set and fade in the victory image and experience text
        self.experienceLabel.text = [NSString stringWithFormat:@"%@%lu",
                                     KLB_LABEL_EXPERIENCE_TEXT_FORMAT,
                                     (unsigned long)totalExperience];
        [self.experienceLabel.layer setHidden:NO];
        [KLBAnimator fadeInCALayer:self.experienceLabel.layer
                      applyChanges:YES];
        [self.victoryImage.layer setHidden:NO];
        [KLBAnimator fadeInCALayer:self.victoryImage.layer
                          duration:KLB_VICTORY_FADE_IN_DURATION
                      applyChanges:YES];
    } else {
        // load the proper gradient for the gradient image view, then apply the flash effect on it
        UIImage *gradientImage = [[KLBImageStore sharedStore] imageForFilename:KLB_DEFEAT_GRADIENT_FILENAME];
        self.battleGradientBackground.image = gradientImage;
        [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer
                        fadeInDuration:KLB_DEFEAT_FADE_IN_DURATION
                       fadeOutDuration:KLB_DEFEAT_FADE_OUT_DURATION
                    applyChangesFadeIn:NO
                   applyChangesFadeOut:YES];
        
        // show the defeat label
        [self.defeatLabel.layer setHidden:NO];
        [KLBAnimator fadeInCALayer:self.defeatLabel.layer
                      applyChanges:YES];
        
        // 50% chance for either hint to appear
        arc4random_uniform(KLB_HINT_CHANCE) == 0 ?
        (self.defeatHintLabel.text = KLB_DEFEAT_HINT_1) :
        (self.defeatHintLabel.text = KLB_DEFEAT_HINT_2);
        
        // show the hint via fade in
        [self.defeatHintLabel.layer setHidden:NO];
        [KLBAnimator fadeInCALayer:self.defeatHintLabel.layer
                      applyChanges:YES];
    }
    self.battleIsActive = NO;
}

- (void)clearShields {
    // The buttons will handle destroying themselves; here we just show an effect
    [KLBAnimator flashWhiteCALayer:self.enemyImage.layer duration:0.1 startOpacity:0.0 endOpacity:1.0 applyChanges:NO];
}

#pragma mark - AttackDelegate Protocol
- (void)attackWillSucceed:(id)sender { //optional
    KLBAttackButton *button = (KLBAttackButton *)sender;
    if (button.isShield) { // shield button
        [KLBAnimator flashWhiteCALayer:self.enemyImage.layer applyChanges:NO];
        UIImage *gradientImage = [[KLBImageStore sharedStore] imageForFilename:KLB_BATTLE_GRADIENT_BLUE_FILENAME];
        self.battleGradientBackground.image = gradientImage;
        [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer applyChanges:YES];
    } else { // attack button
        [KLBAnimator flashWhiteCALayer:self.enemyImage.layer applyChanges:NO];
        UIImage *gradientImage = [[KLBImageStore sharedStore] imageForFilename:KLB_BATTLE_GRADIENT_RED_FILENAME];
        self.battleGradientBackground.image = gradientImage;
        [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer applyChanges:YES];
    }
}
- (void)attackDidSucceed:(id)sender { //required
    KLBAttackButton *button = (KLBAttackButton *)sender;
    if (button.isShield) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BLOCK_SUCCESS
                                                            object:nil
                                                          userInfo:nil];
    } else {
        NSNumber *buttonTime = [NSNumber numberWithInteger:button.attack.timeRemainingSeconds];
        NSDictionary *buttonData = @{KLB_JSON_ENEMY_TIME_LIMIT:buttonTime};
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ATTACK_SUCCESS
                                                            object:nil
                                                          userInfo:buttonData];
    }
}
- (void)attackWillFail:(id)sender { //optional
    UIImage *gradientImage = [[KLBImageStore sharedStore] imageForFilename:KLB_BATTLE_GRADIENT_GREEN_FILENAME];
    self.battleGradientBackground.image = gradientImage;
    [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer applyChanges:YES];
}
- (void)attackDidFail:(id)sender { //optional
    // Enemy regains HP for each failed attack
    [self.enemyController attackFail];
}
@end
