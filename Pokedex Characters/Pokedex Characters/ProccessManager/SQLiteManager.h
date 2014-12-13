//
//  SQLiteManager.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "OrigamiGroup.h"

@interface SQLiteManager : NSObject
+ (SQLiteManager *) getInstance;
- (BOOL)didDownloadedScheme:(OrigamiScheme*)scheme;
- (NSMutableArray*)getArrGroupsWithSearchKey:(NSString*)searchKey;
- (NSMutableArray*)getArrGroups;
- (OrigamiHelp*)getHelpWithId:(NSInteger)iDHelp;
@end
