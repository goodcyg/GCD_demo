//
//  ZXLog.h
//  TDKTV
//
//  Created by Jackson on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#ifndef __ZXLog_h__
#define __ZXLog_h__

#define ARRAY_LEN(x) (sizeof(x)/sizeof((x)[0]))

#define LOGWHITE(...) YGlogInfo(__LINE__, __FUNCTION__, __FILE__, __VA_ARGS__)

#define YGFILE_NAME2(x) (strrchr(x,'/')?strrchr(x,'/')+1:x)

#define LOG_CALLSTACKSYMBOLS LOG5(@"callStackSymbols:%@", [NSThread callStackSymbols])

//1：输出日志 0：不输出日志
#define YGLOG_TEST 1

//1：打开NSLog 0：关闭NSLog
#define NSLog_TEST 1

#if YGLOG_TEST

#if NSLog_TEST
#define NSLog(...) YGLOG(__VA_ARGS__)
#endif
/**
 lg:YGLOG(@"test")
 */
#define YGLOG(...) printf(">>>>>> %s  ...line:%d fun:%s file:%s\n", [[[NSString stringWithFormat:__VA_ARGS__] stringByReplacingOccurrencesOfString:@"\0" withString:@" "] UTF8String], __LINE__, __FUNCTION__,YGFILE_NAME2(__FILE__))

#define YGLOGX(...) printf(">>>>>> %s  ...line:%d fun:%s file:%s\n", [[[NSString stringWithFormat:__VA_ARGS__] stringByReplacingOccurrencesOfString:@"\0" withString:@" "] UTF8String], __LINE__, __FUNCTION__,YGFILE_NAME2(__FILE__))

/**
 lg:YGLOG2(@"test")
 */
#define YGLOG8(...) NSLog(@"%@",[NSString stringWithFormat:@">>>>>>%@ ...line:%d fun:%s file:%s",[NSString stringWithFormat:__VA_ARGS__],__LINE__, __FUNCTION__,YGFILE_NAME2(__FILE__)])

#define YGLOG11(...)

#else

#define YGLOG11(...) printf(">>>>>> %s  ...line:%d fun:%s file:%s\n", [[[NSString stringWithFormat:__VA_ARGS__] stringByReplacingOccurrencesOfString:@"\0" withString:@" "] UTF8String], __LINE__, __FUNCTION__,YGFILE_NAME2(__FILE__))

#define YGLOG20(...) printf(">>>>>> %s  ...line:%d fun:%s file:%s\n", [[[NSString stringWithFormat:__VA_ARGS__] stringByReplacingOccurrencesOfString:@"\0" withString:@" "] UTF8String], __LINE__, __FUNCTION__,YGFILE_NAME2(__FILE__))

#define YGLOGX(...)

#if NSLog_TEST
#define NSLog(...)
#endif

#define YGLOG(...)
#define YGLOG2(...)
#define YGLOG8(...)
#endif

//#define YGLOGX(...) printf(">>>>>> %s  ...line:%d fun:%s file:%s\n", [[[NSString stringWithFormat:__VA_ARGS__] stringByReplacingOccurrencesOfString:@"\0" withString:@" "] UTF8String], __LINE__, __FUNCTION__,YGFILE_NAME2(__FILE__))

#if YGLOG_TEST //1

static __inline__ void ZXHex_log(void* data, int len, const char* msg)
{
    
    if (!data || !len) {
        return;
    }
    
#if 0
    int length = (len > 5) ? 5 : len;
#else
    int length = len;
#endif
    
    const unsigned char* p = (unsigned char*)data;
    printf("\n\n%s len:%d:", msg, len);
    
    for (int i = 0; i < length; ++i) {
        printf("%02X ", p[i]);
    }
    printf("\n\n");
}


#else
#define ZXHex_log(...)
#endif

#if 0
//常驻内存线程写法

//addPort:添加端口(就是source)  forMode:设置模式
//CFRunLoopSourceRef是事件源（输入源）
//按照官方文档的分类
// Port-Based Sources (基于端口,跟其他线程交互,通过内核发布的消息)
// Custom Input Sources (自定义)
//   Cocoa Perform Selector Sources (performSelector…方法)
//按照函数调用栈的分类
//  Source0：非基于Port的
// Source1：基于Port的
//   Source0: event事件，只含有回调，需要先调用CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop。
//   Source1: 包含了一个 mach_port 和一个回调，被用于通过内核和其他线程相互发送消息,能主动唤醒 RunLoop 的线程。

//两个线程通信：基于端口,跟其他线程交互,通过内核发布的消息，也就是借助内核进行消息通信
//它说明了用户对ui的操作实际上是一种port，会放到一个队列中传到loop，然后由loop交给主线程处理。loop就是一个循环，接受event，传递，继续。主线程是另一个循环，负责事件的处理与界面的显示。

//httpserver
static NSThread* bonjourThread;

+ (void)startBonjourThreadIfNeeded
{
    HTTPLogTrace();
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        HTTPLogVerbose(@"%@: Starting bonjour thread...", THIS_FILE);
        
        bonjourThread = [[NSThread alloc] initWithTarget:self
                                                selector:@selector(bonjourThread)
                                                  object:nil];
        [bonjourThread start];
    });
}

+ (void)bonjourThread
{
    @autoreleasepool {
        
        HTTPLogVerbose(@"%@: BonjourThread: Started", THIS_FILE);
        
        // We can't run the run loop unless it has an associated input source or a timer.
        // So we'll just create a timer that will never fire - unless the server runs for 10,000 years.
        
        [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]
                                         target:self
                                       selector:@selector(donothingatall:)
                                       userInfo:nil
                                        repeats:YES];
        
        
        [[NSRunLoop currentRunLoop] run];
        
        HTTPLogVerbose(@"%@: BonjourThread: Aborted", THIS_FILE);
    }
}

+ (void)executeBonjourBlock:(dispatch_block_t)block
{
    HTTPLogTrace();
    
    NSAssert([NSThread currentThread] == bonjourThread, @"Executed on incorrect thread");
    if (block)
        block();
        }

+ (void)performBonjourBlock:(dispatch_block_t)block
{
    HTTPLogTrace();
    
    [self performSelector:@selector(executeBonjourBlock:)
                 onThread:bonjourThread
               withObject:block
            waitUntilDone:YES];
}

//AFN
+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}


[self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];

[self performSelector:@selector(operationDidPause) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];

//YYKit
/// Network thread entry point.
+ (void)_networkThreadMain:(id)object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.ibireme.yykit.webimage.request"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

/// Global image request network thread, used by NSURLConnection delegate.
+ (NSThread *)_networkThread {
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(_networkThreadMain:) object:nil];
        if ([thread respondsToSelector:@selector(setQualityOfService:)]) {
            thread.qualityOfService = NSQualityOfServiceBackground;
        }
        [thread start];
    });
    return thread;
}

[self performSelector:@selector(_startRequest:) onThread:[self.class _networkThread] withObject:nil waitUntilDone:NO];
[self performSelector:@selector(_cancelOperation) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];

#endif

#endif /* __ZXLog_h__ */
