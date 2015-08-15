//
//  ViewController.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/16/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "ViewController.h"
#import "SetupScene.h"

#import "GameKitHelper.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController)
                                                 name:PresentAuthenticationViewController object:nil];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;

    setupScene.delegate = self;
    
    // Present the scene.
    [skView presentScene:setupScene];
}

-(void)callGameCenter:(SetupScene *)scene {
    [[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController:self];
}

-(void)showAuthenticationViewController {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [self presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
