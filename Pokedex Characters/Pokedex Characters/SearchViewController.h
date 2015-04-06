//
//  SearchViewController.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/8/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentGuideView.h"
@protocol SearchViewControllerDelegate <NSObject>
@optional
- (void)shouldReloadParrentViewWhenBackFromSearchPage;
@end
@interface SearchViewController : UIViewController <ContentGuideViewDataSource, ContentGuideViewDelegate, UISearchBarDelegate>
@property (nonatomic, assign) id<SearchViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet ContentGuideView *contentGuideView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
