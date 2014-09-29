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

#define SCROLL_VIEW_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define POSTER_FRAME CGRectMake(0, 0, WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE)
#define TYPE_FRAME CGRectMake(0, WIDTH_DETAIL_PAGE, self.frame.size.width, 30)
#define WEAKNESSES_FRAME CGRectMake(0, TYPE_FRAME.size.height + TYPE_FRAME.origin.y, self.frame.size.width, 30)
#define EVOLUTION_FRAME CGRectMake(0, WEAKNESSES_FRAME.size.height + WEAKNESSES_FRAME.origin.y, self.frame.size.width, 150)
#define DESCRIPTION_FRAME CGRectMake(WIDTH_DETAIL_PAGE, 0, self.frame.size.width - WIDTH_DETAIL_PAGE - 5, WIDTH_DETAIL_PAGE - 160)
#define BASE_STATS_FRAME CGRectMake(WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE - 160, self.frame.size.width - WIDTH_DETAIL_PAGE - 5, 160)

@interface DetailView()<EvolutionsViewDelegate>{
    UIScrollView *scrollView;
    PosterDetail *posterDetail;
    TypeView *typeView;
    TypeView *weaknessView;
    DescriptionView *descriptionView;
    EvolutionsView * evolutionsView;
    BaseStatsView *baseStatsView;
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
    scrollView = [[UIScrollView alloc] initWithFrame:SCROLL_VIEW_FRAME];
    posterDetail = [[PosterDetail alloc] initWithFrame:POSTER_FRAME];
    typeView = [[TypeView alloc] initWithFrame:TYPE_FRAME];
    weaknessView = [[TypeView alloc] initWithFrame:WEAKNESSES_FRAME];
    descriptionView = [[DescriptionView alloc] initWithFrame:DESCRIPTION_FRAME];
    evolutionsView = [[EvolutionsView alloc] initWithFrame:EVOLUTION_FRAME];
    baseStatsView = [[BaseStatsView alloc] initWithFrame:BASE_STATS_FRAME];
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
    [posterDetail.posterImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"character_%@.jpg", pokemon.iD]]];
    [posterDetail.lbTitle setText:[NSString stringWithFormat:@"%@ #%@", pokemon.name, pokemon.iD]];
    [posterDetail.lbDescription setText:[NSString stringWithFormat:@"Height: %@  Weight: %@", pokemon.height, pokemon.weight]];
    [typeView reLoadData:@"Type: " andArrType:pokemon.type];
    [weaknessView reLoadData:@"Weakness: " andArrType:pokemon.weakness];
    [descriptionView reLoadData:[NSArray arrayWithObjects:pokemon.descriptionX, pokemon.descriptionY, nil]];
    [evolutionsView reLoadData:pokemon.evolutions];
    [baseStatsView reLoadData:pokemon.baseStats];
}
- (void)clickEvolutionItem:(NSString*)iDPokemon{
    Pokemon *pokemon = [[SQLiteManager getInstance] getPokemonWithID:iDPokemon];
    if (pokemon) {
        [self setData:pokemon];
    }
}
@end
