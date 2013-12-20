//
//  Game.h
//  Tank
//
//  Created by critter power on 11/21/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scene.h"
#import "Background.h"
#import "Player.h"

@interface Game : Scene
@property Player            *player01, *player02;
@property NSMutableArray    *points;
@property Background        *background;
@property SKShapeNode       *targetLine;
@property SKLabelNode       *forceLabel;
@property CGMutablePathRef  *targetPoint;
@property CGVector          velocity;
@property float             force;
@property BOOL              playerOneTurn;
@property BOOL              lineTooBig;
@property BOOL              isGameOn;
@end

static const uint32_t missileCategory     =  0x1 << 0;
static const uint32_t terrainCategory     =  0x1 << 1;
static const uint32_t explosionCategory   =  0x1 << 2;
static const uint32_t skyBoxCategory      =  0x1 << 3;
static const uint32_t player01Category    =  0x1 << 4;
static const uint32_t player02Category    =  0x1 << 5;