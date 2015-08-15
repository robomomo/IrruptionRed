//
//  Shooter.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-21.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "Shooter.h"
#import "PlayScene.h"
#import "TextureBox.h"
#import "ShooterBullet.h"


@implementation Shooter {
    PlayScene *_scene;
    float _frameTime;
    float _frameTimeBullet;
    float _interval;
    float _intervalBullet;
    ShooterBullet *_bullet;
    
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
        
        SKSpriteNode *thruster = [SKSpriteNode spriteNodeWithTexture:[thrusterTexs objectAtIndex:0]];
        thruster.position = CGPointMake(thruster.position.x + 28, thruster.position.y + 6);
        [self addChild:thruster];
        
        SKSpriteNode *thruster2 = [SKSpriteNode spriteNodeWithTexture:[thrusterTexs objectAtIndex:0]];
        thruster2.position = CGPointMake(thruster2.position.x + 28, thruster2.position.y -6);
        [self addChild:thruster2];
        
        SKAction *thrusterAnimation = [SKAction animateWithTextures:thrusterTexs timePerFrame:0.01];
        [thruster runAction:[SKAction repeatActionForever:thrusterAnimation]];
        [thruster2 runAction:[SKAction repeatActionForever:thrusterAnimation]];
        
        [self configureCollisionBody];
        m_speed = 180;
 
        _interval = RandomFloatRange(0.2f, 4.5f);
        _intervalBullet = 1.5f;
        
        m_hp = 16;
        
        self.position = center;
        self.zRotation = RandomFloatRange(0, 360) * (M_PI  / 180);
        
        float wx = cosf(self.zRotation);
        float wy = sinf(self.zRotation);
        
        self.position = CGPointAdd(self.position, CGPointMake(wx * GameWidth,
                                                              wy * GameHeight));
        
        SKTexture *tankbullet1 = [TextureBox getTexture:@"tank_bullet1"];
        SKTexture *tankbullet2 = [TextureBox getTexture:@"tank_bullet2"];
        
        if(RandomFloatRange(0, 2) == 1) {
  
            _bullet =  [[ShooterBullet alloc] initWithTex:tankbullet1 thrusterTexs:nil scene:_scene dieTime:0.1];
        }
        else
        {
      
            _bullet =  [[ShooterBullet alloc] initWithTex:tankbullet2 thrusterTexs:nil scene:_scene dieTime:0.1];
        }
        
        
        _explode = [SKSpriteNode spriteNodeWithTexture:[explodeTextures objectAtIndex:0]];
        
        SKAction *explodeAnim = [SKAction animateWithTextures:explodeTextures timePerFrame:0.01];
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
            
            CGPoint distance = CGPointSubtract(center, self.position);
            if(CGPointDistance(self.position, center) > (GameHeight * .30)) {
           
                distance = CGPointNormalize(distance);
                CGPoint move = CGPointMultiplyScalar(distance, m_speed * dt);
                self.position = CGPointAdd(self.position, move);
            }
            else {
                 _frameTimeBullet += dt;
                if(_frameTimeBullet >= _intervalBullet) {
                    if(_bullet.parent == nil) {
                        _bullet.position = self.position;
                        _bullet.color = [SKColor whiteColor];
                        _bullet.colorBlendFactor = 1.0;
                        _bullet.alpha = 1;
                     
                        if(!isGameOver)
                        [_scene.enemyLayer addChild:_bullet];
             
                        _frameTimeBullet = 0;
         
                    }
                }
            }
            
        [_bullet update:dt];
        }
    }
}

-(void)removeFromParent {
    [super removeFromParent];
    [_bullet kill];
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
            ShootersDefeated++;
        
         [_bullet kill];
        [self kill];
        [self scoreUp];
        m_isDead = YES;
       
    }
}
@end
