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
#import "DownloadManager.h"
#import "ZipManager.h"

@interface ViewController () <PromoSlidesViewDataSource, PromoSlidesViewDelegate, DownloadManagerDelegate>
{
    NSMutableArray *result;
    AppDelegate *appDelegate;
    DownloadManager *downloadManager;
    LessonObject *lessonSelected;
    BOOL isDownloading;
}
- (IBAction)clickSearch:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.contentGuideView setBackground:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.contentGuideView reloadData];
    downloadManager = [[DownloadManager alloc] init];
    [downloadManager setDelegate:self];
    isDownloading = NO;
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5f]];
    [self.loadingView setHidden:!isDownloading];
    
    // Add Admob
    self.bannerView.adUnitID = BANNER_ID_ADMOB_HOME_PAGE;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    result = [[SQLiteManager getInstance] getHowToDrawAllApps];
    [self.contentGuideView holdPositionReloadData];
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
    if (lesson.downloaded) {
        [posterView setURLImagePoster:[NSURL fileURLWithPath:[Utils documentsPathForFileName:[NSString stringWithFormat:@"%@-%@/icon.png",lesson.appID, lesson.iD]]] placeholderImage:nil];
    }else{
        [posterView setBlurredImagePoster:0.3f];
        [posterView setURLImagePoster:[NSURL URLWithString:lesson.urlIcon] placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
    }
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
    lessonSelected = [((AppObject*)[result objectAtIndex:rowIndex]).lessons objectAtIndex:index];
    if (lessonSelected.downloaded) {
        [self navigationToDetailView];
    }else{
        if (!isDownloading) {
            isDownloading = YES;
            [self.squaresLoading setColor:_red_color_];
            [self.lbDownloading setText:@"Downloading... [0%]"];
            [self.loadingView setHidden:!isDownloading];
            [downloadManager downloadFileWithUrl:[NSString stringWithFormat:@"%@app%@/lesson%@.zip", appDelegate.config.urlServer, lessonSelected.appID, [Utils formatLessonID:lessonSelected.iD]]];
        }
    }
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
- (void)navigationToDetailView{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:NAME_XIB_FILE_DETAIL_VIEW_CONTROLLER bundle:nil];
    [detailViewController setLesson:lessonSelected];
    [self.navigationController pushViewController:detailViewController animated:YES];
    isDownloading = NO;
}
#pragma mark - DownloadManagerDelegate methods
- (void)didFinishedDownloadFileWith:(NSURL*)filePath{
    if (filePath) {
        NSString *pathNew = [Utils documentsPathForFileName:[NSString stringWithFormat:@"%@-%@", lessonSelected.appID, lessonSelected.iD]];
        if ([ZipManager unzipFile:filePath.path withDecPath:pathNew]) {
            [Utils removeFileWithPath:filePath.path];
            [[SQLiteManager getInstance] didDownloadedLesson:lessonSelected];
            lessonSelected.downloaded = YES;
            [self navigationToDetailView];
        }else{
            isDownloading = NO;
        }
    }else{
        isDownloading = NO;
    }
    [self.loadingView setHidden:!isDownloading];
}
- (void)completePercent:(NSInteger)percent{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lbDownloading setText:[NSString stringWithFormat:@"Downloading... [%ld%%]", (long)percent]];
        switch (percent/20) {
            case 0:
                [self.squaresLoading setColor:_red_color_];
                break;
            case 1:
                [self.squaresLoading setColor:_green_color_];
                break;
            case 2:
                [self.squaresLoading setColor:_blue_color_];
                break;
            case 3:
                [self.squaresLoading setColor:_orange_color_];
                break;
            case 4:
                [self.squaresLoading setColor:_grayButton_color_];
                break;
            default:
                break;
        }
    });
}
@end
