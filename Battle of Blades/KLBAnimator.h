//
//  KLBAnimator.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const KLB_ANIMATION_ZERO_F;

// fadeOutCALayer
extern CGFloat const KLB_FADE_OUT_DURATION;
extern CGFloat const KLB_FADE_OUT_OPACITY_START;
extern CGFloat const KLB_FADE_OUT_OPACITY_END;

// fadeInCALayer
extern CGFloat const KLB_FADE_IN_DURATION;
extern CGFloat const KLB_FADE_IN_OPACITY_START;
extern CGFloat const KLB_FADE_IN_OPACITY_END;

// moveCALayer
extern CGFloat const KLB_MOVE_ANIMATION_DURATION;

@interface KLBAnimator : NSObject
+ (void)fadeOutCALayer:(CALayer *)layer applyChanges:(BOOL)applyChanges;
+ (void)fadeInCALayer:(CALayer *)layer applyChanges:(BOOL)applyChanges;
+ (void)moveCALayer:(CALayer *)layer startPoint:(CGPoint)start endPoint:(CGPoint)end applyChanges:(BOOL)applyChanges;
@end
