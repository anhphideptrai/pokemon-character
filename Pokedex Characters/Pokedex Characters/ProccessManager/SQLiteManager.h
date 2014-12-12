//
//  SQLiteManager.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppObject.h"
#import "LessonObject.h"
#import "OrigamiGroup.h"
#import "OrigamiScheme.h"
#import "OrigamiStep.h"

@interface SQLiteManager : NSObject
+ (SQLiteManager *) getInstance;
- (NSMutableArray*)getHowToDrawAllApps;
- (NSMutableArray*)getArrHowToDrawAppsWithSearchKey:(NSString*)searchKey;
- (BOOL)didDownloadedLesson:(LessonObject*)lesson;
- (NSMutableArray*)getArrGroups;
@end
