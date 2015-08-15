//
//  MyScene.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/16/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "PlayScene.h"
#import "SetupScene.h"
#import "ScrollingBackground.h"
#import "TextureBox.h"
#import "Player.h"
#import "BulletManager.h"
#import "EnemyManager.h"
#import "Bullet.h"
#import "BaseEnemy.h"
#import "PowerUp.h"
#import "UpDownerBullet.h"
#import "ShooterBullet.h"

#import "SKTUtils/SKTAudio.h"

#import "GameKitHelper.h"
#import "AchievementsHelper.h"

#import "Chartboost.h"

@implementation PlayScene {
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    ScrollingBackground *_scrollingBackground;
    
    Player *_player;
    BulletManager *_bulletManager;
    EnemyManager *_enemyManager;
    
    SKSpriteNode *_crosshair;
    SKSpriteNode *_crosshairLine;

    SKLabelNode *_scoreText;
    
    BOOL _gameEnd;
    
    BOOL _fingerPressed;
    
    CGPoint _touch;
    CGPoint _prevTouch;
    
    bool playerInPosition;
    
    SKSpriteNode *_fadeOverlay;
    
    SKSpriteNode *_pauseButtonIcon;
    BOOL _isPaused;
    SKLabelNode *_pauseText;
    SKLabelNode *_pauseDesc;
}

@synthesize enemyLayer = m_enemyLayer;
@synthesize powerUpLayer = m_powerUpLayer;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        self.name = @"playscene";
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        _gameEnd = NO;
        _fingerPressed = NO;
        
        _scrollingBackground = [[ScrollingBackground alloc] initWithBG:[TextureBox getTexture:@"sky_bg"] speed:-100];
        [self addChild:_scrollingBackground];

        m_powerUpLayer = [SKNode new];
        
        SKSpriteNode *gunsawp =  [[PowerUp alloc] initWithImageNamed:@"gun_powerup" scene:self type:GunSwap];

        [m_powerUpLayer addChild:gunsawp];
        [self addChild:m_powerUpLayer];
        
        m_enemyLayer = [SKNode new];
        [self addChild:m_enemyLayer];

        _player = [[Player alloc] initWithImageNamed:@"player_sprite" scene:self];
        GPlayer = _player;
        [_player setPosition:CGPointMake(GameWidth/2, GameHeight/2)];
        [self addChild:_player];

        _bulletManager = [[BulletManager alloc] initWithAmount:30 scene:self];
        _enemyManager = [[EnemyManager alloc] initWithScene:self];
        
        _crosshair = [SKSpriteNode spriteNodeWithImageNamed:@"crosshairy"];
        _crosshair.name = @"crosshair";
        _crosshair.size = CGSizeMake(25, 25);
        _crosshairLine = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"line"]];
        _crosshairLine.anchorPoint = CGPointMake(0, 0.5);
        _crosshairLine.size = CGSizeMake(30, 5);
    
        _scoreText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _scoreText.name = @"score";
        _scoreText.fontColor = [SKColor blackColor];
        _scoreText.fontSize = 24.0;
        _scoreText.position = CGPointMake(GameWidth/2, self.size.height - 24);
        [self addChild:_scoreText];
        
        _pauseText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _pauseText.text = @"PAUSE";
        _pauseText.fontColor = [SKColor blackColor];
        _pauseText.fontSize = 18.0f;
        _pauseText.position = CGPointMake(self.size.width/2, self.size.height * .70);
        
        _pauseDesc = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _pauseDesc.text = @"TAP  TO  CONTINUE";
        _pauseDesc.fontColor = [SKColor blackColor];
        _pauseDesc.fontSize = 18.0f;
        _pauseDesc.position = CGPointMake(self.size.width/2, self.size.height * .60);
        
        _pauseButtonIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"pausebutton"]];
        _pauseButtonIcon.name = @"pauseb";
        _pauseButtonIcon.position = CGPointMake(_pauseButtonIcon.size.width/2 + 5, _pauseButtonIcon.size.height/2 + 5);
        _pauseButtonIcon.alpha = 0.3;
        [self addChild:_pauseButtonIcon];
        
        _fadeOverlay = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0]
                                                    size:CGSizeMake(GameWidth, GameHeight)];
        _fadeOverlay.anchorPoint = CGPointMake(0, 0);
        _fadeOverlay.alpha = 0.5f;
        
        score = 0;
        waves = 0;
    }
    return self;
}

-(void)reset {
    
    isTutorial = NO;
    isGameOver = NO;
    _isPaused = NO;
    
    SKTAudio *aud = [SKTAudio sharedInstance];
    [aud playBackgroundMusic:@"Main.wav"];
    
    RoundersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"ROUNDER"];
    ZoomersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"ZOOMER"];
    UpdownersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"UPDOWNER"];
    ShootersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"SHOOTER"];
    WeaponSwitchCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"WSWITCH"];
    
    selectedWeapon = BigShot;
    score = 0;
    waves = 0;
    
   [_fadeOverlay removeFromParent];
    _gameEnd = NO;
     _fingerPressed = NO;
     playerInPosition = NO;
    [_player reset];
  
    _bulletManager.angleOfBullets = 0;
    
    [_crosshair removeFromParent];
    [_crosshairLine removeFromParent];
    
    [m_enemyLayer removeAllChildren];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    _crosshair.position = touchLocation;
    _crosshairLine.position = _crosshair.position;
    if(_crosshair.parent == nil)
        [self addChild:_crosshair];
    
    if(_isPaused) {
        [_fadeOverlay removeFromParent];
        [_pauseText removeFromParent];
        [_pauseDesc removeFromParent];
        _isPaused = NO;
    }
    
    if([node.name isEqualToString:@"pauseb"]) {
   
        if(!_isPaused) {
            _isPaused = YES;
            [self addChild:_fadeOverlay];
            [self addChild:_pauseText];
            [self addChild:_pauseDesc];
        }
    }
    
    if(_gameEnd && _player.alpha == 0) {
        
        if(score > HighScore)
            HighScore = score;
        
        [[NSUserDefaults standardUserDefaults] setInteger:HighScore forKey:@"BEST"];
        [[NSUserDefaults standardUserDefaults] setInteger:RoundersDefeated forKey:@"ROUNDER"];
        [[NSUserDefaults standardUserDefaults] setInteger:ZoomersDefeated forKey:@"ZOOMER"];
        [[NSUserDefaults standardUserDefaults] setInteger:UpdownersDefeated forKey:@"UPDOWNER"];
        [[NSUserDefaults standardUserDefaults] setInteger:ShootersDefeated forKey:@"SHOOTER"];
        [[NSUserDefaults standardUserDefaults] setInteger:WeaponSwitchCount forKey:@"WSWITCH"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [setupScene updateValues];
        [self.view presentScene:setupScene transition:reveal];

    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    if(_crosshairLine.parent == nil) {
        [self addChild:_crosshairLine];
    }
    if(!_fingerPressed) {
        _touch = [[touches anyObject] locationInNode:self];
        _fingerPressed = true;
    }
    _prevTouch = [[touches anyObject] previousLocationInNode:self];
    
    if (!_gameEnd && playerInPosition) {
         _bulletManager.fireFlag = YES;
    }
    

    
}

-(void)handleTouch:(SKNode*)node {

    _bulletManager.fireFlag = YES;
   
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _bulletManager.fireFlag = NO;
    _fingerPressed = false;
    [_crosshair removeFromParent];
    [_crosshairLine removeFromParent];
    
}

-(void)update:(CFTimeInterval)currentTime {
    
    if(_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
  if(!_isPaused) {
    [_player update:currentTime];

    
    if(_player.HP <= 0 && _gameEnd == NO) {
        _gameEnd = YES;
        [self gameOver];
    }
 
    _scoreText.text = [NSString stringWithFormat:@"%06i", score];
  }

}

-(void)didSimulatePhysics {
    
    if(!_isPaused) {
        touchPosition = _touch;
        previoustouchPosition = _prevTouch;
        
        CGPoint length = CGPointSubtract(previoustouchPosition, touchPosition);
        if(ABS(CGPointLength(length)) > 0.5) {
            deltaPoint = CGPointSubtract(previoustouchPosition, touchPosition);
        }
        
        if(isnan(deltaPoint.x) || isnan(deltaPoint.y)) {
            deltaPoint = CGPointZero;
        }

        
        if(!CGPointEqualToPoint(deltaPoint, CGPointZero)) {

            _crosshairLine.zRotation = CGPointToAngle(deltaPoint);
            [_bulletManager update:_dt];

        }
        
        if(_player.position.y == (GameHeight/2)) {
            playerInPosition = YES;
        }
        
        [_scrollingBackground moveBg:_dt];
        
        if(playerInPosition) {
      
        
            [_enemyManager update:_dt];
        } else {
               _player.zRotation = M_PI_2;
        }
        
        [m_powerUpLayer  enumerateChildNodesWithName:@"powerup" usingBlock:^(SKNode *node, BOOL *stop) {
            [(PowerUp*)node update:_dt];
        }];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    if ([nodeA isKindOfClass:[BaseEnemy class]] && [nodeB isKindOfClass:[Bullet class]]) {
        [(BaseEnemy*)nodeA collidedWith:contact.bodyA contact:contact];
        if(![nodeA isKindOfClass:[Bullet class]]) {
            [(Bullet*)nodeB collidedWith:contact.bodyB contact:contact];
        }
        
    }

    if ([nodeA isKindOfClass:[BaseEnemy class]] && [nodeB isKindOfClass:[Player class]]) {
        [(Player*)nodeB collidedWith:contact.bodyB contact:contact];
        [(ShooterBullet*)nodeA collidedWith:contact.bodyA contact:contact];
    }
    
    if ([nodeA isKindOfClass:[PowerUp class]] && [nodeB isKindOfClass:[Bullet class]]) {
        [(PowerUp*)nodeA collidedWith:contact.bodyA contact:contact];
    }

}

- (void)gameOver {

    isGameOver = YES;
    [[Chartboost sharedChartboost] cacheInterstitial:@"showad"];
    
    [_player death];
    [self reportAchievements];
    [self reportHighScore];
    [self addChild:_fadeOverlay];
    
    _bulletManager.fireFlag = NO;
 
}

-(void)reportAchievements {
    NSMutableArray *achievements = [NSMutableArray array];
    
    if(score >= 100)
        [achievements addObject:[AchievementsHelper destroy100Achievement]];
    
    if(score >= 200)
        [achievements addObject:[AchievementsHelper destroy200Achievement]];
    
    [achievements addObject:[AchievementsHelper switch15Achievement]];
    [achievements addObject:[AchievementsHelper roundersAchievement]];
    [achievements addObject:[AchievementsHelper seekersAchievement]];
    [achievements addObject:[AchievementsHelper wallsAchievement]];
    [achievements addObject:[AchievementsHelper tankersAchievement]];
    [achievements addObject:[AchievementsHelper thirtyGamesAchievement]];
    
    [[GameKitHelper sharedGameKitHelper] reportAchievements:achievements];
}

-(void)reportHighScore {
    [[GameKitHelper sharedGameKitHelper] reportScore];
}

@end
