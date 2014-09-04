//
//  KLBHomeViewController.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLBHomeHeaderView.h"
#import "KLBPlayerController.h"
#import "KLBChildViewDelegate.h"

extern CGFloat const KLB_HOME_LEVEL_UP_FLASH_DURATION;
extern CGFloat const KLB_HOME_LEVEL_UP_FLASH_OPACITY_START;
extern CGFloat const KLB_HOME_LEVEL_UP_FLASH_OPACITY_END;

@interface KLBHomeViewController : UIViewController <KLBChildViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *headerViewPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *footerViewPlaceholder;
@property (retain, nonatomic) IBOutlet UIView *mainViewPlaceholder;

@property (retain, nonatomic) KLBPlayerController *playerController;

@end
