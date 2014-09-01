//
//  KLBAttackButton.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBNotifications.h"
#import "KLBAttackButton.h"
#import "KLBAnimator.h"
#import "KLBAttackButtonStore.h"

//These floats MUST match the size of your button in the XIB! (otherwise you make the touchable space smaller)
CGFloat const KLB_ATTACK_BUTTON_WIDTH = 60;
CGFloat const KLB_ATTACK_BUTTON_HEIGHT = 60;

@implementation KLBAttackButton

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_attackButton release];
    [_attack release];
    _attackButton = nil;
    _attack = nil;
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self initializeValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self initializeValues];
    }
    return self;
}

#pragma mark - Other Initialization Methods
- (void)initializeValues {
    if (!self.attack) {
        self.attack = [[KLBAttack alloc] init];
    } else {
        [self.attack resetValues];
    }
    self.enabled = YES;
    self.buttonIsDone = NO;
    self.alpha = 1.0;
}

- (void)replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    KLBAttackButton *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                bundle:nil]
                                    instantiateWithOwner:self
                                    options:nil]
                                   objectAtIndex:0];
    [self addSubview:actualView];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBattleEnd)
                                                 name:KLB_NOTIFICATION_BATTLE_END
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTime)
                                                 name:KLB_NOTIFICATION_ENEMY_TIME_CHANGED
                                               object:nil];
}

#pragma mark - IBActions
- (IBAction)buttonTapped:(id)sender {
    if (!self.buttonIsDone) {
        if ([self.delegate respondsToSelector:@selector(attackWillSucceed)]) {
            [self.delegate attackWillSucceed];
        }
        if ([self.delegate respondsToSelector:@selector(attackDidSucceed)]) {
            [self.delegate attackDidSucceed];
        }
        [self handleBattleEnd];
    }
}

#pragma mark - Battle Methods
- (void)handleBattleEnd {
    self.enabled = NO;
    self.buttonIsDone = YES;
    [KLBAnimator fadeOutCALayer:self.layer applyChanges:YES];
    [self removeFromSuperview];
    [[KLBAttackButtonStore sharedStore] removeItem:self];
}

- (void)handleTime {
    if (self.attack.timeRemainingSeconds > KLB_ANIMATION_ZERO_F) {
        self.attack.timeRemainingSeconds--;
        self.alpha = (CGFloat)self.attack.timeRemainingSeconds / (CGFloat)self.attack.lifetimeInSeconds;
    } else {
        [self timeUp];
    }
}

- (void)timeUp {
    if ([self.delegate respondsToSelector:@selector(attackWillFail)]) {
        [self.delegate attackWillFail];
    }
    if ([self.delegate respondsToSelector:@selector(attackDidFail)]) {
        [self.delegate attackDidFail];
    }
    [self handleBattleEnd];
}
@end
