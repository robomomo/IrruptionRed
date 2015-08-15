//
//  Player.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode {
    int m_HP;
}

@property int HP;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene;
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact;
-(void)death;
-(void)update:(CFTimeInterval)dt;
-(void)reset;
-(void)hideHP;
@end
