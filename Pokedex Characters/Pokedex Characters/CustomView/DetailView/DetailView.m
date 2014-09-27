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

#define POSTER_FRAME CGRectMake(0, 0, WIDTH_DETAIL_PAGE, WIDTH_DETAIL_PAGE)
@interface DetailView(){
    PosterDetail *posterDetail;
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
    [self setBackgroundColor:[UIColor grayColor]];
    [self.layer setCornerRadius:5.0f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.layer setBorderWidth:2.0f];
    posterDetail = [[PosterDetail alloc] initWithFrame:POSTER_FRAME];
    [self addSubview:posterDetail];
    
}
- (void)setData:(Pokemon*)pokemon{
    [posterDetail.posterImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"character_%@.jpg", pokemon.iD]]];
    [posterDetail.lbTitle setText:pokemon.name];
    [posterDetail.lbDescription setText:@"description ..."];
}
@end
