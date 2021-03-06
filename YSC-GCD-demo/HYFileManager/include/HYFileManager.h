//
//  HYFileManager.h
//  HYFileManager
//
//  Created by work on 15/9/30.
//  Copyright © 2015年 Hyyy. All rights reserved.
//


#import <UIKit/UIKit.h>

//! Project version number for HYFileManager.
FOUNDATION_EXPORT double HYFileManagerVersionNumber;

//! Project version string for HYFileManager.
FOUNDATION_EXPORT const unsigned char HYFileManagerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HYFileManager/HYFileManager.h>

@interface HYFileManager : NSObject

#pragma mark - 沙盒目录相关
/**
 沙盒的主目录路径

 @return 沙盒的主目录路径
 */
+ (NSString*)homeDir;
/**
  程序目录，不能存任何东西

 @return  程序目录，不能存任何东西
 */
+ (NSString*)appPath;
/**
 沙盒中Documents的目录路径,保存重要数据,iTunes同步此文件夹中的内容
 @return 沙盒中Documents的目录路径
 */
+ (NSString*)documentsDir;
/**
 沙盒中Library的目录路径

 @return 沙盒中Library的目录路径
 */
+ (NSString*)libraryDir;
/**
 desktop的目录路径

 @return desktop的目录路径
 */
+ (NSString*)desktopDir;
/**
 沙盒中Libarary/Preferences的目录路径,iTunes同步此文件夹中的内容,通常保存应用的设置信息。

 @return 沙盒中Libarary/Preferences的目录路径
 */
+ (NSString*)preferencesDir;

/**
 沙盒中Library/Caches的目录路径,iTunes不会同步此文件夹，适合存储体积大,可以再生非重要数据。
 @return 沙盒中Library/Caches的目录路径,
 */
+ (NSString*)cachesDir;
/**
 沙盒中tmp的目录路径保存应用中的临时文件,iTunes不同步此文件夹,经测试自己的文件保存这里失败,给系统用嘛？？？

 @return 沙盒中tmp的目录路径保存应用中的临时文件
 */
+ (NSString*)tmpDir;

#pragma mark - 遍历文件夹
/**
 文件遍历

 @param path 目录的绝对路径
 @param deep 是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
                       2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 @return 遍历结果数组
 */
+ (NSArray*)listFilesInDirectoryAtPath:(NSString*)path deep:(BOOL)deep;
// 遍历沙盒主目录
+ (NSArray*)listFilesInHomeDirectoryByDeep:(BOOL)deep;
// 遍历Documents目录
+ (NSArray*)listFilesInDocumentDirectoryByDeep:(BOOL)deep;
// 遍历Library目录
+ (NSArray*)listFilesInLibraryDirectoryByDeep:(BOOL)deep;
// 遍历Caches目录
+ (NSArray*)listFilesInCachesDirectoryByDeep:(BOOL)deep;
// 遍历tmp目录
+ (NSArray*)listFilesInTmpDirectoryByDeep:(BOOL)deep;

#pragma mark - 获取文件属性
/**
 根据key获取文件某个属性

 @param path 文件路径
 @param key 属性key
 @return 属性
 */
+ (id)attributeOfItemAtPath:(NSString*)path forKey:(NSString*)key;

/**
 根据key获取文件某个属性(错误信息error)

 @param path 文件路径
 @param key 属性key
 @param error 错误提示
 @return 属性
 */
+ (id)attributeOfItemAtPath:(NSString*)path forKey:(NSString*)key error:(NSError**)error;
/**
 获取文件属性集合

 @param path 文件路径
 @return 字典
 */
+ (NSDictionary*)attributesOfItemAtPath:(NSString*)path;

/**
 获取文件属性集合(错误信息error)

 @param path 文件路径
 @param error 错误提示
 @return 字典
 */
+ (NSDictionary*)attributesOfItemAtPath:(NSString*)path error:(NSError**)error;

#pragma mark - 创建文件(夹)
// 创建多级文件夹
+ (BOOL)createDirectoryAtPath:(NSString*)path;
// 创建文件夹(错误信息error)
+ (BOOL)createDirectoryAtPath:(NSString*)path error:(NSError**)error;
// 创建文件
+ (BOOL)createFileAtPath:(NSString*)path;
// 创建文件(错误信息error)
+ (BOOL)createFileAtPath:(NSString*)path error:(NSError**)error;
// 创建文件，是否覆盖
+ (BOOL)createFileAtPath:(NSString*)path overwrite:(BOOL)overwrite;
// 创建文件，是否覆盖(错误信息error)
+ (BOOL)createFileAtPath:(NSString*)path overwrite:(BOOL)overwrite error:(NSError**)error;
// 创建文件，文件内容
+ (BOOL)createFileAtPath:(NSString*)path content:(NSObject*)content;
// 创建文件，文件内容(错误信息error)
+ (BOOL)createFileAtPath:(NSString*)path content:(NSObject*)content error:(NSError**)error;
// 创建文件，文件内容，是否覆盖
+ (BOOL)createFileAtPath:(NSString*)path content:(NSObject*)content overwrite:(BOOL)overwrite;
// 创建文件，文件内容，是否覆盖(错误信息error)
+ (BOOL)createFileAtPath:(NSString*)path content:(NSObject*)content overwrite:(BOOL)overwrite error:(NSError**)error;
// 获取创建文件时间
+ (NSDate*)creationDateOfItemAtPath:(NSString*)path;
// 获取创建文件时间(错误信息error)
+ (NSDate*)creationDateOfItemAtPath:(NSString*)path error:(NSError**)error;
// 获取文件修改时间
+ (NSDate*)modificationDateOfItemAtPath:(NSString*)path;
// 获取文件修改时间(错误信息error)
+ (NSDate*)modificationDateOfItemAtPath:(NSString*)path error:(NSError**)error;

#pragma mark - 删除文件(夹)
/**
 删除文件

 @param path 文件路径
 @return 成功:YES 失败:NO
 */
+ (BOOL)removeItemAtPath:(NSString*)path;

/**
 删除文件(错误信息error)

 @param path 文件路径
 @param error 错误提示
 @return 成功:YES 失败:NO
 */
+ (BOOL)removeItemAtPath:(NSString*)path error:(NSError**)error;


/**
 清空Caches文件夹

 @return 成功:YES 失败:NO
 */
+ (BOOL)clearCachesDirectory;

/**
 清空tmp文件夹

 @return 成功:YES 失败:NO
 */
+ (BOOL)clearTmpDirectory;

#pragma mark - 复制文件(夹)
/**
 复制文件

 @param path 源文件位置
 @param toPath 新文件位置
 @return 成功:YES 失败:NO
 */
+ (BOOL)copyItemAtPath:(NSString*)path toPath:(NSString*)toPath;

/**
  复制文件(错误信息error)

 @param path 源文件位置
 @param toPath 新文件位置
 @param error 错误提示
 @return 成功:YES 失败:NO
 */
+ (BOOL)copyItemAtPath:(NSString*)path toPath:(NSString*)toPath error:(NSError**)error;

/**
  复制文件，是否覆盖

 @param path 源文件位置
 @param toPath 新文件位置
 @param overwrite 覆盖:YES 否则:NO
 @return 成功:YES 失败:NO
 */
+ (BOOL)copyItemAtPath:(NSString*)path toPath:(NSString*)toPath overwrite:(BOOL)overwrite;

/**
 复制文件，是否覆盖(错误信息error)

 @param path 源文件位置
 @param toPath 新文件位置
 @param overwrite 覆盖:YES 否则:NO
 @param error 错误提示
 @return 成功:YES 失败:NO
 */
+ (BOOL)copyItemAtPath:(NSString*)path toPath:(NSString*)toPath overwrite:(BOOL)overwrite error:(NSError**)error;

#pragma mark - 移动文件(夹) 重命名文件
/**
 移动文件

 @param path 源文件位置
 @param toPath 新文件位置
 @return 成功:YES 失败:NO
 */
+ (BOOL)moveItemAtPath:(NSString*)path toPath:(NSString*)toPath;

/**
 移动文件(错误信息error)

 @param path 源文件位置
 @param toPath 新文件位置
 @param error 错误信息
 @return 成功:YES 失败:NO
 */
+ (BOOL)moveItemAtPath:(NSString*)path toPath:(NSString*)toPath error:(NSError**)error;

/**
 移动文件，是否覆盖

 @param path 源文件位置
 @param toPath 新文件位置
 @param overwrite 覆盖:YES 否则:NO
 @return 成功:YES 失败:NO
 */
+ (BOOL)moveItemAtPath:(NSString*)path toPath:(NSString*)toPath overwrite:(BOOL)overwrite;

/**
 移动文件，是否覆盖(错误信息error)

 @param path 源文件位置
 @param toPath 新文件位置
 @param overwrite 覆盖:YES 否则:NO
 @param error 错误信息
 @return 成功:YES 失败:NO
 */
+ (BOOL)moveItemAtPath:(NSString*)path toPath:(NSString*)toPath overwrite:(BOOL)overwrite error:(NSError**)error;

#pragma mark - 根据URL获取文件名
/**
 根据文件路径获取文件名称，是否需要后缀

 @param path 文件路径
 @param suffix 是否需要后缀
 @return  根据文件路径获取文件名称，是否需要后缀
 */
+ (NSString*)fileNameAtPath:(NSString*)path suffix:(BOOL)suffix;

/**
  获取文件所在的文件夹路径

 @param path 文件路径
 @return  获取文件所在的文件夹路径
 */
+ (NSString*)directoryAtPath:(NSString*)path;

/**
 根据文件路径获取文件扩展类型

 @param path 文件路径
 @return 根据文件路径获取文件扩展类型
 */
+ (NSString*)suffixAtPath:(NSString*)path;


#pragma mark - 判断文件(夹)是否存在
/**
 判断文件路径是否存在

 @param path 文件路径
 @return 存在:YES 否则:NO
 */
+ (BOOL)isExistsAtPath:(NSString*)path;
/**
 判断路径是否为空(判空条件是文件大小为0，或者是文件夹下没有子文件)

 @param path 文件路径
 @return 空:YES 否则:NO
 */
+ (BOOL)isEmptyItemAtPath:(NSString*)path;
/**
 判断路径是否为空(错误信息error)

 @param path 文件路径
 @param error 返回错误
 @return 空:YES 否则:NO
 */
+ (BOOL)isEmptyItemAtPath:(NSString*)path error:(NSError**)error;
/**
 判断目录是否是文件夹

 @param path 文件路径
 @return 是文件夹:YES 否则:NO
 */
+ (BOOL)isDirectoryAtPath:(NSString*)path;
/**
 判断目录是否是文件夹(错误信息error)

 @param path 文件路径
 @param error 返回错误
 @return 是文件夹:YES 否则:NO
 */
+ (BOOL)isDirectoryAtPath:(NSString*)path error:(NSError**)error;
/**
 判断目录是否是文件

 @param path 文件路径
 @return 是文件:YES 否则:NO
 */
+ (BOOL)isFileAtPath:(NSString*)path;
/**
 判断目录是否是文件(错误信息error)

 @param path 文件路径
 @param error 返回错误
 @return 是文件:YES 否则:NO
 */
+ (BOOL)isFileAtPath:(NSString*)path error:(NSError**)error;
/**
 判断目录是否可以执行

 @param path 文件路径
 @return 可执行:YES 否则:NO
 */
+ (BOOL)isExecutableItemAtPath:(NSString*)path;
/**
 判断目录是否可读

 @param path 文件路径
 @return 可读:YES 否则:NO
 */
+ (BOOL)isReadableItemAtPath:(NSString*)path;
/**
 判断目录是否可写

 @param path 文件路径
 @return 可写:YES 否则:NO
 */
+ (BOOL)isWritableItemAtPath:(NSString*)path;

#pragma mark - 获取文件(夹)大小
// 获取目录大小
+ (NSNumber*)sizeOfItemAtPath:(NSString*)path;
// 获取目录大小(错误信息error)
+ (NSNumber*)sizeOfItemAtPath:(NSString*)path error:(NSError**)error;
// 获取文件大小
+ (NSNumber*)sizeOfFileAtPath:(NSString*)path;
// 获取文件大小(错误信息error)
+ (NSNumber*)sizeOfFileAtPath:(NSString*)path error:(NSError**)error;
// 获取文件夹大小
+ (NSNumber*)sizeOfDirectoryAtPath:(NSString*)path;
// 获取文件夹大小(错误信息error)
+ (NSNumber*)sizeOfDirectoryAtPath:(NSString*)path error:(NSError**)error;

// 获取目录大小，返回格式化后的数值
+ (NSString*)sizeFormattedOfItemAtPath:(NSString*)path;
// 获取目录大小，返回格式化后的数值(错误信息error)
+ (NSString*)sizeFormattedOfItemAtPath:(NSString*)path error:(NSError**)error;
// 获取文件大小，返回格式化后的数值
+ (NSString*)sizeFormattedOfFileAtPath:(NSString*)path;
// 获取文件大小，返回格式化后的数值(错误信息error)
+ (NSString*)sizeFormattedOfFileAtPath:(NSString*)path error:(NSError**)error;
// 获取文件夹大小，返回格式化后的数值
+ (NSString*)sizeFormattedOfDirectoryAtPath:(NSString*)path;
// 获取文件夹大小，返回格式化后的数值(错误信息error)
+ (NSString*)sizeFormattedOfDirectoryAtPath:(NSString*)path error:(NSError**)error;
//返回格式化后的数值
+ (NSString*)sizeFormatted:(NSNumber*)size;
//返回格式化后的数值
+ (NSString*)sizeFormatted2:(unsigned long long)size;
#pragma mark - 写入文件内容
/**
 写入文件内容

 @param path 文件路径
 @param content 文件内容
 @return 成功:YES 失败:NO
 */
+ (BOOL)
writeFileAtPath:(NSString*)path
        content:(NSObject*)content;

/**
 写入文件内容(错误信息error)

 @param path 文件路径
 @param content 文件内容
 @param error 错误信息
 @return 成功:YES 失败:NO
 */
+ (BOOL)writeFileAtPath:(NSString*)path content:(NSObject*)content error:(NSError**)error;

@end
