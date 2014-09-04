//
//  KLBEnemyController.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBEnemy.h"

extern NSUInteger const KLB_ENEMY_TIME_REDUCTION_SPEED_SECONDS;
extern NSUInteger const KLB_ENEMY_HEALTH_LOSS_ON_ATTACK;
extern NSInteger const KLB_ENEMY_HEALTH_TO_DIE;
extern NSUInteger const KLB_ENEMY_TIME_REDUCTION_ON_BLOCK;

@interface KLBEnemyController : NSObject

@property (nonatomic) BattleDifficulty selectedDifficulty;
@property (retain, nonatomic) NSString *enemyKey;
@property (unsafe_unretained, nonatomic) KLBEnemy *enemy;
@property (retain, nonatomic) NSTimer *timer;
- (instancetype)initWithDifficulty:(BattleDifficulty)selectedDifficulty;
- (void)loadNewEnemyRandom;
- (NSString *)loadRandomEnemyData;
- (void)attackFail;

@end
