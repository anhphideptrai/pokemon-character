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

@interface ViewController () <PromoSlidesViewDataSource, PromoSlidesViewDelegate>
{
    NSMutableArray *result;
}
@property (nonatomic) ASOAnimationStyle progressiveORConcurrentStyle;
- (IBAction)clickSearch:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    result = [[SQLiteManager getInstance] getPokemonWithAllTypes];
    [self.contentGuideView setBackground:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.contentGuideView reloadData];
    [self.menuButton setOnStateImageName:@"bottomnav_settings_normal.png"];
    [self.menuButton setOffStateImageName:@"bottomnav_settings_normal.png"];
    [self.menuButton initAnimationWithFadeEffectEnabled:YES];
    self.menuItemView = [[[NSBundle mainBundle] loadNibNamed:@"AnimationMenuCustom" owner:self options:nil] lastObject];
    
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects:self.menuItemView.menuItem1,
                                   self.menuItemView.menuItem2,
                                   self.menuItemView.menuItem3,
                                   self.menuItemView.menuItem4,
                                   nil]; // Add all of the defined 'menu item button' to 'menu item view'
    [self.menuItemView addBounceButtons:arrMenuItemButtons];
    
    // Set the bouncing distance, speed and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.3f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    
    [self.menuItemView setAnimationStyle:ASOAnimationStyleRiseProgressively];
    self.progressiveORConcurrentStyle = ASOAnimationStyleRiseProgressively;
    
    // Set as delegate of 'menu item view'
    [self.menuItemView setDelegate:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    // Tell 'menu button' position to 'menu item view'
    [self.menuItemView setAnimationStartFromHere:self.menuButton.frame];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return ((PokemonType*)[result objectAtIndex:rowIndex]).pokemons.count;
}
- (NSUInteger) numberOfRowsInContentGuide:(ContentGuideView*) contentGuide{
    return result.count;
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
    static NSString *identifier = @"ContentGuideViewRowHeaderStyleDefault";
    ContentGuideViewRowHeader *header = [contentGuide dequeueReusableRowHeaderWithIdentifier:identifier];
    if (!header) {
        header = [[ContentGuideViewRowHeader alloc] initWithStyle:ContentGuideViewRowHeaderStyleDefault reuseIdentifier:identifier];
    }
    NSString *type = ((PokemonType*)[result objectAtIndex:rowIndex]).type;
    [header  setTextTitleRowHeader:[type uppercaseString]];
    [header setBackground:[UIImage imageNamed:@"headercell_bg.png"]];
    [header setIconLeft:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", type]]];
    return header;
}

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideView*) contentGuide
                                     posterViewForRowIndex:(NSUInteger)rowIndex
                                          posterViewIndex:(NSUInteger)index{
    static NSString *identifier = @"ContentGuideViewRowCarouselViewPosterViewStyleDefault";
    ContentGuideViewRowCarouselViewPosterView *posterView = [contentGuide dequeueReusablePosterViewWithIdentifier:identifier];
    if (!posterView) {
        posterView = [[ContentGuideViewRowCarouselViewPosterView alloc] initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleDefault reuseIdentifier:identifier];
    }
    Pokemon *pokemon = [((PokemonType*)[result objectAtIndex:rowIndex]).pokemons objectAtIndex:index];
    [posterView setImagePoster:[UIImage imageNamed:[NSString stringWithFormat:@"character_%@.jpg", pokemon.iD]]];
    [posterView setTextTitlePoster:pokemon.name];
    return posterView;
    
}
- (UIView*) topCustomViewForContentGuideView:(ContentGuideView*) contentGuide{
    PromoSlidesView* promoSlidesView = [[PromoSlidesView alloc] initWithFrame:FRAME_PROMO_SLIDES];
    [promoSlidesView setDataSource:self];
    [promoSlidesView setDelegate:self];
    [promoSlidesView reloadData];
    return promoSlidesView;
}

#pragma mark - ContentGuideViewDelegate methods
- (CGFloat)heightForContentGuideViewRow:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return HEIGHT_CONTENT_GUIDE_VIEW_ROW;
}

- (CGFloat)heightForContentGuideViewRowHeader:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return HEIGHT_CONTENT_GUIDE_VIEW_ROW_HEADER;
}

- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return WIDTH_POSTER_VIEW;
}
- (CGFloat)spaceBetweenCarouselViewPosterViews:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex{
    return SPACE_BETWEEN_POSTER_VIEWS;
}

- (CGFloat)pandingTopAndBottomOfRowHeader:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex{
    return PANDING_TOP_AND_BOTTOM_OF_ROW_HEADER;
}

- (CGFloat)offsetYOfFirstRow:(ContentGuideView*) contentGuide{
    return OFFSET_Y_OF_FIRST_ROW;
}
- (void)         contentGuide:(ContentGuideView*) contentGuide
didSelectPosterViewAtRowIndex:(NSUInteger) rowIndex
                  posterIndex:(NSUInteger) index{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [detailViewController setPokemonForDetail:[((PokemonType*)[result objectAtIndex:rowIndex]).pokemons objectAtIndex:index]];
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
    [self.navigationController pushViewController:searchViewCotroller animated:YES ];
}
@end
