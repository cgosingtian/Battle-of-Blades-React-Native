//
//  KLBAttack.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAttack.h"

NSUInteger const KLB_DEFAULT_ATTACK_DAMAGE = 1;
NSUInteger const KLB_DEFAULT_ATTACK_LIFETIME_SECONDS = 5;

@implementation KLBAttack

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetValues];
    }
    return self;
}

- (void)resetValues {
    self.damageOnSuccessfulAttack = KLB_DEFAULT_ATTACK_DAMAGE;
    self.lifetimeInSeconds = KLB_DEFAULT_ATTACK_LIFETIME_SECONDS;
    self.timeRemainingSeconds = self.lifetimeInSeconds;
}

@end
