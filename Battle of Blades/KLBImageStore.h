//
//  KLBImageStore.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forFilename:(NSString *)filename;
- (UIImage *)imageForFilename:(NSString *)filename;
- (void)deleteImageForFilename:(NSString *)filename;

@end
