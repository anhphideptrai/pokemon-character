//
//  ZipManager.m
//  HTMLParsing
//
//  Created by Phi Nguyen on 11/26/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "ZipManager.h"

@implementation ZipManager
+ (BOOL)unzipFile:(NSString*)path withDecPath:(NSString*)decPath{
    BOOL result = NO;
    ZipArchive* za = [[ZipArchive alloc] init];
    
    if( [za UnzipOpenFile:path] ) {
        if( [za UnzipFileTo:decPath overWrite:YES] != NO ) {
            result = YES;
        }
        
        [za UnzipCloseFile];
    }
    return result;
}
@end
