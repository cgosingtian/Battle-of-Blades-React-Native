//
//  KLBPlayerStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPlayerStore.h"

@interface KLBPlayerStore ()

@property (retain,nonatomic) NSMutableDictionary *playerDictionary;

@end

@implementation KLBPlayerStore

+ (instancetype) sharedStore {
    static KLBPlayerStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[KLBPlayerStore alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype) init {
    [NSException raise:@"Singleton" format:@"Use +[KLBPlayerStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.playerDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary *)allItems {
    return self.playerDictionary;
}

@end
