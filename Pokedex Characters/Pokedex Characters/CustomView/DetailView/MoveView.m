//
//  MoveView.m
//  Pokedex Guide
//
//  Created by Phi Nguyen on 1/18/15.
//  Copyright (c) 2015 Duc Thien. All rights reserved.
//

#import "MoveView.h"
#import "Constant.h"

#define BUTTON_PREVIUS_FRAME CGRectMake(10, self.frame.size.height - 30, 70, 30)
#define BUTTON_NEXT_FRAME CGRectMake(self.frame.size.width - 80, self.frame.size.height - 30, 70, 30)
@interface MoveView(){
    UIButton *buttonPrevius;
    UIButton *buttonNext;
}
@end

@implementation MoveView
-(void)reloadViewWithEnableLeft:(BOOL)enableLeft andEnableRigth:(BOOL)enableRight{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    buttonPrevius        = [[UIButton alloc] initWithFrame:BUTTON_PREVIUS_FRAME];
    buttonNext        = [[UIButton alloc] initWithFrame:BUTTON_NEXT_FRAME];
    
    [buttonNext setBackgroundColor:[UIColor clearColor]];
    [buttonPrevius setBackgroundColor:[UIColor clearColor]];
    [buttonNext.layer setCornerRadius:4.0f];
    [buttonNext.layer setMasksToBounds:YES];
    [buttonPrevius.layer setCornerRadius:4.0f];
    [buttonPrevius.layer setMasksToBounds:YES];
    [buttonPrevius setTag:LEFT_MOVE];
    [buttonNext setTag:RIGHT_MOVE];
    
    [buttonPrevius setTitle:@"<Previus" forState:UIControlStateNormal];
    [buttonNext setTitle:@"Next>" forState:UIControlStateNormal];
    
    [buttonNext setUserInteractionEnabled:enableRight];
    [buttonPrevius setUserInteractionEnabled:enableLeft];
    [buttonPrevius setBackgroundColor:enableLeft?BG_COLOR_MOVE_ITEM_ENABLE:BG_COLOR_MOVE_ITEM_DISABLE];
    [buttonNext setBackgroundColor:enableRight?BG_COLOR_MOVE_ITEM_ENABLE:BG_COLOR_MOVE_ITEM_DISABLE];
    
    [buttonPrevius.titleLabel setFont:FONT_MOVE_ITEM];
    [buttonNext.titleLabel setFont:FONT_MOVE_ITEM];
    
    [buttonPrevius addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonNext addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buttonPrevius];
    [self addSubview:buttonNext];
    
}
- (IBAction)clickButton:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldMoveCharacterTo:)]) {
        UIButton *btSender = (UIButton*)sender;
        [self.delegate shouldMoveCharacterTo:(MoveDirection)btSender.tag];
    }
}
@end
