//
//  Game.m
//  Tank
//
//  Created by critter power on 11/21/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import "Game.h"

@implementation Game
{
    float x, y;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])
    {
        
        self.force = 0.0;
        self.forceLabel    = [SKLabelNode labelNodeWithFontNamed:@"CourierNewPS-BoldMT"];
        self.forceLabel.text               = [NSString stringWithFormat:@"FORCE:%2.1f",self.force];
        self.forceLabel.fontSize           = 30;
        self.forceLabel.position           = CGPointMake(CGRectGetMidX(self.frame),500);
        self.forceLabel.fontColor          = [SKColor whiteColor];
        [self addChild:self.forceLabel];

        self.playerOneTurn = true;
        self.isGameOn      = true;
        
        self.physicsBody                    = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate   = self;
        self.physicsBody.categoryBitMask    = skyBoxCategory;
       // self.physicsBody.collisionBitMask   = missileCategory;
        self.physicsBody.contactTestBitMask = missileCategory;
        self.physicsWorld.gravity           = CGVectorMake(0,-.5);
        
        self.background  = [[Background alloc]init];
        [self.background buildTerrain:self];
        self.player01         = [[Player alloc]initWithSprite:@"king_tiger.gif"
                                    Scene:self
                                    X:20
                                    Y:self.frame.size.height/2];
        
        self.player02         = [[Player alloc]initWithSprite:@"sherman.png"
                                    Scene:self
                                    X:self.frame.size.width - 30
                                    Y:0];
        self.background.line.physicsBody.categoryBitMask    = terrainCategory;
        self.background.line.physicsBody.collisionBitMask   = missileCategory | explosionCategory;
        
        self.player01.player.physicsBody.dynamic            = YES;
        self.player01.player.physicsBody.affectedByGravity  = NO;
        self.player01.player.zPosition                      = 1;
        self.player01.player.physicsBody.categoryBitMask    = player01Category;
        self.player01.player.physicsBody.collisionBitMask   = explosionCategory | missileCategory;
        self.player01.player.physicsBody.contactTestBitMask = explosionCategory | missileCategory;
        [self.background getPlayerStartPosition:self.player01 WhichPlayer:TRUE
                                                ScreenWidth:self.frame];
        
        
        self.player02.player.physicsBody.dynamic            = YES;
        self.player02.player.physicsBody.affectedByGravity  = NO;
        self.player01.player.zPosition                      = 1;
        self.player02.player.physicsBody.categoryBitMask    = player02Category;
        self.player02.player.physicsBody.collisionBitMask   = explosionCategory;
        self.player02.player.physicsBody.contactTestBitMask = explosionCategory;
        [self.background getPlayerStartPosition:self.player02 WhichPlayer:FALSE
                                                ScreenWidth:self.frame];

    }
    return self;
}

#pragma mark TOUCHES_BEGAN
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch         = [touches anyObject];
    CGPoint location       = [touch locationInNode:self];
    self.targetPoint       = CGPathCreateMutable();
    float result = 0.0;
    
    if(self.isGameOn)
    {
        if(self.playerOneTurn)
        {
            CGPathMoveToPoint(  self.targetPoint,
                                NULL, self.player01.location.x,
                                self.player01.location.y);
            
            CGPathAddLineToPoint(self.targetPoint, NULL, location.x, location.y);
    
            self.targetLine      = [SKShapeNode node];
            self.targetLine.path = self.targetPoint;
            result               = [self distanceFormulaX1:self.player01.location.x X2:location.x
                                                        Y1:self.player01.location.y Y2:location.y];
            self.force     = result * .05;
            self.velocity  = CGVectorMake((location.x - self.player01.location.x)/2 * self.force ,
                                      (location.y - self.player01.location.y) /2 * self.force);
        }
        else
        {
            CGPathMoveToPoint(self.targetPoint,
                            NULL,
                            self.player02.location.x,
                            self.player02.location.y);
        
            CGPathAddLineToPoint(self.targetPoint, NULL,
                                 location.x, location.y);
        
            self.targetLine      = [SKShapeNode node];
            self.targetLine.path = self.targetPoint;
            result               = [self distanceFormulaX1:self.player02.location.x X2:location.x
                                                    Y1:self.player02.location.y Y2:location.y];
        
            self.force     = result * .05;
            self.velocity  = CGVectorMake((location.x - self.player02.location.x)/2 * self.force ,
                                      (location.y - self.player02.location.y) /2 * self.force);
        }
    
        if( result > 150.0)
        {
            self.forceLabel.fontColor   = [SKColor redColor];
            self.targetLine.strokeColor = [SKColor redColor];
            self.lineTooBig             = true;
        }
        else{
            self.forceLabel.fontColor   = [SKColor whiteColor];
            self.targetLine.strokeColor = [SKColor greenColor];
            self.lineTooBig             = false;
        }

      self.forceLabel.text            = [NSString stringWithFormat:@"FORCE:%2.1f",self.force];
      [self addChild:self.targetLine];
    }
    else
    {
        SKNode *node           = [self nodeAtPoint:location];
        if ([node.name isEqualToString:@"continueButtonNode"])
        {
           
            SKAction *pause    = [SKAction waitForDuration:.2];
            SKAction *fadeAway = [SKAction fadeOutWithDuration:.4];
            SKAction *remove   = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[pause,fadeAway,remove]];
            
            Game *game = [[Game alloc]initWithSize:self.size];
            
            //run transition
            [self runAction: sequence completion:
             ^{
                
                SKTransition *doors = [SKTransition doorsCloseHorizontalWithDuration:.5];
                [self.view presentScene: game transition:doors]; }];
        

        }
        else if([node.name isEqualToString:@"quitButtonNode"])
        {
            exit(0);
        }
    
        
    }

}

#pragma mark TOUCHES_MOVED
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch         = [touches anyObject];
    CGPoint location       = [touch locationInNode:self];
    float result = 0.0;
    self.targetPoint = CGPathCreateMutable();
    
    if(self.isGameOn)
    {
        if(self.playerOneTurn)
        {
            CGPathMoveToPoint(self.targetPoint, NULL,
                            self.player01.location.x,
                            self.player01.location.y);
        
            CGPathAddLineToPoint(self.targetPoint, NULL,
                                location.x, location.y);
        
            self.targetLine.path = self.targetPoint;
            result               = [self distanceFormulaX1:self.player01.location.x X2:location.x
                                                        Y1:self.player01.location.y Y2:location.y];
            self.force     = result * .05;
            self.velocity  = CGVectorMake((location.x - self.player01.location.x)/2 * self.force ,
                                        (location.y - self.player01.location.y) /2 * self.force);
            CGPathRelease(self.targetPoint);

        }
        else
        {
            CGPathMoveToPoint(self.targetPoint, NULL,
                            self.player02.location.x,
                            self.player02.location.y);
        
            CGPathAddLineToPoint(self.targetPoint, NULL,
                                location.x, location.y);
        
            self.targetLine.path = self.targetPoint;
            result               = [self distanceFormulaX1:self.player02.location.x X2:location.x
                                                        Y1:self.player02.location.y Y2:location.y];
        
            self.force     = result * .05;
            self.velocity  = CGVectorMake((location.x - self.player02.location.x)/2 * self.force ,
                                        (location.y - self.player02.location.y) /2 * self.force);
            CGPathRelease(self.targetPoint);
        }
    
        if( result > 150.0)
        {
            self.forceLabel.fontColor   = [SKColor redColor];
            self.targetLine.strokeColor = [SKColor redColor];
            self.lineTooBig = true;
        }
        else{
            self.forceLabel.fontColor   = [SKColor whiteColor];
            self.targetLine.strokeColor = [SKColor greenColor];
            self.lineTooBig = false;
        }
    
        self.forceLabel.text            = [NSString stringWithFormat:@"FORCE:%2.1f",self.force];
    }
}

#pragma mark TOUCHES_ENDED
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isGameOn)
    {
        if(self.playerOneTurn)
        {
            if(!self.lineTooBig)
            {
                [self buildMissile:self.player01.location];
                self.playerOneTurn = NO;
            }
        }
        else
        {
            if(!self.lineTooBig)
            {
            
                [self buildMissile:self.player02.location];
                self.playerOneTurn = YES;
            }
        }
    
        self.forceLabel.text  = [NSString stringWithFormat:@"FORCE:%2.1f",self.force];
        // delete the following line if you want the line to remain on screen.
        [self.targetLine removeFromParent];
    }
    
}

#pragma mark DID_BEGIN_CONTACT:COLLISION
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
    
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody  = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody  = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if((firstBody.categoryBitMask & missileCategory) != 0)
    {
        NSLog(@"HIT");
        if((secondBody.categoryBitMask & skyBoxCategory) != 0)
        {
            NSLog(@"Skybox hit");
            [firstBody.node removeFromParent];
        }
        if((secondBody.categoryBitMask & player01Category) != 0
            || (secondBody.categoryBitMask & player02Category) != 0)
        {
            self.forceLabel.text               = [NSString stringWithFormat:@"GAME OVER!"];
            
            self.forceLabel.fontSize           = 30;
            self.forceLabel.position           = CGPointMake(CGRectGetMidX(self.frame),500);
            self.forceLabel.fontColor          = [SKColor redColor];
            
            [self addChild:[self continueButtonNode]];
            [self addChild:[self quitButtonNode]];
            self.isGameOn = false;

            NSLog(@"Player01 hit");
            [firstBody.node removeFromParent];
            [secondBody.node removeFromParent];
            
        }
        if((secondBody.categoryBitMask & player02Category) != 0)
        {
            NSLog(@"Player02 hit");
            [firstBody.node removeFromParent];
            [secondBody.node removeFromParent];
        }
        if((secondBody.categoryBitMask & terrainCategory) != 0)
        {
            
            NSLog(@"Terrain hit");
            [self buildExplosion:contact];

        }
    }
}


#pragma BUILD_EXPLOSION
-(void) buildExplosion:(SKPhysicsContact *)contact
{
    float radius          = 20.0;
    SKShapeNode *ball     = [[SKShapeNode alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, contact.bodyB.node.position.x,
                       contact.bodyB.node.position.y,
                       radius, M_1_PI, M_1_PI*2, YES);
    
    ball.path = path;
    ball.fillColor   = [SKColor blueColor];
    ball.strokeColor = [SKColor blueColor];
    
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    ball.physicsBody.dynamic =  YES;
    ball.physicsBody.affectedByGravity = NO;

    ball.physicsBody.usesPreciseCollisionDetection = YES;
    
    ball.physicsBody.categoryBitMask    = explosionCategory;
    ball.physicsBody.contactTestBitMask = terrainCategory | player01Category | player02Category;
    ball.physicsBody.collisionBitMask   = 0;
    
    [self addChild:ball];
    [contact.bodyB.node removeAllChildren];
    [contact.bodyB.node removeFromParent];

}

#pragma BUILD_BOMB
-(void) buildMissile:(CGPoint)location
{
    CGPoint       currentPlayerLocation = location;
  

    
    
    SKSpriteNode *orb = [SKSpriteNode spriteNodeWithImageNamed:@"Bomb.png"];

    orb.xScale        = .05;
    orb.yScale        = .05;
    orb.position      = CGPointMake(currentPlayerLocation.x,
                                    currentPlayerLocation.y + orb.size.height+10);
    orb.physicsBody   = [SKPhysicsBody bodyWithCircleOfRadius:orb.size.width*.2];
    orb.physicsBody.usesPreciseCollisionDetection = YES;
    orb.physicsBody.dynamic =  YES;
    orb.physicsBody.categoryBitMask    = missileCategory, player02Category;

    orb.physicsBody.contactTestBitMask = terrainCategory | missileCategory | player01Category |
                                         player02Category;
    
    orb.physicsBody.velocity           = self.velocity;
    
    
    
    NSString      *burstPath    = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    SKEmitterNode *particleNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    particleNode.xScale         = .4;
    particleNode.yScale         = .4;
    particleNode.position       = orb.position;
    
    particleNode.targetNode = self.scene;
    [self addChild:orb];
    [self addChild:particleNode];
}


#pragma UPDATE
-(void)update:(NSTimeInterval)currentTime
{
    
}

#pragma DISTANCE_FORMULA
-(float) distanceFormulaX1:(float)x1 X2:(float)x2 Y1:(float)y1 Y2:(float)y2
{
    float result = sqrt(  pow(x2-x1 , 2) + pow(y2-y1 , 2)  );
    return result;
}

#pragma CONTINUE_BUTTON_NODE
- (SKSpriteNode *)continueButtonNode
{
    SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"continue.jpg"];
    playNode.position      = CGPointMake(CGRectGetMidX(self.frame)-30,50);
    playNode.size          = CGSizeMake(30,60);
    playNode.name          = @"continueButtonNode";
    return playNode;
}

#pragma QUIT_BUTTON_NODE
- (SKSpriteNode *)quitButtonNode
{
    SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"quit.png"];
    playNode.position      = CGPointMake(CGRectGetMidX(self.frame)+30,50);
    playNode.size          = CGSizeMake(30,60);
    playNode.name          = @"quitButtonNode";
    return playNode;
}


@end