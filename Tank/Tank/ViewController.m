//
//  ViewController.m
//  Tank
//
//  Created by critter power on 11/20/13.
//  Copyright (c) 2013 Stenqvi. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView       = (SKView *)self.view;
    skView.showsFPS       = NO;
    skView.showsNodeCount = NO;

    //Scenes
    self.menu = [[Menu alloc] initWithSize:skView.bounds.size];
   // self.menu.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene: self.menu];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden{ return YES; }
- (BOOL)shouldAutorotate{return YES;}

@end
