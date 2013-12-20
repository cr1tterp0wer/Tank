//
//  End.m
//  Tank
//
//  Created by critter power on 11/21/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import "End.h"

@implementation End


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 2
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        // 3
        self.backgroundColor = [SKColor colorWithRed:0 green:1 blue:0 alpha:1.0];
    }
    return self;
}

@end
