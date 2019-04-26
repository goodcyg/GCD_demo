//
//  YCPlayList.m
//  iKBa
//
//  Created by Jackson on 2018/7/20.
//  Copyright © 2018年 Jackson. All rights reserved.
//

#import "YCPlayListManger.h"
#import "TCBlobDownload.h"
#import "YGFile.h"
#import <HYFileManager.h>
#import "ZXLog.h"
#import <NSLogger/NSLogger.h>
#import "SVProgressHUD/SVProgressHUD.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "MBProgressHUD/MBProgressHUD+YG.h"


@interface YCPlayListManger()<TCBlobDownloaderDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;
@property(nonatomic,strong) NSMutableArray * playListArray;
/**
 当前播放歌曲索引,管理播放
 */
@property (nonatomic,assign) NSInteger playIndex;
/**
 歌曲在播放列表中序号，解决歌曲允许重复添加的问题，管理序号
 */
@property (nonatomic,assign) NSInteger playID;
@property(nonatomic,strong) NSOperationQueue *parseQueue;
@end
@implementation YCPlayListManger

static YCPlayListManger *_sharedInstance=nil;

+(instancetype)sharedManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [YCPlayListManger new];
        _sharedInstance.playListArray=[NSMutableArray new];
        _sharedInstance.playID=0;
    });
    
    return _sharedInstance;
}
-(void)addFile:(YGFile *)file
{
    if (file) {
        ++_playID;
      
        [_playListArray addObject:file];
       
          Logger(@"%@ add Download",file.title);
         [self startParseVideoURL:file];
    }
   
}
-(BOOL)deleteFileWithID:(NSString *)videoID
{
    for (YGFile *m in _playListArray) {
        if ([m.videoID isEqualToString:videoID]) {
            [_playListArray removeObject:m];
            return YES;
        }
    }

    return NO;
}

-(BOOL)deleteFile:(YGFile *)file
{
    if(!file)
        return NO;
    _playID=0;
    BOOL res= [self deleteFileWithID:file.videoID];
     return res;
}
-(NSInteger)indexOfFile:(YGFile *)file
{
    return [_playListArray indexOfObject:file];
}
-(BOOL)firstFile:(YGFile *)file
{
    YGFile *m=_playListArray.firstObject;
    return  [file isEqual:m];
}

-(BOOL)lastFile:(YGFile *)file
{
    YGFile *m=_playListArray.lastObject;
    return  [file isEqual:m];
}
- (void)exchangeObjectAtIndex:(NSInteger)idx1 withObjectAtIndex:(NSInteger)idx2
{
   
    if (idx1>=0&&idx1<_playListArray.count && idx2<_playListArray.count) {
        [_playListArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }
}
-(YGFile *)getCurrentFile
{
    _playIndex=0;
    return _playListArray.firstObject;
}

-(YGFile *)getNextFile
{
    if (!_playListArray.count) {
        return nil;
    }
   [_playListArray removeObjectAtIndex:0];
   return _playListArray.firstObject;
}
-(YGFile *)getFile:(NSInteger)playIndex
{
    if (_playListArray.count && playIndex>=0 && playIndex<_playListArray.count) {
      return _playListArray[playIndex];
    }
    return nil;
}
-(NSInteger)getCount
{
    return _playListArray.count;
}

-(void)removeAll
{
    _playIndex=0;
    _playID=0;
    NSMutableIndexSet *set=[[NSMutableIndexSet alloc] init];
    for (NSInteger i=0; i<_playListArray.count; ++i) {
        //YGFile *m=_playListArray[i];
    
        [set addIndex:i];
        
    }
    [_playListArray removeObjectsAtIndexes:set];
}
-(NSMutableArray *)getPlayList
{
    return _playListArray;
}
#pragma mark - 视频地址解析部分
-(void)startParseVideoURL:(YGFile *)file
{
    __weak typeof(self) weakSelf = self;
    [self.parseQueue addOperationWithBlock:^{
        [weakSelf startDownFile:file];
    }];
}
-(NSOperationQueue *)parseQueue
{
    if (!_parseQueue) {
        _parseQueue=[[NSOperationQueue alloc] init];
        _parseQueue.maxConcurrentOperationCount=2;
    }
    
    return _parseQueue;
}

#pragma mark - 视频下载部分
-(void)startDownFile:(YGFile *)file
{
    if (!file.videoURL.relativeString.length) {
        return;
    }
    file.progress=0.0;
    file.filePath=[[HYFileManager documentsDir] stringByAppendingPathComponent:file.fileName];
    TCBlobDownloadManager *DownloadManager=[TCBlobDownloadManager sharedInstance];
    TCBlobDownloader *download = [[TCBlobDownloader alloc] initWithURL:file.videoURL
                                                          downloadPath:[HYFileManager documentsDir]
                                                              delegate:self];
    
    [download setFileName: file.fileName];
    //[DownloadManager setMaxConcurrentDownloads:4];
    download.tag=file;
    if ([HYFileManager isExistsAtPath:file.filePath]) {
        [HYFileManager removeItemAtPath:file.filePath];
    }
    //YGLOG(@"%@ ready Download file:%p",file.title,file);
    [DownloadManager startDownload:download];

}
#pragma mark - TCBlobDownloader Delegate
- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
{
    YGFile *file=blobDownload.tag;
    //YGLOG(@"%@ Download file:%p",file.title,file);
    NSInteger index = [self.playListArray indexOfObject:file];
  
    if (downloadFinished) {
        
        NSInteger index = [self.playListArray indexOfObject:blobDownload.tag];
        Logger(@"%@ Download Success ",file.title);
        //[self.hud hideAnimated:YES];
        [SVProgressHUD dismiss];
    }

}
-(MBProgressHUD *)hud
{
    if (_hud==nil) {
        _hud=[MBProgressHUD showMessage:nil];
        _hud.mode=MBProgressHUDModeDeterminate;
    }
    return _hud;
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    YGFile *file=blobDownload.tag;
    file.progress=progress;
    //self.hud.label.text=file.title;
    //self.hud.progress=progress;
    // Logger(@"%@ Downloading ",file.title);
    [SVProgressHUD showProgress:file.progress status:file.title];
    NSInteger index = [self.playListArray indexOfObject:file];
    
}
- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    YGFile *file=blobDownload.tag;
    Logger(@"%@ start Download",file.title);
    //self.hud.label.text=file.title;
    //self.hud.progress=0;
    
    //[SVProgressHUD showProgress:file.progress status:file.title];
 
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{
    if (error) {
        Logger(@"didStopWithErrorerror:%ld %@ Fail:%@",(long)error.code,error.localizedDescription,error.localizedFailureReason);
    }
    
    YGFile *file=blobDownload.tag;
    Logger(@"%@ didStopWithError",file.title);

}
@end
