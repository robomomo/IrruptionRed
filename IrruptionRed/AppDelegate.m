//
//  AppDelegate.m
//  prototypeshooter
//
//  Created by Mo Mohamed on 3/16/2014.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "AppDelegate.h"
#import "Player.h"
#import "TextureBox.h"

#import "GameKitHelper.h"

#import "Chartboost.h"

int GameWidth;
int GameHeight;

CGPoint crosshairPosition;
Player *GPlayer;
CGPoint touchPosition;
CGPoint previoustouchPosition;
CGPoint deltaPoint;
int dmgLevel;
int firespdLevel;
int HPMAX;
Weapon selectedWeapon;

int score;
int waves;

NSMutableArray *explodeTextures;
NSMutableArray *explodeTexturesSmall;
NSArray *thrusterTexturesLong;
NSArray *thrusterTexturesShort;

SKTexture *zoomerTex;
SKTexture *rounderTex;
SKTexture *updownerTex;
SKTexture *shooterTex;

SetupScene *setupScene;
PlayScene *playScene;
TutorialScene *tutorialScene;

int HighScore;
int GamesPlayed;

int RoundersDefeated;
int ZoomersDefeated;
int UpdownersDefeated;
int ShootersDefeated;

int WeaponSwitchCount;

BOOL isTutorial;
BOOL isGameOver;

double WeaponDamage;

int AdCounter;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    GameWidth = 320;
    GameHeight = 480;
    
    dmgLevel = 1;
    firespdLevel = 1;
    HPMAX = 3;
    selectedWeapon = BigShot;
    
    AdCounter = 0;
    
    // preload
    HighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"BEST"];
    GamesPlayed = [[NSUserDefaults standardUserDefaults] integerForKey:@"GAMES"];
    
    SKLabelNode *preload = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
    preload.text = @"preload";
    
    explodeTextures = [[NSMutableArray alloc] init];
    [explodeTextures addObject:[TextureBox getTexture:@"exp_large1"]];
    [explodeTextures addObject:[TextureBox getTexture:@"exp_large2"]];
    for(int i = 1; i < 27; i++) {
        [explodeTextures addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_big%d", i]]];
    }
    
    explodeTexturesSmall = [[NSMutableArray alloc] init];
    [explodeTexturesSmall addObject:[TextureBox getTexture:@"exp_small1"]];
    [explodeTexturesSmall addObject:[TextureBox getTexture:@"exp_small2"]];
    for(int i = 1; i < 33; i++) {
        [explodeTexturesSmall addObject:[TextureBox getTexture:[NSString stringWithFormat:@"explosion_small%d", i]]];
    }
    
    thrusterTexturesLong = [[NSArray alloc] initWithObjects:
                             [TextureBox getTexture:@"long_thruster0001"],
                             [TextureBox getTexture:@"long_thruster0002"],
                             [TextureBox getTexture:@"long_thruster0003"],
                             [TextureBox getTexture:@"long_thruster0004"],
                             [TextureBox getTexture:@"long_thruster0005"],
                             [TextureBox getTexture:@"long_thruster0006"],
                             nil];
    
    thrusterTexturesShort = [[NSArray alloc] initWithObjects:
                              [TextureBox getTexture:@"tank_thruster0001"],
                              [TextureBox getTexture:@"tank_thruster0002"],
                              [TextureBox getTexture:@"tank_thruster0003"],
                              [TextureBox getTexture:@"tank_thruster0004"],
                              [TextureBox getTexture:@"tank_thruster0005"],
                              [TextureBox getTexture:@"tank_thruster0006"],
                              nil];
    
    rounderTex = [TextureBox getTexture:@"enemy_round"];
    zoomerTex = [TextureBox getTexture:@"enemy_long"];
    updownerTex = [TextureBox getTexture:@"enemy_laser"];
    shooterTex = [TextureBox getTexture:@"enemy_tank"];
    
    SKLabelNode *preloadFont = [SKLabelNode labelNodeWithFontNamed:@"5x5-Pixel"];
    [preloadFont setText:@"preload"];
    
    isTutorial = NO;
    isGameOver = NO;

    setupScene = [[SetupScene alloc] initWithSize:CGSizeMake(GameWidth, GameHeight)];
   
    playScene = [[PlayScene alloc] initWithSize:CGSizeMake(GameWidth, GameHeight)];
    tutorialScene = [[TutorialScene alloc] initWithSize:CGSizeMake(GameWidth, GameHeight)];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [Chartboost startWithAppId:@"omitted" appSignature:@"omitted" delegate:self];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
