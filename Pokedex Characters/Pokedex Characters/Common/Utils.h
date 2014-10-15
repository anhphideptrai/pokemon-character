//
//  Utils.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/11/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LANGUAGE_SETTING_TAG @"LANGUAGE_SETTING_TAG"
typedef enum {
    LanguageSettingEN = 0,
    LanguageSettingES = 1,
    LanguageSettingFR = 2,
    LanguageSettingIT = 3
} LanguageSetting;

typedef enum {
    SEARCH_STRING,
    VERSION_STRING,
    HEIGHT_STRING,
    WEIGHT_STRING,
    BASE_STATS_STRING,
    TYPE_STRING,
    WEAKNESS_STRING,
    EVOLUTION_STRING,
    HP_STRING,
    ATTACK_STRING,
    DEFENSE_STRING,
    SP_ATK_STRING,
    SP_DEF_STRING,
    SPEED_STRING,
    ORDER_ID_NAME_STRING,
    DB_NAME_STRING
} STRING_APP;

typedef enum {
    Fire_TYPE = 0,
    Flying_TYPE,
    Ice_TYPE,
    Psychic_TYPE,
    Ground_TYPE,
    Water_TYPE,
    Dragon_TYPE,
    Rock_TYPE,
    Electric_TYPE,
    Grass_TYPE,
    Fighting_TYPE,
    Steel_TYPE,
    Bug_TYPE,
    Ghost_TYPE,
    Dark_TYPE,
    Fairy_TYPE,
    Poison_TYPE,
    Normal_TYPE
} CHARACTER_TYPE;

@interface Utils : NSObject
+ (NSString*)getStringType:(NSString*)strType withLanguage:(LanguageSetting)language;
+ (NSString*)getStringOf:(STRING_APP)stringApp withLanguage:(LanguageSetting)language;
+ (NSString *) admobDeviceID;
@end
