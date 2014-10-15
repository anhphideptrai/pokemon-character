//
//  SplashScreenViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 10/15/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "ConfigApp.h"
#import "ConfigManager.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface SplashScreenViewController (){
    UIImageView *bgView;
    UIActivityIndicatorView *loadingView;
}

@end

@implementation SplashScreenViewController

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self initSubView];
    [[ConfigManager getInstance] loadConfig:@"https://character-app.googlecode.com/git/get_config_character_app.json" finished:^(BOOL success, ConfigApp *configApp) {
        [loadingView stopAnimating];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if (success) {
            appDelegate.config = configApp;
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.config.statusApp forKey:CONFIG_SETTING_TAG];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            appDelegate.config = [[ConfigApp alloc] init];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:CONFIG_SETTING_TAG]) {
                appDelegate.config.statusApp = [[NSUserDefaults standardUserDefaults] objectForKey:CONFIG_SETTING_TAG];
            }else{
                appDelegate.config.statusApp = STATUS_APP_DEFAUL;
            }
        }
        ViewController *mainViewController = [[ViewController alloc] initWithNibName:NAME_XIB_FILE_MAIN_VIEW_CONTROLLER bundle:nil];
        appDelegate.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        appDelegate.window.rootViewController = appDelegate.navigationController;
        [appDelegate.window makeKeyAndVisible];
    }];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)initSubView{
    bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect tmpRect = self.view.frame;
    tmpRect.origin.x = tmpRect.size.width/2 - 20;
    tmpRect.origin.y = tmpRect.size.height/2 - 20;
    tmpRect.size.width = 40;
    tmpRect.size.height = 40;
    [loadingView setFrame:tmpRect];
    [self.view addSubview:bgView];
    [self.view addSubview:loadingView];
    [bgView setImage:[UIImage imageNamed:@"Default.png"]];
    [loadingView startAnimating];
}
@end
