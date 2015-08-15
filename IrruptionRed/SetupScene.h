//
//  SetupScene.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-04.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GameCenterTappedDelegate;

@interface SetupScene : SKScene

@property (nonatomic, weak) id<GameCenterTappedDelegate> delegate;

-(void)updateValues;

@end


@protocol GameCenterTappedDelegate <NSObject>
-(void)callGameCenter:(SetupScene *)scene;
@end