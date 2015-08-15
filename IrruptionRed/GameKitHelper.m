//
//  GameKitHelper.m
//  QuadCrisis
//
//  Created by Mo Mohamed on 2014-07-29.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "GameKitHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const leaderboardID = @"com.momogames.IrruptionRed.highscore";

@interface GameKitHelper ()<GKGameCenterControllerDelegate>

@end

@implementation GameKitHelper {
    BOOL _enableGameCenter;
}

-(id)init {
    self = [super init];
    if(self) {
        _enableGameCenter = YES;
    }
    return self;
}

+(instancetype)sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

-(void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
        } else {
            _enableGameCenter = NO;
        }
    };
}

-(void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    if(authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
    }
}

-(void)setLastError:(NSError *)error {
    _lastError = [error copy];
    if(_lastError) {
        NSLog(@"@GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
    }
}

-(void)reportAchievements:(NSArray *)achievements {
    if(!_enableGameCenter) {
        NSLog(@"Local player is not authenticated");
    }
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];
}

-(void)showGKGameCenterViewController:(UIViewController*)viewController {
    if(!_enableGameCenter) {
        NSLog(@"Local player is not authenticated");
    }
    
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.gameCenterDelegate = self;
    gameCenterViewController.viewState = GKGameCenterViewControllerStateAchievements;
    
    [viewController presentViewController:gameCenterViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)reportScore {
    if(!_enableGameCenter) {
        NSLog(@"Local player is not authenticated");
    }
    
    GKScore *scoreReporter = [[[GKScore alloc] init] initWithLeaderboardIdentifier:leaderboardID];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];
}

@end
