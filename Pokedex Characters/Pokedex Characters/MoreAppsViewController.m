//
//  MoreAppsViewController.m
//  Knots Art
//
//  Created by Phi Nguyen on 2/15/15.
//  Copyright (c) 2015 Duc Thien. All rights reserved.
//

#import "MoreAppsViewController.h"
#import <UIImageView+AFNetworking.h>
#import "AppDelegate.h"
#import "ConfigManager.h"

@interface MoreAppsViewController (){
    NSArray *arrApps;
}
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitingV;

- (IBAction)actionClose:(id)sender;
@end

@implementation MoreAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    arrApps = [NSArray new];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.moreApps) {
        arrApps = appDelegate.moreApps;
        [_tbView reloadData];
        [_waitingV stopAnimating];
    }else{
        [_tbView setHidden:YES];
        [[ConfigManager getInstance] loadMoreApp:_url_more_apps_ finished:^(BOOL success, NSArray *moreApps) {
            if (success) {
                arrApps = moreApps;
                appDelegate.moreApps = moreApps;
                [_tbView setHidden:NO];
                [_tbView reloadData];
                [_waitingV stopAnimating];
            }
        }];
    }

    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - TableViewControll Delegate + DataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrApps.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPAD?100:70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell.imageView cancelImageRequestOperation];
    [cell.imageView setImage:[UIImage imageNamed:@"ic_more.png"]];
    MoreApp *data = arrApps[indexPath.row];
    [cell.textLabel setText:data.name];
    [cell.detailTextLabel setText:data.descriptionApp];
    [cell.imageView setImageWithURL:[NSURL URLWithString:data.urlImage]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MoreApp *data = arrApps[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.urlItunes]];
}
@end
