//
//  PromoSlidesView.h
//  TelenorMyTV
//
//  Created by Phi Nguyen on 8/29/14.
//  Copyright (c) 2014 UUX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@class PromoSlidesView;

@protocol PromoSlidesViewDataSource <NSObject>
@required

- (NSUInteger) numberOfItemsInPromoSlides:(PromoSlidesView*) promoSlides;

- (NSURL*) promoSlidesView:(PromoSlidesView*) promoSlides
    urlImageForItemAtIndex:(NSInteger) indexItem;

- (UIImage*) promoSlidesView:(PromoSlidesView*) promoSlides
         imageForItemAtIndex:(NSInteger) indexItem;


@end

@protocol PromoSlidesViewDelegate <NSObject>
@optional

- (void)         promoSlidesView:(PromoSlidesView*) promoSlides
           didSelectPromoAtIndex:(NSUInteger) indexItem;

@end

@interface PromoSlidesView : UIView <iCarouselDataSource, iCarouselDelegate>{
    @private
    iCarousel *carouselPromoSlide;
    UIPageControl *pageControl;
    NSTimer *timerAutoScroll;
    
}
@property (nonatomic, assign) IBOutlet id  <PromoSlidesViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <PromoSlidesViewDelegate> delegate;
- (void) reloadData;
- (void) scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
@end
