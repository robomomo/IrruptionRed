//
//  TextureBox.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "TextureBox.h"

@implementation TextureBox

@synthesize atlas = m_atlas;

+ (SKTexture *)getTexture:(NSString*)name
{
    static SKTextureAtlas *atlas = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        atlas = [SKTextureAtlas atlasNamed:@"Art"];
    });
    
    SKTexture *tex = [atlas textureNamed:name];
    tex.filteringMode = SKTextureFilteringNearest;
    return tex;
}


@end
