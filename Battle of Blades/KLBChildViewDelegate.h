//
//  KLBChildViewDelegate.h
//  Battle of Blades
//
//  Created by Chase Gosingtian on 9/3/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLBChildViewDelegate <NSObject>
- (void)childDidRequestViewChange:(id)sender;
@end
