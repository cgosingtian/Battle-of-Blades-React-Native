//
//  KLBAnimator.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAnimator.h"

CGFloat const KLB_ANIMATION_ZERO_F = 0.0;

// fadeOutCALayer
CGFloat const KLB_FADE_OUT_DURATION = 0.5;
CGFloat const KLB_FADE_OUT_OPACITY_START = 1.0;
CGFloat const KLB_FADE_OUT_OPACITY_END = 0.0;

// fadeInCALayer
CGFloat const KLB_FADE_IN_DURATION = 0.5;
CGFloat const KLB_FADE_IN_OPACITY_START = 0.0;
CGFloat const KLB_FADE_IN_OPACITY_END = 1.0;

// moveCALayer
CGFloat const KLB_MOVE_ANIMATION_DURATION = 1.5;

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

+ (void)fadeInCALayer:(CALayer *)layer applyChanges:(BOOL)applyChanges {
    [CATransaction begin];
    
    NSString *keyPathTransparency = @"opacity";
    
    CAKeyframeAnimation *transparency = [[CAKeyframeAnimation alloc] init];
    
    [transparency setKeyPath:keyPathTransparency];
    transparency.duration = KLB_FADE_IN_DURATION;
    
    NSMutableArray *transparencyValues = [[NSMutableArray alloc] init];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_IN_OPACITY_START]];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_IN_OPACITY_END]];
    transparency.values = transparencyValues;
    
    
    // This block repeats the animation but also randomizes the location and size of the cloud
    [CATransaction setCompletionBlock:^()
     {
         [transparencyValues release];
         [transparency release];
         
         if (applyChanges) {
             [layer setOpacity:KLB_FADE_IN_OPACITY_END];
         }
     }];
    
    [layer addAnimation:transparency forKey:keyPathTransparency];
    
    [CATransaction commit];
}

+ (void)moveCALayer:(CALayer *)layer startPoint:(CGPoint)start endPoint:(CGPoint)end applyChanges:(BOOL)applyChanges {
    [CATransaction begin];
    
    NSString *keyPathPosition = @"position";
    
    CAKeyframeAnimation *positionAnimation = [[CAKeyframeAnimation alloc] init];
    
    [positionAnimation setKeyPath:keyPathPosition];
    positionAnimation.duration = KLB_MOVE_ANIMATION_DURATION;
    
    NSMutableArray *positionValues = [[NSMutableArray alloc] init];
    [positionValues addObject:[NSValue valueWithCGPoint:start]];
    [positionValues addObject:[NSValue valueWithCGPoint:end]];
    positionAnimation.values = positionValues;
    
    [CATransaction setCompletionBlock:^()
     {
         [positionValues release];
         [positionAnimation release];
         
         if (applyChanges) {
             [layer setPosition:end];
         }
     }];
    
    [layer addAnimation:positionAnimation forKey:keyPathPosition];
    
    [CATransaction commit];
}

+ (void)flashWhiteCALayer:(CALayer *)layer applyChanges:(BOOL)applyChanges {
    CALayer *tintLayer = [[CALayer alloc] init];
    [tintLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [tintLayer setOpacity:KLB_FADE_IN_OPACITY_START];
    [tintLayer setBounds:[layer bounds]];
    [tintLayer setPosition:CGPointMake([layer bounds].size.width/2.0,
                                       [layer bounds].size.height/2.0)];
    
    [layer addSublayer:tintLayer];
    
    [CATransaction begin];
    
    NSString *keyPathTransparency = @"opacity";
    
    CAKeyframeAnimation *transparency = [[CAKeyframeAnimation alloc] init];
    
    [transparency setKeyPath:keyPathTransparency];
    transparency.duration = 0.1;
    
    NSMutableArray *transparencyValues = [[NSMutableArray alloc] init];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_IN_OPACITY_START]];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_IN_OPACITY_END]];
    [transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_IN_OPACITY_START]];
    //[transparencyValues addObject:[NSNumber numberWithFloat:KLB_FADE_IN_OPACITY_END]];
    transparency.values = transparencyValues;
    
    
    // This block repeats the animation but also randomizes the location and size of the cloud
    [CATransaction setCompletionBlock:^()
     {
         [transparencyValues release];
         [transparency release];
         
//         if (applyChanges) {
//             [tintLayer setOpacity:KLB_FADE_IN_OPACITY_END];
//         } else {
//             [tintLayer removeFromSuperlayer];
//         }
     }];
    
    [tintLayer addAnimation:transparency forKey:keyPathTransparency];
    
    [CATransaction commit];
}
@end
