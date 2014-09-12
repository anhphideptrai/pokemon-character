//
//  ContentGuideView.h
//  TelenorMyTV
//
//  Created by Phi Nguyen on 7/3/14.
//  Copyright (c) 2014 UUX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentGuideViewRow.h"
#import "ContentGuideViewRowCarouselViewPosterView.h"
#import "ContentGuideViewRowHeader.h"

typedef enum {
    ContentGuideViewScrollDirectionNone = 0,
    ContentGuideViewScrollDirectionUp = 1,
    ContentGuideViewScrollDirectionDown = 2
} ContentGuideViewScrollDirection;

@class ContentGuideView;

@protocol ContentGuideViewDataSource <NSObject>
@required

- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex;
- (NSUInteger) numberOfRowsInContentGuide:(ContentGuideView*) contentGuide;
- (ContentGuideViewRow*) contentGuide:(ContentGuideView*) contentGuide
                       rowForRowIndex:(NSUInteger)rowIndex;

- (ContentGuideViewRowHeader*) contentGuide:(ContentGuideView*) contentGuide
                       rowHeaderForRowIndex:(NSUInteger)rowIndex;

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideView*) contentGuide
                                     posterViewForRowIndex:(NSUInteger)rowIndex
                                           posterViewIndex:(NSUInteger)index;

@optional

- (UIView*) topCustomViewForContentGuideView:(ContentGuideView*) contentGuide;

@end

@protocol ContentGuideViewDelegate <NSObject>
@required

- (CGFloat)heightForContentGuideViewRow:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex;

- (CGFloat)heightForContentGuideViewRowHeader:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex;

- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex;

@optional

- (CGFloat)spaceBetweenCarouselViewPosterViews:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex;

- (CGFloat)pandingTopAndBottomOfRowHeader:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex;

- (CGFloat)offsetYOfFirstRow:(ContentGuideView*) contentGuide;

- (void)         contentGuide:(ContentGuideView*) contentGuide
didSelectPosterViewAtRowIndex:(NSUInteger) rowIndex
                  posterIndex:(NSUInteger) index;

- (void)      contentGuide:(ContentGuideView*) contentGuide
didScrollToVisibleRowIndex:(NSUInteger) rowIndex
             withDirection:(ContentGuideViewScrollDirection) direction;

- (void)                contentGuide:(ContentGuideView*) contentGuide
       didScrollToVisibleposterIndex:(NSUInteger) posterIndex
                           atViewRow:(ContentGuideViewRow*) viewRow
                       withDirection:(CarouselViewScrollDirection) direction;

@end

@interface ContentGuideView : UIView{
    
}
/** The object that acts as the data source of the receiving table view.
 */
@property (nonatomic, assign) IBOutlet id  <ContentGuideViewDataSource> dataSource;

/** The object that acts as the delegate of the receiving table view.
 */
@property (nonatomic, assign) IBOutlet id <ContentGuideViewDelegate> delegate;

- (ContentGuideViewRowCarouselViewPosterView*) dequeueReusablePosterViewWithIdentifier:(NSString*) identifier;

- (ContentGuideViewRowHeader*) dequeueReusableRowHeaderWithIdentifier:(NSString*) identifier;

- (ContentGuideViewRow*) dequeueReusableRowWithIdentifier:(NSString*) identifier;

- (void) scrollToRowIndex:(NSUInteger) rowIndex animated:(BOOL) animated;

/** Causes the content guide view to reload its data from its data source and
 delegate.
 
 Calling this method should maintain the current position (time and row) of the guide
 view.
 */
- (void) reloadData;
/**
 Causes the content guide view to reload its data from its data source and
 delegate.
 */
- (void) holdPositionReloadData;
/**
 Change size of this view
 */
-(void) changeToSize:(CGSize) newSize;
-(void) setBackground:(UIImage*)image;
@end
