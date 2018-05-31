//
//  LoadedGroupItemsView.m
//  ImageLoader
//
//  Created by Victor Macintosh on 31/05/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "LoadedGroupItemsView.h"

@implementation LoadedGroupItemsView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        
        CGFloat padding = 10.0;
        CGFloat height = frame.size.height;
        CGFloat width = [[UIScreen mainScreen] bounds].size.width / 3;
        
        for (int i = 0; i < 3; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(width * i + padding, 0, width - 2 * padding, height)];
            image.layer.cornerRadius = 3.0;
            image.clipsToBounds = YES;
            [image setContentMode:UIViewContentModeScaleAspectFill];
            [_items addObject:image];
            [self addSubview:image];
            [image release];
        }
    }
    return self;
}

- (void)dealloc {
    [_items release];
    [super dealloc];
}

@end
