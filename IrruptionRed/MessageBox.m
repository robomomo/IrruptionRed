//
//  MessageBox.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-06-22.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "MessageBox.h"
#import "TextureBox.h"

@implementation MessageBox {
    SKScene *_scene;
    
    CGPoint onScreenPosition;
    CGPoint offScreenPosition;
    
    SKSpriteNode *_box;
    
    SKLabelNode *_message;
    SKLabelNode *_messageLine1;
    SKLabelNode *_messageLine2;
    SKLabelNode *_messageLine3;
    
    SKLabelNode *_blinker;
}

@synthesize showing = m_showing;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene {
    if(self = [super init]) {
        _scene = scene;
        
        [self setTexture:[TextureBox getTexture:name]];
        [self setSize:self.texture.size];

        self.anchorPoint = CGPointMake(0, 0);
        onScreenPosition = CGPointMake(0, 40);
        offScreenPosition = CGPointMake(-self.size.width, 40);
        
        self.position = offScreenPosition;
        
        _box = [SKSpriteNode spriteNodeWithTexture:[TextureBox getTexture:@"black"]];
        _box.size = CGSizeMake(GameWidth, 60);
        _box.position = CGPointMake(0, 40);
        _box.hidden = YES;
        _box.anchorPoint = CGPointMake(0, 0);
        _box.alpha = 0.5;
  
        [scene addChild:_box];
 
        _message = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
        _message.fontColor = [SKColor whiteColor];
        _message.fontSize = 16;
        _message.position = CGPointMake(115, 80);
        _message.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _message.hidden = YES;
        _message.alpha = 0;
        [scene addChild:_message];
        
        _messageLine1 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
        _messageLine1.fontColor = [SKColor whiteColor];
        _messageLine1.fontSize = 16;
        _messageLine1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
  
        
        _messageLine2 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
        _messageLine2.fontColor = [SKColor whiteColor];
        _messageLine2.fontSize = 16;
        _messageLine2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _messageLine2.position = CGPointMake(_messageLine2.position.x, _messageLine2.position.y - 15);
        
        _messageLine3 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
        _messageLine3.fontColor = [SKColor whiteColor];
        _messageLine3.fontSize = 16;
        _messageLine3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _messageLine3.position = CGPointMake(_messageLine2.position.x, _messageLine2.position.y - 15);
      
        SKAction *hide = [SKAction fadeAlphaTo:0 duration:0.2];
        SKAction *show = [SKAction fadeAlphaTo:1 duration:0.2];
        SKAction *seq = [SKAction sequence:@[hide, show]];
        _blinker = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
        _blinker.text = @"▼";
        _blinker.fontColor = [SKColor blackColor];
        _blinker.fontSize = 18.0f;
        _blinker.position = CGPointMake(GameWidth - 10, _box.size.height + 5);
        
        [_blinker runAction:[SKAction repeatActionForever:seq]];
     
    }
    return self;
}

-(void)prepareMsg:(NSString*)msg {
    if(!m_showing)
    {
        NSArray *txt = [msg componentsSeparatedByString:@"|"];
    
        _messageLine1.text = txt[0];
        _messageLine2.text = txt[1];
        _messageLine3.text = txt[2];

        [_message addChild:_messageLine1];
        [_message addChild:_messageLine2];
        [_message addChild:_messageLine3];
        
        if(_blinker.parent == nil)
            [_box addChild:_blinker];

    }
    
}

-(void)showMessage:(NSString*)msg {
    
    [self prepareMsg:msg];
    
    m_showing = YES;
    _message.hidden = NO;
    _box.hidden = NO;
    
    [self runAction:[SKAction moveTo:onScreenPosition duration:0.1]];

    [_message runAction:[SKAction fadeAlphaTo:1 duration:0.2]];
  
}

-(void)hideMessage:(BOOL)hidePic {
    m_showing = NO;
    
    if(hidePic) {
        [self runAction:[SKAction moveTo:offScreenPosition duration:0.1]];
    }
    else {
  
    }
    
    _box.hidden = YES;
    _message.hidden = YES;
    _message.text = @"";
    _message.alpha = 0;
    
    [_message removeAllChildren];
    [_box removeAllChildren];
}

-(void)reset {
    self.position = offScreenPosition;
}

@end
