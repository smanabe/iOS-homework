//
//  FocusViewController.m
//  ThumbnailFocus
//
//  Created by 鄭 基旭 on 2013/04/18.
//  Copyright (c) 2013年 鄭 基旭. All rights reserved.
//

#import "FocusViewController.h"

static NSTimeInterval const kDefaultOrientationAnimationDuration = 0.4;

@interface FocusViewController ()
@property (nonatomic, assign) UIDeviceOrientation previousOrientation;
@end

#warning 「⬇ Answer：」マークがあるラインにコメントで簡単な解説文を書いてください。

@implementation FocusViewController

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mainImageView = nil;
    self.contentView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // ⬇Answer：
    //画面の遷移を感知した場合、orientationDidChangeNotificationを発動
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    // ⬇Answer：
    //GeneratingDeviceOrientationNotificationsを発動。画面の向きを取得
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // ⬇Answer：
    //orientationDidChangeNotificationを無効化
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    // ⬇Answer：
    //GeneratingDeviceOrientationNotificationsを無効化
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (NSUInteger)supportedInterfaceOrientations
{
    // ⬇Answer：
    //ホームボタンが下の時
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)isParentSupportingInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch(toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;

        case UIInterfaceOrientationPortraitUpsideDown:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortraitUpsideDown;

        case UIInterfaceOrientationLandscapeLeft:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeLeft;

        case UIInterfaceOrientationLandscapeRight:
            return [self.parentViewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscapeRight;
    }
}


/////////////////////////////////////////////////////////////
// ⬇Answer： 次の関数は回転時のアニメーションを担当しています。
//　82ラインから140ラインまで、すべてのラインにコメントを書いてください。
/////////////////////////////////////////////////////////////
- (void)updateOrientationAnimated:(BOOL)animated
{
    CGAffineTransform transform;
    NSTimeInterval duration = kDefaultOrientationAnimationDuration;

    if([UIDevice currentDevice].orientation == self.previousOrientation)
        return;

    if((UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsLandscape(self.previousOrientation))
       || (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation) && UIInterfaceOrientationIsPortrait(self.previousOrientation)))
    {
        duration *= 2;
    }

    if(([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait)
       || [self isParentSupportingInterfaceOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation]) {
        //画面をもとに戻す
        transform = CGAffineTransformIdentity;
    }else {
        //　画面の向き毎に処理を実装
        switch ([UIDevice currentDevice].orientation){
            //ホームボタンの位置が左の場合
            case UIInterfaceOrientationLandscapeLeft:
                //現在の設定から反時計周り90°回転
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait) {
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }else {
                    //現在の設定から時計回りに90°回転
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }
                break;
            // ホームボタンの位置が右の場合
            case UIInterfaceOrientationLandscapeRight:
                //ホームボタンが下にある場合
                if(self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait) {
                    //現在の設定から時計回り90°回転
                    transform = CGAffineTransformMakeRotation(M_PI_2);
                }else {
                    //現在の設定から反時計回り90°回転
                    transform = CGAffineTransformMakeRotation(-M_PI_2);
                }
                break;
            // ホームボタンの位置が下の場合
            case UIInterfaceOrientationPortrait:
                //画面を元に戻す
                transform = CGAffineTransformIdentity;
                break;
            // ホームボタンの位置が上の場合
            case UIInterfaceOrientationPortraitUpsideDown:
                //時計周りに１８０°回転
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
                
            //画面が下向き
            case UIDeviceOrientationFaceDown:
             
            //画面が上向き
            case UIDeviceOrientationFaceUp:
             
            //向きがわからない場合
            case UIDeviceOrientationUnknown:
                return;
        }
    }

    CGRect frame = CGRectZero;
    if(animated) {
        frame = self.contentView.frame;
        [UIView animateWithDuration:duration
                         animations:^{
                             self.contentView.transform = transform;
                             self.contentView.frame = frame;
                         }];
    }else {
        frame = self.contentView.frame;
        self.contentView.transform = transform;
        self.contentView.frame = frame;
    }
    self.previousOrientation = [UIDevice currentDevice].orientation;
}

#pragma mark - Notifications
// ⬇Answer：こちはいつ呼ばれますか？
// 画面の向きが変わる場合
- (void)orientationDidChangeNotification:(NSNotification *)notification
{
    [self updateOrientationAnimated:YES];
}
@end