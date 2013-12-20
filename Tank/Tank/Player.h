//
//  Player.h
//  Tank
//
//  Created by critter power on 11/21/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SKSpriteNode.h>
#import <SpriteKit/SKScene.h>
#import <SpriteKit/SKPhysicsBody.h>

@interface Player : NSObject
@property CGPoint location;
@property SKSpriteNode *player;
-(id)initWithSprite:(NSString*)str Scene:(SKScene*)scene X:(double)x Y:(double)y;

@end
