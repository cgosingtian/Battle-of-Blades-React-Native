//
//  KLBEnemy.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBEnemy.h"

NSString *const KLB_DEFAULT_ENEMY_KEY = @"Enemy1";
NSString *const KLB_DEFAULT_ENEMY_NAME = @"Enemy";
CGFloat const KLB_DEFAULT_ENEMY_LEVEL = 1;
NSUInteger const KLB_DEFAULT_ENEMY_HEALTH = 5;
NSUInteger const KLB_DEFAULT_ENEMY_TIME_LIMIT_SECONDS = 30;

@implementation KLBEnemy

#pragma mark - Dealloc
- (void)dealloc {
    [_key release];
    [_enemyName release];
    [super dealloc];
}

#pragma mark - Initializers
// Designated Initializer
- (instancetype)initWithKey:(NSString *)key
                       name:(NSString *)enemyName
                      level:(NSUInteger)level
              healthMaximum:(NSUInteger)healthMaximum
           timeLimitSeconds:(NSUInteger)timeLimitSeconds {
    self = [super init];
    if (self) {
        self.key = key;
        self.enemyName = enemyName;
        self.level = level;
        self.healthMaximum = healthMaximum;
        self.healthRemaining = (NSInteger)healthMaximum;
        self.timeLimitSeconds = timeLimitSeconds;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithKey:KLB_DEFAULT_ENEMY_KEY
                        name:KLB_DEFAULT_ENEMY_NAME
                       level:KLB_DEFAULT_ENEMY_LEVEL
               healthMaximum:KLB_DEFAULT_ENEMY_HEALTH
            timeLimitSeconds:KLB_DEFAULT_ENEMY_TIME_LIMIT_SECONDS];

    return self;
}

#pragma mark - Description Override
- (NSString *) description {
    return [NSString stringWithFormat:@"Key: %@, Name: %@, Level: %lu, Health: %lu, Time Limit: %lu",
            self.key,
            self.enemyName,
            (unsigned long)self.level,
            (unsigned long)self.healthMaximum,
            (unsigned long)self.timeLimitSeconds];
}

@end
