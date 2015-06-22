//
//  ConfigManager.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/14/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "ConfigApp.h"
#import "MoreApp.h"

@interface ConfigManager : AFHTTPRequestOperationManager
+ (ConfigManager *) getInstance;
- (void)loadConfig:(NSString *)url
          finished:(void (^)(BOOL success, ConfigApp *configApp))finished;
- (void)loadMoreApp:(NSString *)url
           finished:(void (^)(BOOL success, NSArray *moreApps))finished;
@end
