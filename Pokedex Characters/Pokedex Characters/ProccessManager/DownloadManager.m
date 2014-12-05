//
//  DownloadManager.m
//  Pokedex Guide
//
//  Created by Phi Nguyen on 12/5/14.
//  Copyright (c) 2014 Duc Thien. All rights reserved.
//

#import "DownloadManager.h"
#import <AFNetworking.h>
#import "Utils.h"
#define FRACTION_COMPLETED @"fractionCompleted"

@implementation DownloadManager
- (void)downloadFileWithUrl:(NSString*)strUrl{
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishedDownloadFileWith:)]) {
            [self.delegate didFinishedDownloadFileWith:filePath];
        }
        [progress removeObserver:self forKeyPath:FRACTION_COMPLETED context:NULL];
        
    }];
    [downloadTask resume];
    [progress addObserver:self
               forKeyPath:FRACTION_COMPLETED
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:FRACTION_COMPLETED]) {
        NSProgress *progress = (NSProgress *)object;
        int percentCompledted = (int)(progress.fractionCompleted * 100);
        NSLog(@"Progress… %d", percentCompledted);
        if (self.delegate && [self.delegate respondsToSelector:@selector(completePercent:)]) {
            [self.delegate completePercent:percentCompledted];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
