//
//  KLBEnemy.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBEnemy.h"

NSString *const KLB_DEFAULT_ENEMY_NAME = @"Enemy";
CGFloat const KLB_DEFAULT_ENEMY_LEVEL = 1;
NSUInteger const KLB_DEFAULT_ENEMY_HEALTH = 5;
NSUInteger const KLB_DEFAULT_ENEMY_TIME_LIMIT_SECONDS = 30;

@implementation KLBEnemy

#pragma mark - Initializers
// Designated Initializer
- (instancetype)initWithName:(NSString *)name
                       level:(NSUInteger)level
               healthMaximum:(NSUInteger)healthMaximum
            timeLimitSeconds:(NSUInteger)timeLimitSeconds {
    self = [super init];
    if (self) {
        _name = name;
        _level = level;
        _healthMaximum = healthMaximum;
        _healthRemaining = healthMaximum;
        _timeLimitSeconds = timeLimitSeconds;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithName:KLB_DEFAULT_ENEMY_NAME
                        level:KLB_DEFAULT_ENEMY_LEVEL
                healthMaximum:KLB_DEFAULT_ENEMY_HEALTH
             timeLimitSeconds:KLB_DEFAULT_ENEMY_TIME_LIMIT_SECONDS];

    return self;
}

@end
