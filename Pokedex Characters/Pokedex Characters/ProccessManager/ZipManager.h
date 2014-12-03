//
//  ZipManager.h
//  HTMLParsing
//
//  Created by Phi Nguyen on 11/26/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive/ZipArchive.h"
@interface ZipManager : NSObject
+ (BOOL)unzipFile:(NSString*)path withDecPath:(NSString*)decPath;
@end
