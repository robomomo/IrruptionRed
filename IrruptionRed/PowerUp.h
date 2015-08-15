//
//  PowerUp.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 2014-04-19.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PowerUp : SKSpriteNode {
    PowerUpType m_type;
}

@property (nonatomic) PowerUpType type;

-(id)initWithImageNamed:(NSString *)name scene:(SKScene*)scene type:(PowerUpType)type;
-(void)update:(CFTimeInterval)dt;
-(void)configureCollisionBody;
-(void)collidedWith:(SKPhysicsBody *)body contact:(SKPhysicsContact*)contact;

@end
