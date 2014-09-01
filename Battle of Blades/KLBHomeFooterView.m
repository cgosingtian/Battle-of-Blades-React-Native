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
        [self registerForNotifications];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Other Initializing Methods
- (void)replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    KLBHomeFooterView *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                     bundle:nil]
                                      instantiateWithOwner:self
                                      options:nil]
                                     objectAtIndex:0];
    [self addSubview:actualView];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleDidStart)
                                                 name:KLB_NOTIFICATION_BATTLE_START
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(battleWillEnd)
                                                 name:KLB_NOTIFICATION_BATTLE_END
                                               object:nil];
}

#pragma mark - IBActions
- (IBAction)battleButtonTapped:(id)sender {
    [self battleWillStart];
}

#pragma mark - Battle Lifecycle
- (void)battleWillStart {
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_START_ATTEMPT
                                                        object:self];
}
- (void)battleDidStart {
    NSLog(@"battle did start");
    [_battleButton setEnabled:NO];
}
- (void)battleWillEnd {
    NSLog(@"battle will end");
    [_battleButton setEnabled:YES];
}
@end
