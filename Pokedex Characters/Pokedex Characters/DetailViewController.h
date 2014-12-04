//
//  DetailViewController.h
//  Pokedex Guide
//
//  Created by Phi Nguyen on 12/4/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lbSteps;
- (IBAction)actionBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end
