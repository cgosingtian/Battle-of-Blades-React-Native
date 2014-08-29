//
//  KLBBattleView.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLBEnemy.h"

@interface KLBBattleViewController : UIView
@property (retain, nonatomic) IBOutlet UIImageView *enemyImage;
@property (retain, nonatomic) IBOutlet UIImageView *battleInfoBackground;
@property (retain, nonatomic) IBOutlet UILabel *healthLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (retain, nonatomic) IBOutlet UIView *coverView;
@property (retain, nonatomic) IBOutlet UILabel *enemyNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *enemyLevelLabel;

@property (unsafe_unretained, nonatomic) KLBEnemy *activeEnemy;

//test - we're using this as a "cover" for the battle screen - place an image or something
@property (retain,nonatomic) UIView *blackView;

- (NSString *)loadRandomEnemyData;

@end
