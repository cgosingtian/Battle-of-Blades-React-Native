//
//  KLBPlayerController.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBPlayer.h"

@interface KLBPlayerController : NSObject

@property (unsafe_unretained, nonatomic) KLBPlayer *player;
@property (nonatomic) BOOL battleIsActive;

- (void)loadPlayerData;
- (NSUInteger)levelUp;
- (void)gainExperience:(NSUInteger)amount;
- (NSUInteger)experienceToLevel;
- (NSUInteger)experienceNeededToLevelUp;

@end