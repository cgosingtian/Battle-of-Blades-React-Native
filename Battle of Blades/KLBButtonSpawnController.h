//
//  KLBButtonSpawnController.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBButtonSpawnDelegate.h"
#import "KLBAttackDelegate.h"

extern CGFloat const KLB_BUTTON_SPAWN_DELAY;

@interface KLBButtonSpawnController : UIView <KLBButtonSpawnDelegate>

@property (unsafe_unretained, nonatomic) UIButton *button;
@property (nonatomic) Class buttonClass;
@property (nonatomic) CGRect buttonFrame;
@property (nonatomic) BOOL canLoadButton;
@property (unsafe_unretained, nonatomic) UIView* mainView;
@property (nonatomic) NSInteger waitTimeOnceSeconds; // The initial time the button must wait before it can load
@property (nonatomic) BOOL battleIsActive;

- (void)initializeSpawnerWithButtonClass:(Class)class frame:(CGRect)frame mainView:(UIView *)mainView;
- (void)battleStartSetup;

@end
