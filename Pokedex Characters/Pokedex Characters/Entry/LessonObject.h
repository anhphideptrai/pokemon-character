//
//  LessonObject.h
//  JSONAndXMLDemo
//
//  Created by Phi Nguyen on 11/30/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonObject : NSObject
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger steps;
@property (nonatomic) NSInteger rate;
@property (nonatomic, strong) NSString* urlIcon;
@property (nonatomic) BOOL downloaded;
@end
