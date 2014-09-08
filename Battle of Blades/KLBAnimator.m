//
//  KLBAnimator.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAnimator.h"

// CA Strings
NSString *const KLB_CA_OPACITY_STRING = @"opacity";
NSString *const KLB_CA_POSITION_STRING = @"position";

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

// flashWhiteCALayer
CGFloat const KLB_FLASH_WHITE_DURATION = 0.1;
CGFloat const KLB_FLASH_WHITE_OPACITY = 0.5;

// flashAlphaCALayer
CGFloat const KLB_FLASH_ALPHA_FADE_IN_DURATION = 0.5;
CGFloat const KLB_FLASH_ALPHA_FADE_OUT_DURATION = 0.5;
CGFloat const KLB_FLASH_ALPHA_FADE_IN_OPACITY_START = 0.0;
CGFloat const KLB_FLASH_ALPHA_FADE_IN_OPACITY_END = 1.0;
CGFloat const KLB_FLASH_ALPHA_FADE_OUT_OPACITY_START = 1.0;
CGFloat const KLB_FLASH_ALPHA_FADE_OUT_OPACITY_END = 0.0;

@implementation KLBAnimator
// ---------- INITIALIZE CAKEYFRAMEANIMATION ----------
+ (CAKeyframeAnimation *)initializeAnimationWithKey:(NSString *)key
                                           duration:(CGFloat)duration
                                    startValueFloat:(CGFloat)startValue
                                      endValueFloat:(CGFloat)endValue {
    // Initialize the Animation
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    [animation setKeyPath:key];
    
    // Setup the Animation
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    
    NSMutableArray *animationValues = [[NSMutableArray alloc] init];
    [animationValues addObject:[NSNumber numberWithFloat:startValue]];
    [animationValues addObject:[NSNumber numberWithFloat:endValue]];
    
    animation.values = animationValues;
//    [animationValues release]; // TEST THIS
    
    return animation;
}

// ---------- OPACITY ANIMATION ----------
+ (void)fadeCALayer:(CALayer *)layer
           duration:(CGFloat)duration
       startOpacity:(CGFloat)startOpacity
         endOpacity:(CGFloat)endOpacity
       applyChanges:(BOOL)applyChanges {
    if (!layer.isHidden) {
        NSString *key = KLB_CA_OPACITY_STRING;
        [CATransaction begin];
        
        // Initialize Animation object
        CAKeyframeAnimation *animation = [self initializeAnimationWithKey:key
                                                                 duration:duration
                                                          startValueFloat:startOpacity
                                                            endValueFloat:endOpacity];
        
        // Prevent flickering by setting final value on layer
        [layer setOpacity:endOpacity];
        
        [CATransaction setCompletionBlock:^()
         {
//             [animation.values release];
             [animation release];
             
             if (applyChanges) {
                 [layer setOpacity:endOpacity];
             } else {
                 [layer setOpacity:startOpacity];
             }
         }];
        
        [layer addAnimation:animation forKey:key];
        
        [CATransaction commit];
    }
}

+ (void)fadeOutCALayer:(CALayer *)layer
          applyChanges:(BOOL)applyChanges {
    [self fadeCALayer:layer
             duration:KLB_FADE_OUT_DURATION
         startOpacity:KLB_FADE_OUT_OPACITY_START
           endOpacity:KLB_FADE_OUT_OPACITY_END
         applyChanges:applyChanges];
}

+ (void)fadeInCALayer:(CALayer *)layer
         applyChanges:(BOOL)applyChanges {
    [self fadeCALayer:layer
             duration:KLB_FADE_IN_DURATION
         startOpacity:KLB_FADE_IN_OPACITY_START
           endOpacity:KLB_FADE_IN_OPACITY_END
         applyChanges:applyChanges];
}

+ (void)fadeInCALayer:(CALayer *)layer
             duration:(CGFloat)duration
         applyChanges:(BOOL)applyChanges {
    [self fadeCALayer:layer
             duration:duration
         startOpacity:KLB_FADE_IN_OPACITY_START
           endOpacity:KLB_FADE_IN_OPACITY_END
         applyChanges:applyChanges];
}

// ---------- FLASH VIEW WITH TINT ----------
+ (void)flashCALayer:(CALayer *)layer
                duration:(CGFloat)duration
            startOpacity:(CGFloat)startOpacity
              endOpacity:(CGFloat)endOpacity
            applyChanges:(BOOL)applyChanges
              flashColor:(UIColor *)flashColor {
    if (!layer.isHidden) {
        NSString *keyPath = KLB_CA_OPACITY_STRING;
        
        // Setup the Tint Layer
        CALayer *tintLayer = [[CALayer alloc] init];
        CGColorRef cgFlashColor = [flashColor CGColor];
        [tintLayer setBackgroundColor:cgFlashColor];
        [tintLayer setOpacity:startOpacity];
        [tintLayer setBounds:[layer bounds]];
        
        // Center the Tint Layer onto the Main Layer
        [tintLayer setPosition:CGPointMake([layer bounds].size.width/2.0,
                                           [layer bounds].size.height/2.0)];
        
        // Add the Tint Layer to the Main Layer
        [layer addSublayer:tintLayer];
        
        [CATransaction begin];
        
        // Initialize the Animation
        CAKeyframeAnimation *animation = [self initializeAnimationWithKey:keyPath
                                                                    duration:duration
                                                             startValueFloat:startOpacity
                                                               endValueFloat:endOpacity];
        
        // prevent flickering
        tintLayer.opacity = endOpacity;
        
        [CATransaction setCompletionBlock:^()
         {
             [animation release];
             if (!applyChanges) {
                 [tintLayer removeFromSuperlayer];
             }
             [tintLayer release];
         }];
        
        [tintLayer addAnimation:animation forKey:keyPath];
        
        [CATransaction commit];
    }
}

+ (void)flashWhiteCALayer:(CALayer *)layer
             applyChanges:(BOOL)applyChanges {
    [self flashCALayer:layer
              duration:KLB_FLASH_WHITE_DURATION
          startOpacity:KLB_FADE_IN_OPACITY_START
            endOpacity:KLB_FLASH_WHITE_OPACITY
          applyChanges:applyChanges
            flashColor:[UIColor whiteColor]];
}

+ (void)flashWhiteCALayer:(CALayer *)layer
                 duration:(CGFloat)duration
             startOpacity:(CGFloat)startOpacity
               endOpacity:(CGFloat)endOpacity
             applyChanges:(BOOL)applyChanges {
    [self flashCALayer:layer
              duration:duration
          startOpacity:startOpacity
            endOpacity:endOpacity
          applyChanges:applyChanges
            flashColor:[UIColor whiteColor]];
}

+ (void)flashGoldCALayer:(CALayer *)layer
                duration:(CGFloat)duration
            startOpacity:(CGFloat)startOpacity
              endOpacity:(CGFloat)endOpacity
            applyChanges:(BOOL)applyChanges {
    [self flashCALayer:layer
              duration:duration
          startOpacity:startOpacity
            endOpacity:endOpacity
          applyChanges:applyChanges
            flashColor:[UIColor yellowColor]];
}

// ---------- FLASH LAYER WITH FADE IN THEN FADE OUT ANIMATION ----------
+ (void)flashAlphaCALayer:(CALayer *)layer
           fadeInDuration:(CGFloat)fadeInDuration
          fadeOutDuration:(CGFloat)fadeOutDuration
       applyChangesFadeIn:(BOOL)applyChangesFadeIn
      applyChangesFadeOut:(BOOL)applyChangesFadeOut {
    if (!layer.isHidden) {
        NSString *key = KLB_CA_OPACITY_STRING;
        CGFloat fadeInStartOpacity = KLB_FLASH_ALPHA_FADE_IN_OPACITY_START;
        CGFloat fadeInEndOpacity = KLB_FLASH_ALPHA_FADE_IN_OPACITY_END;
        CGFloat fadeOutStartOpacity = KLB_FLASH_ALPHA_FADE_OUT_OPACITY_START;
        CGFloat fadeOutEndOpacity = KLB_FLASH_ALPHA_FADE_OUT_OPACITY_END;
        // FADE IN
        CAKeyframeAnimation *fadeInAnimation = [self initializeAnimationWithKey:key
                                                                       duration:fadeInDuration
                                                                startValueFloat:fadeInStartOpacity
                                                                  endValueFloat:fadeInEndOpacity];
    
        // FADE OUT
        CAKeyframeAnimation *fadeOutAnimation = [self initializeAnimationWithKey:key
                                                                        duration:fadeOutDuration
                                                                 startValueFloat:fadeOutStartOpacity
                                                                   endValueFloat:fadeOutEndOpacity];
        
        // prevent flickering
        [layer setOpacity:KLB_FLASH_ALPHA_FADE_OUT_OPACITY_END];
    
        [CATransaction setCompletionBlock:^()
         {
             [fadeInAnimation release];
             [fadeOutAnimation release];
         
             if (applyChangesFadeIn) {
                 [layer setOpacity:fadeInEndOpacity];
             } else {
                 [layer setOpacity:fadeInStartOpacity];
             }
             if (applyChangesFadeOut) {
                 [layer setOpacity:fadeOutEndOpacity];
             } else {
                 [layer setOpacity:fadeOutStartOpacity];
             }
         }];
    
        [layer addAnimation:fadeInAnimation forKey:key];
        [layer addAnimation:fadeOutAnimation forKey:key];
    
        [CATransaction commit];
    }
}

+ (void)flashAlphaCALayer:(CALayer *)layer applyChanges:(BOOL)applyChanges {
    [self flashAlphaCALayer:layer
             fadeInDuration:KLB_FLASH_ALPHA_FADE_IN_DURATION
            fadeOutDuration:KLB_FLASH_ALPHA_FADE_OUT_DURATION
         applyChangesFadeIn:applyChanges
        applyChangesFadeOut:applyChanges];
}
@end
