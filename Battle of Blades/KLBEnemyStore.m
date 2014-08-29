//
//  KLBEnemyStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBEnemyStore.h"
#import "KLBEnemy.h"

@interface KLBEnemyStore ()

// Each enemy has a dictionary [A] of stats.
// The enemies list has a dictionary [B] of enemies.
// We add each enemy's dictionary [A] to the dictionary below
// to form dictionary [B].
@property (retain,nonatomic) NSMutableDictionary *enemyDictionary;

@end

@implementation KLBEnemyStore

+ (instancetype) sharedStore {
    static KLBEnemyStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[KLBEnemyStore alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype) init {
    [NSException raise:@"Singleton" format:@"Use +[KLBEnemyStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.enemyDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary *)allItems {
    return self.enemyDictionary;
}

- (void)addEnemy:(KLBEnemy *)enemy forKey:(NSString *)key {
    [self.enemyDictionary setObject:enemy forKey:key];
}

- (KLBEnemy *)enemyForKey:(NSString *)key {
    return [self.enemyDictionary objectForKey:key];
}

- (void)setAllItems:(NSMutableDictionary *)dictionary {
    if (self.enemyDictionary.count != 0) {
        [self.enemyDictionary removeAllObjects];
    }
    self.enemyDictionary = [dictionary copy];
}

@end
