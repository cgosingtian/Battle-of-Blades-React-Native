//
//  KLBAttackButtonStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/1/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAttackButtonStore.h"
#import "KLBAttackButton.h"

NSString *const KLB_ATTACK_BUTTON_STORE_SINGLETON_EXCEPTION = @"Singleton";

@interface KLBAttackButtonStore ()

@property (retain,nonatomic) NSMutableArray *attackButtons;

@end

@implementation KLBAttackButtonStore

+ (instancetype) sharedStore {
    static KLBAttackButtonStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[KLBAttackButtonStore alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype) init {
    [NSException raise:KLB_ATTACK_BUTTON_STORE_SINGLETON_EXCEPTION
                format:@"Use +[KLBAttackButtonStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.attackButtons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)allItems {
    return self.attackButtons;
}

- (void)addItem:(KLBAttackButton *)button {
    [self.attackButtons addObject:button];
}

- (KLBAttackButton *)getRandomItem {
    NSUInteger maxIndex = [self.attackButtons count];
    NSUInteger randomIndex = arc4random_uniform(maxIndex);
    return [self.attackButtons objectAtIndex:randomIndex];
}

- (void)removeItem:(KLBAttackButton *)button {
    [self.attackButtons removeObject:button];
    [button release];
    button = nil;
}

- (void)setAllItems:(NSMutableArray *)array {
    if (self.attackButtons.count != 0) {
        [self.attackButtons removeAllObjects];
    }
    self.attackButtons = [array mutableCopy];
}

@end
