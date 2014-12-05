//
//  AppDelegate.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigApp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, retain) UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ConfigApp *config;
@end
