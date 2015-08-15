//
//  Bullet.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/22/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKSpriteNode {
    CGPoint m_direction;
    float m_rotation;
}

@property (nonatomic) CGPoint direction;
@property (nonatomic) float rotation;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene;
-(void)update:(CFTimeInterval)dt;
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact;

@end
