//
//  Utils.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/11/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (NSURL*)getURLImageWith:(NSString*)schemeID andWithStep:(NSInteger)step;
+ (NSString *)documentsPathForFileName:(NSString *)name;
//+ (NSString *) admobDeviceID;
@end
