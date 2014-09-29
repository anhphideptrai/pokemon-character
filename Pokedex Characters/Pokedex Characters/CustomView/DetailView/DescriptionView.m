//
//  DescriptionView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/28/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DescriptionView.h"
#import "Constant.h"

#define BG_FRAME CGRectMake(0, 0, self.frame.size.width, 35)
#define BUTTON_X_FRAME CGRectMake(130, 5, 30, 30)
#define BUTTON_Y_FRAME CGRectMake(165, 5, 30, 30)
#define TXT_DESCRIPTION_FRAME CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)
#define LB_VERSION_FRAME CGRectMake(10, 5, 120, 30)

@interface DescriptionView(){
    UIImageView *bgView;
    UIButton *buttonX;
    UIButton *buttonY;
    UITextView *txtDescription;
    UILabel *lbVersion;
    NSArray *arrDesc;
}

@end

@implementation DescriptionView

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

- (void) reLoadData:(NSArray*)arrDescription{
    [self setBackgroundColor:[UIColor clearColor]];
    arrDesc = arrDescription;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    bgView         = [[UIImageView alloc] initWithFrame:BG_FRAME];
    buttonX        = [[UIButton alloc] initWithFrame:BUTTON_X_FRAME];
    buttonY        = [[UIButton alloc] initWithFrame:BUTTON_Y_FRAME];
    txtDescription = [[UITextView alloc] initWithFrame:TXT_DESCRIPTION_FRAME];
    lbVersion      = [[UILabel alloc] initWithFrame:LB_VERSION_FRAME];
    [self addSubview:bgView];
    [self addSubview:buttonX];
    [self addSubview:buttonY];
    [self addSubview:txtDescription];
    [self addSubview:lbVersion];
    
    //set Style for items
    [bgView setImage:[UIImage imageNamed:@"gradient.png"]];
    [lbVersion setFont:FONT_TITLE_ROW_HEADER_DEFAULT];
    [lbVersion setTextColor:[UIColor whiteColor]];
    [txtDescription setBackgroundColor:[UIColor clearColor]];
    [txtDescription setFont:FONT_TITLE_POSTER_DEFAULT];
    [txtDescription setTextColor:[UIColor whiteColor]];
    [txtDescription setUserInteractionEnabled:NO];
    //set Data for items
    
    [buttonX setBackgroundImage:[UIImage imageNamed:@"x_normal.png"] forState:UIControlStateNormal];
    [buttonX setBackgroundImage:[UIImage imageNamed:@"x_selected.png"] forState:UIControlStateSelected];
    [buttonY setBackgroundImage:[UIImage imageNamed:@"y_normal.png"] forState:UIControlStateNormal];
    [buttonY setBackgroundImage:[UIImage imageNamed:@"y_selected.png"] forState:UIControlStateSelected];
    [lbVersion setText:@"Versions:"];
    [txtDescription setText:[arrDesc objectAtIndex:0]];
    
    [buttonX setSelected:YES];
    [buttonX setTag:100];
    [buttonY setTag:101];
    
    [buttonX addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonY addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)clickButton:(id)sender{
    [buttonX setSelected:NO];
    [buttonY setSelected:NO];
    UIButton *btSender = (UIButton*)sender;
    int index = btSender.tag%100;
    [btSender setSelected:YES];
    [txtDescription setText:[arrDesc objectAtIndex:index]];
}

@end
