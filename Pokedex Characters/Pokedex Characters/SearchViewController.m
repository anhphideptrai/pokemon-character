//
//  SearchViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/8/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SearchViewController.h"
#import "SQLiteManager.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "DownloadManager.h"

@interface SearchViewController () <DownloadManagerDelegate>{
    NSMutableArray *result;
    NSTimer *timerSearch;
    AppDelegate *appDelegate;
    DownloadManager *downloadManager;
    OrigamiScheme *schemeSelected;
    BOOL isDownloading;
    NSString *keySearch;
}
@property (strong, nonatomic) IBOutlet UILabel *title_Search;
@property (strong, nonatomic) IBOutlet UIImageView *bgNavigationBar;
- (IBAction)clickBack:(id)sender;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    keySearch = @"";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.title_Search setText:search_string_en];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self.contentGuideView setBackgroundColor:BACKGROUND_COLOR_CONTENT_GUIDE_VIEW];
    [self.contentGuideView reloadData];
    downloadManager = [[DownloadManager alloc] init];
    [downloadManager setDelegate:self];
    isDownloading = NO;
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3f]];
    [self.loadingView setHidden:!isDownloading];
    //Add Admob
    if (![appDelegate.config.statusApp isEqualToString:STATUS_APP_DEFAUL]) {
        self.bannerView.adUnitID = BANNER_ID_ADMOB_SEARCH_PAGE;
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        [self.bannerView loadRequest:request];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[keySearch stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [result removeAllObjects];
    }else{
        result = [[SQLiteManager getInstance] getArrGroupsWithSearchKey:keySearch];
        
    }
    [self.contentGuideView holdPositionReloadData];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:NO];
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
    [posterView setBlurredImagePoster:scheme.isDownloaded?1.f:0.3f];
    [posterView setTextTitlePoster:scheme.name];
    return posterView;
    
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

- (void)         contentGuide:(ContentGuideView*) contentGuide
didSelectPosterViewAtRowIndex:(NSUInteger) rowIndex
                  posterIndex:(NSUInteger) index{
    schemeSelected = ((OrigamiGroup*)result[rowIndex]).schemes[index];
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
- (void)navigationToDetailView{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:NAME_XIB_FILE_DETAIL_VIEW_CONTROLLER bundle:nil];
    [detailViewController setScheme:schemeSelected];
    [self.navigationController pushViewController:detailViewController animated:YES];
    isDownloading = NO;
}
- (IBAction)clickBack:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UISearchBarDelegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (timerSearch) {
        [timerSearch invalidate];
        timerSearch = nil;
    }
    timerSearch = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(searching) userInfo:searchText repeats:NO];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   [self.view endEditing:YES];
}
- (void)searching{
    if ([timerSearch userInfo]) {
     keySearch =  [timerSearch userInfo];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ([[keySearch stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [result removeAllObjects];
        }else{
            result = [[SQLiteManager getInstance] getArrGroupsWithSearchKey:keySearch];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentGuideView reloadData];
        });
    });
}
#pragma mark - DownloadManagerDelegate methods
- (void)didFinishedDownloadFilesWith:(NSArray *)filePaths{
    [[SQLiteManager getInstance] didDownloadedScheme:schemeSelected];
    schemeSelected.isDownloaded = YES;
    [self navigationToDetailView];
    isDownloading = NO;
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
