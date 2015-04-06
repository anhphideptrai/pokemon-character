//
//  MoveView.h
//  Pokedex Guide
//
//  Created by Phi Nguyen on 1/18/15.
//  Copyright (c) 2015 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    LEFT_MOVE = 0,
    RIGHT_MOVE = 1,
}MoveDirection;
@protocol MoveViewDelegate <NSObject>
@optional
- (void)shouldMoveCharacterTo:(MoveDirection)move;
- (void)didSelectedLoveIconWith:(BOOL)isLove;
@end
@interface MoveView : UIView
@property (nonatomic, assign) id<MoveViewDelegate> delegate;
-(void)reloadViewWithEnableLeft:(BOOL)enableLeft
                 andEnableRigth:(BOOL)enableRight;
- (void)setLove:(BOOL)isLove;
@end
