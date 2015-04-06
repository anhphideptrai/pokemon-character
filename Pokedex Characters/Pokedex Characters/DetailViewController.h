//
//  DetailViewController.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/22/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pokemon.h"
@class DetailViewController;
@protocol DetailViewControllerDelegate <NSObject>
- (void)shouldReloadWhenBackFromDetailPage:(DetailViewController*)detailPage;
@end
@interface DetailViewController : UIViewController
@property(nonatomic,assign) id<DetailViewControllerDelegate> delegate;
- (void)setPokemonForDetail:(NSArray*)pokemons
           withCurrentIndex:(NSInteger)index;
@end
