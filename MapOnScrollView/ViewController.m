//
//  ViewController.m
//  MapOnScrollView
//
//  Created by hanxiaoming on 16/12/20.
//  Copyright © 2016年 Amap.com. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    UIScrollView *_scrollView;
    int _currentIndex;
    UISegmentedControl *_segmentedControl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _currentIndex = 0;
    
    // segmented
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"首页", @"地图", @"尾页", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0.0, 0.0, 300.0, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedAction:)
               forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setTitleView:segmentedControl];
    _segmentedControl = segmentedControl;
    
    // scroll
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView.delegate = self;
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.bounces = NO;
    _scrollView.bouncesZoom = NO;
    _scrollView.delaysContentTouches = NO;
    _scrollView.clipsToBounds = YES;
    
    [self.view addSubview:_scrollView];
    
    // 添加pan手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    // 设置delegate
    pan.delegate = self;
    [_scrollView addGestureRecognizer:pan];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    _scrollView.frame = self.view.bounds;
    _scrollView.backgroundColor = [UIColor darkGrayColor];
    
    _scrollView.center = self.view.center;
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    a.backgroundColor = [UIColor redColor];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    b.backgroundColor = [UIColor greenColor];
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
    c.backgroundColor = [UIColor blueColor];
    
    MAMapView *map = [[MAMapView alloc] initWithFrame:c.bounds];
    [b addSubview:map];
//
    [_scrollView addSubview:a];
    [_scrollView addSubview:b];
    [_scrollView addSubview:c];
    
    _scrollView.contentSize = CGSizeMake(width * 3, height);
    _scrollView.contentOffset = CGPointMake(0, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offX = scrollView.contentOffset.x;
    
    int idx = round(offX / scrollView.bounds.size.width);
    
    if (idx != _currentIndex)
    {
        _currentIndex = idx;
        [_segmentedControl setSelectedSegmentIndex:_currentIndex];
    }
}

- (void)segmentedAction:(UISegmentedControl *)sender
{
    NSInteger idx = sender.selectedSegmentIndex;
    CGFloat width = _scrollView.frame.size.width * idx;
    [_scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
}

//实现手势处理
- (void)panHandler:(UIPanGestureRecognizer *)gesture
{
//    NSLog(@"vvv %f, %f", [gesture velocityInView:_scrollView].x, [gesture velocityInView:_scrollView].y);
    // 设置触发条件
    if (gesture.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    // 调整滑动手势速度阈值
    if (fabs([gesture velocityInView:_scrollView].x) > 1400)
    {
        // -1 向左，1 向右
        int direction = fabs([gesture velocityInView:_scrollView].x) / [gesture velocityInView:_scrollView].x;
        int validIdx = 1;

        if (_currentIndex == validIdx && !_scrollView.isDecelerating)
        {
            CGFloat width = _scrollView.frame.size.width * (1 - direction);
            [_scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
        }
    }
}

//设置允许和scrollview上pan手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
