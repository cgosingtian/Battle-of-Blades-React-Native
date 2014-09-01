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

NSString *const KLB_LABEL_HEALTH_TEXT_FORMAT = @"Health: ";
NSString *const KLB_LABEL_TIME_LEFT_TEXT_FORMAT = @"Time Left: ";
NSString *const KLB_LABEL_NAME_TEXT_FORMAT = @"";
NSString *const KLB_LABEL_LEVEL_TEXT_FORMAT = @"Level ";

CGFloat const KLB_MAX_ALPHA = 1.0;

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self attackDidSucceed];
}
@end
