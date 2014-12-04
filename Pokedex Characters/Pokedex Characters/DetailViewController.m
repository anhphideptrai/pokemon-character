//
//  DetailViewController.m
//  Pokedex Guide
//
//  Created by Phi Nguyen on 12/4/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - iCarouselDataSource methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 0;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImageView *subView = nil;
    if (view && [view isKindOfClass:[UIImageView class]]) {
        subView = (UIImageView*)view;
    }
    if (!subView) {
        subView = [[UIImageView alloc] init];
    }
    return subView;
}
#pragma mark - iCarouselDelegate methods
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return carousel.frame.size.width;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch(option) {
        case iCarouselOptionVisibleItems:{
            return 0;
        }
            break;
        case iCarouselOptionWrap:{
            return YES;
        }
            break;
        default:{
            return value;
        }
            break;
    }
    
}
@end
