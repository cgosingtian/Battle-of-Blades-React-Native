//
//  KLBPlayer.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KLB_DEFAULT_PLAYER_NAME;
extern NSUInteger const KLB_DEFAULT_LEVEL;
extern CGFloat const KLB_DEFAULT_TIME_BONUS;
extern NSUInteger const KLB_DEFAULT_EXPERIENCE;
extern NSUInteger const KLB_DEFAULT_KILLS;

@interface KLBPlayer : NSObject

@property (retain, nonatomic) NSString *name;
@property (nonatomic) NSUInteger level;
@property (nonatomic) CGFloat timeBonus;
@property (nonatomic) NSUInteger experience;
@property (nonatomic) NSUInteger kills;

@end
