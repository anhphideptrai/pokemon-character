//
//  ViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "ViewController.h"
#import "SQLiteManager.h"
#import "PromoSlidesView.h"
#import "PokemonType.h"
#import "Pokemon.h"
#import "Constant.h"
#import "SearchViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "MoreAppsViewController.h"
#import <SVSegmentedControl.h>

@interface ViewController () <PromoSlidesViewDataSource, PromoSlidesViewDelegate, DetailViewControllerDelegate, SearchViewControllerDelegate>
{
    NSMutableArray *result;
    AppDelegate *appDelegate;
    SVSegmentedControl *redSC;
    BOOL shouldReload;
    NSUInteger currentSegmentIndex;
}
@property (nonatomic) ASOAnimationStyle progressiveORConcurrentStyle;
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)clickSearch:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    currentSegmentIndex = 0;
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    result = [[SQLiteManager getInstance] getPokemonWithAllTypes];
    [self.contentGuideView setBackground:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.contentGuideView reloadData];
    [self.menuButton setOnStateImageName:@"bottomnav_settings_normal.png"];
    [self.menuButton setOffStateImageName:@"bottomnav_settings_normal.png"];
    [self.menuButton initAnimationWithFadeEffectEnabled:YES];
    self.menuItemView = [[[NSBundle mainBundle] loadNibNamed:NAME_XIB_ANIMATION_MENU_VIEW_CONTROLLER owner:self options:nil] lastObject];
    [self.menuItemView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.7f]];
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects:self.menuItemView.menuItem1,
                                   self.menuItemView.menuItem2,
                                   self.menuItemView.menuItem3,
                                   self.menuItemView.menuItem4,
                                   nil]; // Add all of the defined 'menu item button' to 'menu item view'
    [self.menuItemView addBounceButtons:arrMenuItemButtons];
    
    // Set the bouncing distance, speed and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.2f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    
    [self.menuItemView setAnimationStyle:ASOAnimationStyleRiseProgressively];
    self.progressiveORConcurrentStyle = ASOAnimationStyleRiseProgressively;
    
    // Set as delegate of 'menu item view'
    [self.menuItemView setDelegate:self];
    
    [self setupSegment];
    
    // Add Admob
    self.bannerView.adUnitID = BANNER_ID_ADMOB;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID",
                           @"1485d1faa4c1010a54b384ca9e9944b7", @"f2b1a55b050ac3483e1c17a21a2073f5",
                           nil];
    [self.bannerView loadRequest:request];
}
- (void)setupSegment{
    if (redSC) {
        [redSC removeFromSuperview];
        redSC = nil;
    }
    redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:[Utils getStringOf:ALL_STRING withLanguage:appDelegate.languageDefault], [Utils getStringOf:FAVORITE_STRING withLanguage:appDelegate.languageDefault], nil]];
    [redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    redSC.crossFadeLabelsOnDrag = YES;
    redSC.height = IS_IPAD?40.f:28.f;
    redSC.thumb.tintColor = _orange_color_;
    [redSC setSelectedSegmentIndex:currentSegmentIndex animated:NO];
    [self.naviView addSubview:redSC];
    [redSC setHidden:YES];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    // Tell 'menu button' position to 'menu item view'
    [self.menuItemView setAnimationStartFromHere:self.menuButton.frame];
    
    redSC.center = CGPointMake(self.naviView.frame.size.width/2, self.naviView.frame.size.height/2);
    [redSC setHidden:NO];
    
    NSUInteger r = arc4random_uniform(10) + 1;
    if (r == 8) {
        MoreAppsViewController *moreAppVC = [[MoreAppsViewController alloc] initWithNibName:NAME_XIB_FILE_MORE_APPS_VIEW_CONTROLLER bundle:nil];
        [self.navigationController presentViewController:moreAppVC animated:YES completion:^{}];
    }
    if(shouldReload && currentSegmentIndex != 0){
        [self loadDataFromDataBase];
        [self.contentGuideView holdPositionReloadData];
    }
    shouldReload = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIControlEventValueChanged
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
    currentSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self loadDataFromDataBase];
    [self.contentGuideView reloadData];
}
- (void)loadDataFromDataBase{
    result = (currentSegmentIndex == 0)?
    [[SQLiteManager getInstance] getPokemonWithAllTypes]:
    [[SQLiteManager getInstance] getPokemonFavoriteWithAllTypes];
}
- (IBAction)menuButtonAction:(id)sender
{
    if ([sender isOn]) {
        // Show 'menu item view' and expand its 'menu item button'
        [self.menuButton addCustomView:self.menuItemView];
        [self.menuItemView expandWithAnimationStyle:self.progressiveORConcurrentStyle];
    }
    else {
        // Collapse all 'menu item button' and remove 'menu item view'
        [self.menuItemView collapseWithAnimationStyle:self.progressiveORConcurrentStyle];
        [self.menuButton removeCustomView:self.menuItemView interval:[self.menuItemView.collapsedViewDuration doubleValue]];
    }
}
- (void)didSelectBounceButtonAtIndex:(NSUInteger)index
{
    [self.menuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    if (index < LanguageSettingEN || index > LanguageSettingIT || index == appDelegate.languageDefault) return;
    [[NSUserDefaults standardUserDefaults] setValue:@(index) forKey:LANGUAGE_SETTING_TAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    appDelegate.languageDefault = (LanguageSetting)index;
    result = (currentSegmentIndex == 0)?[[SQLiteManager getInstance] getPokemonWithAllTypes]:[[SQLiteManager getInstance] getPokemonFavoriteWithAllTypes];
    [self.contentGuideView holdPositionReloadData];
    [self setupSegment];
    redSC.center = CGPointMake(self.naviView.frame.size.width/2, self.naviView.frame.size.height/2);
    [redSC setHidden:NO];
}

- (IBAction)sendActionForMenuButton:(id)sender{
    [self.menuButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    if (currentSegmentIndex != 0) {
        NSUInteger _numberOfRows = (((PokemonType*)[result firstObject]).pokemons.count - 1)/NUMBER_POSTERS_IN_A_ROW + 1;
        NSUInteger _numberOfItems = ((PokemonType*)[result firstObject]).pokemons.count;
        if ((rowIndex == _numberOfRows -1) && _numberOfItems % NUMBER_POSTERS_IN_A_ROW > 0) {
            return _numberOfItems % NUMBER_POSTERS_IN_A_ROW;
        }
        return NUMBER_POSTERS_IN_A_ROW;
    }else{
        return ((PokemonType*)[result objectAtIndex:rowIndex]).pokemons.count;
    }
}
- (NSUInteger) numberOfRowsInContentGuide:(ContentGuideView*) contentGuide{
    if (currentSegmentIndex != 0) {
        NSUInteger numberPokemons = ((PokemonType*)[result firstObject]).pokemons.count;
        return numberPokemons == 0 ? 0 : (numberPokemons - 1)/NUMBER_POSTERS_IN_A_ROW + 1;
    }else{
        return result.count;
    }
}
- (ContentGuideViewRow*) contentGuide:(ContentGuideView*) contentGuide
                       rowForRowIndex:(NSUInteger)rowIndex{
    static NSString *identifier = @"ContentGuideViewRowStyleDefault";
    ContentGuideViewRow *row = [contentGuide dequeueReusableRowWithIdentifier:identifier];
    if (!row) {
        row = [[ContentGuideViewRow alloc] initWithStyle:ContentGuideViewRowStyleDefault reuseIdentifier:identifier];
    }
    return row;
}

- (ContentGuideViewRowHeader*) contentGuide:(ContentGuideView*) contentGuide
                       rowHeaderForRowIndex:(NSUInteger)rowIndex{
    if (currentSegmentIndex != 0) {
        return nil;
    }else{
        static NSString *identifier = @"ContentGuideViewRowHeaderStyleDefault";
        ContentGuideViewRowHeader *header = [contentGuide dequeueReusableRowHeaderWithIdentifier:identifier];
        if (!header) {
            header = [[ContentGuideViewRowHeader alloc] initWithStyle:ContentGuideViewRowHeaderStyleDefault reuseIdentifier:identifier];
        }
        NSString *type = ((PokemonType*)[result objectAtIndex:rowIndex]).type;
        [header  setTextTitleRowHeader:[[Utils getStringType:type withLanguage:appDelegate.languageDefault] uppercaseString]];
        [header setBackground:[UIImage imageNamed:@"headercell_bg.png"]];
        [header setIconLeft:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[Utils getStringType:type withLanguage:LanguageSettingEN] lowercaseString]]]];
        return header;
    }
}

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideView*) contentGuide
                                     posterViewForRowIndex:(NSUInteger)rowIndex
                                          posterViewIndex:(NSUInteger)index{
    static NSString *identifier = @"ContentGuideViewRowCarouselViewPosterViewStyleDefault";
    ContentGuideViewRowCarouselViewPosterView *posterView = [contentGuide dequeueReusablePosterViewWithIdentifier:identifier];
    if (!posterView) {
        posterView = [[ContentGuideViewRowCarouselViewPosterView alloc] initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleDefault reuseIdentifier:identifier];
    }
    Pokemon *pokemon;
    if (currentSegmentIndex == 0) {
        pokemon = [((PokemonType*)[result objectAtIndex:rowIndex]).pokemons objectAtIndex:index];
    }else{
        pokemon = [((PokemonType*)[result firstObject]).pokemons objectAtIndex:(rowIndex*NUMBER_POSTERS_IN_A_ROW + index)];
    }
    [posterView setURLImagePoster:pokemon.ThumbnailImage placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
    [posterView setTextTitlePoster:[NSString stringWithFormat:@"%@\n%@%@",pokemon.name, [Utils getStringOf:ORDER_ID_NAME_STRING withLanguage:appDelegate.languageDefault], pokemon.iD]];
    return posterView;
    
}
- (UIView*) topCustomViewForContentGuideView:(ContentGuideView*) contentGuide{
    if (currentSegmentIndex != 0) {
        return nil;
    }else{
        PromoSlidesView* promoSlidesView = [[PromoSlidesView alloc] initWithFrame:FRAME_PROMO_SLIDES];
        [promoSlidesView setDataSource:self];
        [promoSlidesView setDelegate:self];
        [promoSlidesView reloadData];
        return promoSlidesView;
    }
}

#pragma mark - ContentGuideViewDelegate methods
- (CGFloat)heightForContentGuideViewRow:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return currentSegmentIndex == 0 ? HEIGHT_CONTENT_GUIDE_VIEW_ROW : (contentGuide.frame.size.width/NUMBER_POSTERS_IN_A_ROW - SPACE_BETWEEN_POSTER_VIEWS + HEIGHT_TITLE_POSTER_DEFAULT);
}

- (CGFloat)heightForContentGuideViewRowHeader:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return currentSegmentIndex == 0 ? HEIGHT_CONTENT_GUIDE_VIEW_ROW_HEADER : 0;
}

- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return currentSegmentIndex == 0 ? WIDTH_POSTER_VIEW : (contentGuide.frame.size.width/NUMBER_POSTERS_IN_A_ROW - SPACE_BETWEEN_POSTER_VIEWS);
}
- (CGFloat)spaceBetweenCarouselViewPosterViews:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex{
    return SPACE_BETWEEN_POSTER_VIEWS;
}

- (CGFloat)pandingTopAndBottomOfRowHeader:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex{
    return PANDING_TOP_AND_BOTTOM_OF_ROW_HEADER;
}

- (CGFloat)offsetYOfFirstRow:(ContentGuideView*) contentGuide{
    return currentSegmentIndex != 0?0:OFFSET_Y_OF_FIRST_ROW;
}
- (void)         contentGuide:(ContentGuideView*) contentGuide
didSelectPosterViewAtRowIndex:(NSUInteger) rowIndex
                  posterIndex:(NSUInteger) index{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [detailViewController setPokemonForDetail:((PokemonType*)result[currentSegmentIndex == 0 ? rowIndex : 0]).pokemons withCurrentIndex:currentSegmentIndex == 0 ? index : (rowIndex*NUMBER_POSTERS_IN_A_ROW + index)];
    [detailViewController setDelegate:self];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
#pragma mark - PromoSlidesViewDataSource methods
- (NSUInteger) numberOfItemsInPromoSlides:(PromoSlidesView*) promoSlides{
    return 6;
}
- (UIImage*) promoSlidesView:(PromoSlidesView*) promoSlides
         imageForItemAtIndex:(NSInteger) indexItem{
    return [UIImage imageNamed:[NSString stringWithFormat:@"promo_%d.jpg",(int)indexItem + 1]];
    
}

- (IBAction)clickSearch:(id)sender {
    SearchViewController *searchViewCotroller = [[SearchViewController alloc] initWithNibName:NAME_XIB_FILE_SEARCH_VIEW_CONTROLLER bundle:nil];
    [searchViewCotroller setDelegate:self];
    [self.navigationController pushViewController:searchViewCotroller animated:YES ];
}
#pragma mark - DetailViewControllerDelegate methods
- (void)shouldReloadWhenBackFromDetailPage:(DetailViewController*)detailPage{
    shouldReload = YES;
}
#pragma mark - SearchViewControllerDelegate methods
- (void)shouldReloadParrentViewWhenBackFromSearchPage{
    shouldReload = YES;
}
@end
