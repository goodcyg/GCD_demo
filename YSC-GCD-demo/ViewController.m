//
//  ViewController.m
//  YSC-GCD-demo
//
//  Created by Walking Boy on 2018/2/13.
//  Copyright © 2018年 Walking Boy. All rights reserved.
//

#import "ViewController.h"
#import "ZXLog.h"
#import "YGUtils+Random.h"
#import "YCPlayListManger.h"
#import "YGFile.h"
#import <HYFileManager.h>

/**
 串行队列（Serial Dispatch Queue）：
 
 每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）
 
 
 并发队列（Concurrent Dispatch Queue）：
 
 可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）

 
 进程：可以理解成一个运行中的应用程序，是系统进行资源分配和调度的基本单位，是操作系统结构的基础，主要管理资源。
 
 线程：是进程的基本执行单元，一个进程对应多个线程。
 
 主线程：处理UI，所有更新UI的操作都必须在主线程上执行。不要把耗时操作放在主线程，会卡界面。
 
 多线程：在同一时刻，一个CPU只能处理1条线程，但CPU可以在多条线程之间快速的切换，只要切换的足够快，就造成了多线程一同执行的假象。
 
 线程就像火车的一节车厢，进程则是火车。车厢（线程）离开火车（进程）是无法跑动的，而火车（进程）至少有一节车厢（主线程）。多线程可以看做多个车厢，它的出现是为了提高效率。 多线程是通过提高资源使用率来提高系统总体的效率。
 
 多线程的四种解决方案分别是：pthread，NSThread，GCD， NSOperation。
 
 pthread：运用C语言，是一套通用的API，可跨平台Unix/Linux/Windows。线程的生命周期由程序员管理。 NSThread：面向对象，可直接操作线程对象。线程的生命周期由程序员管理。 GCD：代替NSThread，可以充分利用设备的多核，自动管理线程生命周期。 NSOperation：底层是GCD，比GCD多了一些方法，更加面向对象，自动管理线程生命周期。
 
 1.NSThread
 每个NSThread对象对应一个线程，真正最原始的线程。
 1）优点：NSThread 轻量级最低，相对简单。
 2）缺点：手动管理所有的线程活动，如生命周期、线程同步、睡眠等。
 
 2.NSOperation
 自带线程管理的抽象类。
 1）优点：自带线程周期管理，操作上可更注重自己逻辑。
 2）缺点：面向对象的抽象类，只能实现它或者使用它定义好的两个子类：NSInvocationOperation 和 NSBlockOperation。
 
 3. GCD Grand Central Dispatch (GCD)是Apple开发的一个多核编程的解决方法。
 1）优点：最高效，避开并发陷阱。
 2）缺点：基于C实现。
 
 5. 选择小结
 1）简单而安全的选择NSOperation实现多线程即可。
 2）处理大量并发数据，又追求性能效率的选择GCD。
 3）NSThread本人选择基本上是在做些小测试上使用，当然也可以基于此造个轮子。
 
 总结
 1.串行队列的特点 任务按顺序执行，一个执行完毕执行下一个任务，无论同步任务或是异步任务，因为串行队列 执行同步任务不开辟线程，执行异步任务开辟最多开辟一条线程，所以必须顺序执行。
 2.并行队列的特点，执行异步任务具备开辟多条线程的能力，执行同步任务，顺序执行。因为没有开辟线程。
 3.开不开线程，取决的任务，同步不开新线程，异步开新线程。
 4.开几个线程取决于队列，串行队列开一条线程，并行队列在执行多个异步任务时会开辟多条线程。
 
 NSOperationQueue 类似于 GCD 中的队列。我们知道 GCD 中的队列有三种：主队列、串行队列和并行队列。NSOperationQueue 更简单，只有两种：主队列和非主队列。
 
 我们自己生成的 NSOperationQueue 对象都是非主队列，主队列可以用 NSOperationQueue.mainQueue 取得。
 
 NSOperationQueue 的主队列是串行队列，而且其中所有 NSOperation 都会在主线程中执行。
 
 对于非主队列来说，一旦一个 NSOperation 被放入其中，那这个NSOperation 一定是并发执行的。因为 NSOperationQueue 会为每一个 NSOperation 创建线程并调用它的 start 方法。
 
 NSOperationQueue 有一个属性叫 maxConcurrentOperationCount，它表示最多支持多少个 NSOperation 并发执行。如果 maxConcurrentOperationCount 被设为 1，就以为这个队列是串行队列。
 
 NSOperationQueue 和 GCD 中的队列有这样的对应关系：
 主队列: NSOperationQueue( NSOperationQueue.mainQueue)==GCD(dispatch_get_main_queue())
 
 串行队列：自建队列NSOperationQueue maxConcurrentOperationCount为1=dispatch_queue_create("com.gcd.test", DISPATCH_QUEUE_SERIAL)
 
 并行队列：自建队列NSOperationQueue maxConcurrentOperationCount大于1=dispatch_queue_create("com.gcd.test2", DISPATCH_QUEUE_CONCURRENT)
 
 NSOperation 实现多线程的使用步骤分为三步：
 
 1.创建操作：先将需要执行的操作封装到一个 NSOperation 对象中。
 2.创建队列：创建 NSOperationQueue 对象。
 3.将操作加入到队列中：将 NSOperation 对象添加到 NSOperationQueue 对象中。
 之后呢，系统就会自动将 NSOperationQueue 中的 NSOperation 取出来，在新线程中执行操作。

 */
@interface GCDMethod:NSObject
@property(nonatomic,copy) NSString *name;
@property (nonatomic,assign) SEL nameSelector;
+(instancetype)method:(NSString *)name nameSelector:(SEL)nameSelector;
@end

@implementation GCDMethod
+(instancetype)method:(NSString *)name nameSelector:(SEL)nameSelector
{
    GCDMethod *m=[[self alloc] init];
    m.name=name;
    m.nameSelector=nameSelector;
    
    return m;
}
@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) UITableView *tableView;
/* 剩余火车票数 */
@property (nonatomic, assign) int ticketSurplusCount;
@property(nonatomic,strong) NSOperationQueue *parseQueue;

@end

@implementation ViewController
{
    dispatch_semaphore_t semaphoreLock;
}

-(void)setupTableView
{
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
-(void)test
{
   [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}

-(NSMutableArray*)nameArray
{
    if (!_nameArray) {
        _nameArray=[NSMutableArray array];
        /* 任务+队列 相关方法 */
        
        //    同步执行 + 并发队列
        //    [self syncConcurrent];
        [_nameArray addObject:[GCDMethod method:@"同步执行 + 并发队列" nameSelector:@selector(syncConcurrent)]];
        
        
        //    异步执行 + 并发队列
        //    [self asyncConcurrent];
        [_nameArray addObject:[GCDMethod method:@"异步执行 + 并发队列" nameSelector:@selector(asyncConcurrent)]];
        
        //    同步执行 + 串行队列
        //    [self syncSerial];
        [_nameArray addObject:[GCDMethod method:@"同步执行 + 串行队列" nameSelector:@selector(syncSerial)]];
        
        //    异步执行 + 串行队列
        //    [self asyncSerial];
          [_nameArray addObject:[GCDMethod method:@"异步执行 + 串行队列" nameSelector:@selector(asyncSerial)]];
        
        //    同步执行 + 主队列（主线程调用）
        //    [self syncMain];
          [_nameArray addObject:[GCDMethod method:@"同步执行 + 主队列（主线程调用）" nameSelector:@selector(syncMain)]];
        
        //    同步执行 + 主队列（其他线程调用）
        //    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
          [_nameArray addObject:[GCDMethod method:@"同步执行 + 主队列（其他线程调用)" nameSelector:@selector(test)]];
        //    异步执行 + 主队列
        //    [self asyncMain];
          [_nameArray addObject:[GCDMethod method:@"异步执行 + 主队列" nameSelector:@selector(asyncMain)]];
        
        /* GCD 线程间通信 */
        
        //    [self communication];
          [_nameArray addObject:[GCDMethod method:@"GCD 线程间通信" nameSelector:@selector(communication)]];
        
        
        /* GCD 其他方法 */
        
        //    栅栏方法 dispatch_barrier_async
        //    [self barrier];
          [_nameArray addObject:[GCDMethod method:@"栅栏方法 dispatch_barrier_async" nameSelector:@selector(barrier)]];
        
        //    延时执行方法 dispatch_after
        //    [self after];
          [_nameArray addObject:[GCDMethod method:@"延时执行方法 dispatch_after" nameSelector:@selector(after)]];
        
        //    一次性代码（只执行一次）dispatch_once
        //    [self once];
        
          [_nameArray addObject:[GCDMethod method:@"一次性代码（只执行一次）dispatch_once" nameSelector:@selector(once)]];
        //    快速迭代方法 dispatch_apply
        //    [self apply];
          [_nameArray addObject:[GCDMethod method:@"快速迭代方法 dispatch_apply" nameSelector:@selector(apply)]];
        
        /* 队列组 gropu */
        //    队列组 dispatch_group_notify
        //    [self groupNotify];
          [_nameArray addObject:[GCDMethod method:@"队列组 dispatch_group_notify" nameSelector:@selector(groupNotify)]];
        
        //    队列组 dispatch_group_wait
        //    [self groupWait];
          [_nameArray addObject:[GCDMethod method:@"队列组 dispatch_group_wait" nameSelector:@selector(groupWait)]];
        
        //    队列组 dispatch_group_enter、dispatch_group_leave
        //    [self groupEnterAndLeave];
          [_nameArray addObject:[GCDMethod method:@"队列组 dispatch_group_enter、dispatch_group_leave" nameSelector:@selector(groupEnterAndLeave)]];
        
        /* 信号量 dispatch_semaphore */
        //    semaphore 线程同步
        //    [self semaphoreSync];
          [_nameArray addObject:[GCDMethod method:@"semaphore 线程同步" nameSelector:@selector(semaphoreSync)]];
        
        //    semaphore 线程安全
        //    非线程安全：不使用 semaphore
        //    [self initTicketStatusNotSave];
          [_nameArray addObject:[GCDMethod method:@"非线程安全：不使用 semaphore" nameSelector:@selector(syncSerial)]];
        
        //    线程安全：使用 semaphore 加锁
        //    [self initTicketStatusSave];
          [_nameArray addObject:[GCDMethod method:@"线程安全：使用 semaphore 加锁" nameSelector:@selector(initTicketStatusSave)]];
        
    }
    
    return _nameArray;
}


#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_ID=@"cell_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_ID];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
     }
    GCDMethod *m=self.nameArray[indexPath.row];
    cell.textLabel.text=m.name;
 
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
     //UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GCDMethod *m=self.nameArray[indexPath.row];
    
    [self performSelector:m.nameSelector];
    //[self performSelector:m.nameSelector withObject:nil];
    
    //((void (*)(id, SEL))[self methodForSelector:m.nameSelector])(self, m.nameSelector);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YGLOG(@"viewDidLoad");
    [self setupTableView];
   
}

#pragma mark - 任务+队列 相关方法

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncSerial---end");
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial
{
    int total=100;
    [HYFileManager removeItemAtPath:[HYFileManager documentsDir]];
    for (int i=0; i<total; ++i) {
        
        YGFile *file=[YGFile new];
        file.title=[NSString stringWithFormat:@"test %d",i];
        file.fileName=[NSString stringWithFormat:@"test_%d.mp4",i];
      
        NSString *str=@"https://r4---sn-i3b7kn7r.googlevideo.com/videoplayback?ipbits=0&lmt=1540969325502049&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&ei=L_-vXK-3H8SOqQHs660g&initcwndbps=3521250&source=youtube&requiressl=yes&ratebypass=yes&ms=au%2Crdu&dur=284.560&clen=16261561&fvip=3&mime=video%2Fmp4&txp=5431432&key=yt6&c=WEB&gir=yes&expire=1555059599&pl=20&mn=sn-i3b7kn7r%2Csn-i3beln7z&ip=35.201.242.24&mm=31%2C29&itag=18&mv=m&mt=1555037896&id=o-AHVs5CHRaSJn_14NpfRxC7St3qU2Kymut1UBWpcrSn7a&signature=49A5FD861A52C997E44626CF1C8ADD5113E1834D.D558A06ADD6554099DBF0C2356FDD9B7FE6930FB";
        file.videoURL=[NSURL URLWithString:str];
        [[YCPlayListManger sharedManger] addFile:file];
        
    }
}
- (void)asyncSerial4 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务1
          int k= random_uniformNumber2(3,10);
           [NSThread sleepForTimeInterval:k];                            // 模拟耗时操作
            NSLog(@"任务1---%@ time:%d",[NSThread currentThread],k);      // 打印当前线程
       
    });
    dispatch_async(queue, ^{
        // 追加任务2
    
        int k= random_uniformNumber2(3,10);
        [NSThread sleepForTimeInterval:k];                           // 模拟耗时操作
        NSLog(@"任务2---%@ time:%d",[NSThread currentThread],k);      // 打印当前线程
       
    });
    dispatch_async(queue, ^{
        // 追加任务3
      
        int k= random_uniformNumber2(3,10);
        [NSThread sleepForTimeInterval:k];                           // 模拟耗时操作
        NSLog(@"任务3---%@ time:%d",[NSThread currentThread],k);      // 打印当前线程
       
    });
    
    NSLog(@"asyncSerial---end");
}

- (void)asyncSerial2 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"任务1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"任务2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"任务3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
}


#pragma mark - 线程间通信

/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}


#pragma mark - GCD 其他相关方法

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

#pragma mark - dispatch_group 队列组

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
    
}

/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
//    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//
//    NSLog(@"group---end");
}

#pragma mark - semaphore 线程同步

/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %zd",number);
}

#pragma mark - semaphore 线程安全
/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {
    while (1) {
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}

/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}

@end
