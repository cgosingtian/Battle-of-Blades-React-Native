//
//  KLBAnimator.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// CA Strings
extern NSString *const KLB_CA_OPACITY_STRING;
extern NSString *const KLB_CA_POSITION_STRING;

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

// flashWhiteCALayer
extern CGFloat const KLB_FLASH_WHITE_DURATION;
extern CGFloat const KLB_FLASH_WHITE_SECOND_FLASH_OPACITY;

// flashAlphaCALayer
extern CGFloat const KLB_FLASH_ALPHA_FADE_IN_DURATION;
extern CGFloat const KLB_FLASH_ALPHA_FADE_OUT_DURATION;
extern CGFloat const KLB_FLASH_ALPHA_FADE_IN_OPACITY_START;
extern CGFloat const KLB_FLASH_ALPHA_FADE_IN_OPACITY_END;
extern CGFloat const KLB_FLASH_ALPHA_FADE_OUT_OPACITY_START;
extern CGFloat const KLB_FLASH_ALPHA_FADE_OUT_OPACITY_END;

@interface KLBAnimator : NSObject
// FADE OUT
+ (void)fadeOutCALayer:(CALayer *)layer
          applyChanges:(BOOL)applyChanges;

// FADE IN
+ (void)fadeInCALayer:(CALayer *)layer
         applyChanges:(BOOL)applyChanges;

+ (void)fadeInCALayer:(CALayer *)layer
             duration:(CGFloat)duration
         applyChanges:(BOOL)applyChanges;

// FLASH WITH WHITE TINT LAYER
+ (void)flashWhiteCALayer:(CALayer *)layer
             applyChanges:(BOOL)applyChanges;

+ (void)flashWhiteCALayer:(CALayer *)layer
                 duration:(CGFloat)duration
             startOpacity:(CGFloat)startOpacity
               endOpacity:(CGFloat)endOpacity
             applyChanges:(BOOL)applyChanges;

// FLASH WITH GOLD TINT LAYER
+ (void)flashGoldCALayer:(CALayer *)layer
                 duration:(CGFloat)duration
             startOpacity:(CGFloat)startOpacity
               endOpacity:(CGFloat)endOpacity
             applyChanges:(BOOL)applyChanges;

// FLASH LAYER
+ (void)flashAlphaCALayer:(CALayer *)layer
             applyChanges:(BOOL)applyChanges;

+ (void)flashAlphaCALayer:(CALayer *)layer
           fadeInDuration:(CGFloat)fadeInDuration
          fadeOutDuration:(CGFloat)fadeOutDuration
       applyChangesFadeIn:(BOOL)applyChangesFadeIn
      applyChangesFadeOut:(BOOL)applyChangesFadeOut;
@end
