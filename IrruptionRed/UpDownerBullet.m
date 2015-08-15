//
//  UpDownerBullet.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-21.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "UpDownerBullet.h"
#import "PlayScene.h"
#import "TextureBox.h"


@implementation UpDownerBullet {
    PlayScene *_scene;
    float _frameTime;
    float _interval;
}

-(id)initWithTex:(SKTexture *)tex thrusterTexs:(NSArray*)thrusterTexs scene:(SKScene*)scene dieTime:(float)dieTime {
    if(self = [super init]) {
        _scene = (PlayScene*)scene;
        
        [self setTexture:tex];
        [self setSize:CGSizeMake(GameWidth, 20)];

    }
    return self;
}

- (void)update:(CFTimeInterval)dt
{
    _frameTime += dt;
    if(self.parent != nil) {

    }
}

@end
