//
//  LoadedItemView.m
//  ImageLoader
//
//  Created by Victor Macintosh on 31/05/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "LoadedItemView.h"

@implementation LoadedItemView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat padding = 10.0;
        CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding,
                                                                   padding,
                                                                   frame.size.height - 2 * padding,
                                                                   frame.size.height - 2 * padding)];
        _imageView.layer.cornerRadius = 3.0;
        _imageView.clipsToBounds = YES;
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_imageView];
        [_imageView release];
        
        _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + padding,
                                                              0,
                                                              fullWidth - _imageView.frame.size.width - padding,
                                                              14.0)];
        _urlLabel.center = CGPointMake(_urlLabel.center.x, _imageView.center.y);
        _urlLabel.text = @"Hello world";
        _urlLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        [self addSubview:_urlLabel];
        [_urlLabel release];
    }
    return self;
}

- (void)dealloc {
    _imageView = nil;
    _urlLabel = nil;
    [super dealloc];
}

@end
