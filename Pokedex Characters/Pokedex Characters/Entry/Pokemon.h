//
//  Pokemon.h
//  Pokedex Characters
//
//  Created by Phi Nguyen on 8/31/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pokemon : NSObject
@property (nonatomic, strong) NSMutableArray* abilities;
@property (nonatomic, strong) NSString* weight;
@property (nonatomic, strong) NSString* height;
@property (nonatomic, strong) NSString* iD;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* ThumbnailImage;
@property (nonatomic, strong) NSMutableArray* weakness;
@property (nonatomic, strong) NSMutableArray* type;
@property (nonatomic, strong) NSMutableArray* evolutions;
@property (nonatomic, strong) NSMutableArray* baseStats;
@property (nonatomic, strong) NSString* descriptionX;
@property (nonatomic, strong) NSString* descriptionY;
@property (nonatomic) BOOL isFavorite;
@end
