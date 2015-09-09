//
//  ViewController.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentGuideView.h"
#import <RZSquaresLoading.h>

@interface ViewController : UIViewController <ContentGuideViewDataSource, ContentGuideViewDelegate>
@property (strong, nonatomic) IBOutlet ContentGuideView *contentGuideView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet RZSquaresLoading *squaresLoading;
@property (strong, nonatomic) IBOutlet UILabel *lbDownloading;

@end
