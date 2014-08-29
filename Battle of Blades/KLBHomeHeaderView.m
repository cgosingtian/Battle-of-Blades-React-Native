//
//  KLBHomeHeaderView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeHeaderView.h"

@implementation KLBHomeHeaderView

#pragma mark - Dealloc
- (void)dealloc {
    [_headerView release];
    [super dealloc];
}

#pragma mark - Initializers
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self replacePlaceholderViewsWithActual];
    }
    return self;
}

#pragma mark - Other Initializing Methods
- (void) replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    KLBHomeHeaderView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                     bundle:nil]
                                      instantiateWithOwner:self
                                      options:nil]
                                     objectAtIndex:0];
    [self addSubview:actualView];
}
@end
