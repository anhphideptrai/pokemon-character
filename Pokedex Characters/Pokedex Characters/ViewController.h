//
//  ViewController.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonView.h"
#import "ASOBounceButtonViewDelegate.h"
#import "AnimationMenuCustom.h"
#import "ContentGuideView.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController <ContentGuideViewDataSource, ContentGuideViewDelegate, ASOBounceButtonViewDelegate>
@property (strong, nonatomic) IBOutlet ASOTwoStateButton *menuButton;
@property (strong, nonatomic) AnimationMenuCustom *menuItemView;
@property (strong, nonatomic) IBOutlet ContentGuideView *contentGuideView;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end
