//
//  Background.m
//  Tank
//
//  Created by critter power on 11/26/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import "Background.h"

@implementation Background

-(void) buildTerrain:(SKScene*)skv
{
 
    skv.backgroundColor = [SKColor colorWithRed:0.15 green:0 blue:1 alpha:1.0];
    self.points         = [[NSMutableArray alloc]init];
    NSValue *val;
    CGPoint p1;
    
    //setup line features
     self.line            = [SKShapeNode node];
    [self.line setLineWidth:0.02 ];
    [self.line setStrokeColor:[UIColor redColor]];
    self.line.fillColor = [UIColor blackColor];
    CGMutablePathRef pathToDraw  = CGPathCreateMutable();
    
    
    //create brownian Bridge Fractal
    [self brownianBridge: CGPointMake ( 0, skv.frame.size.height/2 )
                          Point02:CGPointMake
                          ( skv.frame.size.width,
                            skv.frame.size.height/2 )
                            max: 100 threshold:20 ];
    
    CGPathMoveToPoint(pathToDraw, NULL, 0, skv.frame.size.height/2); //added
    
    for (int i=0; i<self.points.count; i++)
    {
        //draw line from point
        val   = [self.points objectAtIndex:i];
        p1    = [val CGPointValue];
        CGPathAddLineToPoint(pathToDraw, NULL, p1.x, p1.y); //first
        
        
        //draw line to point
        if(i+1 < self.points.count)
        {
            val        = [self.points objectAtIndex:i+1];
            CGPoint p2 = [val CGPointValue];
            CGPathAddLineToPoint(pathToDraw,NULL,p2.x,p2.y);
        }
    }
    
    //build the sides and bottoms of the frame
    val       = [self.points lastObject];
    p1        = [val CGPointValue];
    
    CGPathAddLineToPoint ( pathToDraw, NULL, p1.x, p1.y );
    CGPathAddLineToPoint ( pathToDraw, NULL, skv.frame.size.width, 0 );
    CGPathAddLineToPoint ( pathToDraw, NULL, 0, 0 );
    
    val       = [self.points firstObject];
    p1        = [val CGPointValue];
    CGPathAddLineToPoint ( pathToDraw, NULL, p1.x, p1.y );
  
    self.line.path = pathToDraw;
    self.line.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:self.line.path];
   // CGPathRelease(pathToDraw);
    
    
    [skv addChild:self.line];
    
    
}


-(void) brownianBridge:(CGPoint)p1 Point02:(CGPoint)p2 max:(double)maxHeight threshold:(double)thresh
{
    
    
    if((p2.x - p1.x) < thresh)
    {
        NSValue* pOne = [NSValue valueWithCGPoint:p1];
        NSValue* pTwo = [NSValue valueWithCGPoint:p2];
        //add p1 and p2
        [self.points addObject:pOne];
        [self.points addObject:pTwo];
        
        return;
    }
    
    double posNeg    = arc4random() % 2 ? 1 : -1; //+1 or -1
    double rand      = maxHeight * posNeg;          //random multiplier
    
    CGPoint midPoint = CGPointMake( (p1.x + p2.x)/2, p1.y + rand ); //aggressive map
    
    [self brownianBridge:p1 Point02:midPoint max:maxHeight/2.2 threshold:thresh];
    [self brownianBridge:midPoint Point02:p2 max:maxHeight/2.2 threshold:thresh];
    
}


-(void) getPlayerStartPosition:(Player *)player WhichPlayer:(BOOL)bPlayer
                                ScreenWidth:(CGRect)frame
{
    //playerone
    if(bPlayer == TRUE)
    {
        for(int i=0;i<self.points.count;i++)
        {
            NSValue *val;
            CGPoint p1;
            val   = [self.points objectAtIndex:i];
            p1    = [val CGPointValue];
            
            
        if(!(player.player.size.width > p1.x - player.player.size.width))
            {
                player.player.position = CGPointMake(p1.x, p1.y+10);
                player.location        = CGPointMake(p1.x, p1.y+10);
                break;
            }
        }
        
        
    }
    //playertwo
    else
    {
        for(int i=self.points.count-1;i>0;i--)
        {
            NSValue *val;
            CGPoint p2;
            val   = [self.points objectAtIndex:i];
            p2    = [val CGPointValue];
            
            if( p2.x + player.player.size.width < frame.size.width &&
               p2.x > ( frame.size.width - ( player.player.size.width * 3 )))
            {
                player.player.position = CGPointMake(p2.x, p2.y+10);
                player.location        = CGPointMake(p2.x, p2.y+10);
                break;
            }
        }
    }
}




@end
