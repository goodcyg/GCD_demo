//
//  YGFile.m
//  iKBa
//
//  Created by Jackson on 2018/7/5.
//  Copyright © 2018年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YGFile : NSObject
/**
 视频ID
 */
@property(nonatomic,copy) NSString *videoID;

/**
 视频标题
 */
@property(nonatomic,copy) NSString *title;

/**
 视频后缀名
 */
@property(nonatomic,copy) NSString *suffixName;


/**
 本地保存地址=title+suffixName
 */
@property(nonatomic,copy) NSString *fileName;

/**
 本地保存地址=document+fileName
 */
@property(nonatomic,copy) NSString *filePath;


/**
 Youtube视频解析后的地址
 */
@property(nonatomic,strong) NSURL *videoURL;


/**
 是否解析成功
 YES：成功  NO:失败
 */
@property(nonatomic,assign) BOOL parseResults;

/**
 Youtube视频时间
 */
@property(nonatomic,copy) NSString *duration;
/**
 Youtube视频频道title
 */
@property(nonatomic,copy) NSString *channelTitle;
/**
 Youtube缩略图
 */
@property(nonatomic,strong) NSURL *icon;

/**
 本地文件图标
 */
@property(nonatomic,copy) NSString *image;
/**
  下载开始为了设置等待进度条
 */
@property(nonatomic,assign) BOOL downingProgress;

@property (nonatomic,assign) float progress;

+ (instancetype)fileInfoWithPath:(NSString*)filePath;
@end                        
