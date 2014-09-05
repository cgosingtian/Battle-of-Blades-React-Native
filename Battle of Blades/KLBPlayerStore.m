//
//  KLBPlayerStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPlayerStore.h"
#import "KLBPlayer.h"

@interface KLBPlayerStore ()

@property (retain,nonatomic) KLBPlayer *player;

@end

@implementation KLBPlayerStore

+ (instancetype) sharedStore {
    static KLBPlayerStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[KLBPlayerStore alloc] init];
    }
    return sharedStore;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        KLBPlayer *player = [[KLBPlayer alloc] init];
        self.player = player;
        [player release];
    }
    return self;
}
@end
