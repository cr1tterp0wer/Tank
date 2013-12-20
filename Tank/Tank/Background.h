//
//  Background.h
//  Tank
//
//  Created by critter power on 11/26/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SKShapeNode.h>
#import <SpriteKit/SKScene.h>
#import <SpriteKit/SKSpriteNode.h>
#import <SpriteKit/SKPhysicsBody.h>
#import "Player.h"

@interface Background : NSObject

@property NSMutableArray *points;
@property SKShapeNode *line;

-(void) buildTerrain:(SKScene*)skv;
-(void) brownianBridge:(CGPoint)p1 Point02:(CGPoint)p2 max:(double)maxHeight threshold:(double)thresh;
-(void) getPlayerStartPosition:(Player *)player WhichPlayer:(BOOL)bPlayer ScreenWidth:(CGRect)frame;


@end
