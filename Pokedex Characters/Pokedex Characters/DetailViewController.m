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
#import <Social/Social.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "GADInterstitial.h"

@interface DetailViewController ()<CustomNavigationBarDelegate, DetailViewDelegate, GADInterstitialDelegate>{
    CustomNavigationBar *customNavigation;
    Pokemon *currentPokemon;
    DetailView *detailPoster;
    AppDelegate *appDelegate;
}
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation DetailViewController
-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION_BAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVIGATION_BAR)];
    [bgImage setImage:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.view addSubview:bgImage];
    customNavigation = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_NAVIGATION_BAR)];
    [customNavigation setDelegate:self];
    [self.view addSubview:customNavigation];
    detailPoster = [[DetailView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVIGATION_BAR, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_NAVIGATION_BAR)];
    [detailPoster setDelegate:self];
    [self.view addSubview:detailPoster];
    [self reLoadData];
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtnBack:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer: swipeGestureRight];
    //Add Admob
    if (![appDelegate.config.statusApp isEqualToString:STATUS_APP_DEFAUL]) {
        self.interstitial = [self createAndLoadInterstitial];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)clickBtnBack:(CustomNavigationBar *)customNavigationBar{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickBtnShare:(CustomNavigationBar *)customNavigationBar{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:[NSString stringWithFormat:@"%@\n%@%@\n\n",currentPokemon.name, [Utils getStringOf:ORDER_ID_NAME_STRING withLanguage:appDelegate.languageDefault], currentPokemon.iD]];
    [controller addURL:[NSURL URLWithString:appDelegate.config.urlShare]];
    [controller addImage:detailPoster.getImageDetail];
    [self presentViewController:controller animated:YES completion:Nil];
}
- (void)setPokemonForDetail:(Pokemon*)pokemon{
    currentPokemon = pokemon;
}
- (void)reLoadData{
    [detailPoster setData:currentPokemon];
}
- (void)didChangeCurrentPokemon:(DetailView*)detailView withNewPokemon:(Pokemon*)pokemonNew{
    if (pokemonNew) {
        currentPokemon = pokemonNew;
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    interstitial.adUnitID = INTERSTITIAL_ID_ADMOB;
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    // Requests test ads on simulators.
    // request.testDevices = @[ GAD_SIMULATOR_ID, [Utils admobDeviceID] ];
    [interstitial loadRequest:request];
    return interstitial;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if (![appDelegate.config.statusApp isEqualToString:STATUS_APP_DEFAUL]) {
        [self.interstitial presentFromRootViewController:self];
    }
}
@end
