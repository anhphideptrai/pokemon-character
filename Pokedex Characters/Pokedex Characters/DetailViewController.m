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

@interface DetailViewController ()
@property (nonatomic, strong)LessonObject *lesson;
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
- (void)setLesson:(LessonObject*)lesson{
    _lesson = lesson;
}
- (void)updateTitleStep{
    [self.lbSteps setText:[NSString stringWithFormat:@"%ld/%ld",self.contentView.currentItemIndex, _lesson.steps]];
}
#pragma mark - iCarouselDataSource methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _lesson.steps + 1;
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
    [subView setImageWithURL:[Utils getURLImageWith:_lesson.appID andWithLessonID:_lesson.iD andWithStep:(int)index]];
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
@end
