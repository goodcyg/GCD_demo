//
//  MBProgressHUD+YG.h
//
//  Created by YG on 14-4-18.
//  Copyright (c) 2014年. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YG)
/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
/**
 *  显示信息
 *
 *  @param message message 信息内容
 *  @param view    显示信息的视图
 *  @param method  方法
 *  @param target  实例类
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view method:(SEL)method onTarget:(id)target;

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  显示成功信息
 *
 *  @text  信息内容
 */
+ (void)showText:(NSString *)text;
/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 */
+ (void)showError:(NSString *)error;
+ (void)showError2:(NSString *)error;
+ (void)showError3:(NSString *)error;
/**
 *  显示成功信息
 *
 *  @param message 成功信息内容
 *
 *  @return 实例
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view;
/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD;

@end
