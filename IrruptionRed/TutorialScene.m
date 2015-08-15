//
//  TutorialScene.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-07-24.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//


#import "TutorialScene.h"
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
#import "MessageBox.h"

#import "SKTUtils/SKTAudio.h"

#import "Chartboost.h"

@implementation TutorialScene {
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    ScrollingBackground *_scrollingBackground;
    ScrollingBackground *_scrollingBackground2;
    
    Player *_player;
    BulletManager *_bulletManager;
    EnemyManager *_enemyManager;
    
    SKSpriteNode *_crosshair;
    SKSpriteNode *_crosshairLine;
    
    SKSpriteNode *_moneyIcon;
    SKLabelNode *_moneyText;
    SKLabelNode *_scoreText;
    SKLabelNode *_comboText;
    SKLabelNode *_levelText;
    
    BOOL _tutorialStart;
    
    BOOL _fingerPressed;
    
    CGPoint _touch;
    CGPoint _prevTouch;
    
    BOOL _playerInPosition;
    
    SKSpriteNode *_fadeOverlay;
    
    MessageBox *_testMsg;
    NSMutableArray *_messages;
    int _messageCurrentIndex;
    
    SKSpriteNode *_backButtonIcon;
    SKSpriteNode *_pauseButtonIcon;
    BOOL _isPaused;
    SKLabelNode *_pauseText;
    SKLabelNode *_pauseDesc;
    
    SKAction *_backSeq;
    
    SKTAudio *_aud;
}

@synthesize enemyLayer = m_enemyLayer;
@synthesize powerUpLayer = m_powerUpLayer;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        self.name = @"tutorialscene";
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);

        
        _tutorialStart = NO;
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
        
        SKLabelNode *practiceMode = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        practiceMode.text = @"PRACTICE  MODE";
        practiceMode.fontColor = [SKColor darkGrayColor];
        practiceMode.fontSize = 18.0f;
        practiceMode.position = CGPointMake(self.size.width/2, self.size.height * .80);
        [self addChild:practiceMode];
        
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
        
        SKAction *alhpaUp = [SKAction fadeAlphaTo:1 duration:0.5];
        SKAction *alphaDown = [SKAction fadeAlphaTo:0.0 duration:0.5];
        SKAction *fade = [SKAction sequence:@[alhpaUp, alphaDown]];
        [practiceMode runAction:[SKAction repeatActionForever:fade]];
        
        _backButtonIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"button"]];
        _backButtonIcon.name = @"backb";
        _backButtonIcon.position = CGPointMake(self.size.width/2, _backButtonIcon.size.height/2 * .90);
        _backButtonIcon.size = CGSizeMake(_backButtonIcon.size.width * .60, _backButtonIcon.size.height * .80);
        _backButtonIcon.alpha = 0.9;
        [self addChild:_backButtonIcon];
        
        _pauseButtonIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"pausebutton"]];
        _pauseButtonIcon.name = @"pauseb";
        _pauseButtonIcon.position = CGPointMake(_pauseButtonIcon.size.width/2 + 5, _pauseButtonIcon.size.height/2 + 5);
        _pauseButtonIcon.alpha = 0.3;
        [self addChild:_pauseButtonIcon];
        
        SKLabelNode *backButtonText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        backButtonText.text = @"BACK";
        backButtonText.name = @"backb";
        backButtonText.fontColor = [SKColor darkGrayColor];
        backButtonText.fontSize = 24.0f;
        backButtonText.position = CGPointMake(0, -8);
        [_backButtonIcon addChild:backButtonText];
        
        _testMsg = [[MessageBox alloc] initWithImageNamed:@"portrait_done2" scene:self];
        [self addChild:_testMsg];

        _messages = [[NSMutableArray alloc] init];
        _messageCurrentIndex = 0;
        
        [_messages addObject:
         @"I will now explain the|"
        "controls.|"
        ""];
        
        [_messages addObject:
         @"Firing your weapon is|"
         "first done by placing the|"
         "crosshair"];
        
        [_messages addObject:
         @"Do so by touching and|"
         "holding down anywhere|"
         "on the screen."];
        
        [_messages addObject:
         @"Once held, move your|"
         "finger a bit in the|"
         "direction you wish to fire."];
        
        [_messages addObject:
         @"You don't need to keep|"
         "moving your finger, only|"
         "enough to start firing."];
        
        [_messages addObject:
         @"Your weapon will fire|"
         "using the crosshair as|"
         "an anchor point."];
        
        [_messages addObject:
         @"You can replace your|"
         "current crosshair by|"
         "touching the screen again."];
        
        [_messages addObject:
         @"Enough explanation.|"
         "Practice firing by shooting|"
         "these enemies!"];
        
        [_messages addObject:
         @"Tap the back button when|"
         "you're finished.|"
         ""];
        
        _fadeOverlay = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0]
                                                    size:CGSizeMake(GameWidth, GameHeight)];
        _fadeOverlay.anchorPoint = CGPointMake(0, 0);
        _fadeOverlay.alpha = 0.5f;
     
        score = 0;
        waves = 0;
        
        _aud = [SKTAudio sharedInstance];
    }
    return self;
}

-(void)reset {
    isTutorial = YES;
    isGameOver = NO;
    _isPaused = NO;
   
    [_aud playBackgroundMusic:@"Main.wav"];

    selectedWeapon = BigShot;
    score = 0;
    waves = 0;

    [_fadeOverlay removeFromParent];
  
    _fingerPressed = NO;
    _playerInPosition = NO;
    _tutorialStart = NO;
    _messageCurrentIndex = 0;

    [_player reset];
    
    
    _bulletManager.angleOfBullets = 0;
    
    [_crosshair removeFromParent];
    [_crosshairLine removeFromParent];
    
    [m_enemyLayer removeAllChildren];
    [_bulletManager removeAllBullets];
 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    _crosshair.position = touchLocation;
    _crosshairLine.position = _crosshair.position;
    if(_crosshair.parent == nil && _testMsg.showing == NO)
        [self addChild:_crosshair];
    
    [_testMsg hideMessage:YES];
    if(_testMsg.showing == NO) {
    
        if((_messageCurrentIndex <= [_messages count] - 1)) {
            [_testMsg showMessage:[_messages objectAtIndex:_messageCurrentIndex]];
            _messageCurrentIndex++;
        }
        else {
            _tutorialStart = YES;
        }
        
    }

    if(_isPaused) {
        [_fadeOverlay removeFromParent];
        [_pauseText removeFromParent];
        [_pauseDesc removeFromParent];
        _isPaused = NO;
    }
    
    if([node.name isEqualToString:@"backb"]) {
        
        AdCounter++;
        [[Chartboost sharedChartboost] cacheInterstitial:@"showad"];
        
        SKAction *tapped = [SKAction sequence:@[
                                                [SKAction runBlock:^{ _backButtonIcon.color = [SKColor blackColor]; _backButtonIcon.colorBlendFactor = 1.0; }],
                                                [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.0 duration:0.0]]];
        
        [_backButtonIcon runAction:tapped];
        
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [_testMsg hideMessage:YES];
        [_testMsg reset];
        [_player removeAllActions];
        [setupScene updateValues];
        [self.view presentScene:setupScene transition:reveal];

        
    }
    else if([node.name isEqualToString:@"pauseb"]) {
       
        if(!_isPaused) {
            _isPaused = YES;
          [self addChild:_fadeOverlay];
             [self addChild:_pauseText];
            [self addChild:_pauseDesc];
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if(_crosshairLine.parent == nil && _testMsg.showing == NO) {
        [self addChild:_crosshairLine];
    }
    if(!_fingerPressed) {

        _touch = [[touches anyObject] locationInNode:self];
        _fingerPressed = true;
    }

    _prevTouch = [[touches anyObject] previousLocationInNode:self];
    
    
    if (_playerInPosition) {
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
    score = 15;
    waves = 15;

    [_player hideHP];
    
  
    if(_lastUpdateTime) {
            _dt = currentTime - _lastUpdateTime;
        }
        else {
            _dt = 0;
        }
        _lastUpdateTime = currentTime;
      if(!_isPaused) {
    
        [_player update:currentTime];
    

        _scoreText.text = [NSString stringWithFormat:@""];
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
            
            if(_playerInPosition && _tutorialStart) {
                [_bulletManager update:_dt];
            }
            
            
            if(_bulletManager.angleOfBullets != 0) {
                _player.zRotation = _bulletManager.angleOfBullets;
            }
            
        }
        
        
        if(_playerInPosition && _tutorialStart) {
            [_enemyManager update:_dt];
        } else {
            _player.zRotation = M_PI_2;
        }
        
        if(_playerInPosition && _messageCurrentIndex <= 0) {
            [_testMsg hideMessage:NO];
            [_testMsg showMessage:[_messages objectAtIndex:_messageCurrentIndex]];
            _messageCurrentIndex++;
        }
        
        if(_player.position.y == (GameHeight/2)) {
            _playerInPosition = YES;
            
        }
        
        [_scrollingBackground moveBg:_dt];
        [_scrollingBackground2 moveBg:_dt];

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



@end
