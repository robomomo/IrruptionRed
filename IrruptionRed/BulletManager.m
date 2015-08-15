//
//  BulletManager.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "BulletManager.h"
#import "Bullet.h"
#import "TextureBox.h"

@implementation BulletManager {
    float _shotCooldown;
    float _shotRate;
    
    SKScene *_scene;
    
    SKTexture *_frontBullet;
    SKTexture *_backBullet;
}

@synthesize bullets = m_bullets;
@synthesize angleOfBullets = m_angleOfBullets;

-(id)initWithAmount:(int)n scene:(SKScene*)scene {
    if(self = [super init]) {

        _scene = scene;
        
        _shotCooldown = 0;
        _shotRate = 0.05f;
        
        m_bullets = [[NSMutableArray alloc] init];
        
        
        for(int i = 0; i < n; i++) {
            Bullet *b = [[Bullet alloc] initWithImageNamed:@"player_bullet_back" scene:scene];
            [m_bullets addObject:b];
        }
        
        _frontBullet = [TextureBox getTexture:@"player_bullet_front"];
        _backBullet = [TextureBox getTexture:@"player_bullet_back"];
    }
    return self;
}

-(void)removeAllBullets {
    for(Bullet *b in m_bullets) {
        [b removeFromParent];
    }
}

- (void)update:(CFTimeInterval)dt {
    _shotCooldown += dt;

    if(m_angleOfBullets != 0)
        GPlayer.zRotation = m_angleOfBullets;
    
    // bullet
    if(_shotCooldown >= _shotRate) {
        _shotCooldown = 0;
        if(selectedWeapon == BigShot ) {
            for(Bullet *b in m_bullets) {
                if([self shouldFire] && b.parent == nil) {
                    [_scene runAction:[SKAction playSoundFileNamed:@"s1.wav" waitForCompletion:NO]];
                    [self fireBullet:b reverse:NO index:1];
                        break;
                }
            }
        } else if(selectedWeapon == DoubleShot) {
            for(int i = 0; i < 2; i ++) {
                for(Bullet *b in m_bullets) {
                    if([self shouldFire] && b.parent == nil) {
                        
                        if(i == 0)
                            [_scene runAction:[SKAction playSoundFileNamed:@"s1.wav" waitForCompletion:NO]];
                        if(i == 1)
                            [self fireBullet:b reverse:NO index:1];
                        else
                            [self fireBullet:b reverse:YES index:1];
                        break;
                    }
                }
            }
        } else if(selectedWeapon == Spread) {
            for(int i = 0; i < 3; i ++) {
                for(Bullet *b in m_bullets) {
                    if([self shouldFire] && b.parent == nil) {
                        
                        if(i == 0)
                          [_scene runAction:[SKAction playSoundFileNamed:@"s1.wav" waitForCompletion:NO]];
                        [self fireBullet:b reverse:NO index:i];
                        break;
                    }
                }
            }
        }
        
    }
    
    for(Bullet *b in m_bullets) {
        [b update:dt];
    }
}

-(void)fireBullet:(Bullet*)bullet reverse:(BOOL)reverse index:(int)index {
  
    CGPoint variance = CGPointZero;
    if(selectedWeapon != Spread)
        variance = CGPointMake(RandomFloatRange(-3, 3), RandomFloatRange(-3, 3));

    deltaPoint = CGPointNormalize(deltaPoint);
  
    bullet.position = GPlayer.position;
    
    bullet.position = CGPointAdd(bullet.position, variance);
 
    bullet.rotation = CGPointToAngle(deltaPoint);
    m_angleOfBullets = CGPointToAngle(deltaPoint);
    
    float wx = cosf(bullet.rotation);
    float wy = sinf(bullet.rotation);
  
    if(index == 0) {
        wx = cosf(bullet.rotation + .20);
        wy = sinf(bullet.rotation + .20) ;
    }
    else if(index == 2) {
        wx = cosf(bullet.rotation - .20);
        wy = sinf(bullet.rotation - .20);
    }

    
    if(reverse) {
        bullet.direction = CGPointMultiplyScalar(CGPointNormalize(CGPointMake(wx, wy)), -1);
        bullet.position = CGPointAdd(bullet.position, CGPointMultiplyScalar(CGPointNormalize(CGPointMake(wx, wy)), -5));
        bullet.texture = _frontBullet;
    }
    else {
        bullet.direction = CGPointNormalize(CGPointMake(wx, wy));
        bullet.position = CGPointAdd(bullet.position, CGPointMultiplyScalar(deltaPoint, 5));
        bullet.texture = _backBullet;
    }
  
    [_scene addChild:bullet];


}

-(BOOL)shouldFire {
    return _fireFlag;
}

@end
