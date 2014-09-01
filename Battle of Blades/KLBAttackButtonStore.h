//
//  KLBAttackButtonStore.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBAttackButton.h"

extern NSString *const KLB_ATTACK_BUTTON_STORE_SINGLETON_EXCEPTION;

@interface KLBAttackButtonStore : NSObject
+(instancetype)sharedStore;
- (NSMutableArray *)allItems;
- (void)addItem:(KLBAttackButton *)button;
- (KLBAttackButton *)getRandomItem;
- (void)removeItem:(KLBAttackButton *)button;
- (void)setAllItems:(NSMutableArray *)array;
@end
