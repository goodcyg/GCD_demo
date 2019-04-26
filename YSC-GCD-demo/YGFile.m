//
//  YGFile.m
//  iKBa
//
//  Created by Jackson on 2018/7/5.
//  Copyright © 2018年 Jackson. All rights reserved.
//

#import "YGFile.h"

@interface YGFile ()<NSCopying,NSCoding>

@end
@implementation YGFile

- (instancetype)init
{
    if (self = [super init]) {
        self.title = nil;
        
        self.videoID = nil;
        self.suffixName=nil;
        
        self.fileName=nil;
        self.filePath=nil;
        self.parseResults=NO;
       
        self.duration=nil;
        self.channelTitle=nil;
        self.icon=nil;
        self.image=nil;
        self.videoURL=nil;
        self.downingProgress=NO;
    }
    return self;
}
#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone*)zone
{
    YGFile* m = [[YGFile alloc] init];
    m.title = self.title.copy;

    m.videoID = self.videoID.copy;
    m.suffixName=self.suffixName.copy;
    
    m.filePath=self.filePath.copy;
    m.fileName=self.fileName.copy;
    

    m.parseResults=self.parseResults;
    m.duration=self.duration.copy;
    m.channelTitle=self.channelTitle.copy;
    m.icon=self.icon.copy;
    m.image=self.image.copy;
    m.videoURL=self.videoURL.copy;
    return m;
}
- (id)mutableCopyWithZone:(nullable NSZone*)zone
{
    return [self copyWithZone:zone];
}
#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];


    [aCoder encodeObject:self.videoID forKey:@"videoID"];
    [aCoder encodeObject:self.suffixName forKey:@"suffixName"];
    
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
   
    [aCoder encodeObject:[NSNumber numberWithBool:self.parseResults] forKey:@"parseResults"];
    
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.channelTitle forKey:@"channelTitle"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
     [aCoder encodeObject:self.image forKey:@"image"];
    
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
}
- (nullable instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        
        self.videoID = [aDecoder decodeObjectForKey:@"videoID"];
        self.suffixName= [aDecoder decodeObjectForKey:@"suffixName"];
        
        self.fileName=[aDecoder decodeObjectForKey:@"fileName"];
        self.filePath=[aDecoder decodeObjectForKey:@"filePath"];
        self.parseResults=[[aDecoder decodeObjectForKey:@"parseResults"] boolValue];
        self.duration=[aDecoder decodeObjectForKey:@"duration"];
        self.channelTitle=[aDecoder decodeObjectForKey:@"channelTitle"];
        self.image=[aDecoder decodeObjectForKey:@"image"];
        self.icon=[aDecoder decodeObjectForKey:@"icon"];
        
        self.videoURL=[aDecoder decodeObjectForKey:@"videoURL"];
        
    }
    return self;
}
- (instancetype)initWithPath:(NSString*)filePath
{
    if (self = [super init]) {
         self.filePath = filePath;
         self.fileName=[filePath lastPathComponent];
         self.suffixName=[filePath pathExtension];
    }
    return self;
}
+ (instancetype)fileInfoWithPath:(NSString*)filePath
{
    if (!filePath.length)
        return nil;
    return [[self alloc] initWithPath:filePath];
}
@end
