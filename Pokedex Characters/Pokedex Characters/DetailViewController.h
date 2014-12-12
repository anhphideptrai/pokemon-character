//
//  DetailViewController.h
//  Pokedex Guide
//
//  Created by Phi Nguyen on 12/4/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADRequest.h"
#import <iCarousel.h>
#import "OrigamiScheme.h"
@interface DetailViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lbLessonName;
@property (strong, nonatomic) IBOutlet UILabel *lbSteps;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (strong, nonatomic) IBOutlet iCarousel *contentView;
@property (strong, nonatomic) IBOutlet UIButton *btBackStep;
@property (strong, nonatomic) IBOutlet UIButton *btNextStep;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionBackStep:(id)sender;
- (IBAction)actionNextStep:(id)sender;
- (IBAction)actionShare:(id)sender;
- (void)setScheme:(OrigamiScheme*)scheme;
@end
