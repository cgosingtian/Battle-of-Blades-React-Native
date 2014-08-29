//
//  KLBJSONController.m
//  Battle of Blades
//
//  Created by Chase Gosingtian on 8/29/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBJSONController.h"

@implementation KLBJSONController

+ (NSDictionary *) loadJSONfromFile:(NSString *)file {
    NSString *strippedExtension = [file stringByDeletingPathExtension];
    
    NSString *existingFilename = [NSString stringWithFormat:@"%@.%@",strippedExtension,@"json"];
    NSString *existingFilePath = [self filePathInDocuments:existingFilename];
    NSURL *existingFileURL = [NSURL fileURLWithPath:existingFilePath];
    
    NSData *existingJSONData = [[NSData alloc] initWithContentsOfURL:existingFileURL];
    
    // Try loading the JSON file from our Bundle if file in Documents directory doesn't exist
    if (!existingJSONData) {
        NSString *filename = [[NSBundle mainBundle] pathForResource:strippedExtension
                                                             ofType:@"json"];
        NSURL *fileURL = [NSURL fileURLWithPath:filename];
        
        NSData *JSONData = [[NSData alloc] initWithContentsOfURL:fileURL];
        existingJSONData = JSONData;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:existingJSONData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    [existingJSONData release];
    return dictionary;
}

+ (void) saveJSONtoFile:(NSString *)file contents:(NSDictionary *)dictionary {
    NSString *strippedExtension = [file stringByDeletingPathExtension];
    NSString *filename = [NSString stringWithFormat:@"%@.%@",strippedExtension,@"json"];
    NSString *filePath = [self filePathInDocuments:filename];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    [JSONData writeToURL:fileURL atomically:YES];
}

+ (NSString *)filePathInDocuments:(NSString *)filename
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:filename];
}

@end
