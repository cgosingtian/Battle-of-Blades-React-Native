//
//  KLBBattleView.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLBEnemyController.h"
#import "KLBAttackDelegate.h"

extern CGFloat const KLB_BATTLE_SPEED_SECONDS;

extern NSString *const KLB_LABEL_HEALTH_TEXT_FORMAT;
extern NSString *const KLB_LABEL_TIME_LEFT_TEXT_FORMAT;
extern NSString *const KLB_LABEL_NAME_TEXT_FORMAT;
extern NSString *const KLB_LABEL_LEVEL_TEXT_FORMAT;
extern NSString *const KLB_LABEL_EXPERIENCE_TEXT_FORMAT;

extern CGFloat const KLB_MAX_ALPHA;
extern NSUInteger const KLB_BUTTON_SPAWN_MAXIMUM_ON_SCREEN;
extern CGFloat const KLB_BUTTON_SPAWN_FADE_IN_DURATION;
extern NSInteger const KLB_BUTTON_SPAWN_MAXIMUM_PER_SECOND;
extern NSInteger const KLB_BUTTON_SPAWN_MINIMUM_PER_SECOND;

extern CGFloat const KLB_BUTTON_SHIELD_CONVERT_CHANCE_PERCENT;
extern CGFloat const KLB_BUTTON_SHIELD_CONVERT_PERCENT;

extern CGFloat const KLB_VICTORY_FADE_IN_DURATION;
extern CGFloat const KLB_VICTORY_FADE_OUT_DURATION;
extern NSString *const KLB_VICTORY_GRADIENT_FILENAME;

extern CGFloat const KLB_DEFEAT_FADE_IN_DURATION;
extern CGFloat const KLB_DEFEAT_FADE_OUT_DURATION;
extern NSString *const KLB_DEFEAT_GRADIENT_FILENAME;

extern NSString *const KLB_DEFEAT_HINT_1;
extern NSString *const KLB_DEFEAT_HINT_2;
extern NSUInteger const KLB_HINT_CHANCE;

extern NSString *const KLB_BATTLE_GRADIENT_RED_FILENAME;
extern NSString *const KLB_BATTLE_GRADIENT_GREEN_FILENAME;
extern NSString *const KLB_BATTLE_GRADIENT_BLUE_FILENAME;

extern NSString *const KLB_ENEMY_HARD_IMAGE_FILENAME;
extern NSString *const KLB_ENEMY_AVERAGE_IMAGE_FILENAME;
extern NSString *const KLB_ENEMY_EASY_IMAGE_FILENAME;

@interface KLBBattleViewController : UIView <KLBAttackDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *enemyImage;
@property (retain, nonatomic) IBOutlet UIImageView *battleInfoBackground;
@property (retain, nonatomic) IBOutlet UILabel *healthLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (retain, nonatomic) IBOutlet UIImageView *coverView;
@property (retain, nonatomic) IBOutlet UILabel *enemyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *enemyLevelLabel;
@property (retain, nonatomic) IBOutlet UIImageView *battleGradientBackground;
@property (retain, nonatomic) IBOutlet UILabel *experienceLabel;
@property (retain, nonatomic) IBOutlet UIImageView *victoryImage;
@property (retain, nonatomic) IBOutlet UILabel *defeatLabel;
@property (retain, nonatomic) IBOutlet UILabel *defeatHintLabel;
@property (retain, nonatomic) NSTimer *battleTimer;

@property (retain, nonatomic) KLBEnemyController *enemyController;

@property (nonatomic) BOOL enemyDefenseAllowed;
@property (nonatomic) BOOL enemyMovementAllowed;

@property (nonatomic) BattleDifficulty selectedDifficulty;

@end
