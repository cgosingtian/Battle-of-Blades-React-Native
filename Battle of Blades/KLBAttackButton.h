//
//  KLBAttackButton.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLBAttackDelegate.h"

@interface KLBAttackButton : UIButton
@property (retain, nonatomic) IBOutlet UIButton *attackButton;
@property (unsafe_unretained, nonatomic) id<KLBAttackDelegate> delegate;

- (IBAction)buttonTapped:(id)sender;

@end
