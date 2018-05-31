//
//  DownloadManager.m
//  ImageLoader
//
//  Created by Victor Macintosh on 31/05/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

+ (UIImage *)downloadImageWithURL:(NSString *)stringUrl {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

@end
