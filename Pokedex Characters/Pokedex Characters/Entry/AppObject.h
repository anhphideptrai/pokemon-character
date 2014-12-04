//
//  AppObject.h
//  JSONAndXMLDemo
//
//  Created by Phi Nguyen on 11/30/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppObject : NSObject
@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *lessons;
@end
