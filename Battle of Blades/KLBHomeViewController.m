//
//  KLBHomeViewController.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeViewController.h"
#import "KLBHomeHeaderView.h"
#import "KLBHomeFooterView.h"
#import "KLBBattleViewController.h"
#import "KLBPlayerController.h"
#import "KLBAnimator.h"
#import "KLBJSONController.h"

CGFloat const KLB_HOME_LEVEL_UP_FLASH_DURATION = 1.0;
CGFloat const KLB_HOME_LEVEL_UP_FLASH_OPACITY_START = 1.0;
CGFloat const KLB_HOME_LEVEL_UP_FLASH_OPACITY_END = 0.0;

@interface KLBHomeViewController ()

@end

@implementation KLBHomeViewController

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_headerViewPlaceholder release];
    [_playerController release];
    [_footerViewPlaceholder release];
    [_mainViewPlaceholder release];
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Do any additional setup after loading the view from its nib.
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Other Initializer Methods
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyLevelUpFlashEffect:)
                                                 name:KLB_NOTIFICATION_PLAYER_LEVEL_CHANGED
                                               object:nil];
}

#pragma mark - Level Up Effects
- (void)applyLevelUpFlashEffect:(NSNotification *)notification {
    NSInteger playerLevel = [[notification.userInfo objectForKey:KLB_JSON_PLAYER_LEVEL] integerValue];
    if (playerLevel > 1) {
        [KLBAnimator flashGoldCALayer:self.view.layer
                             duration:KLB_HOME_LEVEL_UP_FLASH_DURATION
                         startOpacity:KLB_HOME_LEVEL_UP_FLASH_OPACITY_START
                           endOpacity:KLB_HOME_LEVEL_UP_FLASH_OPACITY_END
                         applyChanges:NO];
    }
}

#pragma mark - View States
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerController = [[KLBPlayerController alloc] init];
    KLBHomeHeaderView *headerView = (KLBHomeHeaderView *)self.headerViewPlaceholder;
    headerView.delegate = self;
    [headerView release];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChildViewDelegate Protocol
- (void)childDidRequestViewChange:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_CHEAT_CLEAR_SHIELDS
                                                        object:nil
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_CHEAT_GAIN_LEVEL
                                                        object:nil
                                                      userInfo:nil];
}
@end
