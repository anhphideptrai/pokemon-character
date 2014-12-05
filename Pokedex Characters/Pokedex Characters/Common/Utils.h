//
//  Utils.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/11/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (BOOL) removeFileWithPath:(NSString*)path;
+ (NSURL*)getURLImageWith:(NSString*)appID andWithLessonID:(NSString*)lessonID andWithStep:(int)step;
+ (NSString *)documentsPathForFileName:(NSString *)name;
+ (NSString*)formatLessonID:(NSString*)lessonID;
//+ (NSString *) admobDeviceID;
@end
