//
//  OrigamiGroup.h
//  HTMLParsing
//
//  Created by Phi Nguyen on 12/9/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrigamiGroup : NSObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic) NSInteger groupID;
@property (nonatomic, strong) NSMutableArray *schemes;
@end
