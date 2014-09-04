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

CGFloat const KLB_BUTTON_SPAWN_DELAY = 0.0;

@implementation KLBButtonSpawnController

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_buttonClass release];
    [_button release];
    _button = nil;
    _buttonClass = nil;
    [super dealloc];
}

#pragma mark - Initializers
// We won't be using a NIB to load this object - it doesn't have an interface.
// The parent view controller will have to call this to initialize the object.
- (void)initializeSpawnerWithButtonClass:(Class)class frame:(CGRect)frame {
    self.canLoadButton = YES;
    [self setupSpawnButtonClass:class frame:frame];
    [self registerForNotifications];
}

#pragma mark - Other Initialization Methods
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTime)
                                                 name:KLB_NOTIFICATION_BUTTON_SPAWN_START
                                               object:nil];
}

#pragma mark - Button Spawning Methods
- (void)setupSpawnButtonClass:(Class)type frame:(CGRect)frame {
    self.buttonClass = type;
    self.buttonFrame = frame;
}
- (void)handleTime {
    [self spawnButtonAttempt];
}

- (void)spawnButtonAttempt {
    if (_buttonClass) {
        if (self.canLoadButton) {
            self.canLoadButton = NO;
            [self instantiateButton];
        }
    }
}

- (void)instantiateButton {
    _button = [[[_buttonClass class] alloc] initWithFrame:self.frame];
    if ([_button isKindOfClass:[KLBAttackButton class]]) {
        KLBAttackButton *attackButton = (KLBAttackButton *)_button;
        attackButton.delegateButtonSpawnController = self;
        // The attackButton's delegate (for KLBAttackDelegate) is this object's superview's superview's
        // nextResponder, ie., its view controller. Also, this assumes that the button spawn controllers
        // are placed inside a view before they're placed inside the view controller's view
        if ([[[[[self superview] superview] nextResponder] class] conformsToProtocol:@protocol(KLBAttackDelegate)]) {
            attackButton.delegate = (id<KLBAttackDelegate>)[[[self superview] superview] nextResponder];
        }
    }
    [[self superview] addSubview:_button];
}

#pragma mark - Button Spawn Delegate
- (void)buttonWillEnd {
    self.canLoadButton = YES;
}
@end
