//
//  Rounder.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/31/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "Rounder.h"
#import "PlayScene.h"
#import "TextureBox.h"


@implementation Rounder {
    PlayScene *_scene;
    float _frameTime;
    float _interval;
    float _angle;
    CGPoint _waypoint;
    BOOL _pointReached;
    SKSpriteNode *_explode;
    SKAction *_explodeAnimation;
    
    SKAction *_spin;
}

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime {
    if(self = [super initWithTex:tex thrusterTexs:thrusterTexs scene:scene dieTime:dieTime]) {

        _scene = (PlayScene*)scene;
        
        [self setTexture:tex];
        [self setSize:self.texture.size];
        
        _pointReached = NO;
        
        [self configureCollisionBody];
        m_speed = 5.0f;
        _interval = RandomFloatRange(0.2f, 4.5f);
        
        _waypoint = CGPointMake(GameWidth/2, GameHeight/2);
        _angle = 90;
        
        [self reset];
        
        m_hp = 9;
        
        _spin = [SKAction rotateByAngle:M_PI * 4 duration:2.3];
        
        _explode = [SKSpriteNode spriteNodeWithTexture:[explodeTexturesSmall objectAtIndex:0]];
        
        SKAction *explodeAnim = [SKAction animateWithTextures:explodeTexturesSmall timePerFrame:0.01];
        SKAction *hide = [SKAction runBlock:^{
            _explode.hidden = YES;
        }];
        
        _explodeAnimation = [SKAction sequence:@[explodeAnim, hide]];
        
        [self addChild:_explode];
        _explode.hidden = YES;
        [self runAction:[SKAction repeatActionForever:_spin]];
        
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
    _frameTime += dt;
    if(self.parent != nil) {
        if(_frameTime >= _interval) {
            if(!_pointReached) {
                float dx = _waypoint.x - self.position.x;
                float dy = _waypoint.y - self.position.y;
                    
                float vx = dx * m_speed * dt;
                float vy = dy * m_speed * dt;
                CGPoint pos = CGPointMake(vx, vy);
                    
                self.position = CGPointAdd(self.position, pos);
                    
                if(CGPointDistance(_waypoint, self.position) < 1) {
                    _pointReached = YES;
                }
                
            } else {
                _angle = 90 * dt;
                [self rotate];
            }
                
        }
            
    }
}

-(void)rotate {
    _angle = (_angle) * M_PI/180;
    CGPoint pointWithRotation = CGPointMake(
            cosf(_angle) * (self.position.x - GameWidth/2) - sinf(_angle) *  (self.position.y - GameHeight/2) + GameWidth/2,
            sinf(_angle) * (self.position.x - GameWidth/2) + cosf(_angle) *  (self.position.y - GameHeight/2) + GameHeight/2);
    
    self.position =  pointWithRotation;
}

- (void)reset {
    
    CGPoint direction;
    if(RandomFloatRange(0, 2) == 1) {
        self.position = CGPointMake(RandomFloatRange(-1000, [UIScreen mainScreen].bounds.size.width + 1000), -self.size.height);
        _waypoint.y -= GameHeight/2 * .50;
        direction = CGPointSubtract(_waypoint, self.position);
       
    }
    else
    {
        self.position = CGPointMake(RandomFloatRange(-1000, [UIScreen mainScreen].bounds.size.width + 1000),
                                    [UIScreen mainScreen].bounds.size.height + self.size.height);
        _waypoint.y += GameHeight/2 * .50;
        direction = CGPointSubtract(_waypoint, self.position);
    }
    
    m_direction = CGPointNormalize(direction);
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
    _explode.hidden = NO;
    [_explode runAction:_explodeAnimation];
  
    [self removeActionForKey:@"redflash"];
    SKAction *group = [SKAction sequence:@[
                                           [SKAction runBlock:^{ self.color = [SKColor redColor]; self.colorBlendFactor = 1.0; }],
                                           [SKAction waitForDuration:0.1],
                                           [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.0 duration:0.0]]];
    
    [self runAction:group withKey:@"redflash"];
    
    m_hp = m_hp - WeaponDamage;
    
    if(m_hp <= 0 && m_isDead == NO)
    {
        if(!isTutorial)
            RoundersDefeated++;
        
        [self kill];
        [self scoreUp];
        m_isDead = YES;
    }
}

@end
