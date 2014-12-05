//
//  DownloadManager.h
//  Pokedex Guide
//
//  Created by Phi Nguyen on 12/5/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DownloadManagerDelegate <NSObject>
- (void)didFinishedDownloadFileWith:(NSURL*)filePath;
@optional
- (void)completePercent:(NSInteger)percent;
@end
@interface DownloadManager : NSObject
@property (nonatomic, assign) id<DownloadManagerDelegate> delegate;
- (void)downloadFileWithUrl:(NSString*)url;
@end
