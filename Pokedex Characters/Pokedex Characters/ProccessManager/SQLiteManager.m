//
//  SQLiteManager.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SQLiteManager.h"

#define DB_NAME_STRING @"origami.sqlite"
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
    
    _databasePath = [documentsDirectory stringByAppendingPathComponent:DB_NAME_STRING];
    
    if ([fileManager fileExistsAtPath:_databasePath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:DB_NAME_STRING ofType:@""];
        [fileManager copyItemAtPath:resourcePath toPath:_databasePath error:&error];
    }
}
- (NSMutableArray*)getArrGroupsWithSearchKey:(NSString*)searchKey{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    OrigamiGroup *group;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from 'origami_group'"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                group = [[OrigamiGroup alloc] init];
                group.groupID = sqlite3_column_int(statement, 0);
                group.groupName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                group.schemes = [self getArrSchemesWithGroupID:group.groupID andSearchKey:searchKey];
                if (group.schemes.count > 0) {
                    [resultArray addObject:group];
                }
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;
}

- (BOOL)didDownloadedScheme:(OrigamiScheme*)scheme{
    [self copyDatabase];
    BOOL result = NO;
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"UPDATE origami_scheme SET isdownloaded = \"1\" WHERE schemeID = '%@'",scheme.rowid];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        result = (sqlite3_step(statement) == SQLITE_DONE);
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    return result;
}

- (NSMutableArray*)getArrGroups{
    return [self getArrGroupsWithSearchKey:@""];
}

- (NSMutableArray*)getArrSchemesWithGroupID:(NSInteger)groupID andSearchKey:(NSString*)searchKey{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    OrigamiScheme *scheme;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from origami_scheme where iDGroup = \"%ld\" and name LIKE \'%%%@%%\'", (long)groupID, searchKey];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                scheme = [[OrigamiScheme alloc] init];
                scheme.rowid = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                scheme.ident = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                scheme.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                scheme.descr = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
                scheme.changed = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                scheme.steps_count = sqlite3_column_int(statement, 5);
                scheme.iDGroup = sqlite3_column_int(statement, 7);
                scheme.isDownloaded = sqlite3_column_int(statement, 8) > 0;
                scheme.steps = [self getArrStepWithIDScheme:scheme.rowid];
                [resultArray addObject:scheme];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;
    
}
- (NSMutableArray*)getArrStepWithIDScheme:(NSString*)iDScheme{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    OrigamiStep *step;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from origami_step where schemeID = \"%@\" order by sort_order", iDScheme];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                step = [[OrigamiStep alloc] init];
                step.schemeID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                step.stepid = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                step.sort_order = sqlite3_column_int(statement, 2);
                step.info = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
                step.help = sqlite3_column_int(statement, 4);
                step.size = sqlite3_column_int(statement, 5);
                step.img = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 6)];
                [resultArray addObject:step];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    if (step) {
        [resultArray insertObject:step atIndex:0];
    }
    return resultArray;
    
}
- (OrigamiHelp*)getHelpWithId:(NSInteger)iDHelp{
    [self copyDatabase];
    OrigamiHelp *result = [[OrigamiHelp alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from 'origami_help' where id_help = \"%ld\"", (long)iDHelp];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                result.iDHelp = sqlite3_column_int(statement, 0);
                result.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                result.images = [[NSArray alloc] initWithArray:[[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)] componentsSeparatedByString:@","]];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return result;

}
@end
