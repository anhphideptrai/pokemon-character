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
        result = [[SQLiteManager getInstance] getOrigamiSchemesWithSearchKey:keySearch];
        
    }
    [self.contentGuideView holdPositionReloadData];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:NO];
}
#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    NSUInteger _numberOfRows = (result.count - 1)/NUMBER_POSTERS_IN_A_ROW + 1;
    NSUInteger _numberOfItems = result.count;
    if ((rowIndex == _numberOfRows -1) && _numberOfItems % NUMBER_POSTERS_IN_A_ROW > 0) {
        return _numberOfItems % NUMBER_POSTERS_IN_A_ROW;
    }
    return NUMBER_POSTERS_IN_A_ROW;
}
- (NSUInteger) numberOfRowsInContentGuide:(ContentGuideView*) contentGuide{
    NSUInteger numberPokemons = result.count;
    return numberPokemons == 0 ? 0 : (numberPokemons - 1)/NUMBER_POSTERS_IN_A_ROW + 1;
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

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideView*) contentGuide
                                     posterViewForRowIndex:(NSUInteger)rowIndex
                                           posterViewIndex:(NSUInteger)index{
    static NSString *identifier = @"ContentGuideViewRowCarouselViewPosterViewStyleDefault";
    ContentGuideViewRowCarouselViewPosterView *posterView = [contentGuide dequeueReusablePosterViewWithIdentifier:identifier];
    if (!posterView) {
        posterView = [[ContentGuideViewRowCarouselViewPosterView alloc] initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleDefault reuseIdentifier:identifier];
    }
    OrigamiScheme *scheme = result[rowIndex*NUMBER_POSTERS_IN_A_ROW + index];
    [posterView setURLImagePoster: [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"icon-%@", scheme.ident] withExtension:@"jpg"] placeholderImage:nil];
    [posterView setBlurredImagePoster:scheme.isDownloaded?1.f:0.3f];
    [posterView setTextTitlePoster:scheme.name];
    return posterView;
    
}

#pragma mark - ContentGuideViewDelegate methods
- (CGFloat)heightForContentGuideViewRow:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return (contentGuide.frame.size.width/NUMBER_POSTERS_IN_A_ROW - SPACE_BETWEEN_POSTER_VIEWS + HEIGHT_TITLE_POSTER_DEFAULT);
}

- (CGFloat)heightForContentGuideViewRowHeader:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return 0;
}

- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return (contentGuide.frame.size.width/NUMBER_POSTERS_IN_A_ROW - SPACE_BETWEEN_POSTER_VIEWS);
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
    [self.view setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(delayEnableView) userInfo:nil repeats:NO];
    schemeSelected = result[rowIndex*NUMBER_POSTERS_IN_A_ROW + index];
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
-(void)delayEnableView{
    [self.view setUserInteractionEnabled:YES];
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
            result = [[SQLiteManager getInstance] getOrigamiSchemesWithSearchKey:keySearch];
            
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
