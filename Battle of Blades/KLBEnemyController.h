//
//  KLBEnemyController.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBEnemy.h"

@interface KLBEnemyController : NSObject

@property (retain, nonatomic) NSString *enemyKey;
@property (unsafe_unretained, nonatomic) KLBEnemy *enemy;
@property (retain, nonatomic) NSTimer *timer;
- (instancetype)initWithEnemyKey: (NSString *)key;
- (void)loadNewEnemyRandom;
- (NSString *)loadRandomEnemyData;
- (void)attackFail;

@end
