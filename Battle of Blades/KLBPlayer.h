//
//  KLBPlayer.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KLB_DEFAULT_PLAYER_NAME;
extern NSUInteger const KLB_DEFAULT_PLAYER_LEVEL;
extern CGFloat const KLB_DEFAULT_PLAYER_TIME_BONUS;
extern NSUInteger const KLB_DEFAULT_PLAYER_EXPERIENCE;
extern NSUInteger const KLB_DEFAULT_PLAYER_KILLS;
extern NSUInteger const KLB_DEFAULT_PLAYER_ENERGY_MAXIMUM;
extern NSUInteger const KLB_DEFAULT_PLAYER_ENERGY_CURRENT;

@interface KLBPlayer : NSObject

@property (retain, nonatomic) NSString *name;
@property (nonatomic) NSUInteger level;
@property (nonatomic) CGFloat timeBonus;
@property (nonatomic) NSUInteger experience;
@property (nonatomic) NSUInteger kills;
@property (nonatomic) NSUInteger energyMaximum;
@property (nonatomic) NSUInteger energyCurrent;

- (instancetype)initWithName:(NSString *)name
                       level:(NSUInteger)level
                   timeBonus:(CGFloat)timeBonus
                  experience:(NSUInteger)experience
                       kills:(NSUInteger)kills
               energyMaximum:(NSUInteger)energyMaximum
               energyCurrent:(NSUInteger)energyCurrent;

@end
