//
//  ContentGuideViewRowCarouselViewPosterView.m
//  TelenorMyTV
//
//  Created by Phi Nguyen on 7/3/14.
//  Copyright (c) 2014 UUX. All rights reserved.
//

#import "ContentGuideViewRowCarouselViewPosterView.h"
#import "Constant.h"

@interface ContentGuideViewRowCarouselViewPosterView()
{
    UIImageView *imageView;
    UILabel *lbTitle;
    CGFloat heightTitlePoster;
    UIFont *fontTitle;
    UIButton *btnClickView;
}
-(void)removeFromSuperview;
- (void) _initSubviews;
@end

@implementation ContentGuideViewRowCarouselViewPosterView
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleDefault reuseIdentifier:@"ContentGuideViewRowCarouselViewPosterViewStyleDefault"];
}
- (id)initWithStyle:(ContentGuideViewRowCarouselViewPosterViewStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier{
    if (self = [super initWithFrame:CGRectZero]) {
        self.opaque = YES;
        _reuseIdentifier = aReuseIdentifier;
        _style = aStyle;
        [self _initSubviews];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setFrameForViews];
}
- (void) _initSubviews{
    imageView = [[UIImageView alloc] init];
    heightTitlePoster = HEIGHT_TITLE_POSTER_DEFAULT;
    fontTitle = FONT_TITLE_POSTER_DEFAULT;
    lbTitle = [[UILabel alloc] init];
    [lbTitle setBackgroundColor:[UIColor clearColor]];
    [lbTitle setTextColor:TEXT_COLOR_TITLE_POSTER_DEFAULT];
    [lbTitle setNumberOfLines:2];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setFont:fontTitle];
    btnClickView = [[UIButton alloc] init];
    [btnClickView setBackgroundColor:[UIColor clearColor]];
    [btnClickView addTarget:self action:@selector(actionClickView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageView];
    [self addSubview:lbTitle];
    [self addSubview:btnClickView];
}
- (void) setFrameForViews{
    CGRect imageFrame = self.frame;
    imageFrame.origin.x = 0;
    imageFrame.origin.y = 0;
    imageFrame.size.height = self.frame.size.height - heightTitlePoster;
    [imageView setFrame:imageFrame];
    CGRect titleFrame = self.frame;
    titleFrame.origin.x = 0;
    titleFrame.origin.y = imageFrame.size.height;
    titleFrame.size.height = heightTitlePoster;
    [lbTitle setFrame:titleFrame];
    CGRect btnClickFrame = self.frame;
    btnClickFrame.origin.x = 0;
    btnClickFrame.origin.y = 0;
    [btnClickView setFrame:btnClickFrame];
}
- (void)setURLImagePoster:(NSString*)strURL placeholderImage:(UIImage *)placeholderImage{
    if (strURL && ![strURL isEqualToString:@""] && imageView) {
        NSURL *url = [NSURL URLWithString:strURL];
        if (placeholderImage) {
            [imageView setImageWithURL:url placeholderImage:placeholderImage];
        }else{
            [imageView setImageWithURL:url];
        }
    }
}
- (void) setImagePoster:(UIImage*) image{
    if (image) {
        [imageView setImage:image];
    }
}
- (void)setHeightTitlePosterView:(CGFloat)height{
    if (height > 0) {
        heightTitlePoster = height;
        [self setFrameForViews];
    }
}
- (void) setTextTitlePoster:(NSString*) txtTitle{
    if (txtTitle) {
        [lbTitle setText:txtTitle];
    }
}
- (void) setFontTitlePoster:(UIFont*) font{
    if (font) {
        [lbTitle setFont:font];
    }
}
-(void)removeFromSuperview{
    [imageView cancelImageRequestOperation];
    [imageView setImage:nil];
    [super removeFromSuperview];
}

- (void) actionClickView{
    if ([self.delegate respondsToSelector:@selector(didSelectPosterView:)]) {
        [self.delegate didSelectPosterView:self];
    }
}

@end
