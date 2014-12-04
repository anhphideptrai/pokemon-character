//
//  SQLiteManager.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SQLiteManager.h"
#import "PokemonType.h"

#define DB_NAME_STRING @"HowToDraw.sqlite"
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
- (NSMutableArray*)getHowToDrawAllApps{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *arrIDApps = [self getAllIDApps];
    for (AppObject *app in arrIDApps) {
        [app setLessons:[self getAllLessonOfAppWithIDApp:app.iD]];
        [resultArray addObject:app];
    }
    return resultArray;
}
- (NSMutableArray*)getArrHowToDrawAppsWithSearchKey:(NSString*)searchKey{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSArray *arrApps = [self getAllIDApps];
    for (AppObject *app in arrApps) {
        [app setLessons:[self getArrLessonWithIDApp:app.iD andSearchKey:searchKey]];
        if (app.lessons.count > 0) {
            [resultArray addObject:app];
        }
    }
    return resultArray;
}
- (NSMutableArray*)getArrLessonWithIDApp:(NSString*)iDApp andSearchKey:(NSString*)searchKey{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    LessonObject *lesson;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from LESSON WHERE ID_APP = \"%@\" AND NAME LIKE \'%%%@%%\' group by NAME", iDApp, searchKey];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                lesson = [[LessonObject alloc] init];
                lesson.appID = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)];
                lesson.iD = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                lesson.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                lesson.steps = sqlite3_column_int(statement, 3);
                lesson.rate = sqlite3_column_int(statement, 4);
                lesson.urlIcon = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 5)];
                lesson.downloaded = sqlite3_column_int(statement, 6);
                [resultArray addObject:lesson];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;
}
- (NSMutableArray*)getAllLessonOfAppWithIDApp:(NSString*)iDApp{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from LESSON where ID_APP = \"%@\" order by ID_APP", iDApp];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                LessonObject *lesson = [[LessonObject alloc] init];
                [lesson setAppID:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)]];
                [lesson setID:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)]];
                [lesson setName:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)]];
                [lesson setSteps:sqlite3_column_int(statement, 3)];
                [lesson setRate:sqlite3_column_int(statement, 4)];
                [lesson setUrlIcon:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 5)]];
                [lesson setDownloaded:sqlite3_column_int(statement, 6)];
                [resultArray addObject:lesson];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;

}
- (NSMutableArray*)getAllIDApps{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from APP order by NAME"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                AppObject *app = [[AppObject alloc] init];
                [app setID:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)]];
                [app setName:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)]];
                [resultArray addObject:app];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;

}
@end
