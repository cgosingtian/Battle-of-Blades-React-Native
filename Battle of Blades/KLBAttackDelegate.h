//
//  KLBAttackDelegate.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLBAttackDelegate <NSObject>
- (void) attackDidSucceed;
@optional
- (void) attackWillSucceed;
- (void) attackWillFail;
- (void) attackDidFail;
@end
