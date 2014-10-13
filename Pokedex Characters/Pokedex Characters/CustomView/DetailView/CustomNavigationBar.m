//
//  CustomNavigationBar.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/27/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "Constant.h"
#import <Social/Social.h>

#define PANDING_OFFSET (IS_IPAD?10:5)
#define WIDTH_ICON_CENTER (IS_IPAD?48:32)
#define PANDING_LEFT 8
#define BG_IMAGE_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define BACK_BUTTON_FRAME CGRectMake(PANDING_LEFT, PANDING_OFFSET, 30, self.frame.size.height - 2*PANDING_OFFSET)
#define ICON_CENTER_FRAME CGRectMake((self.frame.size.width - WIDTH_ICON_CENTER)/2, PANDING_OFFSET, WIDTH_ICON_CENTER, self.frame.size.height - 2*PANDING_OFFSET)
#define BACK_HIDE_BUTTON_FRAME CGRectMake(0, 0, self.frame.size.height, 60)
#define SHARE_BUTTON_FRAME CGRectMake(self.frame.size.width - PANDING_LEFT - 30, PANDING_OFFSET, 30, self.frame.size.height - 2*PANDING_OFFSET)
#define SHARE_HIDE_BUTTON_FRAME CGRectMake(self.frame.size.width - 60, 0, 60, self.frame.size.height)
@interface CustomNavigationBar()
{
    UIImageView *bgImage;
    UIButton *backButton;
    UIButton *backHideButton;
    UIButton *shareButton;
    UIButton *shareHideButton;
    UIImageView *iconCenter;
}
@end
@implementation CustomNavigationBar
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
    bgImage = [[UIImageView alloc] init];
    backButton = [[UIButton alloc] init];
    backHideButton = [[UIButton alloc] init];
    shareButton = [[UIButton alloc] init];
    shareHideButton = [[UIButton alloc] init];
    iconCenter = [[UIImageView alloc] init];
    [bgImage setImage:[UIImage imageNamed:@"reading_topnav_background.png"]];
    [backButton setImage:[UIImage imageNamed:@"topnav_back_grey.png"] forState:UIControlStateNormal];
    [iconCenter setImage:[UIImage imageNamed:@"placeholder_center.png"]];
    [backHideButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"topnav_share_normal.png"] forState:UIControlStateNormal];
    [shareHideButton addTarget:self action:@selector(sharingClick) forControlEvents:UIControlEventTouchUpInside];
    [self setFrameForViews];
    [self addSubview:bgImage];
    [self addSubview:iconCenter];
    [self addSubview:backButton];
    [self addSubview:backHideButton];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        [self addSubview:shareButton];
        [self addSubview:shareHideButton];
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setFrameForViews];
}

- (void) setFrameForViews{
    [bgImage setFrame:BG_IMAGE_FRAME];
    [backButton setFrame:BACK_BUTTON_FRAME];
    [backHideButton setFrame:BACK_HIDE_BUTTON_FRAME];
    [iconCenter setFrame:ICON_CENTER_FRAME];
    [shareButton setFrame:SHARE_BUTTON_FRAME];
    [shareHideButton setFrame:SHARE_HIDE_BUTTON_FRAME];
}
- (void)backClick{
    if ([self.delegate respondsToSelector:@selector(clickBtnBack:)]) {
        [self.delegate clickBtnBack:self];
    }
}
- (void)sharingClick{
    if ([self.delegate respondsToSelector:@selector(clickBtnShare:)]) {
        [self.delegate clickBtnShare:self];
    }
}
@end
