//
//  KLBHomeHeaderView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeHeaderView.h"
#import "KLBNotifications.h"
#import "KLBJSONController.h"

NSString *const KLB_LABEL_PLAYER_NAME_FORMAT = @" ";
NSString *const KLB_LABEL_PLAYER_LEVEL_FORMAT = @"Level: ";
NSString *const KLB_LABEL_PLAYER_EXPERIENCE_NEEDED_FORMAT = @"XP Needed: ";
NSString *const KLB_LABEL_PLAYER_ENERGY_FORMAT = @"Energy: ";
NSString *const KLB_LABEL_PLAYER_ENERGY_CURRENT_FORMAT = @"";
NSString *const KLB_LABEL_SLASH = @"/";
NSString *const KLB_LABEL_PLAYER_ENERGY_MAXIMUM_FORMAT = @"";

NSString *const KLB_LABEL_PLAYER_ENERGY_TIME_GAIN_FORMAT = @"Energy +1 in ";

@implementation KLBHomeHeaderView

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_headerView release];
    [_levelLabel release];
    [_experienceNeededLabel release];
    [_playerNameLabel release];
    [_energyLabel release];
    [_energyTimeToGainLabel release];
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Other Initializing Methods
- (void) replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    KLBHomeHeaderView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                     bundle:nil]
                                      instantiateWithOwner:self
                                      options:nil]
                                     objectAtIndex:0];
    [self addSubview:actualView];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToNameChange:) name:KLB_NOTIFICATION_PLAYER_NAME_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToLevelModification:) name:KLB_NOTIFICATION_PLAYER_LEVEL_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToExperienceModification:) name:KLB_NOTIFICATION_PLAYER_EXPERIENCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnergyModification:) name:KLB_NOTIFICATION_PLAYER_ENERGY_CHANGED object:nil];
}

#pragma mark - Update Labels Upon Notice
- (void) respondToNameChange: (NSNotification *) notification {
    NSString *newName = [notification.userInfo objectForKey:KLB_JSON_PLAYER_NAME];
    self.playerNameLabel.text = [NSString stringWithFormat:@"%@%@",KLB_LABEL_PLAYER_NAME_FORMAT,newName];
}
- (void) respondToLevelModification: (NSNotification *)notification {
    NSUInteger level = [[notification.userInfo objectForKey:KLB_JSON_PLAYER_LEVEL] integerValue];
    self.levelLabel.text = [NSString stringWithFormat:@"%@%lu",KLB_LABEL_PLAYER_LEVEL_FORMAT,(unsigned long)level];
}
- (void) respondToExperienceModification: (NSNotification *)notification {
    NSUInteger exp = [[notification.userInfo objectForKey:KLB_JSON_PLAYER_EXPERIENCE] integerValue];
    self.experienceNeededLabel.text = [NSString stringWithFormat:@"%@%lu",KLB_LABEL_PLAYER_EXPERIENCE_NEEDED_FORMAT,(unsigned long)exp];
}
- (void) respondToEnergyModification: (NSNotification *)notification {
    NSUInteger energyMax = [[notification.userInfo objectForKey:KLB_JSON_PLAYER_ENERGY_MAXIMUM] integerValue];
    NSUInteger energyCur = [[notification.userInfo objectForKey:KLB_JSON_PLAYER_ENERGY_CURRENT] integerValue];
    self.energyLabel.text = [NSString stringWithFormat:@"%@%@%lu%@%@%lu",
                             KLB_LABEL_PLAYER_ENERGY_FORMAT,
                             KLB_LABEL_PLAYER_ENERGY_CURRENT_FORMAT,
                             (unsigned long)energyCur,
                             KLB_LABEL_SLASH,
                             KLB_LABEL_PLAYER_ENERGY_MAXIMUM_FORMAT,(unsigned long)energyMax];
}
- (void) respondToTimeInSecondsOccurring: (NSNotification *)notification {
    //low priority
}

@end
