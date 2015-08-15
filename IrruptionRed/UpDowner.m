//
//  UpDowner.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-07.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "UpDowner.h"
#import "PlayScene.h"
#import "TextureBox.h"
#import "UpDownerBullet.h"


@implementation UpDowner {
    PlayScene *_scene;
    float _frameTime;
    float _interval;
    CGPoint _wayPoint;
    BOOL _pointReached;
    BOOL _isLeft;
    UpDownerBullet *_bullet;
    
    SKSpriteNode *_explode;
    SKAction *_explodeAnimation;
}

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime {
    if(self = [super initWithTex:tex thrusterTexs:thrusterTexs scene:scene dieTime:dieTime]) {
        _scene = (PlayScene*)scene;
        
        [self setTexture:tex];
        [self setSize:self.texture.size];
        
        _pointReached = NO;
        
        SKTexture *laserTex = [TextureBox getTexture:@"enemy_laser_shot"];
        _bullet =  [[UpDownerBullet alloc] initWithTex:laserTex thrusterTexs:nil scene:_scene dieTime:0.1];
        [self addChild:_bullet];
        
        [self configureCollisionBody];
        
        m_speed = 300.0f;
        
        _interval = RandomFloatRange(0.0f, 5.5f);
        
        m_hp = 6;
        
        _explode = [SKSpriteNode spriteNodeWithTexture:[explodeTextures objectAtIndex:0]];
        _explode.position = CGPointMake(_bullet.position.x - 7, _bullet.position.y);
        
        SKAction *explodeAnim = [SKAction animateWithTextures:explodeTextures timePerFrame:0.01];
        SKAction *hide = [SKAction runBlock:^{
            _explode.hidden = YES;
        }];
        
        _explodeAnimation = [SKAction sequence:@[explodeAnim, hide]];
        
        [self addChild:_explode];
        _explode.hidden = YES;
        
        [self reset];
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
    _frameTime += dt;
    if(self.parent != nil) {
        if(_frameTime >= _interval) {
            [self move:dt];
        }
    }
}

-(void)move:(CFTimeInterval)dt {
    float xpos = _wayPoint.x - self.position.x;
    float ypos = _wayPoint.y - self.position.y;
    
    self.position = CGPointAdd(self.position, CGPointMake(xpos * 0.2 *dt, ypos * 0.2 * dt));
    
    if(_pointReached == NO) {
        if(ABS(ypos) < GameHeight * .10) {
            _pointReached = YES;
            if(_isLeft) {
                _wayPoint =  CGPointMake(self.size.width/2, 0);
            }
            else  {
                _wayPoint = CGPointMake(GameWidth - self.size.width/2, 0);

            }
        }
    } else {

        if(ABS(ypos) < GameHeight * .10) {
            _pointReached = NO;
            
            if(_isLeft) {
                _wayPoint = CGPointMake(self.size.width/2, GameHeight);
            }
            else  {
                _wayPoint = CGPointMake(GameWidth - self.size.width/2, GameHeight);
            }
        }
    }
}

- (void)reset {
    
    if(RandomFloatRange(0, 2) == 1) {
        if(RandomFloatRange(0, 2) == 1) {
            self.position = CGPointMake(self.size.width/2, -self.size.height);
            _wayPoint = CGPointMake(self.size.width/2, GameHeight);
        }
        else {
            self.position = CGPointMake(self.size.width/2, GameHeight + self.size.height);
            _wayPoint = CGPointMake(self.size.width/2, 0);
        }
        
        _isLeft = YES;
    }
    else
    {
        if(RandomFloatRange(0, 2) == 1) {
            self.position = CGPointMake(GameWidth - self.size.width/2, -self.size.height);
            _wayPoint = CGPointMake(GameWidth - self.size.width/2, GameHeight);
        }
        else {
            self.position = CGPointMake(GameWidth - self.size.width/2, GameHeight + self.size.height);
            _wayPoint = CGPointMake(GameWidth - self.size.width/2, 0);
        }

        self.zRotation = DegreesToRadians(180);
        _isLeft = NO;

    }

    _bullet.anchorPoint = CGPointMake(0, 0.5);
    _bullet.position = CGPointMake(_bullet.position.x - 7, _bullet.position.y);
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
    self.physicsBody.contactTestBitMask = ColliderTypeBullet;
    
    /////
    _bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(GameWidth, 20)];
    _bullet.physicsBody.affectedByGravity = NO;
 
    _bullet.physicsBody.usesPreciseCollisionDetection = NO;
    // Set the category of the physics object that will be used for collisions
    _bullet.physicsBody.categoryBitMask = ColliderTypeBullet;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    _bullet.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    _bullet.physicsBody.contactTestBitMask = ColliderTypePlayer;
    
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
            UpdownersDefeated++;
        
        [self kill];
        [self scoreUp];
        m_isDead = YES;
    }
    else {

        
    }
}
@end
