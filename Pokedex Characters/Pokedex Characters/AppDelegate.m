//
//  AppDelegate.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashScreenViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SplashScreenViewController *splashScreenViewController = [[SplashScreenViewController alloc] init];
    self.window.rootViewController = splashScreenViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
@end
