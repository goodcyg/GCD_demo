//
//  MBProgressHUD+YG.m
//
//  Created by YG on 14-4-18.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MBProgressHUD+YG.h"


@implementation MBProgressHUD (YG)

+ (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [self frontWindow];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.square = NO;
    if (icon.length) {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(icon)]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
    }
    else
    {
        hud.mode =MBProgressHUDModeText;
    }
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}
+ (void)show2:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [self frontWindow];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    hud.square = NO;
    if (icon.length) {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(icon)]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
    } else
    {
        hud.mode =MBProgressHUDModeText;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
   [hud hideAnimated:YES afterDelay:3.0];
}
+ (void)show3:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [self frontWindow];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.transform=CGAffineTransformMakeRotation(M_PI_2);
    hud.detailsLabel.text = text;
    hud.square = NO;
    if (icon.length) {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(icon)]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
    } else
    {
        hud.mode =MBProgressHUDModeText;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:3.0];
}

#pragma mark 显示错误信息
/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error.png" view:view];
}
+ (void)showError2:(NSString *)error toView:(UIView *)view {
    [self show2:error icon:@"error.png" view:view];
}
+ (void)showError3:(NSString *)error toView:(UIView *)view {
    [self show3:error icon:@"error.png" view:view];
}
/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
/**
 *  显示信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [self frontWindow];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (message)
    {
        hud.label.text = message;
    }
    hud.square = NO;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //hud.backgroundView.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    return hud;
}
/**
 *  显示信息
 *
 *  @param message message 信息内容
 *  @param view    显示信息的视图
 *  @param method  方法
 *  @param target  实例类
 */
+ (void)showMessage:(NSString *)message
             toView:(UIView *)view
             method:(SEL)method
           onTarget:(id)target {
    if (view == nil) {
        view = [self frontWindow];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    if (message)
    {
        hud.label.text = message;
    }
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //hud.backgroundView.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    hud.animationType = MBProgressHUDAnimationZoomIn;
    // Regiser for HUD callbacks so we can remove it from the window at the right
    // time
    hud.delegate = target;
    
    // Show the HUD while the provided method executes in a new thread
   //[hud showWhileExecuting:method onTarget:target withObject:nil animated:YES];
 }
/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success {
    if (success.length) {
        [self showSuccess:success toView:nil];
    }
}

/**
显示成功信息

 @param text 信息内容
 */
+ (void)showText:(NSString *)text
{
    [self show:text icon:nil view:nil];
}
/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 */
+ (void)showError:(NSString *)error {
    if (error.length) {
        [self showError:error toView:nil];
    }
}
+ (void)showError2:(NSString *)error {
    if (error.length) {
        [self showError2:error toView:nil];
    }
}
+ (void)showError3:(NSString *)error {
    if (error.length) {
        [self showError3:error toView:nil];
    }
}
/**
 *  显示成功信息
 *
 *  @param message 成功信息内容
 *
 *  @return 实例
 */
+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}
/**
 *  手动关闭MBProgressHUD
 */

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
