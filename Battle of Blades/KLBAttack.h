//
//  KLBAttack.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const KLB_DEFAULT_ATTACK_DAMAGE;
extern NSUInteger const KLB_DEFAULT_ATTACK_LIFETIME_SECONDS;

@interface KLBAttack : NSObject

@property (nonatomic) NSUInteger damageOnSuccessfulAttack;
@property (nonatomic) NSUInteger lifetimeInSeconds;

@end
