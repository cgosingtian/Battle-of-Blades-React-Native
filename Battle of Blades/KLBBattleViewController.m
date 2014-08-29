//
//  KLBBattleView.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/28/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBBattleViewController.h"
#import "KLBJSONController.h"
#import "KLBEnemyStore.h"
#import "KLBEnemy.h"
#import "KLBNotifications.h"
#import "KLBAnimator.h"

NSString *const KLB_LABEL_HEALTH_TEXT_FORMAT = @"Health: ";
NSString *const KLB_LABEL_TIME_LEFT_TEXT_FORMAT = @"Time Left: ";
NSString *const KLB_LABEL_NAME_TEXT_FORMAT = @"";
NSString *const KLB_LABEL_LEVEL_TEXT_FORMAT = @"Level ";

CGFloat const KLB_MAX_ALPHA = 1.0;

@implementation KLBBattleViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self showCover];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self replacePlaceholderViewsWithActual];
        [self registerForNotifications];
        [self showCover];
    }
    return self;
}

#pragma mark - Other Initializing Methods
- (void)replacePlaceholderViewsWithActual {
    //Replace placeholders of this class in other XIBs with our defined XIB
    KLBBattleViewController *actualView = [[[UINib nibWithNibName:NSStringFromClass([self class])
                                                           bundle:nil]
                                            instantiateWithOwner:self
                                            options:nil]
                                           objectAtIndex:0];
    [self addSubview:actualView];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startBattle) name:KLB_NOTIFICATION_START_BATTLE object:nil];
}

- (void)showCover {
    self.coverView.alpha = KLB_MAX_ALPHA;
}

#pragma mark - Battle Control
- (void)startBattle {
    //apply a fade out animation to the coverView, and apply the changes
    [KLBAnimator fadeOutCALayer:self.coverView.layer applyChanges:YES];
    //load an enemy
    NSString *enemyKey = [self loadRandomEnemyData];
    self.activeEnemy = [[KLBEnemyStore sharedStore] enemyForKey:enemyKey];
    //configure the screen labels
    NSUInteger enemyHealth = self.activeEnemy.healthRemaining;
    self.healthLabel.text = [NSString stringWithFormat:@"%@%lu",
                             KLB_LABEL_HEALTH_TEXT_FORMAT,
                             (unsigned long)enemyHealth];
    NSUInteger enemyTimeLimit = self.activeEnemy.timeLimitSeconds;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%@%lu",
                             KLB_LABEL_TIME_LEFT_TEXT_FORMAT,
                             (unsigned long)enemyTimeLimit];
    self.enemyNameLabel.text = [NSString stringWithFormat:@"%@%@",
                                KLB_LABEL_NAME_TEXT_FORMAT,
                                self.activeEnemy.name];
    NSUInteger enemyLevel = self.activeEnemy.level;
    self.enemyLevelLabel.text = [NSString stringWithFormat:@"%@%lu",
                                 KLB_LABEL_LEVEL_TEXT_FORMAT,
                                 (unsigned long)enemyLevel];
}

- (NSString *)loadRandomEnemyData {
    NSDictionary *jsonDictionary = [KLBJSONController loadJSONfromFile:KLB_JSON_FILENAME];
    NSDictionary *enemiesList = [jsonDictionary objectForKey:KLB_JSON_ENEMIES_LIST];
    
    NSArray *keys = [enemiesList allKeys];
    NSUInteger randomIndex = arc4random_uniform([keys count]);
    NSString *key = [keys objectAtIndex:randomIndex];
    
    NSString *enemyName = [enemiesList[key] objectForKey:KLB_JSON_ENEMY_NAME];
    NSUInteger enemyLevel = [[enemiesList[key] objectForKey:KLB_JSON_ENEMY_LEVEL] integerValue];
    NSUInteger enemyHealthMaximum = [[enemiesList[key] objectForKey:KLB_JSON_ENEMY_HEALTH] integerValue];
    NSUInteger timeLimitSeconds = [[enemiesList[key] objectForKey:KLB_JSON_ENEMY_TIME_LIMIT] integerValue];
    
    KLBEnemy *enemy = [[KLBEnemy alloc] initWithName:enemyName
                                               level:enemyLevel
                                       healthMaximum:enemyHealthMaximum
                                    timeLimitSeconds:timeLimitSeconds];
    
    [[KLBEnemyStore sharedStore] addEnemy:enemy forKey:key];
    
    // We return the key (not the retrieved dictionary) because we
    // want to restrict access to the EnemyStore only.
    return key;
}

- (void)dealloc {
    [_enemyImage release];
    [_battleInfoBackground release];
    [_healthLabel release];
    [_timeLeftLabel release];
    [_coverView release];
    [_enemyNameLabel release];
    [_enemyLevelLabel release];
    [super dealloc];
}
@end
