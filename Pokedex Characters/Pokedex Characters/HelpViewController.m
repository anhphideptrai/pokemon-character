//
//  HelpViewController.m
//  Origami Paper Art
//
//  Created by Phi Nguyen on 12/14/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "HelpViewController.h"
#import "SQLiteManager.h"
#import <UIImageView+AFNetworking.h>
@interface HelpViewController (){
    OrigamiHelp *data;
    NSTimer *animationTimer;
    NSInteger currentIndex;
}
@property (strong, nonatomic) IBOutlet UIButton *btClose;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)actionClose:(id)sender;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lbName setText:data.name];
    currentIndex = 0;
    [self.imageView setImageWithURL:[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@", data.images[currentIndex++]] withExtension:@"png"]];
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:.2f target:self selector:@selector(animationHelpsImage) userInfo:nil repeats:YES];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)setIDOrigamiHelp:(NSInteger)iDhelp{
    data = [[SQLiteManager getInstance] getHelpWithId:iDhelp];
}
- (void)animationHelpsImage{
    if (currentIndex == data.images.count) {
        currentIndex = 0;
    }
    [self.imageView setImageWithURL:[[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@", data.images[currentIndex++]] withExtension:@"png"]];
}
- (IBAction)actionClose:(id)sender {
    [animationTimer invalidate];
    animationTimer = nil;
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
