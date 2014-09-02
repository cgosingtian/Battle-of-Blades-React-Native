//
//  KLBAttackDelegate.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLBAttackDelegate <NSObject>
- (void) attackDidSucceed:(id)sender;
@optional
- (void) attackWillSucceed:(id)sender;
- (void) attackWillFail:(id)sender;
- (void) attackDidFail:(id)sender;
@end
