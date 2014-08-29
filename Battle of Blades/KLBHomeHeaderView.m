//
//  KLBHomeHeaderView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeHeaderView.h"

@implementation KLBHomeHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        KLBHomeHeaderView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                         bundle:nil]
                                          instantiateWithOwner:self
                                                    options:nil]
                                         objectAtIndex:0];
        [self addSubview:actualView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        KLBHomeHeaderView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                         bundle:nil]
                                          instantiateWithOwner:self
                                          options:nil]
                                         objectAtIndex:0];
        [self addSubview:actualView];
    }
    return self;
}

//- (instancetype)awakeAfterUsingCoder:(NSCoder *)aDecoder {
//    NSLog(@"1");
//    BOOL loadedSelfIsPlaceholder = ([[self subviews] count] == 0);
//    if (loadedSelfIsPlaceholder) {
//        // Load the views from our NIB
//        //NSArray *subViews = [[NSBundle mainBundle] loadNibNamed:@"KLBHomeHeaderView" owner:self options:nil];
//        
//        UIView *result = nil;
//        NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class])
//                                                          owner: self
//                                                        options: nil];
//        for (id anObject in elements) {
//            if ([anObject isKindOfClass:[self class]]) {
//                result = anObject;
//                break;
//            }
//        }
//        
//        // Assign ourself to the view from the NIB (we replace the placeholder in the XIB that instantiates us)
//        KLBHomeHeaderView *actualHeaderView = (id)result;
//        
//        //replace our constraints with the placeholder's
////        [actualHeaderView removeConstraints:actualHeaderView.constraints];
////        [actualHeaderView addConstraints:self.constraints]; //note that self is the placeholder
////        actualHeaderView.frame = self.frame;
////        actualHeaderView.autoresizingMask = self.autoresizingMask;
////        actualHeaderView.alpha = self.alpha;
//        
//        return actualHeaderView;
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_headerView release];
    [super dealloc];
}
@end
