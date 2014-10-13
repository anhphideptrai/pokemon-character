//
//  EvolutionsView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "EvolutionsView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "SQLiteManager.h"
#import "UIImageView+AFNetworking.h"

#define BG_FRAME CGRectMake(0, 0, self.frame.size.width, 35)
#define LB_EVOLUTION_FRAME CGRectMake(10, 5, 120, 30)
#define SCROLL_ICON_FRAME CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)
#define SIZE_ICON CGSizeMake(SCROLL_ICON_FRAME.size.height, SCROLL_ICON_FRAME.size.height)
#define ARROW_FRAME CGRectMake(0, (SCROLL_ICON_FRAME.size.height - 12)/2, 16, 12)
@interface EvolutionsView(){
    UIImageView *bgView;
    UILabel *lbEvolution;
    UIScrollView *scrollView;
    NSArray *pokemons;
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
    NSMutableArray *arrID = [[NSMutableArray alloc] init];
    for (NSString *item in arrPokemonID) {
        [arrID addObject:[[[item stringByReplacingOccurrencesOfString:@"N.º" withString:@""] stringByReplacingOccurrencesOfString:@"N°" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    pokemons = [[SQLiteManager getInstance] getArrPokemonWithArrID:arrID];
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
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [lbEvolution setText:[Utils getStringOf:EVOLUTION_STRING withLanguage:appDelegate.languageDefault]];
    CGRect frameIcon = CGRectZero;
    CGRect frameArrow = ARROW_FRAME;
    frameIcon.size = SIZE_ICON;
    for (int i = 0; i < pokemons.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frameIcon];
        [imageView setImageWithURL:[[NSURL alloc] initWithString:((Pokemon*)[pokemons objectAtIndex:i]).ThumbnailImage]];
        [scrollView addSubview:imageView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:frameIcon];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:i+100];
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        if (i + 1< pokemons.count) {
            frameArrow.origin.x = frameIcon.origin.x + frameIcon.size.width + 2;
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:frameArrow];
            [arrowView setImage:[UIImage imageNamed:@"arrow.png"]];
            [scrollView addSubview:arrowView];
        }
        [scrollView setContentSize:CGSizeMake(frameIcon.size.width + frameIcon.origin.x + 10, scrollView.frame.size.height)];
        frameIcon.origin.x = frameIcon.size.width + frameIcon.origin.x + 20;
    }
}
-(IBAction)clickItem:(id)sender{
    int index = ((UIButton*)sender).tag%100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEvolutionItem:)]) {
        [self.delegate clickEvolutionItem:((Pokemon*)[pokemons objectAtIndex:index]).iD];
    }
}

@end
