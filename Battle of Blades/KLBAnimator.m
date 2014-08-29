//
//  KLBAnimator.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAnimator.h"

CGFloat const KLB_FADE_OUT_DURATION = 1.0;
CGFloat const KLB_FADE_OUT_OPACITY_START = 1.0;
CGFloat const KLB_FADE_OUT_OPACITY_END = 0.0;

@implementation KLBAnimator
+ (void)fadeOutCALayer:(CALayer *)layer applyChanges:(BOOL)applyChanges {
    [CATransaction begin];
    
    NSString *keyPathTransparency = @"opacity";
    
    CAKeyframeAnimation *transparency = [[CAKeyframeAnimation alloc] init];
    
    [transparency setKeyPath:keyPathTransparency];
    transparency.duration = KLB_FADE_OUT_DURATION;
    
    NSMutableArray *transparencyValues = [[NSMutableArray alloc] init];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_OUT_OPACITY_START]];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_OUT_OPACITY_END]];
    transparency.values = transparencyValues;
    
    
    // This block repeats the animation but also randomizes the location and size of the cloud
    [CATransaction setCompletionBlock:^()
     {
         [transparencyValues release];
         [transparency release];
         
         if (applyChanges) {
             [layer setOpacity:KLB_FADE_OUT_OPACITY_END];
         }
     }];
    
    [layer addAnimation:transparency forKey:keyPathTransparency];
    
    [CATransaction commit];
}
@end
