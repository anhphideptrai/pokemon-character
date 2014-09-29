//
//  EvolutionsView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "EvolutionsView.h"
#import "Constant.h"

#define BG_FRAME CGRectMake(0, 0, self.frame.size.width, 35)
#define LB_EVOLUTION_FRAME CGRectMake(10, 5, 120, 30)
#define SCROLL_ICON_FRAME CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)
#define SIZE_ICON CGSizeMake(SCROLL_ICON_FRAME.size.height, SCROLL_ICON_FRAME.size.height)
#define ARROW_FRAME CGRectMake(0, (SCROLL_ICON_FRAME.size.height - 12)/2, 16, 12)
@interface EvolutionsView(){
    UIImageView *bgView;
    UILabel *lbEvolution;
    UIScrollView *scrollView;
}
@end

@implementation EvolutionsView

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

- (void) reLoadData:(NSArray*)arrPokemonID{
    [self setBackgroundColor:[UIColor clearColor]];
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    bgView      = [[UIImageView alloc] initWithFrame:BG_FRAME];
    lbEvolution = [[UILabel alloc] initWithFrame:LB_EVOLUTION_FRAME];
    scrollView  = [[UIScrollView alloc] initWithFrame:SCROLL_ICON_FRAME];
    [self addSubview:bgView];
    [self addSubview:lbEvolution];
    [self addSubview:scrollView];
    
    //set Style for items
    [bgView setImage:[UIImage imageNamed:@"gradient.png"]];
    [lbEvolution setFont:FONT_TITLE_ROW_HEADER_DEFAULT];
    [lbEvolution setTextColor:[UIColor whiteColor]];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    
    //set Data for items
    [lbEvolution setText:@"Evolutions"];
    CGRect frameIcon = CGRectZero;
    CGRect frameArrow = ARROW_FRAME;
    frameIcon.size = SIZE_ICON;
    for (int i = 0; i < arrPokemonID.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frameIcon];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"character_%@.jpg", [arrPokemonID objectAtIndex:i]]]];
        [scrollView addSubview:imageView];
        if (i + 1< arrPokemonID.count) {
            frameArrow.origin.x = frameIcon.origin.x + frameIcon.size.width + 2;
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:frameArrow];
            [arrowView setImage:[UIImage imageNamed:@"arrow.png"]];
            [scrollView addSubview:arrowView];
        }
        [scrollView setContentSize:CGSizeMake(frameIcon.size.width + frameIcon.origin.x + 10, scrollView.frame.size.height)];
        frameIcon.origin.x = frameIcon.size.width + frameIcon.origin.x + 20;
    }
}

@end
