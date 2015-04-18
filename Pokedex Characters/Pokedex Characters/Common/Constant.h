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
#define FONT_MOVE_ITEM [UIFont fontWithName:@"Arial-BoldMT" size:(IS_IPAD?16.0f:14.0f)]
#define BG_COLOR_MOVE_ITEM_DISABLE [UIColor colorWithRed:153.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define BG_COLOR_MOVE_ITEM_ENABLE [UIColor colorWithRed:0.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
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
#define NAME_XIB_FILE_MORE_APPS_VIEW_CONTROLLER (IS_IPAD?@"iPad_MoreAppsViewController":@"iPhone_MoreAppsViewController")

#define FRAME_PROMO_SLIDES (IS_IPAD?CGRectMake(0, 0, 768, 350):CGRectMake(0, 0, 320, 145))
#define HEIGHT_CONTENT_GUIDE_VIEW_ROW (IS_IPAD?255:175)
#define HEIGHT_CONTENT_GUIDE_VIEW_ROW_HEADER 30
#define WIDTH_POSTER_VIEW (IS_IPAD?167:87)
#define SPACE_BETWEEN_POSTER_VIEWS 10
#define PANDING_TOP_AND_BOTTOM_OF_ROW_HEADER (IS_IPAD?0:0)
#define OFFSET_Y_OF_FIRST_ROW (IS_IPAD?350:145)
#define NUMBER_POSTERS_IN_A_ROW (IS_IPAD?5:3)

#define HEIGHT_NAVIGATION_BAR (IS_IPAD?50:30)
#define WIDTH_DETAIL_PAGE (IS_IPAD?384:320)

#define _orange_color_      [UIColor colorWithRed:1.0 green:133.0/255 blue:27.0/255 alpha:1.0]

#define BANNER_ID_ADMOB @"ca-app-pub-1775449000819183/8868100353"
#define BANNER_DETAIL_ADMOB @"ca-app-pub-1775449000819183/3632763157"
#define INTERSTITIAL_ID_ADMOB @"ca-app-pub-1775449000819183/1344833558"
#define BANNER_SEARCH_ADMOB @"ca-app-pub-1775449000819183/2234925158"
#define LANGUAGE_SETTING_TAG @"LANGUAGE_SETTING_TAG"
#define CONFIG_SETTING_TAG @"CONFIG_SETTING_TAG"
#define CONFIG_URL_APP_1 @"CONFIG_URL_APP_1"
#define STATUS_APP_DEFAUL @"beta2"
#define INSERT_FAVORITE_COLUMN_TAG @"INSERT FAVORITE COLUMN"
#define _DID_RATING_FOR_THIS_APP_ @"_DID_RATING_FOR_THIS_APP_"
#define _msg_rating_ @"Help make Pokedex Guide even\nbetter. Rate us 5 stars!"
#define _msg_rate_it_5_starts_ @"Rate it 5 stars"
#define _msg_remind_me_later_ @"Remind me later"
#define _msg_dismiss_ @"Dismiss"
#endif
