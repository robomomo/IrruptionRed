//
//  MyScene.h
//  prototypeshooter
//

//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayScene : SKScene <SKPhysicsContactDelegate>{
    SKNode *m_enemyLayer;
    SKNode *m_powerUpLayer;
}

@property (strong, nonatomic) SKNode *enemyLayer;
@property (strong, nonatomic) SKNode *powerUpLayer;

-(void)reset;

@end
