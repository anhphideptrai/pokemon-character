//
//  MoreAppsViewController.m
//  Knots Art
//
//  Created by Phi Nguyen on 2/15/15.
//  Copyright (c) 2015 Duc Thien. All rights reserved.
//

#import "MoreAppsViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MoreAppsData : NSObject
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *linkApp;
@end
@implementation MoreAppsData
@end

@interface MoreAppsViewController (){
    NSMutableArray *arrApps;
}

- (IBAction)actionClose:(id)sender;
@end

@implementation MoreAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    arrApps = [NSMutableArray new];
    MoreAppsData *app = [MoreAppsData new];
    app.img = [UIImage imageNamed:@"ic_draw.png"];
    app.name = @"How To Draw Everything";
    app.desc = @"When you were a child, have you ever wished that you were an artist? Is you a fan of anime, picture and cartoon? Have you ever wished that you can draw those favorite actors?";
    app.linkApp = @"https://itunes.apple.com/app/id948768878";
    [arrApps addObject:app];
    
    app = [MoreAppsData new];
    app.img = [UIImage imageNamed:@"ic_origami.png"];
    app.name = @"Origami Paper Art";
    app.desc = @"Origami (折り紙?, from ori meaning \"folding\", and kami meaning \"paper\" (kami changes to gami due to rendaku) is the art of paper folding, which is often associated with Japanese culture.";
    app.linkApp = @"https://itunes.apple.com/app/id951371381";
    [arrApps addObject:app];
    
    app = [MoreAppsData new];
    app.img = [UIImage imageNamed:@"ic_pokemon.png"];
    app.name = @"Guide For Pokedex";
    app.desc = @"Pokedex Guide is one of my favorite apps. I have been loving Pokemon for ages, I even have some cards physically for my owns.";
    app.linkApp = @"https://itunes.apple.com/app/id929955668";
    [arrApps addObject:app];
    
    app = [MoreAppsData new];
    app.img = [UIImage imageNamed:@"ic_2048.png"];
    app.name = @"Super Heroes 2048";
    app.desc = @"Sure that you have already known about 2048 game. 2048 is a single-player puzzle game created in March 2014 by 19-year-old Italian web developer Gabriele Cirulli. Ya, I know that's a great game so this is an upgraded version of it, Super Heroes 2048.";
    app.linkApp = @"https://itunes.apple.com/app/id976173648";
    [arrApps addObject:app];
    
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
    MoreAppsData *data = arrApps[indexPath.row];
    [cell.textLabel setText:data.name];
    [cell.detailTextLabel setText:data.desc];
    [cell.imageView setImage:data.img];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MoreAppsData *data = arrApps[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.linkApp]];
}
@end
