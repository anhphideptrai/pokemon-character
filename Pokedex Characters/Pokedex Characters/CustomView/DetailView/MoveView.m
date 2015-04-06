//
//  MoveView.m
//  Pokedex Guide
//
//  Created by Phi Nguyen on 1/18/15.
//  Copyright (c) 2015 Duc Thien. All rights reserved.
//

#import "MoveView.h"
#import "Constant.h"
#import "AppDelegate.h"

#define BUTTON_PREVIUS_FRAME CGRectMake(10, self.frame.size.height - 30, 80, 30)
#define BUTTON_NEXT_FRAME CGRectMake(self.frame.size.width - 90, self.frame.size.height - 30, 80, 30)
#define BUTTON_LOVE_FRAME CGRectMake((self.frame.size.width - 3*79/7)/2, self.frame.size.height - 30, 3*79/7, 30)
@interface MoveView(){
    UIButton *buttonPrevius;
    UIButton *buttonNext;
    UIButton *buttonLove;
    BOOL _isLove;
}
@end

@implementation MoveView
-(void)reloadViewWithEnableLeft:(BOOL)enableLeft andEnableRigth:(BOOL)enableRight{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    buttonPrevius        = [[UIButton alloc] initWithFrame:BUTTON_PREVIUS_FRAME];
    buttonNext        = [[UIButton alloc] initWithFrame:BUTTON_NEXT_FRAME];
    buttonLove        = [[UIButton alloc] initWithFrame:BUTTON_LOVE_FRAME];
    
    [buttonNext setBackgroundColor:[UIColor clearColor]];
    [buttonPrevius setBackgroundColor:[UIColor clearColor]];
    [buttonLove setBackgroundColor:[UIColor clearColor]];
    [buttonNext.layer setCornerRadius:4.0f];
    [buttonNext.layer setMasksToBounds:YES];
    [buttonPrevius.layer setCornerRadius:4.0f];
    [buttonPrevius.layer setMasksToBounds:YES];
    [buttonPrevius setTag:LEFT_MOVE];
    [buttonNext setTag:RIGHT_MOVE];
    
    [buttonPrevius setTitle:[Utils getStringOf:PREVIUS_STRING withLanguage:appDelegate.languageDefault] forState:UIControlStateNormal];
    [buttonNext setTitle:[Utils getStringOf:NEXT_STRING withLanguage:appDelegate.languageDefault] forState:UIControlStateNormal];
    
    [buttonNext setUserInteractionEnabled:enableRight];
    [buttonPrevius setUserInteractionEnabled:enableLeft];
    [buttonPrevius setBackgroundColor:enableLeft?BG_COLOR_MOVE_ITEM_ENABLE:BG_COLOR_MOVE_ITEM_DISABLE];
    [buttonNext setBackgroundColor:enableRight?BG_COLOR_MOVE_ITEM_ENABLE:BG_COLOR_MOVE_ITEM_DISABLE];
    
    [buttonPrevius.titleLabel setFont:FONT_MOVE_ITEM];
    [buttonNext.titleLabel setFont:FONT_MOVE_ITEM];
    
    [buttonPrevius addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonNext addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLove addTarget:self action:@selector(clickLoveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setLove:NO];
    
    [self addSubview:buttonPrevius];
    [self addSubview:buttonNext];
    [self addSubview:buttonLove];
    
}
- (IBAction)clickButton:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldMoveCharacterTo:)]) {
        UIButton *btSender = (UIButton*)sender;
        [self.delegate shouldMoveCharacterTo:(MoveDirection)btSender.tag];
    }
}
- (void)setLove:(BOOL)isLove{
    _isLove = isLove;
    [buttonLove setImage:[UIImage imageNamed:(_isLove?@"love_on.png":@"love_off.png")] forState:UIControlStateNormal];
}
- (IBAction)clickLoveButton:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedLoveIconWith:)]) {
        [self.delegate didSelectedLoveIconWith:!_isLove];
    }
    [self setLove:!_isLove];
}
@end
