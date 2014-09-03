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
#import "KLBAttackButtonStore.h"
#import "KLBAttackButton.h"

CGFloat const KLB_BATTLE_SPEED_SECONDS = 0.75;

NSString *const KLB_LABEL_HEALTH_TEXT_FORMAT = @"Health: ";
NSString *const KLB_LABEL_TIME_LEFT_TEXT_FORMAT = @"Time Left: ";
NSString *const KLB_LABEL_NAME_TEXT_FORMAT = @"";
NSString *const KLB_LABEL_LEVEL_TEXT_FORMAT = @"Level ";
NSString *const KLB_LABEL_EXPERIENCE_TEXT_FORMAT = @"Experience: +";

CGFloat const KLB_MAX_ALPHA = 1.0;
CGFloat const KLB_BUTTON_SPAWN_MAXIMUM_RATIO_TO_HEALTH = 0.5;
NSUInteger const KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN = 10;
CGFloat const KLB_BUTTON_SPAWN_FADE_IN_DURATION = 0.35;
NSInteger const KLB_BUTTON_SPAWN_MINIMUM = 1;

CGFloat const KLB_BUTTON_SHIELD_CONVERT_CHANCE_PERCENT = 8;
CGFloat const KLB_BUTTON_SHIELD_CONVERT_PERCENT = 100;

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

@implementation KLBBattleViewController

#pragma mark - Dealloc
- (void)dealloc {
    [_battleTimer invalidate];
    [_enemyController release];
    [_battleTimer release];
    [_enemyImage release];
    [_battleInfoBackground release];
    [_healthLabel release];
    [_timeLeftLabel release];
    [_coverView release];
    [_enemyNameLabel release];
    [_enemyLevelLabel release];
    [_battleGradientBackground release];
    [_experienceLabel release];
    [_victoryImage release];
    [_defeatLabel release];
    [_defeatHintLabel release];
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self initializeVariables];
        [self instantiateVariables];
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
        [self instantiateVariables];
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
    self.enemyDefenseAllowed = NO;
}

- (void)instantiateVariables {
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
    NSUInteger enemyLevel = 0;
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
    NSUInteger enemyHealthRemaining = 0;
    if (notification.userInfo) {
        enemyHealthRemaining = [[notification.userInfo objectForKey:KLB_JSON_ENEMY_HEALTH_REMAINING] integerValue];
    }
    if (!enemyHealthRemaining || !notification.userInfo) {
        enemyHealthRemaining = self.enemyController.enemy.healthRemaining;
    }
    self.healthLabel.text = [NSString stringWithFormat:@"%@%ld",
                             KLB_LABEL_HEALTH_TEXT_FORMAT,
                             (long)enemyHealthRemaining];
}
- (void)respondToEnemyTimeModification: (NSNotification *)notification {
    // Update the time label:
    NSInteger enemyTimeLimit = 0;
    if (!notification.userInfo) {
        enemyTimeLimit = (NSInteger)[[notification.userInfo objectForKey:KLB_JSON_ENEMY_TIME_LIMIT] integerValue];
    }
    if (!enemyTimeLimit || !notification.userInfo) {
        enemyTimeLimit = (NSInteger)self.enemyController.enemy.timeLimitSeconds;
    }
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%@%ld",
                               KLB_LABEL_TIME_LEFT_TEXT_FORMAT,
                               (long)enemyTimeLimit];
}

#pragma mark - Battle Control
- (void)startBattle:(NSNotification *)notification {
    [self initializeVariables];
    
    NSInteger difficulty = [[notification.userInfo objectForKey:@"difficulty"] integerValue];
    UIImage *enemyImage = nil;
    switch (difficulty) {
        case 0: {
            self.selectedDifficulty = Easy;
            enemyImage = [UIImage imageNamed:KLB_ENEMY_EASY_IMAGE_FILENAME];
            self.enemyDefenseAllowed = false;
            self.enemyMovementAllowed = false;
        } break;
        case 1: {
            self.selectedDifficulty = Average;
            enemyImage = [UIImage imageNamed:KLB_ENEMY_AVERAGE_IMAGE_FILENAME];
            self.enemyDefenseAllowed = true;
            self.enemyMovementAllowed = false;
        } break;
        case 2: {
            self.selectedDifficulty = Hard;
            enemyImage = [UIImage imageNamed:KLB_ENEMY_HARD_IMAGE_FILENAME];
            self.enemyDefenseAllowed = true;
            self.enemyMovementAllowed = true;
        } break;
    }
    if (enemyImage) {
        self.enemyImage.image = enemyImage;
    }
    
    //apply a fade out animation to the coverView, and apply the changes
    [KLBAnimator fadeOutCALayer:self.coverView.layer applyChanges:YES];

    //load an enemy
    [self.enemyController loadNewEnemyRandom];
    
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
}

- (void)timePassed {
    NSUInteger enemyTime = self.enemyController.enemy.timeLimitSeconds;
    if ([[[KLBAttackButtonStore sharedStore] allItems] count] < KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN &&
        enemyTime > 0) {
        NSUInteger enemyHealth = self.enemyController.enemy.healthMaximum;
        NSUInteger minimumButtonSpawns = enemyHealth / enemyTime;
        NSUInteger maximumButtonSpawns = enemyHealth * KLB_BUTTON_SPAWN_MAXIMUM_RATIO_TO_HEALTH;
        NSUInteger numberOfButtons = arc4random_uniform(maximumButtonSpawns);
        if (numberOfButtons < minimumButtonSpawns) {
            if (minimumButtonSpawns == 0)
                numberOfButtons = KLB_BUTTON_SPAWN_MINIMUM;
            numberOfButtons = minimumButtonSpawns;
        } else if (numberOfButtons > KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN) {
            numberOfButtons = KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN;
        }
        for (int i = 0; i < numberOfButtons; i++) {
            [self spawnAttackButton];
        }
    }
}

- (void)spawnAttackButton {
    CGRect frame = [self generateRandomAttackButtonFrame];
    KLBAttackButton *attackButton = [[KLBAttackButton alloc] initWithFrame:frame];
    attackButton.delegate = self;
    [[KLBAttackButtonStore sharedStore] addItem:attackButton];
    [attackButton setAlpha:KLB_FADE_IN_OPACITY_START];
    [self addSubview:attackButton];
    [KLBAnimator fadeInCALayer:attackButton.layer duration:KLB_BUTTON_SPAWN_FADE_IN_DURATION applyChanges:YES];
    
    // Allow the button to move on its own
    if (self.enemyMovementAllowed) {
        [attackButton allowMovement];
    }
    
    // Allow the button to convert to a shield based on chance
    if (self.enemyDefenseAllowed) {
        CGFloat chance = arc4random_uniform(KLB_BUTTON_SHIELD_CONVERT_PERCENT);
        if (chance <= KLB_BUTTON_SHIELD_CONVERT_CHANCE_PERCENT) {
            [attackButton convertToShield];
        }
    }
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
        UIImage *gradientImage = [UIImage imageNamed:KLB_VICTORY_GRADIENT_FILENAME];
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
        UIImage *gradientImage = [UIImage imageNamed:KLB_DEFEAT_GRADIENT_FILENAME];
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
}

#pragma mark - AttackDelegate Protocol
- (void)attackWillSucceed:(id)sender { //optional
    KLBAttackButton *button = (KLBAttackButton *)sender;
    if (button.isShield) { // shield button
        [KLBAnimator flashWhiteCALayer:self.enemyImage.layer applyChanges:NO];
        UIImage *gradientImage = [UIImage imageNamed:KLB_BATTLE_GRADIENT_BLUE_FILENAME];
        self.battleGradientBackground.image = gradientImage;
        [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer applyChanges:YES];
    } else { // attack button
        [KLBAnimator flashWhiteCALayer:self.enemyImage.layer applyChanges:NO];
        UIImage *gradientImage = [UIImage imageNamed:KLB_BATTLE_GRADIENT_RED_FILENAME];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ATTACK_SUCCESS
                                                            object:nil
                                                          userInfo:nil];
    }
}
- (void)attackWillFail:(id)sender { //optional
    UIImage *gradientImage = [UIImage imageNamed:KLB_BATTLE_GRADIENT_GREEN_FILENAME];
    self.battleGradientBackground.image = gradientImage;
    [KLBAnimator flashAlphaCALayer:self.battleGradientBackground.layer applyChanges:YES];
}
- (void)attackDidFail:(id)sender { //optional
    // Enemy regains HP for each failed attack
    [self.enemyController attackFail];
}
@end
