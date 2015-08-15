//
//  ShooterBullet.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-21.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "ShooterBullet.h"
#import "PlayScene.h"
#import "TextureBox.h"

@implementation ShooterBullet {
    PlayScene *_scene;
    float _frameTime;
    float _interval;
    
    CGPoint _center;
}

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime {
    if(self = [super initWithTex:tex thrusterTexs:thrusterTexs scene:scene dieTime:dieTime]) {
        _scene = (PlayScene*)scene;
        
        [self setTexture:tex];
        [self setSize:self.texture.size];
        
        
        [self configureCollisionBody];
        
        m_speed = 90;
        
        _center = CGPointMake(GameWidth/2, GameHeight/2);
        
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
    _frameTime += dt;
    if(self.parent != nil) {
        CGPoint distance = CGPointSubtract(_center, self.position);
            
        distance = CGPointNormalize(distance);
        CGPoint move = CGPointMultiplyScalar(distance, m_speed * dt);
        self.position = CGPointAdd(self.position, move);

    }
    

}

- (void)configureCollisionBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.usesPreciseCollisionDetection = NO;
    // Set the category of the physics object that will be used for collisions
    self.physicsBody.categoryBitMask = ColliderTypeEnemy;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    self.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = ColliderTypePlayer | ColliderTypeBullet;
    
}


- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    [self kill];
}


@end
