//
//  AchievementsHelper.m
//  QuadCrisis
//
//  Created by Mo Mohamed on 2014-08-01.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import "AchievementsHelper.h"

static NSString *const kDestroy100 =    @"com.momogames.IrruptionRed.omitted";
static NSString *const kSwitch15 =      @"com.momogames.IrruptionRed.omitted";
static NSString *const kDestroy200 =    @"com.momogames.IrruptionRed.omitted";
static NSString *const k500Rounders =   @"com.momogames.IrruptionRed.omitted";
static NSString *const k300Seekers =    @"com.momogames.IrruptionRed.omitted";
static NSString *const k150Walls =      @"com.momogames.IrruptionRed.omitted";
static NSString *const k150Tankers =    @"com.momogames.IrruptionRed.omitted";
static NSString *const k30Games =       @"com.momogames.IrruptionRed.omitted";

@implementation AchievementsHelper

+(GKAchievement*)destroy100Achievement {
    GKAchievement *destroy100 = [[GKAchievement alloc] initWithIdentifier:kDestroy100];
    
    destroy100.percentComplete = 100.0;
    destroy100.showsCompletionBanner = YES;
    
    return destroy100;
}

+(GKAchievement*)destroy200Achievement {
    GKAchievement *destroy200 = [[GKAchievement alloc] initWithIdentifier:kDestroy200];
    
    destroy200.percentComplete = 100.0;
    destroy200.showsCompletionBanner = YES;
    
    return destroy200;
}

+(GKAchievement*)switch15Achievement {
    GKAchievement *switch15 = [[GKAchievement alloc] initWithIdentifier:kSwitch15];
    
    double switched = WeaponSwitchCount;
    double percent = 0;
    if(switched < 15)
        percent = (switched/15) * 100.0;
    else
        percent = 100.0;
    
    switch15.percentComplete = percent;
    switch15.showsCompletionBanner = YES;
    
    return switch15;
}

+(GKAchievement*)roundersAchievement {
    GKAchievement *rounders = [[GKAchievement alloc] initWithIdentifier:k500Rounders];
    
    double defeated = RoundersDefeated;
    double percent = 0;
    if(defeated < 500)
        percent = (defeated/500) * 100.0;
    else
        percent = 100.0;
    
    rounders.percentComplete = percent;
    rounders.showsCompletionBanner = YES;
    
    return rounders;
}

+(GKAchievement*)seekersAchievement {
    GKAchievement *seekers = [[GKAchievement alloc] initWithIdentifier:k300Seekers];
    
    double defeated = ZoomersDefeated;
    double percent = 0;
    if(defeated < 300)
        percent = (defeated/300) * 100.0;
    else
        percent = 100.0;
    
    seekers.percentComplete = percent;
    seekers.showsCompletionBanner = YES;
    
    return seekers;
}

+(GKAchievement*)wallsAchievement {
    GKAchievement *walls = [[GKAchievement alloc] initWithIdentifier:k150Walls];
    
    double defeated = UpdownersDefeated;
    double percent = 0;
    if(defeated < 150)
        percent = (defeated/150) * 100.0;
    else
        percent = 100.0;
    
    walls.percentComplete = percent;
    walls.showsCompletionBanner = YES;
    
    return walls;
}

+(GKAchievement*)tankersAchievement {
    GKAchievement *tankers = [[GKAchievement alloc] initWithIdentifier:k150Tankers];
    
    double defeated = ShootersDefeated;
    double percent = 0;
    if(defeated < 150)
        percent = (defeated/150) * 100.0;
    else
        percent = 100.0;
    
    tankers.percentComplete = percent;
    tankers.showsCompletionBanner = YES;
    
    return tankers;
}

+(GKAchievement*)thirtyGamesAchievement {
    GKAchievement *games = [[GKAchievement alloc] initWithIdentifier:k30Games];
    
    double count = GamesPlayed;
    double percent = 0;
    if(count < 30)
        percent = (count/30) * 100.0;
    else
        percent = 100.0;
    
    games.percentComplete = percent;
    games.showsCompletionBanner = YES;
    
    return games;
}
@end
