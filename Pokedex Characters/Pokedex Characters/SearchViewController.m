//
//  SearchViewController.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/8/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "SearchViewController.h"
#import "Pokemon.h"
#import "PokemonType.h"
#import "Constant.h"
#import "SQLiteManager.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface SearchViewController (){
    NSMutableArray *result;
    NSTimer *timerSearch;
    AppDelegate *appDelegate;
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
}
- (BOOL)prefersStatusBarHidden {
    return YES;
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
    [header  setTextTitleRowHeader:[[Utils getStringType:type withLanguage:appDelegate.languageDefault] uppercaseString]];
    [header setBackground:[UIImage imageNamed:@"headercell_bg.png"]];
    [header setIconLeft:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[Utils getStringType:type withLanguage:LanguageSettingEN] lowercaseString]]]];
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
    [posterView setURLImagePoster:pokemon.ThumbnailImage placeholderImage:nil];
    [posterView setTextTitlePoster:[NSString stringWithFormat:@"%@\n%@%@",pokemon.name, [Utils getStringOf:ORDER_ID_NAME_STRING withLanguage:appDelegate.languageDefault], pokemon.iD]];
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
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [detailViewController setPokemonForDetail:[((PokemonType*)[result objectAtIndex:rowIndex]).pokemons objectAtIndex:index]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
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
            result = [[SQLiteManager getInstance] getArrPokemonWithSearchKey:searchText];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentGuideView reloadData];
        });
    });
}
@end
