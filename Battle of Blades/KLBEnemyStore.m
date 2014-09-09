//
//  KLBEnemyStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBEnemyStore.h"
#import "KLBEnemy.h"

NSString *const KLB_ENEMY_STORE_SINGLETON_EXCEPTION = @"Singleton";

@interface KLBEnemyStore ()

// Each enemy has a dictionary [A] of stats.
// The enemies list has a dictionary [B] of enemies.
// We add each enemy's dictionary [A] to the dictionary below
// to form dictionary [B].
@property (retain,nonatomic) NSMutableDictionary *enemyDictionary;

@end

@implementation KLBEnemyStore

#pragma mark - Dealloc
- (void) dealloc {
    [_enemyDictionary release];
    [super dealloc];
}

#pragma mark - Initializations
+ (instancetype) sharedStore {
    static KLBEnemyStore *sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[KLBEnemyStore alloc] init];
    });
    return sharedStore;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
        self.enemyDictionary = newDictionary;
        [newDictionary release];
    }
    return self;
}

#pragma mark - Getters and Setters
- (NSDictionary *)allItems {
    return self.enemyDictionary;
}

- (void)addEnemy:(KLBEnemy *)enemy forKey:(NSString *)key {
    [self.enemyDictionary setObject:[enemy retain] forKey:key];
}

- (KLBEnemy *)enemyForKey:(NSString *)key {
    return [self.enemyDictionary objectForKey:key];
}

@end
