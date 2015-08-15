//
//  ScrollingBackground.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScrollingBackground : SKNode {
    float m_speed;
}

@property (nonatomic) float speed;


-(id)initWithBG:(SKTexture*)bg speed:(float)speed;
-(void)moveBg:(NSTimeInterval)dt;

@end
