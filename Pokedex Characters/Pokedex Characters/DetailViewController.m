//
//  DetailViewController.m
//  Pokedex Guide
//
//  Created by Phi Nguyen on 12/4/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Utils.h"
#import <Social/Social.h>
#import "AppDelegate.h"
#import "HelpViewController.h"

@interface DetailViewController (){
    AppDelegate *appDelegate;
    OrigamiStep *currentStep;
}
@property (nonatomic, strong)OrigamiScheme *scheme;
@property (strong, nonatomic) IBOutlet UIImageView *bgNavigationBar;
@property (strong, nonatomic) IBOutlet UITextView *txtInfo;
@property (strong, nonatomic) IBOutlet UIButton *btHelp;
- (IBAction)actionHelp:(id)sender;
@end

@implementation DetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setClipsToBounds:YES];
    [self.contentView setPagingEnabled:YES];
    [self.contentView setScrollEnabled:NO];
    [self.btBackStep setEnabled:NO];
    [self.btBackStep setAlpha:0.5f];
    [self updateTitleStep];
    [self.btBackStep.layer setCornerRadius:4.0f];
    [self.btBackStep.layer setMasksToBounds:YES];
    [self.btNextStep.layer setCornerRadius:4.0f];
    [self.btNextStep.layer setMasksToBounds:YES];
    [self.btHelp.layer setCornerRadius:4.0f];
    [self.btHelp.layer setMasksToBounds:YES];
    [self.lbLessonName setText:_scheme.name];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //Add Admob
  if (![appDelegate.config.statusApp isEqualToString:STATUS_APP_DEFAUL]) {
      self.bannerView.adUnitID = BANNER_ID_ADMOB_DETAIL_PAGE;
      self.bannerView.rootViewController = self;
      GADRequest *request = [GADRequest request];
      request.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID",
                             @"1485d1faa4c1010a54b384ca9e9944b7", @"f2b1a55b050ac3483e1c17a21a2073f5",
                             nil];
      [self.bannerView loadRequest:request];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionBackStep:(id)sender {
    [self.contentView scrollToItemAtIndex:self.contentView.currentItemIndex - 1 animated:NO];
}

- (IBAction)actionNextStep:(id)sender {
    [self.contentView scrollToItemAtIndex:self.contentView.currentItemIndex + 1 animated:NO];
}

- (IBAction)actionShare:(id)sender {
    OrigamiStep *step = _scheme.steps[0];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:[NSString stringWithFormat:@"%@\n\n", _scheme.name]];
    [controller addURL:[NSURL URLWithString:appDelegate.config.urlShare]];
    [controller addImage:[UIImage imageWithContentsOfFile:[Utils getURLImageWith:_scheme.rowid andWithStep:step.sort_order].path]];
    [self presentViewController:controller animated:YES completion:Nil];

}
- (void)setScheme:(OrigamiScheme*)scheme{
    _scheme = scheme;
}
- (void)updateTitleStep{
    NSInteger currentIndex = self.contentView.currentItemIndex;
    [self.lbSteps setText:[NSString stringWithFormat:@"%ld/%ld",currentIndex, _scheme.steps_count]];
    [self.txtInfo setText:currentIndex == 0 ? _scheme.descr : currentStep.info];
    [self.btHelp setHidden:currentStep.help == 0];
}
#pragma mark - iCarouselDataSource methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _scheme.steps.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImageView *subView = nil;
    if (view && [view isKindOfClass:[UIImageView class]]) {
        subView = (UIImageView*)view;
    }
    if (!subView) {
        CGRect frame = carousel.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        subView = [[UIImageView alloc] initWithFrame:frame];
    }
    [subView setContentMode:UIViewContentModeScaleAspectFit];
    OrigamiStep *step = _scheme.steps[index];
    [subView setImageWithURL:[Utils getURLImageWith:_scheme.rowid andWithStep:step.sort_order]];
    return subView;
}
#pragma mark - iCarouselDelegate methods
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    BOOL enableButtonBackStep = carousel.currentItemIndex != 0;
    BOOL enableButtonNextStep = carousel.currentItemIndex != carousel.numberOfItems - 1;
    [self.btBackStep setEnabled:enableButtonBackStep];
    [self.btNextStep setEnabled:enableButtonNextStep];
    [self.btBackStep setAlpha:enableButtonBackStep?1.0f:0.5f];
    [self.btNextStep setAlpha:enableButtonNextStep?1.0f:0.5f];
    currentStep = _scheme.steps[carousel.currentItemIndex];
    [self updateTitleStep];
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return carousel.frame.size.width;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch(option) {
        case iCarouselOptionVisibleItems:{
            return 3;
        }
            break;
        case iCarouselOptionWrap:{
            return NO;
        }
            break;
        default:{
            return value;
        }
            break;
    }
    
}
- (IBAction)actionHelp:(id)sender {
    HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:NAME_XIB_FILE_HELP_VIEW_CONTROLLER bundle:nil];
    [helpVC setIDOrigamiHelp:currentStep.help];
    [self presentViewController:helpVC animated:YES completion:^{}];
}
@end
