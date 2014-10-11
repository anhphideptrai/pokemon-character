//
//  BaseStatsView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "BaseStatsView.h"
#import "Constant.h"
#import "AppDelegate.h"

#define OFFSET_X_LB_LEFT IS_IPAD?5:10
#define BG_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define BG_TOP_FRAME CGRectMake(0, 0, self.frame.size.width, 35)
#define LB_BASE_STATS_FRAME CGRectMake(OFFSET_X_LB_LEFT, 0, self.frame.size.width - (OFFSET_X_LB_LEFT), 30)
#define ITEM_FRAME CGRectMake(75, 40, 0, (self.frame.size.height - 75)/6)
#define WIDTH_ITEM self.frame.size.width - 110
#define SIZE_LB_ITEM_FRAME CGRectMake(OFFSET_X_LB_LEFT, 40, 75, (self.frame.size.height - 75)/6)

@interface BaseStatsView(){
    UIImageView *bgTopView;
    UIView *bgView;
    UILabel *lbBaseStat;
}
@end

@implementation BaseStatsView

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

- (void) reLoadData:(NSArray*)arrBaseStats{
    if (IS_IPAD) {
        [self.layer setCornerRadius:20.0f];
        [self.layer setMasksToBounds:YES];
    }
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    bgView = [[UIView alloc] initWithFrame:BG_FRAME];
    bgTopView = [[UIImageView alloc] initWithFrame:BG_TOP_FRAME];
    lbBaseStat = [[UILabel alloc] initWithFrame:LB_BASE_STATS_FRAME];
    [self addSubview:bgView];
    [self addSubview:bgTopView];
    [self addSubview:lbBaseStat];
    
    //set Style for items
    [bgView setBackgroundColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:0.3f]];
    [bgTopView setImage:[UIImage imageNamed:@"gradient.png"]];
    [lbBaseStat setFont:FONT_TITLE_ROW_HEADER_DEFAULT];
    [lbBaseStat setTextColor:[UIColor whiteColor]];
    [lbBaseStat setBackgroundColor:[UIColor clearColor]];
    
    //set Data for items
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [lbBaseStat setText:[Utils getStringOf:BASE_STATS_STRING withLanguage:appDelegate.languageDefault]];
    
    CGRect frameItem = ITEM_FRAME;
    CGRect frameLb = SIZE_LB_ITEM_FRAME;
    NSArray *arr = [NSArray arrayWithObjects:[Utils getStringOf:HP_STRING withLanguage:appDelegate.languageDefault], [Utils getStringOf:ATTACK_STRING withLanguage:appDelegate.languageDefault], [Utils getStringOf:DEFENSE_STRING withLanguage:appDelegate.languageDefault], [Utils getStringOf:SP_ATK_STRING withLanguage:appDelegate.languageDefault], [Utils getStringOf:SP_DEF_STRING withLanguage:appDelegate.languageDefault], [Utils getStringOf:SPEED_STRING withLanguage:appDelegate.languageDefault], nil];
    for (int i = 0; i < 6; i++) {
        
        frameItem.size.width = WIDTH_ITEM;
        frameLb.origin.x = OFFSET_X_LB_LEFT;
        
        UIImageView *itemBGView = [[UIImageView alloc] initWithFrame:frameItem];
        [itemBGView setBackgroundColor:[UIColor colorWithRed:153.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        [self addSubview:itemBGView];

        frameItem.size.width = (WIDTH_ITEM)*[[arrBaseStats objectAtIndex:i] integerValue]/10;
        if(frameItem.size.width > WIDTH_ITEM) frameItem.size.width = WIDTH_ITEM;
        UIImageView *itemView = [[UIImageView alloc] initWithFrame:frameItem];
        [itemView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        [self addSubview:itemView];
        
        UILabel *lbLeft = [[UILabel alloc] initWithFrame:frameLb];
        [lbLeft setBackgroundColor:[UIColor clearColor]];
        [lbLeft setFont:FONT_TITLE_POSTER_DEFAULT];
        [lbLeft setTextColor:[UIColor whiteColor]];
        [lbLeft setText:[arr objectAtIndex:i]];
        [self addSubview:lbLeft];
        
        frameLb.origin.x = frameItem.origin.x + WIDTH_ITEM + 5;
        UILabel *lbRight = [[UILabel alloc] initWithFrame:frameLb];
        [lbRight setBackgroundColor:[UIColor clearColor]];
        [lbRight setFont:FONT_TITLE_POSTER_DEFAULT];
        [lbRight setTextColor:[UIColor whiteColor]];
        [lbRight setText:[NSString stringWithFormat:@"%@%@", [arrBaseStats objectAtIndex:i], [[arrBaseStats objectAtIndex:i] integerValue] < 10?@".0":@""]];
        [self addSubview:lbRight];
        
        frameItem.origin.y = frameItem.origin.y + frameItem.size.height + 5;
        frameLb.origin.y = frameItem.origin.y;
    }
}
@end
