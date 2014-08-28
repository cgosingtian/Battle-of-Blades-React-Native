//
//  KLBPlayer.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPlayer.h"

NSString *const KLB_DEFAULT_NAME = @"Player";
NSUInteger const KLB_DEFAULT_LEVEL = 1;
CGFloat const KLB_DEFAULT_TIME_BONUS = 0;
NSUInteger const KLB_DEFAULT_EXPERIENCE = 0;
NSUInteger const KLB_DEFAULT_KILLS = 0;

@implementation KLBPlayer

#pragma mark - Initializers
// Designated Initializer
- (instancetype)initWithName:(NSString *)name
                       level:(NSUInteger)level
                   timeBonus:(CGFloat)timeBonus
                  experience:(NSUInteger)experience
                       kills:(NSUInteger)kills {
    self = [super init];
    if (self) {
        _name = name;
        _level = level;
        _timeBonus = timeBonus;
        _experience = experience;
        _kills = kills;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithName:KLB_DEFAULT_NAME
                        level:KLB_DEFAULT_LEVEL
                    timeBonus:KLB_DEFAULT_TIME_BONUS
                   experience:KLB_DEFAULT_EXPERIENCE
                        kills:KLB_DEFAULT_KILLS];
    
    return self;
}

@end
