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
#import "Constant.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "AppObject.h"
#import "LessonObject.h"
#import "DetailViewController.h"

@interface ViewController () <PromoSlidesViewDataSource, PromoSlidesViewDelegate>
{
    NSMutableArray *result;
    AppDelegate *appDelegate;
}
- (IBAction)clickSearch:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    result = [[SQLiteManager getInstance] getHowToDrawAllApps];
    [self.contentGuideView setBackground:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.contentGuideView reloadData];
    // Add Admob
  //  if (![appDelegate.config.statusApp isEqualToString:STATUS_APP_DEFAUL]) {
        // Replace this ad unit ID with your own ad unit ID.
//        self.bannerView.adUnitID = BANNER_ID_ADMOB;
//        self.bannerView.rootViewController = self;
//        GADRequest *request = [GADRequest request];
//        // Requests test ads on devices you specify. Your test device ID is printed to the console when
//        // an ad request is made.
//        // request.testDevices = @[ GAD_SIMULATOR_ID, [Utils admobDeviceID] ];
//        [self.bannerView loadRequest:request];
   // }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return ((AppObject*)[result objectAtIndex:rowIndex]).lessons.count;
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
    AppObject *app = (AppObject*)[result objectAtIndex:rowIndex];
    [header  setTextTitleRowHeader:[app.name uppercaseString]];
    [header setBackground:[UIImage imageNamed:@"headercell_bg.png"]];
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
    LessonObject *lesson = [((AppObject*)[result objectAtIndex:rowIndex]).lessons objectAtIndex:index];
    [posterView setURLImagePoster:lesson.urlIcon placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
    [posterView setTextTitlePoster:lesson.name];
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
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:NAME_XIB_FILE_DETAIL_VIEW_CONTROLLER bundle:nil];
    LessonObject *lesson = [[LessonObject alloc] init];
    [lesson setID:@"11"];
    [lesson setAppID:@"133"];
    [lesson setSteps:14];
    [detailViewController setLesson:lesson];
    
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
