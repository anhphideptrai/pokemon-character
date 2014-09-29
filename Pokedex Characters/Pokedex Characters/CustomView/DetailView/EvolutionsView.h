//
//  EvolutionsView.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvolutionsView;
@protocol EvolutionsViewDelegate <NSObject>
@optional
- (void)clickEvolutionItem:(NSString*)iDPokemon;
@end
@interface EvolutionsView : UIView
@property (nonatomic, assign) IBOutlet id <EvolutionsViewDelegate> delegate;
- (void) reLoadData:(NSArray*)arrPokemonID;
@end
