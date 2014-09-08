//
//  KLBHomeFooterView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBHomeFooterView.h"
#import "KLBNotifications.h"
#import "KLBAnimator.h"

NSString *const KLB_FOOTER_HINT_EASY_IMAGE_FILENAME = @"screenfootereasyhint.png";
NSString *const KLB_FOOTER_HINT_AVERAGE_IMAGE_FILENAME = @"screenfooteravghardhint.png";
NSString *const KLB_FOOTER_HINT_HARD_IMAGE_FILENAME = @"screenfooteravghardhint.png";

@implementation KLBHomeFooterView

#pragma mark - Dealloc
- (void)dealloc {
    [_battleButton release];
    [_battleButtonAverage release];
    [_battleButtonHard release];
    [_imageHint release];
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

- (void)initializeVariables {
    [self.imageHint.layer setHidden:YES];
}

#pragma mark - IBActions / Difficulty Setup
- (IBAction)battleButtonTapped:(id)sender {
    [self setupDifficulty:Easy];
}
- (IBAction)averageButtonTapped:(id)sender {
    [self setupDifficulty:Average];
}
- (IBAction)hardButtonTapped:(id)sender {
    [self setupDifficulty:Hard];
}
- (void)setupDifficulty:(BattleDifficulty)difficulty {
    self.selectedDifficulty = difficulty;
    NSNumber *difficultyValue = [NSNumber numberWithInteger:self.selectedDifficulty];
    NSDictionary *difficultyUserInfo = @{@"difficulty":difficultyValue};
    [[NSNotificationCenter defaultCenter] postNotificationName:KLB_NOTIFICATION_BATTLE_START_ATTEMPT
                                                        object:self
                                                      userInfo:difficultyUserInfo];
}

#pragma mark - Battle Lifecycle
- (void)battleDidStart {
    [self setButtonsEnabled:NO];
    [self setupImageHint];
    [self.imageHint.layer setHidden:NO];
    [KLBAnimator fadeInCALayer:self.imageHint.layer applyChanges:YES];
}
- (void)battleWillEnd {
    [self setButtonsEnabled:YES];
    [self setupImageHint];
    [self.imageHint.layer setHidden:NO];
    [KLBAnimator fadeOutCALayer:self.imageHint.layer applyChanges:YES];
}
- (void)setButtonsEnabled:(BOOL)enabled {
    [_battleButton setEnabled:enabled];
    [_battleButtonAverage setEnabled:enabled];
    [_battleButtonHard setEnabled:enabled];
}

#pragma mark - Image Hint Setup
- (void)setupImageHint {
    NSString *imageFileName = @"";
    switch (self.selectedDifficulty) {
        case Easy: {
            imageFileName = KLB_FOOTER_HINT_EASY_IMAGE_FILENAME;
        } break;
        case Average: {
            imageFileName = KLB_FOOTER_HINT_AVERAGE_IMAGE_FILENAME;
        } break;
        case Hard: {
            imageFileName = KLB_FOOTER_HINT_HARD_IMAGE_FILENAME;
        } break;
        default: {
            imageFileName = KLB_FOOTER_HINT_EASY_IMAGE_FILENAME;
        }
    }
    self.imageHint.image = [UIImage imageNamed:imageFileName];
}
@end
