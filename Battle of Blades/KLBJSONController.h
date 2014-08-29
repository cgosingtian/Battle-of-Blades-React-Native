//
//  KLBJSONController.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Files
extern NSString *const KLB_JSON_FILENAME;

// JSON Format Keywords
extern NSString *const KLB_JSON_PLAYER_DATA;
extern NSString *const KLB_JSON_ENEMIES_LIST;

// JSON Format Keywords - Player Stats
extern NSString *const KLB_JSON_PLAYER_ENERGY_CURRENT;
extern NSString *const KLB_JSON_PLAYER_ENERGY_MAXIMUM;
extern NSString *const KLB_JSON_PLAYER_EXPERIENCE;
extern NSString *const KLB_JSON_PLAYER_KILLS;
extern NSString *const KLB_JSON_PLAYER_LEVEL;
extern NSString *const KLB_JSON_PLAYER_NAME;
extern NSString *const KLB_JSON_PLAYER_TIME_BONUS;

// JSON Format Keywords - Enemy Stats
extern NSString *const KLB_JSON_ENEMY_HEALTH;
extern NSString *const KLB_JSON_ENEMY_LEVEL;
extern NSString *const KLB_JSON_ENEMY_NAME;
extern NSString *const KLB_JSON_ENEMY_TIME_LIMIT;

@interface KLBJSONController : NSObject

+ (NSDictionary *) loadJSONfromFile:(NSString *)file;
+ (void) saveJSONtoFile:(NSString *)file contents:(NSDictionary *)dictionary;

@end
