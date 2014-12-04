//
//  DetailView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DetailView.h"
#import "PosterDetail.h"
#import "Constant.h"
#import "TypeView.h"
#import "DescriptionView.h"
#import "EvolutionsView.h"
#import "BaseStatsView.h"
#import "SQLiteManager.h"
#import "AppDelegate.h"

#define SCROLL_VIEW_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define POSTER_FRAME CGRectMake(0, 0, WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE)
#define DESCRIPTION_FRAME IS_IPAD?CGRectMake(WIDTH_DETAIL_PAGE, 0, self.frame.size.width - WIDTH_DETAIL_PAGE - 5, WIDTH_DETAIL_PAGE - 160):CGRectMake(0, WIDTH_DETAIL_PAGE, self.frame.size.width, 130)
#define BASE_STATS_FRAME IS_IPAD?CGRectMake(WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE - 160, self.frame.size.width - WIDTH_DETAIL_PAGE - 5, 160):CGRectMake(0, (DESCRIPTION_FRAME).size.height + (DESCRIPTION_FRAME).origin.y, self.frame.size.width, 142)
#define TYPE_FRAME IS_IPAD?CGRectMake(0, WIDTH_DETAIL_PAGE, self.frame.size.width, 30):CGRectMake(0, (BASE_STATS_FRAME).size.height + (BASE_STATS_FRAME).origin.y, self.frame.size.width, 30)
#define WEAKNESSES_FRAME CGRectMake(0, (TYPE_FRAME).size.height + (TYPE_FRAME).origin.y, self.frame.size.width, 30)
#define EVOLUTION_FRAME CGRectMake(0, WEAKNESSES_FRAME.size.height + WEAKNESSES_FRAME.origin.y, self.frame.size.width, IS_IPAD?150:90)



@interface DetailView()<EvolutionsViewDelegate>{
    UIScrollView *scrollView;
    PosterDetail *posterDetail;
    TypeView *typeView;
    TypeView *weaknessView;
    DescriptionView *descriptionView;
    EvolutionsView * evolutionsView;
    BaseStatsView *baseStatsView;
    AppDelegate *appDelegate;
}
@end
@implementation DetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}
-(void)initCommon{
    [self.layer setCornerRadius:5.0f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.layer setBorderWidth:2.0f];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    scrollView = [[UIScrollView alloc] initWithFrame:SCROLL_VIEW_FRAME];
    descriptionView = [[DescriptionView alloc] initWithFrame:DESCRIPTION_FRAME];
    posterDetail = [[PosterDetail alloc] initWithFrame:POSTER_FRAME];
    baseStatsView = [[BaseStatsView alloc] initWithFrame:BASE_STATS_FRAME];
    typeView = [[TypeView alloc] initWithFrame:TYPE_FRAME];
    weaknessView = [[TypeView alloc] initWithFrame:WEAKNESSES_FRAME];
    evolutionsView = [[EvolutionsView alloc] initWithFrame:EVOLUTION_FRAME];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [evolutionsView setDelegate:self];
    [self addSubview:scrollView];
    [scrollView addSubview:posterDetail];
    [scrollView addSubview:typeView];
    [scrollView addSubview:weaknessView];
    [scrollView addSubview:descriptionView];
    [scrollView addSubview:evolutionsView];
    [scrollView addSubview:baseStatsView];
    CGRect frameTmp = CGRectZero;
    for (UIView *subView in scrollView.subviews) {
        if (frameTmp.origin.y < subView.frame.origin.y) {
            frameTmp = subView.frame;
        }
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, frameTmp.size.height + frameTmp.origin.y + 10)];
}
- (void)setData:(Pokemon*)pokemon{
    [posterDetail.posterImageView setImageWithURL:[NSURL URLWithString:pokemon.ThumbnailImage] placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
    [posterDetail.lbTitle setText:[NSString stringWithFormat:@"%@ %@%@", pokemon.name, [Utils getStringOf:ORDER_ID_NAME_STRING withLanguage:appDelegate.languageDefault],pokemon.iD]];
    [posterDetail.lbDescription setText:[NSString stringWithFormat:@"%@ %@  %@ %@", [Utils getStringOf:HEIGHT_STRING withLanguage:appDelegate.languageDefault], pokemon.height, [Utils getStringOf:WEIGHT_STRING withLanguage:appDelegate.languageDefault], pokemon.weight]];
    [typeView reLoadData:[NSString stringWithFormat:@"%@ ", [Utils getStringOf:TYPE_STRING withLanguage:appDelegate.languageDefault]] andArrType:pokemon.type];
    [weaknessView reLoadData:[NSString stringWithFormat:@"%@ ", [Utils getStringOf:WEAKNESS_STRING withLanguage:appDelegate.languageDefault]] andArrType:pokemon.weakness];
    [descriptionView reLoadData:[NSArray arrayWithObjects:pokemon.descriptionX, pokemon.descriptionY, nil]];
    [evolutionsView reLoadData:pokemon.evolutions];
    [baseStatsView reLoadData:pokemon.baseStats];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (UIImage*)getImageDetail{
    return posterDetail.posterImageView.image;
}
- (void)clickEvolutionItem:(NSString*)iDPokemon{
    Pokemon *pokemon = nil;
    if (pokemon) {
        [self setData:pokemon];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeCurrentPokemon:withNewPokemon:)]) {
            [self.delegate didChangeCurrentPokemon:self withNewPokemon:pokemon];
        }
    }
}
@end
