//
//  KLBEnemyStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBEnemyStore.h"

@interface KLBEnemyStore ()

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

@end
