//
//  KLBPlayer.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPlayer.h"

NSString *const KLB_DEFAULT_PLAYER_NAME = @"Player";
NSUInteger const KLB_DEFAULT_PLAYER_LEVEL = 1;
CGFloat const KLB_DEFAULT_PLAYER_TIME_BONUS = 0;
NSUInteger const KLB_DEFAULT_PLAYER_EXPERIENCE = 0;
NSUInteger const KLB_DEFAULT_PLAYER_KILLS = 0;
NSUInteger const KLB_DEFAULT_PLAYER_ENERGY_MAXIMUM = 10;
NSUInteger const KLB_DEFAULT_PLAYER_ENERGY_CURRENT = 10;

@implementation KLBPlayer
#pragma mark - Dealloc
- (void)dealloc {
    [_name release];
    [super dealloc];
}

#pragma mark - Initializers
// Designated Initializer
- (instancetype)initWithName:(NSString *)name
                       level:(NSUInteger)level
                   timeBonus:(CGFloat)timeBonus
                  experience:(NSUInteger)experience
                       kills:(NSUInteger)kills
               energyMaximum:(NSUInteger)energyMaximum
               energyCurrent:(NSUInteger)energyCurrent {
    self = [super init];
    if (self) {
        self.name = name;
        self.level = level;
        self.timeBonus = timeBonus;
        self.experience = experience;
        self.kills = kills;
        self.energyMaximum = energyMaximum;
        self.energyCurrent = energyCurrent;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithName:KLB_DEFAULT_PLAYER_NAME
                        level:KLB_DEFAULT_PLAYER_LEVEL
                    timeBonus:KLB_DEFAULT_PLAYER_TIME_BONUS
                   experience:KLB_DEFAULT_PLAYER_EXPERIENCE
                        kills:KLB_DEFAULT_PLAYER_KILLS
                energyMaximum:KLB_DEFAULT_PLAYER_ENERGY_MAXIMUM
                energyCurrent:KLB_DEFAULT_PLAYER_ENERGY_CURRENT];
    
    return self;
}

@end
