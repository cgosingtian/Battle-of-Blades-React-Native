//
//  KLBAttackButton.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLBAttackDelegate.h"
#import "KLBAttack.h"
#import "KLBButtonSpawnDelegate.h"

extern CGFloat const KLB_ATTACK_BUTTON_WIDTH;
extern CGFloat const KLB_ATTACK_BUTTON_HEIGHT;

extern CGFloat const KLB_ATTACK_BUTTON_MOVEMENT_RANGE;
extern CGFloat const KLB_ATTACK_BUTTON_MOVEMENT_SPEED;
extern CGFloat const KLB_ATTACK_BUTTON_MOVEMENT_INTERVAL;
extern CGFloat const KLB_ATTACK_BUTTON_WAIT_INTERVAL;

extern CGFloat const KLB_SHIELD_BUTTON_MOVEMENT_RANGE;
extern NSString *const KLB_SHIELD_BUTTON_IMAGE_FILENAME;
extern CGFloat const KLB_SHIELD_BUTTON_LAYER_Z_POSITION;

extern CGFloat const KLB_ATTACK_BUTTON_MAX_ALPHA;
extern CGFloat const KLB_ATTACK_BUTTON_MIN_ALPHA;
extern CGFloat const KLB_ATTACK_BUTTON_ZERO_ALPHA;

extern CGFloat const KLB_ATTACK_BUTTON_SHIELD_LIFETIME_MULTIPLIER;
extern CGFloat const KLB_ATTACK_BUTTON_SHIELD_SIZE_MULTIPLIER;

@interface KLBAttackButton : UIButton
@property (retain, nonatomic) NSTimer *moveTimer;
@property (retain, nonatomic) NSTimer *waitTimer;

@property (unsafe_unretained, nonatomic) id<KLBAttackDelegate> delegate;
@property (unsafe_unretained, nonatomic) id<KLBButtonSpawnDelegate> delegateButtonSpawnController;

@property (retain, nonatomic) IBOutlet UIButton *attackButton;
@property (retain, nonatomic) IBOutlet UILabel *countdownLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *containerView;

@property (retain, nonatomic) KLBAttack *attack;

@property (nonatomic) BOOL isShield;

@property (nonatomic) BOOL canMove;
@property (nonatomic) CGPoint moveDestination;
@property (nonatomic) BOOL isWaiting;

@property (nonatomic) dispatch_once_t onceHandleEndToken;
@property (nonatomic) dispatch_once_t onceSetupToken;

- (IBAction)buttonTapped:(id)sender;
- (void)convertToShield;
- (void)allowMovement;

@end
