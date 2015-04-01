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
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface DetailViewController ()<CustomNavigationBarDelegate, DetailViewDelegate>{
    CustomNavigationBar *customNavigation;
    Pokemon *currentPokemon;
    DetailView *detailPoster;
    AppDelegate *appDelegate;
    NSInteger currentIndex;
    NSArray *pokemons;
}
@property (strong, nonatomic) GADBannerView *bannerView;
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
        self.bannerView = [[GADBannerView alloc] initWithAdSize:IS_IPAD?kGADAdSizeLeaderboard:kGADAdSizeBanner origin:CGPointMake(IS_IPAD?(self.view.frame.size.width - 728)/2:0, self.view.frame.size.height - (IS_IPAD?90:50))];
        self.bannerView.adUnitID = BANNER_DETAIL_ADMOB;
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID",
                               @"1485d1faa4c1010a54b384ca9e9944b7", @"f2b1a55b050ac3483e1c17a21a2073f5",
                               nil];
        [self.bannerView loadRequest:request];
        [self.view addSubview:self.bannerView];
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
- (void)setPokemonForDetail:(NSArray*)_pokemons withCurrentIndex:(NSInteger)index{
    if (_pokemons && _pokemons.count > index) {
        currentIndex = index;
        pokemons = _pokemons;
    }
}
- (void)reLoadData{
    if (pokemons && pokemons.count && pokemons.count > currentIndex) {
        currentPokemon = pokemons[currentIndex];
        [detailPoster setData:currentPokemon];
    }
}
- (void)didChangeCurrentPokemon:(DetailView*)detailView withNewPokemon:(Pokemon*)pokemonNew{
    if (pokemonNew) {
        currentPokemon = pokemonNew;
    }
}
- (void)shouldMoveCharacter:(DetailView*)detailView withDirection:(MoveDirection)direction{
    switch (direction) {
        case LEFT_MOVE:
            --currentIndex;
            break;
         case RIGHT_MOVE:
            ++currentIndex;
            break;
    }
    currentPokemon = pokemons[currentIndex];
    [self reLoadData];
}
-(BOOL)enableMoveLeftOfDetailView{
    return currentIndex != 0;
}
-(BOOL)enableMoveRightOfDetailView{
    return currentIndex < pokemons.count - 1;
}
@end
