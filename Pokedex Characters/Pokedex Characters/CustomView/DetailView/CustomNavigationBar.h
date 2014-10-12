//
//  CustomNavigationBar.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/27/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomNavigationBar;

@protocol CustomNavigationBarDelegate <NSObject>
@optional
- (void)clickBtnBack:(CustomNavigationBar*)customNavigationBar;
- (void)clickBtnShare:(CustomNavigationBar*)customNavigationBar;
@end
@interface CustomNavigationBar : UIView
- (void) setFrame:(CGRect)frame;
@property (nonatomic, assign) IBOutlet id  <CustomNavigationBarDelegate> delegate;
@end
