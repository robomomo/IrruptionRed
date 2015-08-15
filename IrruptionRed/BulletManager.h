//
//  BulletManager.h
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/17/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BulletManager : NSObject {
    NSMutableArray *m_bullets;
    float m_angleOfBullets;
}

@property (strong, nonatomic) NSMutableArray *bullets;
@property BOOL fireFlag;
@property float angleOfBullets;

-(id)initWithAmount:(int)n scene:(SKScene*)scene;
-(void)update:(CFTimeInterval)dt;
-(BOOL)shouldFire;
-(void)fireBullet:(SKSpriteNode*)bullet reverse:(BOOL)reverse index:(int)index;
-(void)removeAllBullets;
@end
