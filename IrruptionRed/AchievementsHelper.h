//
//  AchievementsHelper.h
//  QuadCrisis
//
//  Created by Mo Mohamed on 2014-08-01.
//  Copyright (c) 2014 Mo Mohamed. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

@interface AchievementsHelper : NSObject

+(GKAchievement*)destroy100Achievement;
+(GKAchievement*)destroy200Achievement;
+(GKAchievement*)switch15Achievement;
+(GKAchievement*)roundersAchievement;
+(GKAchievement*)seekersAchievement;
+(GKAchievement*)wallsAchievement;
+(GKAchievement*)tankersAchievement;
+(GKAchievement*)thirtyGamesAchievement;

@end
