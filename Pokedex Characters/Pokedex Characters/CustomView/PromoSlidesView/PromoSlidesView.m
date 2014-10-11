//
//  PromoSlidesView.m
//  TelenorMyTV
//
//  Created by Phi Nguyen on 8/29/14.
//  Copyright (c) 2014 UUX. All rights reserved.
//

#import "PromoSlidesView.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"

@interface PromoSlidesView(){
    NSInteger numberItems;
    BOOL isAutoScroll;
    NSInteger currentIndex;
}
@end
@implementation PromoSlidesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void) initSubViews{
    carouselPromoSlide = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
    [pageControl setUserInteractionEnabled:NO];
    
    [pageControl setBackgroundColor:[UIColor clearColor]];
    [carouselPromoSlide setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:carouselPromoSlide];
    [self addSubview:pageControl];
}
- (void) reloadData{
    numberItems = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInPromoSlides:)]) {
        numberItems = [self.dataSource numberOfItemsInPromoSlides:self];
    }
    [carouselPromoSlide setDataSource:self];
    [carouselPromoSlide setDelegate:self];
    [carouselPromoSlide setPagingEnabled:YES];
    [carouselPromoSlide reloadData];
    [pageControl setNumberOfPages:numberItems];
    [pageControl setCurrentPage:0];
    timerAutoScroll = [NSTimer scheduledTimerWithTimeInterval:TIME_AUTO_SCROLLING_PROMOSLIDES_DEFAULT target:self selector:@selector(scrollCarousel) userInfo:nil repeats:YES];
}
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated{
    if (index < 0) return;
    NSInteger _index = index > numberItems ? numberItems:index;
    [carouselPromoSlide scrollToItemAtIndex:_index animated:animated];
    
}

- (void) scrollCarousel{
    [self scrollToItemAtIndex:++currentIndex%numberItems animated:YES];
}
- (void) removeFromSuperview{
    [super removeFromSuperview];
    if (timerAutoScroll) {
        [timerAutoScroll invalidate];
        timerAutoScroll = nil;
    }
}
#pragma mark - iCarouselDataSource methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return numberItems;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImageView *subView = nil;
    if (view && [view isKindOfClass:[UIImageView class]]) {
        subView = (UIImageView*)view;
    }
    if (!subView) {
        subView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    [subView cancelImageRequestOperation];
    if ([self.dataSource respondsToSelector:@selector(promoSlidesView:imageForItemAtIndex:)]) {
        [subView setImage:[self.dataSource promoSlidesView:self imageForItemAtIndex:index]];
    }else if ([self.dataSource respondsToSelector:@selector(promoSlidesView:urlImageForItemAtIndex:)]) {
        [subView setImageWithURL:[self.dataSource promoSlidesView:self urlImageForItemAtIndex:index]];
    }
    return subView;
}
#pragma mark - iCarouselDelegate methods
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    currentIndex = carousel.currentItemIndex;
    [pageControl setCurrentPage:carousel.currentItemIndex];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(promoSlidesView:didSelectPromoAtIndex:)]) {
        [self.delegate promoSlidesView:self didSelectPromoAtIndex:index];
    }
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
