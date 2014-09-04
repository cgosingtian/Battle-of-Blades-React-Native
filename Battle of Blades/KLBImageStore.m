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
        imageStore = [[self alloc] initPrivate];
    });
    
    return imageStore;
}

- (instancetype)initPrivate
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

- (void)clearCache:(id)sender
{
    [self.dictionary removeAllObjects];
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[KLBImageStore sharedStore]"];
    return nil;
}

#pragma mark - Image Getters and Setters
- (void)setImage:(UIImage *)image forFilename:(NSString *)filename
{
    self.dictionary[filename] = image; //shorthand
}

-(UIImage *)imageForFilename:(NSString *)filename
{
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[filename];
    if (!result) {
        result = [UIImage imageNamed:filename];
        if (result) {
            self.dictionary[filename] = result;
        } else {
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

//- (NSString *)imagePathForKey:(NSString *)key
//{
//    NSArray *documentDirectories =
//    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                        NSUserDomainMask,
//                                        YES);
//    NSString *documentDirectory = [documentDirectories firstObject];
//    return [documentDirectory stringByAppendingPathComponent:key];
//}
@end
