//
//  SearchViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/8/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SearchViewController.h"
#import "AppObject.h"
#import "LessonObject.h"
#import "Constant.h"
#import "SQLiteManager.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "DownloadManager.h"
#import "Utils.h"
#import "ZipManager.h"

@interface SearchViewController () <DownloadManagerDelegate>{
    NSMutableArray *result;
    NSTimer *timerSearch;
    AppDelegate *appDelegate;
    DownloadManager *downloadManager;
    LessonObject *lessonSelected;
    BOOL isDownloading;
}
@property (strong, nonatomic) IBOutlet UILabel *title_Search;
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
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.title_Search setText:[Utils getStringOf:SEARCH_STRING withLanguage:appDelegate.languageDefault]];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self.contentGuideView setBackground:[UIImage imageNamed:@"scrollview_bg.png"]];
    [self.contentGuideView reloadData];
    downloadManager = [[DownloadManager alloc] init];
    [downloadManager setDelegate:self];
    isDownloading = NO;
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5f]];
    [self.loadingView setHidden:!isDownloading];
    //Add Admob
   // if (![appDelegate.config.statusApp isEqualToString:STATUS_APP_DEFAUL]) {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:NO];
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
        [posterView setURLImagePoster:[NSURL fileURLWithPath:[Utils documentsPathForFileName:[NSString stringWithFormat:@"%@-%@/icon.png",lesson.appID, lesson.iD]]] placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
    }else{
        [posterView setURLImagePoster:[NSURL URLWithString:lesson.urlIcon] placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
    }
    [posterView setTextTitlePoster:lesson.name];
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
    lessonSelected = [((AppObject*)[result objectAtIndex:rowIndex]).lessons objectAtIndex:index];
    if (lessonSelected.downloaded) {
        [self navigationToDetailView];
    }else{
        if (!isDownloading) {
            isDownloading = YES;
            [self.squaresLoading setColor:_red_color_];
            [self.lbDownloading setText:@"Downloading... [0%]"];
            [self.loadingView setHidden:!isDownloading];
            [downloadManager downloadFileWithUrl:[NSString stringWithFormat:@"http://www.how2draw.biz/how2draw/app%@/lesson%@.zip", lessonSelected.appID, [Utils formatLessonID:lessonSelected.iD]]];
        }
    }
    
}
- (void)navigationToDetailView{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:NAME_XIB_FILE_DETAIL_VIEW_CONTROLLER bundle:nil];
    [detailViewController setLesson:lessonSelected];
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
   NSString *searchText =  [timerSearch userInfo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ([[searchText stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [result removeAllObjects];
        }else{
            result = [[SQLiteManager getInstance] getArrHowToDrawAppsWithSearchKey:searchText];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentGuideView reloadData];
        });
    });
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
