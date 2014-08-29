//
//  KLBPlayerView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBPlayerView.h"

@implementation KLBPlayerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        KLBPlayerView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
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
        KLBPlayerView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
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
