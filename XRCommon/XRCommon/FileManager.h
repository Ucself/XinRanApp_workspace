//
//  FileManager.h
//  XinRanApp
//
//  Created by tianbo on 14-12-10.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

/*
 @desc 判断应用的Documents文件夹下是否存在某个文件;
 @param fileName_; -- 文件名
 @return BOOL;
 */
+(BOOL)fileExistAtDocumentsDirectory:(NSString *)fileName;

/*
 @desc 获取Documents文件夹下某个文件的完整路径;
 @param fileName_; -- 文件名
 @return 文件的完整路径;
 */
+(NSString *)fileFullPathAtDocumentsDirectory:(NSString *)fileName;


/*
 @desc 文件写入，路径默认为Documents文件夹下的完整路径;
 @param fileData_; -- 需要写入的文件数据,可以为NSString、NSData
 @param fileName_; -- 保存的文件名
 @return 是否成功;
 */
+(BOOL)writeToFile:(id)fileData_ fileName:(NSString *)fileName;

/*
 @desc 删除Documents文件夹下的某一文件;
 @param _fileName; -- 要删除的文件名
 @return 是否成功;
 */
+(BOOL)deleteFileAtDocumentsDirectory:(NSString *)fileName;

/*
 @desc 删除Documents文件夹下的所有文件;
 @return 是否成功;
 */
+(BOOL)deleteAllFilesAtDocumentsDirectory;
/*
 @desc 删除/Library/Caches/ImageCache;
 */
+(void)deleteImageCacheAtLibrary;
@end
