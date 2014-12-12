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
- (BOOL)didDownloadedLesson:(LessonObject*)lesson{
    [self copyDatabase];
    BOOL result = NO;
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"UPDATE LESSON SET DOWNLOADED = \"1\" WHERE ID_APP = '%@' AND ID_LESSON = '%@'",lesson.appID, lesson.iD];
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
                group.schemes = [self getArrSchemesWithGroupID:group.groupID];
                [resultArray addObject:group];
            }
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(_contactDB);
    }
    return resultArray;
}

- (NSMutableArray*)getArrSchemesWithGroupID:(NSInteger)groupID{
    [self copyDatabase];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    OrigamiScheme *scheme;
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from origami_scheme where iDGroup = \"%d\"", groupID];
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
        NSString *querySQL = [NSString stringWithFormat:@"select * from origami_step where schemeID = \"%@\"", iDScheme];
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
    return resultArray;
    
}
@end
