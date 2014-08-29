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

@interface KLBHomeViewController ()

@end

@implementation KLBHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Do any additional setup after loading the view from its nib.
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
