//
//  SetupScene.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-04.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "SetupScene.h"
#import "TextureBox.h"
#import "ScrollingBackground.h"
#import "PlayScene.h"
#import "TextureBox.h"
#import "MessageBox.h"

#import "SKTUtils/SKTAudio.h"

#import "GameKitHelper.h"

#import "Chartboost.h"

@implementation SetupScene {
    ScrollingBackground *_scrollingBackground;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    
    SKSpriteNode *_startButtonIcon;
    SKLabelNode *_startButtonText;
    SKSpriteNode *_creditsButtonIcon;
    SKLabelNode *_creditsButtonText;
    SKSpriteNode *_helpButtonIcon;
    SKLabelNode *_helpButtonText;

    SKSpriteNode *_topTenButtonIcon;
    SKSpriteNode *_topTenImage;
    
    MessageBox *_testMsg;
    
    SKLabelNode *_highScoreValue;
    SKLabelNode *_gamesPlayedValue;
    
    SKLabelNode *_rounderKillsText;
    SKLabelNode *_zoomerKillsText;
    SKLabelNode *_updownerKillsText;
    SKLabelNode *_shooterKillsText;
    
    BOOL _selectLevel;
    
    SKTAudio *_aud;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    
        _selectLevel = YES;

        RoundersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"ROUNDER"];
        ZoomersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"ZOOMER"];
        UpdownersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"UPDOWNER"];
        ShootersDefeated = [[NSUserDefaults standardUserDefaults] integerForKey:@"SHOOTER"];
        
        _scrollingBackground = [[ScrollingBackground alloc] initWithBG:[TextureBox getTexture:@"sky_bg"] speed:-15];
        [self addChild:_scrollingBackground];

        SKSpriteNode *highscoreIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"button"]];
        highscoreIcon.position = CGPointMake(0, self.size.height - highscoreIcon.size.height *.50);
        highscoreIcon.size = CGSizeMake(self.size.width, highscoreIcon.size.height  * .50);
        highscoreIcon.anchorPoint = CGPointZero;
        [self addChild:highscoreIcon];
        
        SKLabelNode *highScoreText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        highScoreText.text = @"Highscore";
        highScoreText.fontColor = [SKColor darkGrayColor];
        highScoreText.fontSize = 18.0f;
        highScoreText.position = CGPointMake(6, 4);
        highScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [highscoreIcon addChild:highScoreText];
        
        _highScoreValue = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _highScoreValue.text = [NSString stringWithFormat:@"%i", HighScore];
        _highScoreValue.fontColor = [SKColor darkGrayColor];
        _highScoreValue.fontSize = 18.0f;
        _highScoreValue.position = CGPointMake(self.size.width - 6, 4);
        _highScoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        [highscoreIcon addChild:_highScoreValue];
        
        SKSpriteNode *gamesPlayedIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"button"]];
        gamesPlayedIcon.position = CGPointMake(0, self.size.height - (gamesPlayedIcon.size.height * 2) * .50);
        gamesPlayedIcon.size = CGSizeMake(self.size.width, gamesPlayedIcon.size.height * .50);
        gamesPlayedIcon.anchorPoint = CGPointZero;
        [self addChild:gamesPlayedIcon];
        
        SKLabelNode *gamesPlayedText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        gamesPlayedText.text = @"Games  Played";
        gamesPlayedText.fontColor = [SKColor darkGrayColor];
        gamesPlayedText.fontSize = 18.0f;
        gamesPlayedText.position = CGPointMake(6, 4);
        gamesPlayedText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [gamesPlayedIcon addChild:gamesPlayedText];
        
        _gamesPlayedValue = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _gamesPlayedValue.text = [NSString stringWithFormat:@"%i", GamesPlayed];
        _gamesPlayedValue.fontColor = [SKColor darkGrayColor];
        _gamesPlayedValue.fontSize = 18.0f;
        _gamesPlayedValue.position = CGPointMake(self.size.width - 6, 4);
        _gamesPlayedValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        [gamesPlayedIcon addChild:_gamesPlayedValue];
        
        _startButtonIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"button"]];
        _startButtonIcon.name = @"startb";
        _startButtonIcon.position = CGPointMake(self.size.width/2, _startButtonIcon.size.height/2 * .80);
        _startButtonIcon.size = CGSizeMake(_startButtonIcon.size.width * .80, _startButtonIcon.size.height * .80);
        _startButtonIcon.alpha = 0.9;
        [self addChild:_startButtonIcon];
        
        _startButtonText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _startButtonText.text = @"PLAY";
        _startButtonText.name = @"startb";
        _startButtonText.fontColor = [SKColor darkGrayColor];
        _startButtonText.fontSize = 24.0f;
        _startButtonText.position = CGPointMake(0, -8);
        [_startButtonIcon addChild:_startButtonText];
        
        _topTenButtonIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"button"]];
        _topTenButtonIcon.name = @"toptenb";
        _topTenButtonIcon.position = CGPointMake(0, 0);
        _topTenButtonIcon.size = CGSizeMake(_topTenButtonIcon.size.width * .40, _topTenButtonIcon.size.height * .80);
        _topTenButtonIcon.alpha = 0.9;
        _topTenButtonIcon.anchorPoint = CGPointZero;
        [self addChild:_topTenButtonIcon];
        
        _topTenImage = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"topten"]];
        _topTenImage.name = @"toptenb";
        _topTenImage.position = CGPointMake(0, 0);
        _topTenImage.size = CGSizeMake(_topTenButtonIcon.size.width * .80, _topTenButtonIcon.size.height * .80);
        _topTenImage.position = CGPointMake(6, 4);
        _topTenImage.alpha = 0.9;
        _topTenImage.anchorPoint = CGPointZero;
        [_topTenButtonIcon addChild:_topTenImage];
        
        _helpButtonIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"button"]];
        _helpButtonIcon.name = @"helpb";
        _helpButtonIcon.position = CGPointMake(self.size.width - (_helpButtonIcon.size.width * .40), 0);
        _helpButtonIcon.size = CGSizeMake(_helpButtonIcon.size.width * .40, _helpButtonIcon.size.height * .80);
        _helpButtonIcon.alpha = 0.9;
        _helpButtonIcon.anchorPoint = CGPointMake(0, 0);
        [self addChild:_helpButtonIcon];
        
        _helpButtonText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _helpButtonText.text = @"Tutorial";
        _helpButtonText.name = @"helpb";
        _helpButtonText.fontColor = [SKColor darkGrayColor];
        _helpButtonText.fontSize = 12.0f;
        _helpButtonText.position = CGPointMake(3, 14);
        _helpButtonText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [_helpButtonIcon addChild:_helpButtonText];
        
        _testMsg = [[MessageBox alloc] initWithImageNamed:@"portrait_done2" scene:self];
        [self addChild:_testMsg];
        
        SKSpriteNode *rounderIcon = [SKSpriteNode spriteNodeWithTexture:rounderTex];
        rounderIcon.position = CGPointMake(self.size.width * .12, self.size.height/2);
        rounderIcon.name = @"rounderi";
        [self addChild:rounderIcon];
        
        _rounderKillsText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _rounderKillsText.text = [NSString stringWithFormat:@"%i", RoundersDefeated];
        _rounderKillsText.fontColor = [SKColor darkGrayColor];
        _rounderKillsText.fontSize = 18.0f;
        _rounderKillsText.position = rounderIcon.position;
        _rounderKillsText.position = CGPointMake(_rounderKillsText.position.x, _rounderKillsText.position.y + 25);
        [self addChild:_rounderKillsText];

        SKSpriteNode *zoomerIcon = [SKSpriteNode spriteNodeWithTexture:zoomerTex];
        zoomerIcon.position = CGPointMake(self.size.width * .30, self.size.height/2 + 50);
        zoomerIcon.name = @"zoomeri";
        [self addChild:zoomerIcon];
        
        _zoomerKillsText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _zoomerKillsText.text =  [NSString stringWithFormat:@"%i", ZoomersDefeated];
        _zoomerKillsText.fontColor = [SKColor darkGrayColor];
        _zoomerKillsText.fontSize = 18.0f;
        _zoomerKillsText.position = zoomerIcon.position;
        _zoomerKillsText.position = CGPointMake(_zoomerKillsText.position.x, _zoomerKillsText.position.y + 30);
        [self addChild:_zoomerKillsText];
        
        SKSpriteNode *upDownerIcon = [SKSpriteNode spriteNodeWithTexture:updownerTex];
        upDownerIcon.position = CGPointMake(self.size.width * .60, self.size.height/2 + 50);
        upDownerIcon.name = @"updowneri";
        [self addChild:upDownerIcon];
        
        _updownerKillsText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _updownerKillsText.text = [NSString stringWithFormat:@"%i", UpdownersDefeated];
        _updownerKillsText.fontColor = [SKColor darkGrayColor];
        _updownerKillsText.fontSize = 18.0f;
        _updownerKillsText.position = upDownerIcon.position;
        _updownerKillsText.position = CGPointMake(_updownerKillsText.position.x, _updownerKillsText.position.y + 45);
        [self addChild:_updownerKillsText];
        
        SKSpriteNode *shooterIcon = [SKSpriteNode spriteNodeWithTexture:shooterTex];
        shooterIcon.position = CGPointMake(self.size.width * .85, self.size.height/2);
        shooterIcon.name = @"shooteri";
        [self addChild:shooterIcon];
        
        _shooterKillsText = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _shooterKillsText.text = [NSString stringWithFormat:@"%i", ShootersDefeated];
        _shooterKillsText.fontColor = [SKColor darkGrayColor];
        _shooterKillsText.fontSize = 18.0f;
        _shooterKillsText.position = shooterIcon.position;
        _shooterKillsText.position = CGPointMake(_shooterKillsText.position.x, _shooterKillsText.position.y + 35);
        [self addChild:_shooterKillsText];

        SKSpriteNode *playerIcon = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"player_sprite"]];
        playerIcon.position = CGPointMake(self.size.width/2, self.size.height/2 - 50);
        [self addChild:playerIcon];
        playerIcon.zRotation = M_PI_2;
        SKAction *alhpaUp = [SKAction fadeAlphaTo:1 duration:1];
        SKAction *alphaDown = [SKAction fadeAlphaTo:0.5 duration:1];
        SKAction *fade = [SKAction sequence:@[alhpaUp, alphaDown]];
        [playerIcon runAction:[SKAction repeatActionForever:fade]];
        
        [rounderIcon runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI * 4 duration:RandomFloatRange(12, 26)]]];
        [zoomerIcon runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI * 4 duration:RandomFloatRange(12, 26)]]];
        [upDownerIcon runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI * 4 duration:RandomFloatRange(12, 26)]]];
        [shooterIcon runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI * 4 duration:RandomFloatRange(12, 26)]]];
        
        _aud = [SKTAudio sharedInstance];

        [_aud playBackgroundMusic:@"Menu.wav"];
        
    }
    return self;
}

-(void)updateValues {
    
    [_aud playBackgroundMusic:@"Menu.wav"];
    
    _highScoreValue.text = [NSString stringWithFormat:@"%i", HighScore];
    _gamesPlayedValue.text = [NSString stringWithFormat:@"%i", GamesPlayed];
    
    _rounderKillsText.text = [NSString stringWithFormat:@"%i", RoundersDefeated];
    _zoomerKillsText.text = [NSString stringWithFormat:@"%i", ZoomersDefeated];
    _updownerKillsText.text = [NSString stringWithFormat:@"%i", UpdownersDefeated];
    _shooterKillsText.text = [NSString stringWithFormat:@"%i", ShootersDefeated];

    if(AdCounter == 3) {
        AdCounter = 0;
        [[Chartboost sharedChartboost] showInterstitial:@"showad"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    
    SKNode *node = [self nodeAtPoint:touchLocation];
    NSLog(@"touched: %@", node.name);
    if([node.name isEqualToString:@"startb"]) {
        AdCounter++;
        
        SKAction *tapped = [SKAction sequence:@[
                                               [SKAction runBlock:^{ _startButtonIcon.color = [SKColor blackColor]; _startButtonIcon.colorBlendFactor = 1.0; }],
                                               [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.0 duration:0.0]]];
        
        [_startButtonIcon runAction:tapped];
        
        GamesPlayed++;
        [[NSUserDefaults standardUserDefaults] setInteger:GamesPlayed forKey:@"GAMES"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _selectLevel = NO;
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    
        [_testMsg hideMessage:YES];
        [_testMsg reset];
        [self.view presentScene:playScene transition:reveal];
          [playScene reset];
        
    }
    else if([node.name isEqualToString:@"helpb"]) {

        
        SKAction *tapped = [SKAction sequence:@[
                                                [SKAction runBlock:^{ _helpButtonIcon.color = [SKColor blackColor]; _helpButtonIcon.colorBlendFactor = 1.0; }],
                                                [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.0 duration:0.0]]];
        
        [_helpButtonIcon runAction:tapped];
        
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        
        [_testMsg hideMessage:YES];
        [_testMsg reset];
        [self.view presentScene:tutorialScene transition:reveal];
           [tutorialScene reset];
        
    }
    else if([node.name isEqualToString:@"toptenb"]) {
        
        SKAction *tapped = [SKAction sequence:@[
                                                [SKAction runBlock:^{ _topTenButtonIcon.color = [SKColor blackColor]; _topTenButtonIcon.colorBlendFactor = 1.0; }],
                                                    [SKAction waitForDuration:0.5],
                                                [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:0.0 duration:0.0]]];
        
        [_topTenButtonIcon runAction:tapped];
        [self.delegate callGameCenter:self];
    }
    else if([node.name isEqualToString:@"rounderi"]) {
           [_testMsg hideMessage:NO];
            if(_testMsg.showing == NO) {
                [_testMsg showMessage:
                 @"This is the Rounder, it|"
                 "will circle your ship as|"
                 "a distraction."];
            }
    
        
    }
    else if([node.name isEqualToString:@"zoomeri"]) {
        [_testMsg hideMessage:NO];
        if(_testMsg.showing == NO) {
            [_testMsg showMessage:
             @"The Seeker attempts to|"
             "crash into you, shoot it|"
             "down quickly."];
        }
        
        
    }
    else if([node.name isEqualToString:@"updowneri"]) {
        [_testMsg hideMessage:NO];
        if(_testMsg.showing == NO) {
            [_testMsg showMessage:
             @"The Wall's laser will flank|"
             "you. More than one is|"
             "very dangerous."];
        }
        
        
    }
    else if([node.name isEqualToString:@"shooteri"]) {
        [_testMsg hideMessage:NO];
        if(_testMsg.showing == NO) {
            [_testMsg showMessage:
             @"Tanker is the only enemy|"
             "ship capable of firing.|"
             "Shoot down it's bullets."];
        }
        
        
    }
    else {
         [_testMsg hideMessage:YES];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if(_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    [_scrollingBackground moveBg:_dt];
   
}

@end
