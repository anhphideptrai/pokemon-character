//
//  PosterDetail.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/22/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface PosterDetail : UIView
@property(nonatomic, strong) UIImageView *posterImageView;
@property(nonatomic, strong) UILabel *lbTitle;
@property(nonatomic, strong) UILabel *lbDescription;
- (void) setFrame:(CGRect)frame;

@end
