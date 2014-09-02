//
//  KLBHomeHeaderView.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const KLB_LABEL_PLAYER_NAME_FORMAT;
extern NSString *const KLB_LABEL_PLAYER_LEVEL_FORMAT;
extern NSString *const KLB_LABEL_PLAYER_EXPERIENCE_NEEDED_FORMAT;
extern NSString *const KLB_LABEL_PLAYER_ENERGY_FORMAT;
extern NSString *const KLB_LABEL_PLAYER_ENERGY_CURRENT_FORMAT;
extern NSString *const KLB_LABEL_SLASH;
extern NSString *const KLB_LABEL_PLAYER_ENERGY_MAXIMUM_FORMAT;

NSString *const KLB_LABEL_PLAYER_ENERGY_TIME_GAIN_FORMAT;

@interface KLBHomeHeaderView : UIView
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UILabel *levelLabel;
@property (retain, nonatomic) IBOutlet UILabel *experienceNeededLabel;
@property (retain, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *energyLabel;
@property (retain, nonatomic) IBOutlet UILabel *energyTimeToGainLabel;

@end
