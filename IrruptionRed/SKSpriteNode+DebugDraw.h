//
//  SKSpriteNode+DebugDraw.h
//  CatNap
//
//  Created by Mo Mohamed on 2/21/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (DebugDraw)

-(void)attachDebugRectWithSize:(CGSize)s;
-(void)attachDebugFrameFromPath:(CGPathRef)bodyPath;

@end
