//
//  EnemyManager.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/26/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "PlayScene.h"
#import "SetupScene.h"
#import "EnemyManager.h"
#import "Zoomer.h"
#import "Rounder.h"
#import "UpDowner.h"
#import "Shooter.h"
#import "TextureBox.h"

@implementation EnemyManager {
    PlayScene *_scene;
    BOOL _addEnemies;
    NSString *_levels;
    NSArray *_baddies;
}

-(id)initWithScene:(SKScene*)scene {
    if(self = [super init]) {
        _scene = (PlayScene*)scene;

        NSString *path = [[NSBundle mainBundle] pathForResource:@"Levels.txt" ofType:nil];
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];

        if (fileContents == nil && error) {
            NSLog(@"Error reading file: %@", error.localizedDescription);
            return nil;
        }

        _levels = [fileContents componentsSeparatedByString:@"\n"][0];
        _baddies = [_levels componentsSeparatedByString:@","];
    
    }
    return self;
}

- (void)addEnemy:(int)amount enemy:(NSString*)name {
    for(int i = 0; i < amount; i++) {
        BaseEnemy *enemy;
        if([name isEqualToString:@"rounder"]) {
            enemy = [[Rounder alloc] initWithTex:rounderTex thrusterTexs:nil scene:_scene dieTime:0.3];
        }
        if([name isEqualToString:@"zoomer"]) {
            enemy = [[Zoomer alloc] initWithTex:zoomerTex thrusterTexs:thrusterTexturesLong scene:_scene dieTime:0.1];
        }
        if([name isEqualToString:@"updowner"]) {
            enemy = [[UpDowner alloc] initWithTex:updownerTex thrusterTexs:nil scene:_scene dieTime:0.3];
        }
        if([name isEqualToString:@"shooter"]) {
            enemy = [[Shooter alloc] initWithTex:shooterTex thrusterTexs:thrusterTexturesShort scene:_scene dieTime:0.3];
        }
        enemy.name = @"enemy";
        [_scene.enemyLayer addChild:enemy];
    }
}

- (void)addLevelEnemies {
        for(int i = 0; i < [_baddies count]; i++)
        {
            float amountMod = 0;
            NSString *name = [_baddies[i] componentsSeparatedByString:@"_"][1];
            if([name isEqualToString:@"rounder"]) {

                amountMod = waves * 0.2;
                if(amountMod > 4)
                    amountMod = 4;
   
            }
            else if([name isEqualToString:@"zoomer"]) {

                amountMod = waves * 0.1;
                if(amountMod > 3)
                    amountMod = 3;
            }
            else if([name isEqualToString:@"updowner"]) {
         
                amountMod = waves * 0.1;
                if(amountMod > 2)
                    amountMod = 2;
            }
            else if([name isEqualToString:@"shooter"]) {
               
                amountMod = waves * 0.1;
                if(amountMod > 3)
                    amountMod = 3;
              
            }
            
            if(score == 0 && [name isEqualToString:@"rounder"])
                amountMod = 1;
           

            [self addEnemy:amountMod enemy:name];
    
        }

        waves++;
    
    _addEnemies = NO;
}

- (void)update:(CFTimeInterval)dt {
    if(_addEnemies == NO && [_scene.enemyLayer.children count] > 0) {
        
        [_scene.enemyLayer  enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
            [(BaseEnemy*)node update:dt];
        }];
        
    }

    if([_scene.enemyLayer.children count] <= arc4random() %(4)) {
   
        _addEnemies = YES;
        [self addLevelEnemies];
    }
    
}


@end
