//
//  BaseEnemy.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/26/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEnemy : SKSpriteNode {
    CGPoint m_direction;
    float m_rotation;
    float m_speed;
    double m_hp;
    BOOL m_isDead;
}

@property (nonatomic) CGPoint direction;
@property (nonatomic) float rotation;
@property (nonatomic) float speed;
@property (nonatomic) double hp;
@property (nonatomic) BOOL isDead;

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime;
-(void)update:(CFTimeInterval)dt;
-(void)reset;
-(void)configureCollisionBody;
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact;
-(void)scoreUp;

-(void)kill;

@end
