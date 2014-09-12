//
//  ContentGuideViewRowCarouselViewPosterView.h
//  TelenorMyTV
//
//  Created by Phi Nguyen on 7/3/14.
//  Copyright (c) 2014 UUX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@class ContentGuideViewRowCarouselViewPosterView;
typedef enum {
    ContentGuideViewRowCarouselViewPosterViewStyleDefault
} ContentGuideViewRowCarouselViewPosterViewStyle;

@protocol ContentGuideViewRowCarouselViewPosterViewDelegate <NSObject>
@optional
- (void) didSelectPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView;
@end

@interface ContentGuideViewRowCarouselViewPosterView : UIView

@property (nonatomic, assign) IBOutlet id <ContentGuideViewRowCarouselViewPosterViewDelegate> delegate;
@property(nonatomic,readonly,copy) NSString *reuseIdentifier;
@property (nonatomic, readonly) NSInteger style;
@property (nonatomic, readwrite) NSInteger index;

- (id) initWithStyle:(ContentGuideViewRowCarouselViewPosterViewStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setFrame:(CGRect)frame;
- (void) setURLImagePoster:(NSString*)strURL placeholderImage:(UIImage *)placeholderImage;
- (void) setImagePoster:(UIImage*) image;
- (void) setHeightTitlePosterView:(CGFloat)height;
- (void) setTextTitlePoster:(NSString*) txtTitle;
- (void) setFontTitlePoster:(UIFont*) font;
@end
