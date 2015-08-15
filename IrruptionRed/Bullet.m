//
//  Bullet.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/22/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "Bullet.h"
#import "PlayScene.h"
#import "TextureBox.h"

@implementation Bullet {
    PlayScene *_scene;
    float _bulletSpeed;
}

@synthesize direction = m_direction;
@synthesize rotation = m_rotation;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene {
    if(self = [super init]) {
        _scene = (PlayScene*)scene;
        
        _bulletSpeed = 550.0f;
        
        [self setTexture:[TextureBox getTexture:name]];

        [self configureCollisionBody];
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
    if(self.parent != nil) {
        
        if(selectedWeapon == BigShot) {
            [self setSize:CGSizeMake(28 * 1.8, 17 * 1.8)];
            WeaponDamage = 4;
            _bulletSpeed = 750.0f;
        } else if (selectedWeapon == DoubleShot) {
             [self setSize:CGSizeMake(28 * 1.1, 17 * 1.1)];
            WeaponDamage = 2;
            _bulletSpeed = 550.0f;
        }
        else if (selectedWeapon == Spread) {
             [self setSize:CGSizeMake(28 * .8, 17 * .8)];
            WeaponDamage = 0.8;
            _bulletSpeed = 550.0f;
        }
        
        self.zRotation = m_rotation;
        
        CGPoint spd = CGPointMultiplyScalar(m_direction, _bulletSpeed * dt);
        self.position = CGPointAdd(self.position, spd);
        
        if (self.position.x + self.size.width/2 > GameWidth + self.size.width ||
            self.position.x - self.size.width/2 < -self.size.width ||
            self.position.y + self.size.height/2 > GameHeight + self.size.height ||
            self.position.y - self.size.height/2 < -self.size.height)
        {
            [self removeFromParent];
            self.position = GPlayer.position;
        }
    }

}

- (void)configureCollisionBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5];
    
    self.physicsBody.affectedByGravity = NO;

    self.physicsBody.usesPreciseCollisionDetection = NO;
    // Set the category of the physics object that will be used for collisions
    self.physicsBody.categoryBitMask = ColliderTypeBullet;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    self.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = ColliderTypeEnemy;
    
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    [self removeFromParent];
}

@end
