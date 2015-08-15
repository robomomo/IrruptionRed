//
//  Zoomer.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/26/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "Zoomer.h"
#import "PlayScene.h"
#import "TextureBox.h"


@implementation Zoomer {
    PlayScene *_scene;
    float _frameTime;
    float _interval;
    
    SKSpriteNode *_explode;
    SKAction *_explodeAnimation;

    CGPoint center;
}

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime {
    if(self = [super initWithTex:tex thrusterTexs:thrusterTexs scene:scene dieTime:dieTime]) {
        _scene = (PlayScene*)scene;
        
        center = CGPointMake(GameWidth/2, GameHeight/2);
        
        [self setTexture:tex];
        [self setSize:self.texture.size];
        
        SKSpriteNode *thruster = [SKSpriteNode spriteNodeWithTexture:[thrusterTexs objectAtIndex:0]];         thruster.position = CGPointMake(thruster.position.x - 30, thruster.position.y);
        [self addChild:thruster];
               
        SKAction *thrusterAnimation = [SKAction animateWithTextures:thrusterTexs timePerFrame:0.01];
        [thruster runAction:[SKAction repeatActionForever:thrusterAnimation]];
        
        [self configureCollisionBody];
        m_speed = 90.0f;
        _interval = RandomFloatRange(0.5f, 2.7f);
        
        [self reset];
        
        m_hp = 6;
        
        _explode = [SKSpriteNode spriteNodeWithTexture:[explodeTexturesSmall objectAtIndex:0]];
        
        SKAction *explodeAnim = [SKAction animateWithTextures:explodeTexturesSmall timePerFrame:0.01];
        SKAction *hide = [SKAction runBlock:^{
            _explode.hidden = YES;
        }];
        
        _explodeAnimation = [SKAction sequence:@[explodeAnim, hide]];
        
        [self addChild:_explode];
        _explode.hidden = YES;
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
     _frameTime += dt;
    if(self.parent != nil) {
        if(_frameTime >= _interval) {
        self.zRotation = m_rotation;
        CGPoint spd = CGPointMultiplyScalar(m_direction, m_speed * dt);
        self.position = CGPointAdd(self.position, spd);
            
            if(CGPointDistance(center, self.position) > (GameHeight * .80 + 100)) {
                if(_frameTime >= _interval) {
                    [self reset];
                    _frameTime = 0;
                }
            }
        }
    }
}

- (void)reset {
    if(RandomFloatRange(0, 2) == 1) {
        self.position = CGPointMake(RandomFloatRange(-200, GameWidth + 200), -self.size.height);
    }
    else
    {
        self.position = CGPointMake(RandomFloatRange(-200, GameWidth + 200),
                                    GameHeight + self.size.height);
    }

    CGPoint direction = CGPointSubtract(center, self.position);
    m_direction = CGPointNormalize(direction);
    m_rotation = CGPointToAngle(direction);
   
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
    self.physicsBody.contactTestBitMask =  ColliderTypePlayer | ColliderTypeBullet;
    
}


- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    if(!isGameOver) {
        _explode.hidden = NO;
        [_explode runAction:_explodeAnimation];
        
        m_hp = m_hp - WeaponDamage;
        
        [self removeActionForKey:@"redflash"];
        SKAction *group = [SKAction sequence:@[
                                               [SKAction runBlock:^{ self.color = [SKColor redColor]; self.colorBlendFactor = 1.0; }],
                                               [SKAction waitForDuration:0.1],
                                               [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.0 duration:0.0]]];
        
        [self runAction:group withKey:@"redflash"];
    }

   
    if(m_hp <= 0 && m_isDead == NO)
    {
        if(!isTutorial)
            ZoomersDefeated++;
        [self kill];
        [self scoreUp];
        m_isDead = YES;
    }
    else  {
        
    }
}
@end
