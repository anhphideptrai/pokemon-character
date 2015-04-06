//
//  SQLiteManager.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Pokemon.h"

@interface SQLiteManager : NSObject
+ (SQLiteManager *) getInstance;
- (NSMutableArray*)getPokemonWithAllTypes;
- (NSMutableArray*)getPokemonFavoriteWithAllTypes;
- (NSMutableArray*)getArrPokemonWithSearchKey:(NSString*)searchKey;
- (Pokemon*)getPokemonWithID:(NSString*)iDPokemon;
- (NSMutableArray*)getArrPokemonWithArrID:(NSArray*)arrID;
- (BOOL)updateFavoritePokemon:(Pokemon*)pokemon;
- (BOOL)insertFavoriteColumn;
@end
