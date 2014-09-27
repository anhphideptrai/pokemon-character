//
//  DetailView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DetailView.h"
#import "PosterDetail.h"
#define POSTER_FRAME CGRectMake(0, 0, 400, 400)
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
    posterDetail = [[PosterDetail alloc] initWithFrame:POSTER_FRAME];
    [posterDetail.posterImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"character_%@.jpg", @"070"]]];
    [posterDetail.lbTitle setText:@"pokemon afs"];
    [posterDetail.lbDescription setText:@"description ..."];
    [self addSubview:posterDetail];
    
}
@end
