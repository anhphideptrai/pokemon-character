//
//  TypeView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/27/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "TypeView.h"
#import "Constant.h"

#define BG_BOTTOM_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define TITLE_FRAME CGRectMake(10, 0, 130, self.frame.size.height)
#define SIZE_TYPE CGSizeMake(self.frame.size.height, self.frame.size.height)
#define SCROLL_ICON CGRectMake(140, 0, self.frame.size.width - 140, self.frame.size.height)
#define PANDING_X 5
@interface TypeView()
{
    UILabel *title;
}
@end

@implementation TypeView

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void) reLoadData:(NSString*)strTitle andArrType:(NSArray*)arrType{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:BG_BOTTOM_FRAME];
    [imageView setImage:[UIImage imageNamed:@"gradient.png"]];
    [self addSubview:imageView];
    title = [[UILabel alloc] initWithFrame:TITLE_FRAME];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setFont:FONT_TITLE_ROW_HEADER_DEFAULT];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:strTitle];
    [self addSubview:title];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:SCROLL_ICON];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:scrollView];
    CGRect frameIcon = CGRectZero;
    frameIcon.size = SIZE_TYPE;
    CGFloat widthContentScroll = 0;
    for (NSString *type in arrType) {
        UIImageView *iconType = [[UIImageView alloc] initWithFrame:frameIcon];
        [iconType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[type lowercaseString] isEqualToString:@"water"]?@"watter":[[Utils getStringType:type withLanguage:LanguageSettingEN] lowercaseString]]]];
        [scrollView addSubview:iconType];
        widthContentScroll = frameIcon.origin.x + frameIcon.size.width;
        frameIcon.origin.x += frameIcon.size.width + PANDING_X;
    }
    [scrollView setContentSize:CGSizeMake(widthContentScroll, self.frame.size.height)];
}
@end
