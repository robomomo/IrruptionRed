//
//  Player.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "Player.h"
#import "TextureBox.h"

@implementation Player {
    SKScene *_scene;
    SKSpriteNode *_HPIcon;
    SKNode *_HPContainer;

    SKSpriteNode *_explode;
    SKAction *_explodeAnimation;
    
    SKNode *_smallDamage;
    SKNode *_largeDamage;
    SKSpriteNode *_playerTookDamageShow;
    
    SKAction *_playerDeathSeq;
    
    SKAction *_move;
}

@synthesize HP = m_HP;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene; {
    if(self = [super init]) {
        _scene = scene;
        
        [self setPosition:CGPointMake(GameWidth/2, (GameHeight/2) - 350)];
        [self setTexture:[TextureBox getTexture:name]];
        [self setSize:self.texture.size];
 
        [self configureCollisionBody];
        
        SKSpriteNode *thruster = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"player_thruster0001"]];
        thruster.position = CGPointMake(thruster.position.x - 23, thruster.position.y);
        [self addChild:thruster];
        
        NSArray *thrusterTextures = [[NSArray alloc] initWithObjects:
                         [TextureBox getTexture:@"player_thruster0001"],
                         [TextureBox getTexture:@"player_thruster0002"],
                         [TextureBox getTexture:@"player_thruster0003"],
                         [TextureBox getTexture:@"player_thruster0004"],
                         [TextureBox getTexture:@"player_thruster0005"],
                         [TextureBox getTexture:@"player_thruster0006"],
                         nil];
        
        SKAction *thrusterAnimation = [SKAction animateWithTextures:thrusterTextures timePerFrame:0.01];
        [thruster runAction:[SKAction repeatActionForever:thrusterAnimation]];
        
        
        _explode = [SKSpriteNode spriteNodeWithTexture:[explodeTextures objectAtIndex:0]];
        
        
        SKAction *explodeAnim = [SKAction animateWithTextures:explodeTextures timePerFrame:0.01];
        SKAction *hide = [SKAction runBlock:^{
            _explode.hidden = YES;
        }];
        
        _explodeAnimation = [SKAction sequence:@[explodeAnim, hide]];
        
        [self addChild:_explode];
        _explode.hidden = YES;
        
        
        _smallDamage = [SKNode new];
        _largeDamage = [SKNode new];
       
       NSMutableArray *smallExpl = [[NSMutableArray alloc] init];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small11"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small12"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small13"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small14"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small15"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small16"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small17"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small18"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small19"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small20"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small21"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small22"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small23"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small24"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small25"]]];
        [smallExpl addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small26"]]];
  
        for(int i = 0; i < 6; i++) {
            SKSpriteNode *playerTookDamageShow = [SKSpriteNode spriteNodeWithTexture:[smallExpl objectAtIndex:0]];
            playerTookDamageShow.size = CGSizeMake(35, 35);
            playerTookDamageShow.position =
                CGPointMake(RandomFloatRange(-25, 25), RandomFloatRange(-25, 25));
            SKAction *playerTookDamageAnim = [SKAction animateWithTextures:smallExpl timePerFrame:((float)rand() / RAND_MAX * 0.06)];
            [playerTookDamageShow runAction:[SKAction repeatActionForever:playerTookDamageAnim]];
            [_smallDamage addChild:playerTookDamageShow];
        }
        
        [self addChild:_smallDamage];
        _smallDamage.hidden = YES;
        
        for(int i = 0; i < 6; i++) {
            SKSpriteNode *playerTookDamageShow = [SKSpriteNode spriteNodeWithTexture:[explodeTexturesSmall objectAtIndex:0]];
            playerTookDamageShow.size = CGSizeMake(35, 35);
            playerTookDamageShow.position =
                CGPointMake(RandomFloatRange(-25, 25), RandomFloatRange(-25, 25));
            SKAction *playerTookDamageAnim = [SKAction animateWithTextures:explodeTexturesSmall timePerFrame:((float)rand() / RAND_MAX * 0.06)];
            [playerTookDamageShow runAction:[SKAction repeatActionForever:playerTookDamageAnim]];
            [_largeDamage addChild:playerTookDamageShow];
        }
        
        [self addChild:_largeDamage];
        _largeDamage.hidden = YES;
     
        SKAction *sprChange = [SKAction runBlock:^{
            self.color = [SKColor blackColor];
            self.colorBlendFactor = 1.0;
        }];
        SKAction *playerDeath = [SKAction fadeAlphaTo:0 duration:1];
        SKAction *remove = [SKAction runBlock:^{
            self.alpha = 0;
        }];
        
        _playerDeathSeq = [SKAction sequence:@[sprChange, playerDeath, remove]];
        
        _move = [SKAction moveToY:GameHeight/2 duration:1];
        _move.timingMode = SKActionTimingEaseInEaseOut;
    }
    return self;
}

-(void)reset {

    self.color = [SKColor whiteColor];
    self.colorBlendFactor = 1.0;
    self.alpha = 1;
    m_HP = HPMAX;
    
    [self setPosition:CGPointMake(GameWidth/2, (GameHeight/2) - 350)];
    
    _HPContainer = [SKNode new];
    for(int i = 0; i < HPMAX; i++) {
        _HPIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"heart2"]];
        _HPIcon.name = @"hp";
        _HPIcon.anchorPoint = CGPointMake(0, 1);
        _HPIcon.position = CGPointMake(i * _HPIcon.size.width, 0);
        [_HPContainer addChild:_HPIcon];
    }
    
    
    _HPContainer.position = CGPointMake(GameWidth/2 - _HPIcon.size.width * 1.5, GameHeight - 26);
    [_scene addChild:_HPContainer];

    
     self.zRotation = M_PI_2;

    [self runAction:_move];
    
}

-(void)hideHP {
    _HPContainer.hidden = YES;
}

- (void)update:(CFTimeInterval)dt
{
    if(m_HP == 3) {
        _smallDamage.hidden = YES;
        _largeDamage.hidden = YES;
    }
    if(m_HP == 2) {
        _smallDamage.hidden = NO;
    }
    if(m_HP == 1) {
        _smallDamage.hidden = YES;
        _largeDamage.hidden = NO;
    }
}

- (void)death {
    [self runAction:_playerDeathSeq];
}

- (void)configureCollisionBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5];
    
    self.physicsBody.affectedByGravity = NO;
    
    self.physicsBody.usesPreciseCollisionDetection = NO;
    // Set the category of the physics object that will be used for collisions
    self.physicsBody.categoryBitMask = ColliderTypePlayer;
    
    // We want to know when a collision happens but we dont want the bodies to actually react to each other so we
    // set the collisionBitMask to 0
    self.physicsBody.collisionBitMask = 0;
    
    // Make sure we get told about these collisions
    self.physicsBody.contactTestBitMask = ColliderTypeEnemy;
    
}

- (void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact
{
    _explode.hidden = NO;
    [_explode runAction:_explodeAnimation];
    
    if(m_HP != 0 || !isGameOver)
      [self runAction:[SKAction playSoundFileNamed:@"d2.wav" waitForCompletion:NO]];
    
    
    __block int count = 0;
    [_HPContainer enumerateChildNodesWithName:@"hp" usingBlock:^(SKNode *node, BOOL *stop) {
        count++;
        if(count == _HPContainer.children.count) {
            
            if(!isTutorial)
                m_HP--;
           
            [node removeFromParent];
            
            *stop = YES;
        }
        
    }];

}

@end
