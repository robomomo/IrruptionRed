//
//  GameKitHelper.h
//  QuadCrisis
//
//  Created by Mo Mohamed on 2014-07-29.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

extern NSString *const PresentAuthenticationViewController;
extern NSString *const leaderboardID;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+(instancetype)sharedGameKitHelper;
-(void)authenticateLocalPlayer;
-(void)reportAchievements:(NSArray *)achievements;
-(void)showGKGameCenterViewController:(UIViewController*)viewController;
-(void)reportScore;

@end
