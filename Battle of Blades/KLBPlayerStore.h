//
//  KLBPlayerStore.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBPlayerStore : NSObject
+(instancetype)sharedStore;
- (NSDictionary *)allItems;
- (void)addPlayerValue:(id)object forKey:(NSString *)key;
- (id)playerValueforKey:(NSString *)key;
- (void)setAllItems:(NSMutableDictionary *)dictionary;
@end
