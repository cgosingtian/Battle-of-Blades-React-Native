//
//  KLBHomeHeaderView.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLBHomeHeaderView : UIView
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UILabel *levelLabel;
@property (retain, nonatomic) IBOutlet UILabel *experienceNeededLabel;
@property (retain, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *energyLabel;
@property (retain, nonatomic) IBOutlet UILabel *energyTimeToGainLabel;

@end
