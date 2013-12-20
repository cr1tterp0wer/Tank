//
//  Menu.m
//  Tank
//
//  Created by critter power on 11/21/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import "Menu.h"

@implementation Menu


-(id)initWithSize:(CGSize)size {
    
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor     = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        SKLabelNode *title       = [SKLabelNode labelNodeWithFontNamed:@"Copperplate-Bold"];
        
        title.text               = @"TANK!";
        title.fontSize           = 30;
        title.position           = CGPointMake(CGRectGetMidX(self.frame),500);
        title.fontColor          = [SKColor greenColor];
        
        SKLabelNode *titleShadow       = [SKLabelNode labelNodeWithFontNamed:@"Copperplate-Bold"];
        
        titleShadow.text               = @"TANK!";
        titleShadow.fontSize           = 30;
        titleShadow.position           = CGPointMake(CGRectGetMidX(self.frame)+2,498);
        titleShadow.fontColor          = [SKColor redColor];

        
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"menu.jpg"];
        background.position      = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMidY(self.frame));
        
        [self addChild:   background];
        [self addChild:   title];
        [self addChild:   titleShadow];
        [self addChild:   [self playButtonNode]];
        
    }
    return self;
}


- (SKSpriteNode *)playButtonNode
{
    SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"playbutton.png"];
    playNode.position      = CGPointMake(CGRectGetMidX(self.frame),50);
    playNode.size          = CGSizeMake(30,60);
    playNode.name          = @"playNode";
    return playNode;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch         = [touches anyObject];
    CGPoint location       = [touch locationInNode:self];
    SKNode *node           = [self nodeAtPoint:location];
    self.game              = [[Game alloc] initWithSize:self.size];
  //  self.game.scaleMode    = SKSceneScaleModeAspectFill;
    
    if ([node.name isEqualToString:@"playNode"]) {
        
        SKAction *moveUp   = [SKAction moveByX:0 y:-100 duration:0.5];
        SKAction *zoom     = [SKAction scaleBy:1.0 duration:.25];
        SKAction *pause    = [SKAction waitForDuration:.2];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:.4];
        SKAction *remove   = [SKAction removeFromParent];
        SKAction *sequence = [SKAction sequence:@[moveUp,zoom,pause,fadeAway,remove]];
        
        //run transition
        [self runAction: sequence completion:^{
                   
               SKTransition *doors = [SKTransition doorsCloseHorizontalWithDuration:.5];
               [self.view presentScene: self.game transition:doors]; }];
    }
    
    
}


@end
