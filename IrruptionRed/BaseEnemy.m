//
//  BaseEnemy.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/26/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "BaseEnemy.h"
#import "PlayScene.h"
#import "TextureBox.h"

@implementation BaseEnemy {
    PlayScene *_scene;
    SKAction *_death;

}


@synthesize direction = m_direction;
@synthesize rotation = m_rotation;
@synthesize speed = m_speed;
@synthesize hp = m_hp;
@synthesize isDead = m_isDead;

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime {
    if(self = [super init]) {
        _scene = (PlayScene*)scene;
        
        SKAction *sprChange = [SKAction runBlock:^{
            self.color = [SKColor blackColor];
            self.colorBlendFactor = 1.0;
        }];
        
        
        
        SKAction *die = [SKAction fadeAlphaTo:0 duration:dieTime];
        SKAction *remove = [SKAction runBlock:^{
            [self removeFromParent];
        }];
        
        _death = [SKAction sequence:@[sprChange, die, remove]];
        
        
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{

}

- (void)reset {
}

- (void)configureCollisionBody {
    
}

-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact {

}

-(void)scoreUp {
    score++;
}



-(void)kill {
    [self runAction:[SKAction playSoundFileNamed:@"d1.wav" waitForCompletion:NO]];
    [self runAction:_death];
}
@end
