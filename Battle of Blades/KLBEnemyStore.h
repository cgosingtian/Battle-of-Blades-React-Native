//
//  KLBEnemyStore.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBEnemy.h"

extern NSString *const KLB_ENEMY_STORE_SINGLETON_EXCEPTION;

@interface KLBEnemyStore : NSObject
+(instancetype)sharedStore;
- (NSDictionary *)allItems;
- (void)addEnemy:(KLBEnemy *)enemy forKey:(NSString *)key;
- (KLBEnemy *)enemyForKey:(NSString *)key;
- (void)setAllItems:(NSMutableDictionary *)dictionary;
@end
