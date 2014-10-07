//
//  SQLiteManager.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SQLiteManager.h"
#import "PokemonType.h"

@interface SQLiteManager()

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

@end

@implementation SQLiteManager
static SQLiteManager *thisInstance;
+ (SQLiteManager *) getInstance{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        thisInstance = [[SQLiteManager alloc] init];
    }
    return thisInstance;
}
- (void)copyDatabase {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    _databasePath = [documentsDirectory stringByAppendingPathComponent:@"PokemonNew_es.db"];
    
    if ([fileManager fileExistsAtPath:_databasePath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"PokemonNew_es" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:_databasePath error:&error];
    }
}
- (NSMutableArray*)getArrPokemonWithType:(NSString*)type andSearchKey:(NSString*)searchKey{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    Pokemon *pokemonItem;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from Pokemon WHERE TYPE LIKE \'%%%@%%\' AND (Name LIKE \'%%%@%%\' OR IDPokemon LIKE \'%%%@%%\') group by iDPokemon", type, searchKey, searchKey];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                pokemonItem = [[Pokemon alloc] init];
                pokemonItem.iD = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                pokemonItem.abilities = [[NSMutableArray alloc] initWithArray:[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)] componentsSeparatedByString:@" "]];
                pokemonItem.weight = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                pokemonItem.height = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
                pokemonItem.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                pokemonItem.ThumbnailImage = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 5)];
                pokemonItem.weakness = [[NSMutableArray alloc] initWithArray:[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 6)] componentsSeparatedByString:@"---"]];
                pokemonItem.type = [[NSMutableArray alloc] initWithArray:[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 7)] componentsSeparatedByString:@"---"]];
                pokemonItem.descriptionX = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 8)];
                pokemonItem.descriptionY = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 9)];
                pokemonItem.evolutions = [[NSMutableArray alloc] initWithArray:[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 10)] componentsSeparatedByString:@"---"]];
                pokemonItem.baseStats = [[NSMutableArray alloc] initWithArray:[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 11)] componentsSeparatedByString:@"---"]];
                [resultArray addObject:pokemonItem];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;
}
- (NSMutableArray*)getPokemonWithAllTypes{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSArray *arrType = [self getTypes];
    for (NSString *type in arrType) {
        PokemonType *pokemonType = [[PokemonType alloc] init];
        [pokemonType setType:type];
        [pokemonType setPokemons:[self getArrPokemonWithType:pokemonType.type andSearchKey:@""]];
        [resultArray addObject:pokemonType];
    }
    return resultArray;

}
- (NSMutableArray*)getTypes{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from Type group by Type"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [resultArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;

}
- (NSMutableArray*)getArrPokemonWithSearchKey:(NSString*)searchKey{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSArray *arrType = [self getTypes];
    for (NSString *type in arrType) {
        PokemonType *pokemonType = [[PokemonType alloc] init];
        [pokemonType setType:type];
        [pokemonType setPokemons:[self getArrPokemonWithType:pokemonType.type andSearchKey:searchKey]];
        if (pokemonType.pokemons.count > 0) {
            [resultArray addObject:pokemonType];
        }
    }
    return resultArray;
}
- (Pokemon*)getPokemonWithID:(NSString*)iDPokemon{
    Pokemon* result = nil;
    NSArray* arr = [self getArrPokemonWithType:@"" andSearchKey:iDPokemon];
    if (arr && arr.count > 0) {
        result = [arr objectAtIndex:0];
    }
    return result;
}
@end
