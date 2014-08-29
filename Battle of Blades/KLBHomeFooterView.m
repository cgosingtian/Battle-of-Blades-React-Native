//
//  KLBHomeFooterView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeFooterView.h"
#import "KLBNotifications.h"

@implementation KLBHomeFooterView

#pragma mark - Dealloc
- (void)dealloc {
    [_battleButton release];
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
    KLBHomeFooterView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                     bundle:nil]
                                      instantiateWithOwner:self
                                      options:nil]
                                     objectAtIndex:0];
    [self addSubview:actualView];
}

#pragma mark - IBActions
- (IBAction)battleButtonTapped:(id)sender {
    [self startBattle];
}

#pragma mark - Battle Start
- (void)startBattle {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_START_ATTEMPT
                                                        object:self];
}
@end
