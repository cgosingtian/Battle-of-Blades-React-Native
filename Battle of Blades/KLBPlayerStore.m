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

@synthesize player = _player; // custom getter/setter below

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
        self.player = [[KLBPlayer alloc] init];
    }
    return self;
}

- (KLBPlayer *)player {
    return _player;
}

- (void)setPlayer:(KLBPlayer *)player {
    _player = player;
}

@end
