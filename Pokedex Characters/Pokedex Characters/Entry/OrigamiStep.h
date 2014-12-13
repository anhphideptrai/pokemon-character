//
//  OrigamiStep.h
//  HTMLParsing
//
//  Created by Phi Nguyen on 12/8/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrigamiHelp.h"
@interface OrigamiStep : NSObject
@property (nonatomic, strong) NSString *schemeID;
@property (nonatomic, strong) NSString *stepid;
@property (nonatomic) NSUInteger sort_order;
@property (nonatomic, strong) NSString *info;
@property (nonatomic) NSUInteger help;
@property (nonatomic) NSUInteger size;
@property (nonatomic, strong) NSString *img;

@end
