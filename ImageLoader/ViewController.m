//
//  ViewController.m
//  ImageLoader
//
//  Created by Victor Macintosh on 31/05/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"
#import "LoadedItemView.h"
#import "LoadedGroupItemsView.h"

@interface ViewController ()

@property (retain, nonatomic) NSMutableArray *singleItems;
@property (assign, nonatomic) LoadedGroupItemsView *groupItems;
@property (retain, nonatomic) NSArray *urls;
@property (assign, nonatomic) NSUInteger taskCounter;
@property (assign, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) UIButton *refreshButton;

- (void)setupViews;
- (void)loadContent;
- (void)startLoading;
- (void)setSingleItemsWithImage:(UIImage *)image andUrl:(NSString *)url;
- (void)setGroupItem:(NSArray *)pics;
- (void)checkIfTasksCompleted;

@end

@implementation ViewController

//MARK:- Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.singleItems = [[NSMutableArray alloc] init];
    self.urls = [NSArray arrayWithObjects:
                 @"https://images.unsplash.com/photo-1506642328232-1ea4d3b6ba6f?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=d3f6516fdad9709738200ea5727d5cf6",
                 @"https://images.unsplash.com/photo-1498263382026-c65d01dad017?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=39dfa4588454cba293783e9f5d45f969",
                 @"https://dingo.care2.com/pictures/greenliving/uploads/2018/04/Forest-trail.jpg",
                 @"https://images.pexels.com/photos/257360/pexels-photo-257360.jpeg?auto=compress&cs=tinysrgb&h=350",
                 @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHM3bc2tzq2nd7jcBrg-dESfSVFyotDvSKi-Z_hBi4_W8AJaOBg",
                 @"https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&h=350",
                 nil];
    
    [self setupViews];
    [self startLoading];

}

- (void)setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGFloat padding = 20.0;
    CGFloat height = 40.0;
    CGFloat parentWidth = self.view.frame.size.width;
    CGFloat parentHeight = self.view.frame.size.height;
    CGRect buttonFrame = CGRectMake(padding,
                                    parentHeight - height - padding,
                                    parentWidth - 2 * padding,
                                    height);
    self.refreshButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.refreshButton.backgroundColor = UIColor.redColor;
    [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    self.refreshButton.layer.cornerRadius = 3.0;
    self.refreshButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [self.refreshButton addTarget:self
               action:@selector(startLoading)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.refreshButton];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = UIColor.blueColor;
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
}

//MARK:- Loading

- (void)startLoading {
    for(UIView *item in self.singleItems) {
        [item removeFromSuperview];
    }
    self.taskCounter = 4;
    [self.groupItems removeFromSuperview];
    [self.activityIndicator startAnimating];
    self.refreshButton.enabled = NO;
    [self.singleItems removeAllObjects];
    [self loadContent];
}

- (void)loadContent {
    
    dispatch_queue_t firstQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for(int i = 0; i < 3; i++) {
        NSString *url = self.urls[i];
        ViewController * __weak weakSelf = self;
        dispatch_async(firstQueue, ^{
            UIImage *img = [DownloadManager downloadImageWithURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setSingleItemsWithImage:(UIImage *)img andUrl:(NSString *)url];
                [weakSelf checkIfTasksCompleted];
            });
        });
    }
    
    dispatch_queue_t secondQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *pics = [[NSMutableArray alloc] init];
    
    for(int i = 3; i < 6; i++) {
        dispatch_group_async(group, secondQueue, ^{
            NSString *url = self.urls[i];
            [pics addObject:[DownloadManager downloadImageWithURL:url]];
        });
    }

    __block ViewController *weakSelf = self;
    dispatch_group_notify(group, secondQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setGroupItem:pics];
            [weakSelf checkIfTasksCompleted];
        });
    });
    
    [pics release];
    dispatch_release(group);
    dispatch_release(firstQueue);
    dispatch_release(secondQueue);
    
}

//MARK:- Set loaded info

- (void)setSingleItemsWithImage:(UIImage *)image andUrl:(NSString *)url {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 100.0;
    CGFloat x = 0;
    CGFloat y = height * self.singleItems.count + 40.0;
    
    LoadedItemView *item = [[LoadedItemView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    item.imageView.image = image;
    item.urlLabel.text = url;
    
    [self.singleItems addObject:item];
    [self.view addSubview:self.singleItems.lastObject];
    [item release];
}

- (void)setGroupItem:(NSArray *)pics {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 100.0;
    CGFloat maxY = 40 + height * 3;
    
    self.groupItems = [[[LoadedGroupItemsView alloc] initWithFrame:CGRectMake(0, maxY, width, height)] autorelease];
    [self.view addSubview:self.groupItems];
    
    for(int i = 0; i < pics.count; i++) {
        [self.groupItems.items[i] setImage:pics[i]];
    }
}

- (void)checkIfTasksCompleted {
    self.taskCounter -= 1;
    if (self.taskCounter == 0) {
        [self.activityIndicator stopAnimating];
        self.refreshButton.enabled = YES;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_singleItems release];
    [_urls release];
    _activityIndicator = nil;
    _refreshButton = nil;
    _groupItems = nil;
    [super dealloc];
}


@end
