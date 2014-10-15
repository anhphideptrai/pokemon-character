//
//  Constant.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#ifndef Pokedex_Characters_Constant_h
#define Pokedex_Characters_Constant_h
/*
 ** START - CONSTANT OF CONTENT GUIDE VIEWS
 */
#define BACKGROUND_COLOR_ROWHEADER [UIColor colorWithRed:37.0f/255.0f green:64.0f/255.0f blue:68.0f/255.0f alpha:1.0f]
#define BACKGROUND_COLOR_CONTENTGUIDEVIEW [UIColor colorWithRed:25.0f/255.0f green:38.0f/255.0f blue:44.0f/255.0f alpha:1.0f]
#define PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT 10
#define HEIGHT_TITLE_POSTER_DEFAULT 50
#define TEXT_COLOR_TITLE_POSTER_DEFAULT [UIColor colorWithRed:220.0f/255.0f green:198.0f/255.0f blue:152.0f/255.0f alpha:1.0f]
#define TEXT_COLOR_RIGHT_LABEL_POSTER_DEFAULT [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
#define FONT_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Arial-BoldMT" size:14.0f]
#define FONT_RIGHT_LABEL_POSTER_DEFAULT [UIFont fontWithName:@"ArialMT" size:(IS_IPAD?14.0f:12.0f)]
#define FONT_TITLE_ROW_HEADER_DEFAULT [UIFont fontWithName:@"Arial-BoldMT" size:20.0f]
#define TIME_AUTO_SCROLLING_PROMOSLIDES_DEFAULT 8
/*
 ** END - CONSTANT OF CONTENT GUIDE VIEWS
 */

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

#define NAME_XIB_FILE_MAIN_VIEW_CONTROLLER (IS_IPAD?@"iPad_MainViewController":@"iPhone_MainViewController")
#define NAME_XIB_FILE_SEARCH_VIEW_CONTROLLER (IS_IPAD?@"iPad_SearchViewController":@"iPhone_SearchViewController")
#define NAME_XIB_ANIMATION_MENU_VIEW_CONTROLLER (IS_IPAD?@"iPad_AnimationMenuCustom":@"iPhone_AnimationMenuCustom")

#define FRAME_PROMO_SLIDES (IS_IPAD?CGRectMake(0, 0, 768, 350):CGRectMake(0, 0, 320, 145))
#define HEIGHT_CONTENT_GUIDE_VIEW_ROW (IS_IPAD?255:175)
#define HEIGHT_CONTENT_GUIDE_VIEW_ROW_HEADER 30
#define WIDTH_POSTER_VIEW (IS_IPAD?167:87)
#define SPACE_BETWEEN_POSTER_VIEWS 10
#define PANDING_TOP_AND_BOTTOM_OF_ROW_HEADER (IS_IPAD?0:0)
#define OFFSET_Y_OF_FIRST_ROW (IS_IPAD?350:145)

#define HEIGHT_NAVIGATION_BAR (IS_IPAD?50:30)
#define WIDTH_DETAIL_PAGE (IS_IPAD?384:320)

#define BANNER_ID_ADMOB @"ca-app-pub-1775449000819183/8868100353"
#define INTERSTITIAL_ID_ADMOB @"ca-app-pub-1775449000819183/1344833558"

#endif
