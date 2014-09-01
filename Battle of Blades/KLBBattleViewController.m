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

NSString *const KLB_LABEL_HEALTH_TEXT_FORMAT = @"Health: ";
NSString *const KLB_LABEL_TIME_LEFT_TEXT_FORMAT = @"Time Left: ";
NSString *const KLB_LABEL_NAME_TEXT_FORMAT = @"";
NSString *const KLB_LABEL_LEVEL_TEXT_FORMAT = @"Level ";

CGFloat const KLB_MAX_ALPHA = 1.0;
CGFloat const KLB_BUTTON_SPAWN_MAXIMUM_RATIO_TO_HEALTH = 0.5;
NSUInteger const KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN = 6;

@implementation KLBBattleViewController

#pragma mark - Dealloc
- (void)dealloc {
    [_enemyImage release];
    [_battleInfoBackground release];
    [_healthLabel release];
    [_timeLeftLabel release];
    [_coverView release];
    [_enemyNameLabel release];
    [_enemyLevelLabel release];
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self showCover];
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
        [self showCover];
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
                                             selector:@selector(startBattle)
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


- (void)showCover {
    self.coverView.alpha = KLB_MAX_ALPHA;
}

- (void)instantiateVariables {
    self.enemyController = [[KLBEnemyController alloc] init];
}

#pragma mark - Update Labels Upon Notice
- (void)respondToEnemyNameChange: (NSNotification *)notification {
    NSString *newName = @"";
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
    self.healthLabel.text = [NSString stringWithFormat:@"%@%lu",
                             KLB_LABEL_HEALTH_TEXT_FORMAT,
                             (unsigned long)enemyHealthRemaining];
}
- (void)respondToEnemyTimeModification: (NSNotification *)notification {
    // Update the time label:
    NSUInteger enemyTimeLimit = 0;
    if (!notification.userInfo) {
        enemyTimeLimit = [[notification.userInfo objectForKey:KLB_JSON_ENEMY_TIME_LIMIT] integerValue];
    }
    if (!enemyTimeLimit || !notification.userInfo) {
        enemyTimeLimit = self.enemyController.enemy.timeLimitSeconds;
    }
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%@%lu",
                               KLB_LABEL_TIME_LEFT_TEXT_FORMAT,
                               (unsigned long)enemyTimeLimit];
    
    // Perform other time-related actions:
    [self timePassed];
}

#pragma mark - Battle Control
- (void)startBattle {
    //apply a fade out animation to the coverView, and apply the changes
    [KLBAnimator fadeOutCALayer:self.coverView.layer applyChanges:YES];

    //load an enemy
    [self.enemyController loadNewEnemyRandom];
    
    //configure the screen labels - USE A DELEGATE FOR THIS LATER (low priority)
    [self respondToEnemyHealthModification:nil];
    [self respondToEnemyLevelModification:nil];
    [self respondToEnemyNameChange:nil];
    [self respondToEnemyTimeModification:nil];
}

- (void)timePassed {
    if ([[[KLBAttackButtonStore sharedStore] allItems] count] < KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN) {
        NSUInteger enemyHealth = self.enemyController.enemy.healthMaximum;
        NSUInteger enemyTime = self.enemyController.enemy.timeLimitSeconds;
        NSUInteger minimumButtonSpawns = enemyHealth / enemyTime;
        NSUInteger maximumButtonSpawns = enemyHealth * KLB_BUTTON_SPAWN_MAXIMUM_RATIO_TO_HEALTH;
        NSUInteger numberOfButtons = arc4random_uniform(maximumButtonSpawns);
        if (numberOfButtons < minimumButtonSpawns) {
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
    [KLBAnimator fadeInCALayer:attackButton.layer applyChanges:YES];
    
//    //move button - make this a toggle option later
//    CGPoint randomPoint = [self generateRandomAttackButtonFrame].origin;
//    [KLBAnimator moveCALayer:attackButton.layer startPoint:attackButton.frame.origin endPoint:randomPoint applyChanges:YES];
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
    NSLog(@"WIN key: %@",self.enemyController.enemyKey);
    // win due to enemy losing health before time runs out
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_END
                                                        object:nil
                                                      userInfo:@{KLB_JSON_ENEMY_KEY:self.enemyController.enemyKey}];
}
- (void)battleTimeOver {
    // lose due to time running out
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_END
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark - AttackDelegate Protocol
- (void)attackWillSucceed { //optional
    
}
- (void)attackDidSucceed { //required
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_ATTACK_SUCCESS
                                                        object:nil
                                                      userInfo:nil];
}
@end
