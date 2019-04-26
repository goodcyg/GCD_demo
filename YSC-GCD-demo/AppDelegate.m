//
//  AppDelegate.m
//  YSC-GCD-demo
//
//  Created by Walking Boy on 2018/2/13.
//  Copyright © 2018年 Walking Boy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+YG.h"


@interface YGWindow:UIWindow
@property(nonatomic,copy) NSString *name;
@end

@implementation YGWindow
@end

@interface AppDelegate ()
@property(strong, nonatomic) YGWindow *normalWindow;
@property(strong, nonatomic) YGWindow *coverStatusBarWindow;
@property(strong, nonatomic) YGWindow *alertWindow;
@end

@implementation AppDelegate

#if  0
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController=[[UINavigationController alloc] initWithRootViewController: [ViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}
#else
- (void)coverWindowOnClicked{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kOnClickedStatusBarNotification" object:self userInfo:nil];
    YGWindow *win=(YGWindow *)[UIApplication sharedApplication].keyWindow;
    win=[UIApplication sharedApplication].windows.lastObject;
    //win=[self frontWindow2];
    NSLog(@"coverWindowOnClicked MBProgressHUD show:%@:%p",win,win);
    if (win) {
        MBProgressHUD *hud=[MBProgressHUD showMessage:@"测试keywindow" toView:win];
        [hud hideAnimated:YES afterDelay:2];
    }
    [SVProgressHUD showSuccessWithStatus:@"测试keywindow"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan ---");
    
}
-(void)addLabel:(NSString*)msg win:(YGWindow *)win
{
    UILabel *w=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
    w.text=msg;
    w.textColor=[UIColor whiteColor];
    [win addSubview:w];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGFloat snwidth=[UIScreen mainScreen].bounds.size.width;
    CGFloat snheight=[UIScreen mainScreen].bounds.size.height;
    CGFloat step=40;
    //1.
    self.window = [[YGWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blueColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    self.window.windowLevel = UIWindowLevelNormal;
    self.window.name=[NSString stringWithFormat:@"1 window windowLevel:%0.0f",self.window.windowLevel];
    [self addLabel:self.window.name win:self.window];
    
    NSLog(@"%@:%p keyWindowLevel:%0.0f",self.window.name,self.window,[UIApplication sharedApplication].keyWindow.windowLevel);
    
    //2.
    YGWindow *normalWindow = [[YGWindow alloc] initWithFrame:CGRectMake(0, step, snwidth, snheight-step-20)];
    normalWindow.backgroundColor = [UIColor purpleColor];
    normalWindow.windowLevel = UIWindowLevelNormal+1;
    normalWindow.rootViewController = [[UIViewController alloc]init];
    //normalWindow.hidden=NO;
    [normalWindow makeKeyAndVisible];
    self.normalWindow = normalWindow;
    self.normalWindow.name=[NSString stringWithFormat:@"2 normalWindow windowLevel:%0.0f",self.normalWindow.windowLevel];
    [self addLabel:self.normalWindow.name win:self.normalWindow];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(10, 164, 200, 20);
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.text=@"normalWindow";
    [self.normalWindow addSubview:tf];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverWindowOnClicked)];
    [self.normalWindow addGestureRecognizer:tap1];
    
    
    NSLog(@"%@:%p keyWindowLevel:%0.0f",self.normalWindow.name,self.normalWindow,[UIApplication sharedApplication].keyWindow.windowLevel);
    
    //3. 创建覆盖着状态栏的window
    YGWindow * coverStatusBarWindow =[[YGWindow alloc]initWithFrame:CGRectMake(0, step*2, snwidth, snheight-step*3-10)];
    coverStatusBarWindow.rootViewController = [[UIViewController alloc] init];
    coverStatusBarWindow.backgroundColor = [UIColor redColor];
    coverStatusBarWindow.hidden=NO;
    
    //级别要比 状态栏的级别高
    coverStatusBarWindow.windowLevel =UIWindowLevelStatusBar+1;
    [coverStatusBarWindow makeKeyAndVisible];
    self.coverStatusBarWindow = coverStatusBarWindow;
    self.coverStatusBarWindow.name=[NSString stringWithFormat:@"3 statusBarWindow windowLevel:%0.0f",self.coverStatusBarWindow.windowLevel];
    [self addLabel:self.coverStatusBarWindow.name win:self.coverStatusBarWindow];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverWindowOnClicked)];
    [self.coverStatusBarWindow addGestureRecognizer:tap];
    //想移除coverStatusBarWindow 将其赋值为空
    //     self.coverStatusBarWindow = nil;
    NSLog(@"%@:%p keyWindowLevel:%0.0f",self.coverStatusBarWindow.name,self.coverStatusBarWindow,[UIApplication sharedApplication].keyWindow.windowLevel);
    
    
    // 4.创建UIwindow1
    self.alertWindow = [[YGWindow alloc] initWithFrame:CGRectMake(0, step*3, snwidth, snheight-step*4-30)];
    self.alertWindow.backgroundColor = [UIColor orangeColor];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    self.alertWindow.hidden=NO;
    self.alertWindow.windowLevel = UIWindowLevelAlert+1;
    //[self.alertWindow makeKeyAndVisible];
    self.alertWindow.name=[NSString stringWithFormat:@"4 alertWindow windowLevel:%0.0f",self.alertWindow.windowLevel];
    
    [self addLabel:self.alertWindow.name win:self.alertWindow];
    
    // 给UIwindow1添加一个输入框
    UITextField *tf1 = [[UITextField alloc] init];
    tf1.frame = CGRectMake(10, 100, 200, 40);
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.text=@"alertWindow";
    [self.alertWindow addSubview:tf1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverWindowOnClicked)];
    [self.alertWindow addGestureRecognizer:tap2];
    
    
    NSLog(@"%@:%p keyWindowLevel:%0.0f",self.alertWindow.name,self.alertWindow,[UIApplication sharedApplication].keyWindow.windowLevel);
    for (YGWindow *window in [UIApplication sharedApplication].windows) {
        NSLog(@"----windows %@ %p",window.name,window);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        YGWindow *win=(YGWindow *)[UIApplication sharedApplication].keyWindow;
        win=[UIApplication sharedApplication].windows.lastObject;
        //win=[self frontWindow2];
        NSLog(@"MBProgressHUD show:%@:%p",win.name,win);
        if (win) {
            MBProgressHUD *hud=[MBProgressHUD showMessage:@"测试keywindow" toView:win];
            [hud hideAnimated:YES afterDelay:2];
        }
        [SVProgressHUD showSuccessWithStatus:@"测试keywindow"];
    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    return YES;
}

-(YGWindow *)frontWindow {
    YGWindow *win=nil;
    NSArray *frontToBackWindows = UIApplication.sharedApplication.windows;
    for (YGWindow *window in frontToBackWindows) {
        NSLog(@"show:%p windowLevel:%0.2f",window,window.windowLevel);
        if (win==nil) {
            win=window;
        }
        if (window.windowLevel>win.windowLevel)
            win=window;
    }
    return win;
}

-(YGWindow *)frontWindow2 {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (YGWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = window.windowLevel >= UIWindowLevelNormal;
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return [UIApplication sharedApplication].windows.lastObject;
}
- (void)keyBoardShow:(NSNotification *)notif{
    
    NSLog(@"windows 键盘弹出 ---%@",[UIApplication sharedApplication].windows);
    
    NSLog(@"键盘弹出 keywindow:%@ windowLevel%0.0f",[UIApplication sharedApplication].keyWindow,[UIApplication sharedApplication].keyWindow.windowLevel);
}


#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
