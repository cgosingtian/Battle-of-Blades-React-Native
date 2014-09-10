//
//  KLBButtonSpawnController.m
//  Battle of Blades
//
//  This object simply instantiates a button at its coordinates. It has a weak reference
//  to the object and when the object is deallocated, creates a new one.
//
//  For simplicity, the button is set to be of type KLBAttackButton
//
//  Created by Chase Gosingtian on 9/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBButtonSpawnController.h"
#import "KLBAttackButton.h"
#import "KLBAttackDelegate.h"

const NSInteger KLB_BUTTON_SPAWN_MAXIMUM_WAIT_TIME_INITIAL = 7;

@implementation KLBButtonSpawnController

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_buttonClass release];
    _button = nil;
    _buttonClass = nil;
    _mainView = nil;
    [super dealloc];
}

#pragma mark - Initializers
// We won't be using a NIB to load this object - it doesn't have an interface.
// The parent view controller will have to call this to initialize the object.
- (void)initializeSpawnerWithButtonClass:(Class)class frame:(CGRect)frame mainView:(UIView *)mainView {
    self.mainView = mainView;
    self.canLoadButton = YES;
    [self setupSpawnButtonClass:class frame:frame];
    [self registerForNotifications];
    [self initializeRandomWaitTime];
}

#pragma mark - Other Initialization Methods
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTime)
                                                 name:KLB_NOTIFICATION_BUTTON_SPAWN_START
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBattleEnd)
                                                 name:KLB_NOTIFICATION_BATTLE_END
                                               object:nil];
}
- (void)initializeRandomWaitTime {
    _waitTimeOnceSeconds = arc4random_uniform(KLB_BUTTON_SPAWN_MAXIMUM_WAIT_TIME_INITIAL);
}

#pragma mark - Button Spawning Methods
- (void)setupSpawnButtonClass:(Class)type frame:(CGRect)frame {
    self.buttonClass = type;
    self.buttonFrame = frame;
    [self battleStartSetup];
}
- (void)handleTime {
    [self spawnButtonAttempt];
}
- (void)handleBattleEnd {
    dispatch_async(dispatch_get_main_queue(), ^() {
        if (self.battleIsActive) {
            self.battleIsActive = NO;
        }
    });
}
- (void)battleStartSetup {
    dispatch_async(dispatch_get_main_queue(), ^() {
        if (!self.battleIsActive) {
            [self initializeRandomWaitTime];
            self.battleIsActive = YES;
        }
    });
}

- (void)spawnButtonAttempt {
    if (self.battleIsActive) {
        if (_buttonClass) {
            if (self.canLoadButton) {
                if (_waitTimeOnceSeconds > 0) {
                    _waitTimeOnceSeconds--;
                } else {
                    self.canLoadButton = NO;
                    [self instantiateButton];
                    [self initializeRandomWaitTime];
                }
            }
        }
    }
}

- (void)instantiateButton {
    // If we don't have a button for this controller, create one
    if (!_button) {
        UIButton *button = [[[_buttonClass class] alloc] initWithFrame:self.frame];
        _button = button;
    
        if ([_button isKindOfClass:[KLBAttackButton class]]) {
            KLBAttackButton *attackButton = (KLBAttackButton *)_button;
            attackButton.delegateButtonSpawnController = self;
        
            if ([[self.mainView class] conformsToProtocol:@protocol(KLBAttackDelegate)]) {
                attackButton.delegate = (id<KLBAttackDelegate>)self.mainView;
            }
        }
        [[self superview] addSubview:_button];
        [button release];
    } else {
        // Otherwise, reactivate it
        if ([_button isKindOfClass:[KLBAttackButton class]]) {
            KLBAttackButton *attackButton = (KLBAttackButton *)_button;
            attackButton.delegateButtonSpawnController = self;
            
            [attackButton initializeValues];
        }
    }
}

#pragma mark - Button Spawn Delegate
- (void)buttonWillEnd {
    self.canLoadButton = YES;
    [self initializeRandomWaitTime];
}
@end
