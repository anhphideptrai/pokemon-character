//
//  DetailViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/22/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomNavigationBar.h"
#import "Constant.h"
#import "DetailView.h"

@interface DetailViewController ()<CustomNavigationBarDelegate>{
    CustomNavigationBar *customNavigation;
}

@end

@implementation DetailViewController
-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgImage setImage:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.view addSubview:bgImage];
    customNavigation = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_NAVIGATION_BAR)];
    [customNavigation setDelegate:self];
    [self.view addSubview:customNavigation];
    DetailView *detail = [[DetailView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 400)];
    [self.view addSubview:detail];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)clickBtnBack:(CustomNavigationBar *)customNavigationBar{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
