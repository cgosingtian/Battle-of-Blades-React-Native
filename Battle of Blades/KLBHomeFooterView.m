//
//  KLBHomeFooterView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeFooterView.h"

@implementation KLBHomeFooterView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        KLBHomeFooterView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
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
        KLBHomeFooterView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                         bundle:nil]
                                          instantiateWithOwner:self
                                          options:nil]
                                         objectAtIndex:0];
        [self addSubview:actualView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
