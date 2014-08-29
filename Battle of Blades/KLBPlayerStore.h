//
//  KLBPlayerStore.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBPlayer.h"

@interface KLBPlayerStore : NSObject
+(instancetype)sharedStore;
- (KLBPlayer *)player;
- (void)setPlayer:(KLBPlayer *)player;
@end
