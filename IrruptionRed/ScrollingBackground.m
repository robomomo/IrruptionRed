//
//  ScrollingBackground.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "ScrollingBackground.h"

@implementation ScrollingBackground {
    SKSpriteNode *_spr;
}

@synthesize speed = m_speed;

-(id)initWithBG:(SKTexture*)bg speed:(float)speed {
    if(self = [super init]) {
        m_speed = speed;
        for(int i = 0; i < 2; i++)
        {
            _spr = [SKSpriteNode spriteNodeWithTexture:bg];

            _spr.anchorPoint = CGPointMake(0, 0);
            _spr.size = CGSizeMake(GameWidth, GameHeight);
            _spr.position = CGPointMake(0, i * GameHeight);
            _spr.name = @"bg";
            _spr.zPosition = -1;
         
            [self addChild:_spr];
        }
       
        
    }
    return self;
}


-(void)moveBg:(NSTimeInterval)dt {
    CGPoint bgVelocity = CGPointMake(0, m_speed);
    CGPoint amtMove = CGPointMultiplyScalar(bgVelocity, dt);
    
    self.position = CGPointAdd(self.position, amtMove);
    
    if(self.position.y <= -GameHeight) {
        self.position = CGPointMake(0, 0);
    }
}

@end
