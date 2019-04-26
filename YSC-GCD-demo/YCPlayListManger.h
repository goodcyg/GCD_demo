//
//  YCPlayList.h
//  iKBa
//
//  Created by Jackson on 2018/7/20.
//  Copyright © 2018年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGFile;
@interface YCPlayListManger : NSObject

+(instancetype)sharedManger;
-(void)addFile:(YGFile *)file;
-(BOOL)deleteFileWithID:(NSString *)videoID;
-(BOOL)deleteFile:(YGFile *)file;
-(NSInteger)indexOfFile:(YGFile *)file;
-(BOOL)firstFile:(YGFile *)file;
-(BOOL)lastFile:(YGFile *)file;

/**
 交换数组元素位置
 @param idx1 需要交换位置的元素位置, 比如例子里写的是0, 那么就是@"One"这个元素需要换到别的地方去.
 @param idx2 被交换位置的元素位置, 比如例子写的是2, 那么@"Three"的位置就会被交换.
  NSMutableArray *array =@[@"ONE",@"TWO",@"THREE"];
  [array exchangeObjectAtIndex:0 withObjectAtIndex:2];
 array =@[@"THREE",@"TWO",@"ONE"];
 */
- (void)exchangeObjectAtIndex:(NSInteger)idx1 withObjectAtIndex:(NSInteger)idx2;
/**
 返回第一首歌曲
 @return  返回第一首歌曲
 */
-(YGFile *)getCurrentFile;
/**
 返回下一首歌曲
 @return  返回下一首歌曲
 */
-(YGFile *)getNextFile;

-(YGFile *)getFile:(NSInteger)playIndex;

/**
 返回播放列表中的数量

 @return 返回数量
 */
-(NSInteger)getCount;

/**
 删除所有
 */
-(void)removeAll;

-(NSMutableArray *)getPlayList;
@end
