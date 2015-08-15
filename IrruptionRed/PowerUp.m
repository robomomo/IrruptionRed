//
//  PowerUp.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-19.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "PowerUp.h"
#import "PlayScene.h"
#import "TextureBox.h"

@implementation PowerUp {
    PlayScene *_scene;
    float _frameTime;
    float _intervalBomb;
    float _intervalWeapon;
    SKAction *_animation;
    
    SKLabelNode *_weaponName;
    SKAction *_textAction;

}

@synthesize type = m_type;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene type:(PowerUpType)type {
    if(self = [super init]) {
        _scene = (PlayScene*)scene;
        
        m_type = type;
 
        _weaponName = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _weaponName.name = @"weapon";
        _weaponName.fontColor = [SKColor blackColor];
        _weaponName.fontSize = 18.0;
        _weaponName.position = CGPointMake(GameWidth/2, GameHeight/2 + 80);
        [_scene addChild:_weaponName];
        
        SKAction *moveUp = [SKAction moveByX:0 y:35 duration:0.5];
        SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:2];
        SKAction *reset = [SKAction runBlock:^{
            _weaponName.text = @"";
            _weaponName.position = CGPointMake(GameWidth/2, GameHeight/2 + 80);
            _weaponName.alpha = 1;
        }];
        
        _textAction = [SKAction sequence:@[moveUp, fadeOut, reset]];
        
        NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
        [textures addObject:[TextureBox getTexture:name]];
        
        if(m_type == Bomb) {
            [textures addObject:[TextureBox getTexture:@"powerupbomb"]];
        } else if (m_type == GunSwap) {
            [textures addObject:[TextureBox getTexture:@"gun_blank"]];
        }

        _animation = [SKAction animateWithTextures:textures timePerFrame:0.2];
        
        
        SKTexture *tex = [TextureBox getTexture:name];
        [self setTexture:tex];
        [self setSize:CGSizeMake(tex.size.width, tex.size.height)];
        [self setIntervals];
        self.name = @"powerup";
      
        [self setSize:self.texture.size];
        self.position = CGPointMake(RandomFloatRange(0, GameWidth - self.size.width*2),
                                    RandomFloatRange(0, GameHeight - self.size.height*2));
        [self configureCollisionBody];
        
        [self runAction:[SKAction repeatActionForever:_animation] withKey:@"blink"];
        
        self.hidden = YES;

        _intervalWeapon = 1;
    

        
    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
    _frameTime += dt;
    if(m_type == Bomb) {
        if(_frameTime >= _intervalBomb) {
            self.hidden = NO;
            
            
        }
    } else if (m_type == GunSwap) {
        if(_frameTime >= _intervalWeapon) {
            self.hidden = NO;
            
            
        }
    }
    
    if(_frameTime >= 15)
        [self move];

}

- (void)configureCollisionBody
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.usesPreciseCollisionDetection = NO;
    //self.physicsBody.dynamic = NO;
    
    // Set the category of the physics object that will be used for collisions
    self.physicsBody.categoryBitMask = ColliderTypePowerup;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    self.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask =  ColliderTypeBullet;
    
}


- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    if(self.isHidden == NO) {

        WeaponSwitchCount++;
        _frameTime = 0;
        self.physicsBody = nil;
        self.position = CGPointMake(RandomFloatRange(self.size.width*2, GameWidth - self.size.width*2),
                                    RandomFloatRange(self.size.height*2, GameHeight - self.size.height*2));

        [self configureCollisionBody];
        [self setIntervals];
        
        if (m_type == GunSwap) {
            int rnd = arc4random() %(2);
            if(selectedWeapon == Spread) {
                if(rnd == 0) {
                    selectedWeapon = DoubleShot;
                    _weaponName.text = @"Double  Shot";
                }
                else {
                    selectedWeapon = BigShot;
                    _weaponName.text = @"Big  Shot";
                }
            }
            else if(selectedWeapon == BigShot) {
                if(rnd == 0) {
                    selectedWeapon = Spread;
                   _weaponName.text = @"Spread  Shot";
                }
                else {
                    selectedWeapon = DoubleShot;
                    _weaponName.text = @"Double  Shot";
                }
            }
            else if(selectedWeapon == DoubleShot) {
                if(rnd == 0) {
                    selectedWeapon = Spread;
                    _weaponName.text = @"Spread  Shot";
                }
                else {
                    selectedWeapon = BigShot;
                    _weaponName.text = @"Big  Shot";
                }
            }
            
            [_weaponName runAction:_textAction];
      }
          [_scene runAction:[SKAction playSoundFileNamed:@"s5.wav" waitForCompletion:NO]];
        
        self.hidden = YES;

    }
    
}

-(void)move {
 
        _frameTime = 0;
        self.physicsBody = nil;
        self.position = CGPointMake(RandomFloatRange(self.size.width*2, GameWidth - self.size.width*2),
                                    RandomFloatRange(self.size.height*2, GameHeight - self.size.height*2));
        
        [self configureCollisionBody];
        [self setIntervals];
        self.hidden = YES;
        
}

-(void)setIntervals {
    if(m_type == Bomb) {
        _intervalBomb = RandomFloatRange(15.0f, 60.0f);
    } else if (m_type == GunSwap) {
        
        _intervalWeapon = RandomFloatRange(6.0f, 12.0f);
    }
}

@end
