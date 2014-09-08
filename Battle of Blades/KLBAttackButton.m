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
#import "KLBImageStore.h"
//#import "KLBAttackButtonStore.h"

//These floats MUST match the size of your button in the XIB! (otherwise you make the touchable space smaller)
CGFloat const KLB_ATTACK_BUTTON_WIDTH = 60;
CGFloat const KLB_ATTACK_BUTTON_HEIGHT = 60;

CGFloat const KLB_ATTACK_BUTTON_MOVEMENT_RANGE = 30.0;
CGFloat const KLB_ATTACK_BUTTON_MOVEMENT_SPEED = 1;
CGFloat const KLB_ATTACK_BUTTON_MOVEMENT_INTERVAL = 0.03;
CGFloat const KLB_ATTACK_BUTTON_WAIT_INTERVAL = 1.5;

CGFloat const KLB_SHIELD_BUTTON_MOVEMENT_RANGE = 90.0;
NSString *const KLB_SHIELD_BUTTON_IMAGE_FILENAME = @"shieldbutton2.png";
CGFloat const KLB_SHIELD_BUTTON_LAYER_Z_POSITION = 10.0;

CGFloat const KLB_ATTACK_BUTTON_MAX_ALPHA = 1.0;
CGFloat const KLB_ATTACK_BUTTON_MIN_ALPHA = 0.2;
CGFloat const KLB_ATTACK_BUTTON_ZERO_ALPHA = 0.0;

CGFloat const KLB_ATTACK_BUTTON_SHIELD_LIFETIME_MULTIPLIER = 0.5;
CGFloat const KLB_ATTACK_BUTTON_SHIELD_SIZE_MULTIPLIER = 1.5;

@implementation KLBAttackButton

#pragma mark - Dealloc
- (void)dealloc {
    // Undo notification registration
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // Nil delegates
    _delegate = nil;

    // Release Timers
    [_moveTimer release];
    [_waitTimer release];

    // Release IBOutlets
    [_attackButton release];
    [_countdownLabel release];
    [_containerView release];

    // Release owned objects
    [_attack release];
    
    // Avoid dangling pointers for safety
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
        KLBAttack *attackInitialized = [[KLBAttack alloc] init];
        self.attack = attackInitialized;
        [attackInitialized release];
    } else {
        [self.attack resetValues];
    }
    self.enabled = YES;
    self.alpha = KLB_ATTACK_BUTTON_MAX_ALPHA;
    self.isShield = NO;
    self.canMove = NO;
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld",(long)self.attack.timeRemainingSeconds];
}

- (void)convertToShield {
    self.isShield = YES;
    self.canMove = YES;
    
    self.attack.lifetimeInSeconds *= KLB_ATTACK_BUTTON_SHIELD_LIFETIME_MULTIPLIER;
    self.attack.timeRemainingSeconds = self.attack.lifetimeInSeconds;
    
    UIImage *shieldImage = [[KLBImageStore sharedStore] imageForFilename:KLB_SHIELD_BUTTON_IMAGE_FILENAME];
    [self.attackButton setImage:shieldImage forState:UIControlStateNormal];
    [shieldImage release];
    
    self.layer.zPosition = KLB_SHIELD_BUTTON_LAYER_Z_POSITION;
    CGSize buttonSize = self.containerView.frame.size;
    buttonSize = CGSizeMake(buttonSize.width*KLB_ATTACK_BUTTON_SHIELD_SIZE_MULTIPLIER,
                            buttonSize.height*KLB_ATTACK_BUTTON_SHIELD_SIZE_MULTIPLIER);
    self.containerView.frame = CGRectMake(self.containerView.frame.origin.x,
                                          self.containerView.frame.origin.y,
                                          buttonSize.width,
                                          buttonSize.height);
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.containerView.frame.size.width,
                            self.containerView.frame.size.height);
    [self.containerView setNeedsLayout];
    
    [self.countdownLabel.layer setHidden:YES];
}

- (void)allowMovement {
    self.canMove = YES;
}

- (void)replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])
                                bundle:nil];
    NSArray *nibViews = [nib instantiateWithOwner:self options:nil];
    KLBAttackButton *actualView = [nibViews objectAtIndex:0];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleClearShields)
                                                 name:KLB_NOTIFICATION_CHEAT_CLEAR_SHIELDS
                                               object:nil];
}

#pragma mark - IBActions
- (IBAction)buttonTapped:(id)sender {
    self.enabled = NO;
    self.alpha = KLB_ATTACK_BUTTON_ZERO_ALPHA;
    if ([self.delegate respondsToSelector:@selector(attackWillSucceed:)]) {
        [self.delegate attackWillSucceed:self];
    }
    if ([self.delegate respondsToSelector:@selector(attackDidSucceed:)]) {
        [self.delegate attackDidSucceed:self];
    }
    
    // We do cleanup of tapped buttons either during the timer tick (see handleTime below)
    // or when the battle view controller tells us that the battle is done.
    // We do this to prevent calling [self handleBattleEnd] twice: when the battle ends
    // (from the KLB_NOTIFICATION_BATTLE_END notification) and from the buttonTapped IBAction,
    // the latter of which causes a crash.
    //[self handleBattleEnd]; // don't do this
}

#pragma mark - Battle Methods
- (void)handleClearShields {
    if (self.isShield) {
        [self handleBattleEnd];
    }
}
- (void)handleBattleEnd {
    // This method should only be run once in the lifetime of this object.
    dispatch_once(&_onceHandleEndToken, ^{
        if ([self.delegateButtonSpawnController respondsToSelector:@selector(buttonWillEnd)]) {
            [self.delegateButtonSpawnController buttonWillEnd];
        }
        [self.layer removeAllAnimations];
        self.attackButton.enabled = NO;
        [self.moveTimer invalidate];
        if (self.waitTimer)
            [self.waitTimer invalidate];
        [self removeFromSuperview];
    });
}

- (void)handleTime {
    [self updateCountdownLabel];
    // If this attack button is enabled, proceed normally.
    // Otherwise, we end the button's existence.
    if (self.enabled) {
        // Activate movement when the timer starts (so we're sure that everything's set up)
        // We only do this once (so we set canMove to NO)
        if (self.canMove) {
            self.moveDestination = [self generateRandomPoint];
            [self activateMovement];
            self.canMove = NO;
        }
        // Timer counts down here
        if (self.attack.timeRemainingSeconds > KLB_ANIMATION_ZERO_F) {
            self.attack.timeRemainingSeconds--;
            if (!self.isShield) {
                [self updateCountdownLabel];
                self.alpha = MAX(KLB_ATTACK_BUTTON_MIN_ALPHA,
                                 (CGFloat)self.attack.timeRemainingSeconds / (CGFloat)self.attack.lifetimeInSeconds
                                 );
            }
        }
        // If out of time, handle accordingly
        if (self.attack.timeRemainingSeconds <= KLB_ANIMATION_ZERO_F) {
            [self timeUp];
        }
      }
    else {
        [self handleBattleEnd];
    }
}

- (void)updateCountdownLabel {
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld",(long)self.attack.timeRemainingSeconds];
}

// When the time of the attack expires, we tell the delegate that the attack failed.
// Then we end the button's existence.
- (void)timeUp {
    self.enabled = NO;
    if (!self.isShield) {
        if ([self.delegate respondsToSelector:@selector(attackWillFail:)]) {
            [self.delegate attackWillFail:self];
        }
        if ([self.delegate respondsToSelector:@selector(attackDidFail:)]) {
            [self.delegate attackDidFail:self];
        }
    }
    [self handleBattleEnd];
}

#pragma mark - Movement Methods
// Movement logic:
// 1. wait for X time
// 2. generate coordinates
// 3. move to coordinates
// 4. upon reaching coordinates, return to #1
- (void)activateMovement {
    self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:KLB_ATTACK_BUTTON_MOVEMENT_INTERVAL
                                                  target:self
                                                selector:@selector(randomMove)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) doneWaiting {
    self.moveDestination = [self generateRandomPoint];
    self.isWaiting = NO;
}

- (CGPoint)generateRandomPoint {
    CGFloat range;
    // Button type determines movement range
    if (self.isShield) {
        range = KLB_SHIELD_BUTTON_MOVEMENT_RANGE;
    } else {
        range = KLB_ATTACK_BUTTON_MOVEMENT_RANGE;
    }
    CGRect superviewFrame = [self superview].frame;
    
    CGFloat maxX = superviewFrame.size.width - self.frame.size.width;
    CGFloat maxY = superviewFrame.size.height - self.frame.size.height;
    
    float randomX = arc4random_uniform(maxX);
    float randomY = arc4random_uniform(maxY);
    
    // Limit X and Y to movement range
    if (randomX > self.frame.origin.x) {
        if (randomX - self.frame.origin.x > range) {
            randomX = self.frame.origin.x + range;
        }
    } else {
        if (randomX + self.frame.origin.x > range) {
            randomX = self.frame.origin.x - range;
        }
    }
    if (randomY > self.frame.origin.y) {
        if (randomY - self.frame.origin.y > range) {
            randomY = self.frame.origin.y + range;
        }
    } else {
        if (randomY + self.frame.origin.y > range) {
            randomY = self.frame.origin.y - range;
        }
    }
    
    return CGPointMake(randomX, randomY);
}

- (void) randomMove {
    if (self.isEnabled) {
        if (CGPointEqualToPoint(self.moveDestination, self.frame.origin)) {
            // wait for waitSeconds time
            if (!self.isWaiting) {
                if (!self.waitTimer) {
                    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:KLB_ATTACK_BUTTON_WAIT_INTERVAL
                                                                      target:self
                                                                    selector:@selector(doneWaiting)
                                                                    userInfo:nil
                                                                     repeats:NO];
                }
                self.isWaiting = YES;
            }
            // then generate random coordinates (in the doneWaiting method)
        }
        else {
            // we add together all of the needed movement adjustments to a single
            // CGPoint (destinationResult) then update the frame in one go
            CGPoint destinationResult = self.frame.origin;
            CGFloat velocity = KLB_ATTACK_BUTTON_MOVEMENT_SPEED;
            
            if (destinationResult.x > self.moveDestination.x) {
                CGFloat x = destinationResult.x - velocity;
                CGFloat y = destinationResult.y;
                
                if (x < self.moveDestination.x) //don't overshoot coordinates
                    x = self.moveDestination.x;
                
                destinationResult = CGPointMake(x, y);
            } else if (destinationResult.x < self.moveDestination.x) {
                CGFloat x = destinationResult.x + velocity;
                CGFloat y = destinationResult.y;
                
                if (x > self.moveDestination.x) //don't overshoot coordinates
                    x = self.moveDestination.x;
                
                destinationResult = CGPointMake(x, y);
            }
            
            if (destinationResult.y > self.moveDestination.y) {
                CGFloat x = destinationResult.x;
                CGFloat y = destinationResult.y - velocity;
                
                if (y < self.moveDestination.y) //don't overshoot coordinates
                    y = self.moveDestination.y;
                
                destinationResult = CGPointMake(x, y);
            } else if (destinationResult.y < self.moveDestination.y) {
                CGFloat x = destinationResult.x;
                CGFloat y = destinationResult.y + velocity;
                
                if (y > self.moveDestination.y) //don't overshoot coordinates
                    y = self.moveDestination.y;
                
                destinationResult = CGPointMake(x, y);
            }
            
            // Update the frame
            self.frame = CGRectMake(destinationResult.x, destinationResult.y, self.frame.size.width, self.frame.size.height);
        }
    }
}
@end
