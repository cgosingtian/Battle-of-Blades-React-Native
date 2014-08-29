//
//  KLBAttackButton.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBAttackButton.h"

@implementation KLBAttackButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        KLBAttackButton *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
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
        KLBAttackButton *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                     bundle:nil]
                                      instantiateWithOwner:self
                                      options:nil]
                                     objectAtIndex:0];
        [self addSubview:actualView];
    }
    return self;
}

- (IBAction)buttonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(attackWillSucceed)]) {
        [self.delegate attackWillSucceed];
    }
    if ([self.delegate respondsToSelector:@selector(attackDidSucceed)]) {
        [self.delegate attackDidSucceed];
    }
}

- (void)dealloc {
    [_attackButton release];
    [super dealloc];
}
@end
