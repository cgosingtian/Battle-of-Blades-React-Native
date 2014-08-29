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
#import "KLBBattleView.h"

@interface KLBHomeViewController ()

@end

@implementation KLBHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Do any additional setup after loading the view from its nib.
        // Initialize Header View
//        KLBHomeHeaderView *headerView = [[KLBHomeHeaderView alloc] init];
//        [self.view addSubview:headerView];
//        headerView.frame = self.headerViewPlaceholder.frame; //this will only set the position; xib overrides size
//        [headerView addConstraints:self.headerViewPlaceholder.constraints];
//        [headerView setNeedsUpdateConstraints];
//        [self.headerViewPlaceholder removeFromSuperview];
        
        // *************************
        // NOTE- Some weird overflow occurs in larger screens. Visit this again when you've set the battleview's
        // background to verify the effect
        // *************************
        
        //Initialize Main View - (Default: Battle View, for now)
//        KLBBattleView *battleView = [[KLBBattleView alloc] init];
//        [self.view addSubview:battleView];
//        battleView.frame = self.mainViewPlaceholder.frame; //this will only set the position; xib overrides size
//        [battleView addConstraints:self.mainViewPlaceholder.constraints];
//        [battleView setNeedsUpdateConstraints];
//        [self.mainViewPlaceholder removeFromSuperview];
        
        //Initialize Footer View
//        KLBHomeFooterView *footerView = [[KLBHomeFooterView alloc] init];
//        [self.view addSubview:footerView];
//        footerView.frame = self.footerViewPlaceholder.frame; //this will only set the position; xib overrides size
//        [footerView addConstraints:self.footerViewPlaceholder.constraints];
//        [footerView setNeedsUpdateConstraints];
//        [self.footerViewPlaceholder removeFromSuperview];
        
    }
    return self;
}

- (void)awakeFromNib {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_headerViewPlaceholder release];

    [_footerViewPlaceholder release];
    [_mainViewPlaceholder release];
    [super dealloc];
}
@end
