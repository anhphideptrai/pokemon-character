//
//  Utils.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/11/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "Utils.h"
#import "ZipManager.h"
// #import <AdSupport/ASIdentifierManager.h>
// #include <CommonCrypto/CommonDigest.h>

#define search_string_en @"SEARCH"
#define search_string_es @"BUSCAR"
#define search_string_fr @"RECHERCHER"
#define search_string_it @"CERCA"

#define version_string_en @"Versions:"
#define version_string_es @"Versiones:"
#define version_string_fr @"Versions:"
#define version_string_it @"Versioni:"

#define height_string_en @"Height:"
#define height_string_es @"Altura:"
#define height_string_fr @"Taille:"
#define height_string_it @"Altezza:"

#define weight_string_en @"Weight:"
#define weight_string_es @"Peso:"
#define weight_string_fr @"Poids:"
#define weight_string_it @"Peso:"

#define base_stats_string_en @"Base Stats"
#define base_stats_string_es @"Puntos de base"
#define base_stats_string_fr @"Stats de base"
#define base_stats_string_it @"Statistiche"

#define type_string_en @"Type:"
#define type_string_es @"Tipo:"
#define type_string_fr @"Type:"
#define type_string_it @"Tipo:"

#define weakness_string_en @"Weaknesses:"
#define weakness_string_es @"Debilidad:"
#define weakness_string_fr @"Faiblesse(s):"
#define weakness_string_it @"Debolezze:"

#define evolution_string_en @"Evolutions"
#define evolution_string_es @"Evoluciones"
#define evolution_string_fr @"Évolutions"
#define evolution_string_it @"Evoluzioni"

#define hp_string_en @"HP"
#define hp_string_es @"PS"
#define hp_string_fr @"PV"
#define hp_string_it @"PS"

#define attack_string_en @"Attack"
#define attack_string_es @"Ataque"
#define attack_string_fr @"Attaque"
#define attack_string_it @"Attacco"

#define defense_string_en @"Defense"
#define defense_string_es @"Defensa"
#define defense_string_fr @"Défense"
#define defense_string_it @"Difesa"

#define sp_atk_string_en @"Sp. Atk"
#define sp_atk_string_es @"Ate .Es"
#define sp_atk_string_fr @"Ate .Sp"
#define sp_atk_string_it @"Ato .Sp"

#define sp_def_string_en @"Sp. Def"
#define sp_def_string_es @"Def .Es"
#define sp_def_string_fr @"Déf .Sp"
#define sp_def_string_it @"Dif .Sp"

#define speed_string_en @"Speed"
#define speed_string_es @"Velocidad"
#define speed_string_fr @"Vitesse"
#define speed_string_it @"Velocità"

#define order_id_name_string_en @"#"
#define order_id_name_string_es @"N.º "
#define order_id_name_string_fr @"No. "
#define order_id_name_string_it @"N° "

#define db_name_string_en @"00A2C633-5090-4F9E-A1DA-EF8E508FDC9A"
#define db_name_string_es @"08E7CCA3-E0A7-48FA-8F09-BAEE19B835A9"
#define db_name_string_fr @"020D14C1-66CF-4B4B-9727-6A54C6B7A5F2"
#define db_name_string_it @"0407126C-F70D-4DF4-929D-474BCA9D6E87"

#define fire_type       [NSArray arrayWithObjects:@"Fire", @"Fuego", @"Feu",	@"Fuoco", nil]
#define flying_type     [NSArray arrayWithObjects:@"Flying",	@"Volador",	@"Vol",	@"Volante", nil]
#define ice_type        [NSArray arrayWithObjects:@"Ice",	@"Hielo",	@"Glace",	@"Ghiaccio", nil]
#define psychic_type    [NSArray arrayWithObjects:@"Psychic", @"Psíquico",	@"Psy",	@"Psico", nil]
#define ground_type     [NSArray arrayWithObjects:@"Ground",	@"Tierra",	@"Sol",	@"Terra", nil]
#define water_type      [NSArray arrayWithObjects:@"Water",	@"Agua",	@"Eau",	@"Acqua", nil]
#define dragon_type     [NSArray arrayWithObjects:@"Dragon",	@"Dragón",	@"Dragon",	@"Drago", nil]
#define rock_type       [NSArray arrayWithObjects:@"Rock",	@"Roca",	@"Roche",	@"Roccia", nil]
#define electric_type   [NSArray arrayWithObjects:@"Electric",	@"Eléctrico",	@"Électrik",	@"Elettro", nil]
#define grass_type      [NSArray arrayWithObjects:@"Grass",	@"Planta",	@"Plante",	@"Erba", nil]
#define fighting_type   [NSArray arrayWithObjects:@"Fighting",	@"Lucha",	@"Combat",	@"Lotta", nil]
#define steel_type      [NSArray arrayWithObjects:@"Steel",	@"Acero",	@"Acier",	@"Acciaio", nil]
#define bug_type        [NSArray arrayWithObjects:@"Bug",	@"Bicho",	@"Insecte",	@"Coleott.", nil]
#define ghost_type      [NSArray arrayWithObjects:@"Ghost",	@"Fantasma",	@"Spectre",	@"Spettro", nil]
#define dark_type       [NSArray arrayWithObjects:@"Dark",	@"Siniestro",	@"Ténèbr.",	@"Buio", nil]
#define fairy_type      [NSArray arrayWithObjects:@"Fairy",	@"Hada",	@"Fée",	@"Folletto", nil]
#define poison_type     [NSArray arrayWithObjects:@"Poison",	@"Veneno",	@"Poison",	@"Veleno", nil]
#define normal_type     [NSArray arrayWithObjects:@"Normal",	@"Normal",	@"Normal",	@"Normale", nil]
#define array_all_type  [NSArray arrayWithObjects:fire_type,flying_type,ice_type,psychic_type,ground_type,water_type,dragon_type,rock_type,electric_type,grass_type,fighting_type,steel_type,bug_type,ghost_type,dark_type,fairy_type,poison_type,normal_type,nil]
@implementation Utils
+ (NSString*)getStringType:(NSString*)strType withLanguage:(LanguageSetting)language{
    for (NSArray *item in array_all_type) {
        for (NSString *strItem in item) {
            if ([[strItem lowercaseString] isEqualToString:[strType lowercaseString]]) {
                return [item objectAtIndex:language];
            }
        }
    }
    return strType;
}
+ (NSString*)getStringOf:(STRING_APP)stringApp withLanguage:(LanguageSetting)language{
    switch (language) {
        case LanguageSettingEN:
            return [Utils getStringOfLanguageEN:stringApp];
        case LanguageSettingES:
            return [Utils getStringOfLanguageES:stringApp];
        case LanguageSettingFR:
            return [Utils getStringOfLanguageFR:stringApp];
        case LanguageSettingIT:
            return [Utils getStringOfLanguageIT:stringApp];
    }
}

+ (NSString*)getStringOfLanguageEN:(STRING_APP)stringApp{
    switch (stringApp) {
        case SEARCH_STRING:
            return search_string_en;
        case VERSION_STRING:
            return version_string_en;
        case HEIGHT_STRING:
            return height_string_en;
        case WEIGHT_STRING:
            return weight_string_en;
        case BASE_STATS_STRING:
            return base_stats_string_en;
        case TYPE_STRING:
            return type_string_en;
        case WEAKNESS_STRING:
            return weakness_string_en;
        case EVOLUTION_STRING:
            return evolution_string_en;
        case HP_STRING:
            return hp_string_en;
        case ATTACK_STRING:
            return attack_string_en;
        case DEFENSE_STRING:
            return defense_string_en;
        case SP_ATK_STRING:
            return sp_atk_string_en;
        case SP_DEF_STRING:
            return sp_def_string_en;
        case SPEED_STRING:
            return speed_string_en;
        case ORDER_ID_NAME_STRING:
            return order_id_name_string_en;
        case DB_NAME_STRING:
            return db_name_string_en;
    }
}
+ (NSString*)getStringOfLanguageES:(STRING_APP)stringApp{
    switch (stringApp) {
        case SEARCH_STRING:
            return search_string_es;
        case VERSION_STRING:
            return version_string_es;
        case HEIGHT_STRING:
            return height_string_es;
        case WEIGHT_STRING:
            return weight_string_es;
        case BASE_STATS_STRING:
            return base_stats_string_es;
        case TYPE_STRING:
            return type_string_es;
        case WEAKNESS_STRING:
            return weakness_string_es;
        case EVOLUTION_STRING:
            return evolution_string_es;
        case HP_STRING:
            return hp_string_es;
        case ATTACK_STRING:
            return attack_string_es;
        case DEFENSE_STRING:
            return defense_string_es;
        case SP_ATK_STRING:
            return sp_atk_string_es;
        case SP_DEF_STRING:
            return sp_def_string_es;
        case SPEED_STRING:
            return speed_string_es;
        case ORDER_ID_NAME_STRING:
            return order_id_name_string_es;
        case DB_NAME_STRING:
            return db_name_string_es;
    }
}
+ (NSString*)getStringOfLanguageFR:(STRING_APP)stringApp{
    switch (stringApp) {
        case SEARCH_STRING:
            return search_string_fr;
        case VERSION_STRING:
            return version_string_fr;
        case HEIGHT_STRING:
            return height_string_fr;
        case WEIGHT_STRING:
            return weight_string_fr;
        case BASE_STATS_STRING:
            return base_stats_string_fr;
        case TYPE_STRING:
            return type_string_fr;
        case WEAKNESS_STRING:
            return weakness_string_fr;
        case EVOLUTION_STRING:
            return evolution_string_fr;
        case HP_STRING:
            return hp_string_fr;
        case ATTACK_STRING:
            return attack_string_fr;
        case DEFENSE_STRING:
            return defense_string_fr;
        case SP_ATK_STRING:
            return sp_atk_string_fr;
        case SP_DEF_STRING:
            return sp_def_string_fr;
        case SPEED_STRING:
            return speed_string_fr;
        case ORDER_ID_NAME_STRING:
            return order_id_name_string_fr;
        case DB_NAME_STRING:
            return db_name_string_fr;
    }
}
+ (NSString*)getStringOfLanguageIT:(STRING_APP)stringApp{
    switch (stringApp) {
        case SEARCH_STRING:
            return search_string_it;
        case VERSION_STRING:
            return version_string_it;
        case HEIGHT_STRING:
            return height_string_it;
        case WEIGHT_STRING:
            return weight_string_it;
        case BASE_STATS_STRING:
            return base_stats_string_it;
        case TYPE_STRING:
            return type_string_it;
        case WEAKNESS_STRING:
            return weakness_string_it;
        case EVOLUTION_STRING:
            return evolution_string_it;
        case HP_STRING:
            return hp_string_it;
        case ATTACK_STRING:
            return attack_string_it;
        case DEFENSE_STRING:
            return defense_string_it;
        case SP_ATK_STRING:
            return sp_atk_string_it;
        case SP_DEF_STRING:
            return sp_def_string_it;
        case SPEED_STRING:
            return speed_string_it;
        case ORDER_ID_NAME_STRING:
            return order_id_name_string_it;
        case DB_NAME_STRING:
            return db_name_string_it;
    }
}

+ (void) downloadFile:(NSString*)urlFile andSaveWithName:(NSString*)nameFile{
    NSURL *contributorsUrl = [NSURL URLWithString:urlFile];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:contributorsUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ( urlData )
    {
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@.zip", documentsDirectory,nameFile];
        NSString *fileDec = [NSString stringWithFormat:@"%@/%@", documentsDirectory,nameFile];
        [urlData writeToFile:filePath atomically:YES];
        if ([ZipManager unzipFile:filePath withDecPath:fileDec]) {
            [Utils removeFileWithPath:filePath];
        }
    }
    urlData = nil;
}

+ (BOOL) removeFileWithPath:(NSString*)path{
    NSError *error=nil;
    BOOL succes = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
    return succes;
}
/*
+ (NSString *) admobDeviceID
{
    NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    const char *cStr = [adid.UUIDString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}*/

@end
