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

@interface KLBHomeViewController ()

@end

@implementation KLBHomeViewController

#pragma mark - Dealloc
- (void)dealloc {
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
    }
    return self;
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
}
@end
