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
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "DownloadManager.h"
#import "MoreAppsViewController.h"

@interface ViewController () <PromoSlidesViewDataSource, PromoSlidesViewDelegate, DownloadManagerDelegate>
{
    NSMutableArray *result;
    AppDelegate *appDelegate;
    DownloadManager *downloadManager;
    OrigamiScheme *schemeSelected;
    BOOL isDownloading;
}
@property (strong, nonatomic) IBOutlet UIImageView *bgNavigationBar;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
- (IBAction)clickSearch:(id)sender;
- (IBAction)actionMoreApps:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.contentGuideView setBackgroundColor:BACKGROUND_COLOR_CONTENT_GUIDE_VIEW];
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
    request.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID",
                           @"1485d1faa4c1010a54b384ca9e9944b7", @"f2b1a55b050ac3483e1c17a21a2073f5",
                           nil];
    [self.bannerView loadRequest:request];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    result = [[SQLiteManager getInstance] getArrGroups];
    [self.contentGuideView holdPositionReloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUInteger r = arc4random_uniform(15) + 1;
    if (r == 3) {
        if (!([[NSUserDefaults standardUserDefaults] objectForKey:SHOW_RATING_VIEW_TAG])) {
            [self actionLike];
        }
    }
}
- (void)actionLike{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_msg_rating_ message:nil delegate:self cancelButtonTitle:_msg_dismiss_ otherButtonTitles:_msg_rate_it_5_starts_, nil];
    [alert show];
}
-(void)delayEnableView{
    [self.view setUserInteractionEnabled:YES];
}
#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return ((OrigamiGroup*)result[rowIndex]).schemes.count;
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
    OrigamiGroup *group = (OrigamiGroup*)result[rowIndex];
    [header  setTextTitleRowHeader:[group.groupName uppercaseString]];
    [header setBackground:[UIImage imageNamed:@"headercell_bg.jpg"]];
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
    OrigamiScheme *scheme = ((OrigamiGroup*)result[rowIndex]).schemes[index];
    [posterView setURLImagePoster: [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"icon-%@", scheme.ident] withExtension:@"jpg"] placeholderImage:nil];
    [posterView setBlurredImagePoster:scheme.isDownloaded?1.f:0.4f];
    [posterView setTextTitlePoster:scheme.name];
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
    [self.view setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(delayEnableView) userInfo:nil repeats:NO];
    schemeSelected = ((OrigamiGroup*)result[rowIndex]).schemes[index];
    schemeSelected.steps = [[SQLiteManager getInstance] getArrStepWithIDScheme:schemeSelected.rowid];
    if (schemeSelected.steps.count > 0) {
        if (schemeSelected.isDownloaded) {
            [self navigationToDetailView];
        }else{
            if (!isDownloading) {
                isDownloading = YES;
                [self.squaresLoading setColor:_red_color_];
                [self.lbDownloading setText:@"Downloading... [0%]"];
                [self.loadingView setHidden:!isDownloading];
                NSMutableArray *files = [[NSMutableArray alloc] init];
                for (OrigamiStep *step in schemeSelected.steps) {
                    DownloadEntry *entry = [[DownloadEntry alloc] init];
                    entry.strUrl = step.img;
                    entry.dir = step.schemeID;
                    entry.fileName = _IMAGE_NAME_STEP_(step.sort_order);
                    entry.size = step.size;
                    [files addObject:entry];
                }
                [downloadManager dowloadFilesWith:files];
            }
        }
    }
}

#pragma mark - PromoSlidesViewDataSource methods
- (NSUInteger) numberOfItemsInPromoSlides:(PromoSlidesView*) promoSlides{
    return 7;
}
- (NSURL*) promoSlidesView:(PromoSlidesView*) promoSlides
    urlImageForItemAtIndex:(NSInteger) indexItem{
    return [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"promo_%d",(int)indexItem + 1] withExtension:@"jpg"];
}
- (IBAction)clickSearch:(id)sender {
    SearchViewController *searchViewCotroller = [[SearchViewController alloc] initWithNibName:NAME_XIB_FILE_SEARCH_VIEW_CONTROLLER bundle:nil];
    [self.navigationController pushViewController:searchViewCotroller animated:YES ];
}
- (IBAction)actionMoreApps:(id)sender {
    MoreAppsViewController *moreAppsVC = [[MoreAppsViewController alloc] initWithNibName:NAME_XIB_FILE_MORE_APPS_VIEW_CONTROLLER bundle:nil];
    [self presentViewController:moreAppsVC animated:YES completion:^{}];
}
- (void)navigationToDetailView{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:NAME_XIB_FILE_DETAIL_VIEW_CONTROLLER bundle:nil];
    [detailViewController setScheme:schemeSelected];
    [self.navigationController pushViewController:detailViewController animated:YES];
    isDownloading = NO;
}
#pragma mark - DownloadManagerDelegate methods
-(void)didFinishedDownloadFilesWith:(NSArray *)filePaths withError:(NSError *)error{
    isDownloading = NO;
    [self.loadingView setHidden:!isDownloading];
    if (!error) {
        [[SQLiteManager getInstance] didDownloadedScheme:schemeSelected];
        schemeSelected.isDownloaded = YES;
        [self navigationToDetailView];
    }else{
        [Utils showAlertWithError:error];
    }
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
#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[NSUserDefaults standardUserDefaults] setValue:@(true) forKey:SHOW_RATING_VIEW_TAG];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDelegate.config.urlShare]];
    }
}
@end
