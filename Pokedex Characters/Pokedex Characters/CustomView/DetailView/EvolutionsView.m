//
//  EvolutionsView.m
//  Pokedex Characters
//
//  Created by Phi Nguyen on 9/12/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "EvolutionsView.h"

@interface EvolutionsView()
@end

@implementation EvolutionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(void) initCommon{
    
}

#pragma mark -- Layout methods
-(void) layoutSubviews{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    [CATransaction setDisableActions:YES];
    
    [CATransaction commit];
}
@end
