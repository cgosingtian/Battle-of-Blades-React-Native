//
//  KLBImageStore.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBImageStore.h"

@interface KLBImageStore ()
@property (retain, nonatomic) NSMutableDictionary *dictionary;
@end

@implementation KLBImageStore

#pragma mark - Initializers and Singleton Getter
+ (instancetype)sharedStore
{
    static KLBImageStore *imageStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageStore = [[self alloc] init];
    });
    
    return imageStore;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCache:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Image Getters and Setters
- (void)setImage:(UIImage *)image forFilename:(NSString *)filename
{
    self.dictionary[filename] = image; //shorthand
}

-(UIImage *)imageForFilename:(NSString *)filename
{
    // Check if the image requested is already cached
    UIImage *result = self.dictionary[filename];
    if (!result) {
        // Otherwise, try loading the image from Resources
        result = [UIImage imageNamed:filename];
        if (result) {
            // Cache the image found
            self.dictionary[filename] = result;
        } else {
            // Report that no image was found
            NSLog(@"Error: unable to find %@ in resources or image store.", filename);
        }
    }
    return result;
}

- (void)deleteImageForFilename:(NSString *)filename
{
    if (!filename)
        return;
    
    [self.dictionary removeObjectForKey:filename];
}

- (void)clearCache:(id)sender
{
    [self.dictionary removeAllObjects];
}
@end
