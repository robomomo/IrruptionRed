//
//  TextureBox.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextureBox : NSObject {
    SKTextureAtlas *m_atlas;
}

@property (strong, nonatomic) SKTextureAtlas *atlas;

+ (SKTexture *)getTexture:(NSString*)name;

@end
