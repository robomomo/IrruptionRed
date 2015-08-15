//
//  MessageBox.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-06-22.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MessageBox : SKSpriteNode {
    BOOL m_showing;
}

@property (nonatomic) BOOL showing;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene;
-(void)showMessage:(NSString*)msg;
-(void)hideMessage:(BOOL)hidePic;
-(void)reset;

@end
