//
//  Player.m
//  Tank
//
//  Created by critter power on 11/21/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import "Player.h"

@implementation Player{
    CGPoint location;
}

-(id)initWithSprite:(NSString*)str Scene:(SKScene*)scene X:(double)x Y:(double)y
{
    if (self = [super init]) {
        CGFloat x1 = x;
        CGFloat y1 = y;
        
        self.player                = [SKSpriteNode spriteNodeWithImageNamed:str];
        self.player.size           = CGSizeMake(20,30);
        self.player.position       = CGPointMake(x1, y1);
        self.player.physicsBody    = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        
        self.location              = self.player.position;

        
        [scene addChild:self.player];
    }
    
    return self;
}


@end
