//
//  DetailView.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pokemon.h"
@class DetailView;
@protocol DetailViewDelegate <NSObject>
@optional
- (void)didChangeCurrentPokemon:(DetailView*)detailView withNewPokemon:(Pokemon*)pokemonNew;
@end
@interface DetailView : UIView
@property (nonatomic, assign) IBOutlet id  <DetailViewDelegate> delegate;
- (void)setData:(Pokemon*)pokemon;
@end
