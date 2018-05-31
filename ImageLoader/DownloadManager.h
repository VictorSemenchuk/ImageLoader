//
//  DownloadManager.h
//  ImageLoader
//
//  Created by Victor Macintosh on 31/05/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadManager : NSObject

+ (UIImage *)downloadImageWithURL:(NSString *)stringUrl;

@end
