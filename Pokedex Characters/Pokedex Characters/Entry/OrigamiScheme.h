//
//  OrigamiScheme.h
//  HTMLParsing
//
//  Created by Phi Nguyen on 12/8/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrigamiStep.h"
@interface OrigamiScheme : NSObject
@property (nonatomic, strong) NSString *rowid;
@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, strong) NSString *changed;
@property (nonatomic) NSUInteger steps_count;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic) NSUInteger iDGroup;
@property (nonatomic) BOOL isDownloaded;
@property (nonatomic, strong) NSMutableArray *steps;
@end
