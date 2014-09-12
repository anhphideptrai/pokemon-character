//
//  BaseStatsView.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseStatsViewDataSource <NSObject>
@end

@interface BaseStatsView : UIView
@property (nonatomic, assign) IBOutlet id  <BaseStatsViewDataSource> dataSource;
@end
