//
//  SVSViewController.m
//  scrollViewSample
//
//  Created by 武田 祐一 on 2013/04/19.
//  Copyright (c) 2013年 武田 祐一. All rights reserved.
//

#import "SVSViewController.h"

@interface SVSViewController ()

@end

@implementation SVSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    UIImage *image = [UIImage imageNamed:@"big_image.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    
    [scrollView addSubview:imageView];
    
    scrollView.contentSize = imageView.frame.size;
    
    scrollView.maximumZoomScale = 3.0; // 最大倍率
    scrollView.minimumZoomScale = 0.5; // 最小倍率
    
    scrollView.delegate = self;
    
    // 一番上までスクロール
    // [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    // スクロール
    // スクロール
    CGPoint startpoint = [scrollView contentOffset];
    NSLog(@"startpoint:%@", NSStringFromCGPoint(startpoint));
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [scrollView setContentOffset:CGPointMake(300, 100)];
    [UIView commitAnimations];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    return nil;
}

// スクロール中に呼ばれる
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentPoint = [scrollView contentOffset];
    // NSLog(@"X:%f Y:%f", currentPoint.x, currentPoint.y);
    NSLog(@"currentPoint:%@", NSStringFromCGPoint(currentPoint));
}

// ドラッグが終了した時に呼ばれる
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

// 画面が静止したときに呼ばれる
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
