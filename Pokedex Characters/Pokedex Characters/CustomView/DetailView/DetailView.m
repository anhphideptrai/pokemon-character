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

#define POSTER_FRAME CGRectMake(0, 0, WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE)
#define TYPE_FRAME CGRectMake(0, WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE, 30)
#define WEAKNESSES_FRAME CGRectMake(0, TYPE_FRAME.size.height + TYPE_FRAME.origin.y, WIDTH_DETAIL_PAGE, 30)

@interface DetailView(){
    PosterDetail *posterDetail;
    TypeView *typeView;
    TypeView *weaknessView;
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
    posterDetail = [[PosterDetail alloc] initWithFrame:POSTER_FRAME];
    typeView = [[TypeView alloc] initWithFrame:TYPE_FRAME];
    weaknessView = [[TypeView alloc] initWithFrame:WEAKNESSES_FRAME];
    [self addSubview:posterDetail];
    [self addSubview:typeView];
    [self addSubview:weaknessView];
    
}
- (void)setData:(Pokemon*)pokemon{
    [posterDetail.posterImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"character_%@.jpg", pokemon.iD]]];
    [posterDetail.lbTitle setText:pokemon.name];
    [posterDetail.lbDescription setText:@"description ..."];
    [typeView reLoadData:@"Type: " andArrType:pokemon.type];
    [weaknessView reLoadData:@"Weakness: " andArrType:pokemon.weakness];
}
@end
