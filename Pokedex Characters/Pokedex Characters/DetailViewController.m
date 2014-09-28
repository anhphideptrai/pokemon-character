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
    Pokemon *currentPokemon;
    DetailView *detailPoster;
}

@end

@implementation DetailViewController
-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION_BAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVIGATION_BAR)];
    [bgImage setImage:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.view addSubview:bgImage];
    customNavigation = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_NAVIGATION_BAR)];
    [customNavigation setDelegate:self];
    [self.view addSubview:customNavigation];
    detailPoster = [[DetailView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION_BAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVIGATION_BAR)];
    [self.view addSubview:detailPoster];
    [self reLoadData];
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)clickBtnBack:(CustomNavigationBar *)customNavigationBar{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setPokemonForDetail:(Pokemon*)pokemon{
    currentPokemon = pokemon;
}
- (void)reLoadData{
    [detailPoster setData:currentPokemon];
}
@end
