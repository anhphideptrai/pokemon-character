//
//  PosterDetail.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/22/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "PosterDetail.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"

#define POSTER_IMAGE_VIEW_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define BG_BOTTOM_FRAME CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)
#define LABEL_TITLE_FRAME CGRectMake(20, BG_BOTTOM_FRAME.origin.y + 5, self.frame.size.width - 20, 25)
#define LABEL_DESCRIPTION_FRAME CGRectMake(20, BG_BOTTOM_FRAME.origin.y + 30, self.frame.size.width - 20, 15)

@interface PosterDetail()
@property(nonatomic, strong) UIImageView *bgBottom;
- (void) initCommon;
- (void) setFrameForViews;

@end
@implementation PosterDetail
@synthesize posterImageView = _posterImageView;
@synthesize bgBottom = _bgBottom;
@synthesize lbTitle = _lbTitle;
@synthesize lbDescription = _lbDescription;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(void) initCommon{
    _posterImageView = [[UIImageView alloc] init];
    _bgBottom = [[UIImageView alloc] init];
    _lbTitle = [[UILabel alloc] init];
    _lbDescription = [[UILabel alloc] init];
    [_lbTitle setTextColor:TEXT_COLOR_TITLE_POSTER_DEFAULT];
    [_lbTitle setFont:FONT_TITLE_ROW_HEADER_DEFAULT];
    [_lbDescription setFont:FONT_TITLE_POSTER_DEFAULT];
    [_lbDescription setTextColor:[UIColor whiteColor]];
    
    [_bgBottom setImage:[UIImage imageNamed:@"gradient.png"]];
    
    [self addSubview:_posterImageView];
    [self addSubview:_bgBottom];
    [self addSubview:_lbTitle];
    [self addSubview:_lbDescription];
    [self setFrameForViews];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setFrameForViews];
}

- (void) setFrameForViews{
    [_posterImageView setFrame:POSTER_IMAGE_VIEW_FRAME];
    [_bgBottom setFrame:BG_BOTTOM_FRAME];
    [_lbTitle setFrame:LABEL_TITLE_FRAME];
    [_lbDescription setFrame:LABEL_DESCRIPTION_FRAME];
}

#pragma mark -- Layout methods
-(void) layoutSubviews{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    [CATransaction setDisableActions:YES];
    
    [CATransaction commit];
}

@end
