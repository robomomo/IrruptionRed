//
//  MyScene.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/16/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    SKNode *_backgroundLayer;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"textures"];
        
        
        _backgroundLayer = [SKNode node];
        [self addChild:_backgroundLayer];
        
        for(int i = 0; i < 2; i++)
        {
            //SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
            SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"bg"]];
            //bg.texture = [atlas textureNamed:@"bg"];
            bg.anchorPoint = CGPointZero;
            bg.position = CGPointMake(0, 0);
            bg.name = @"bg";
            [_backgroundLayer addChild:bg];
        }

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void)update:(CFTimeInterval)currentTime {
    if(_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    [self moveBg];
    
}

- (void)moveBg {
    
    CGPoint bgVelocity = CGPointMake(0, -50);
    CGPoint amtMove = CGPointMultiplyScalar(bgVelocity, _dt);
    _backgroundLayer.position = CGPointAdd(_backgroundLayer.position, amtMove);
    
    [_backgroundLayer enumerateChildNodesWithName:@"bg" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *bg = (SKSpriteNode *)node;
        
        CGPoint bgScreenPos = [_backgroundLayer convertPoint:bg.position toNode:self];
        
        if(bgScreenPos.y <= -bg.size.height) {
            bg.position = CGPointMake(bg.position.x, bg.position.y + bg.size.height);
        }
    }];
}

@end
