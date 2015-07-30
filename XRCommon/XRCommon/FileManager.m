//
//  FileManager.m
//  XinRanApp
//
//  Created by tianbo on 14-12-10.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+(BOOL)fileExistAtDocumentsDirectory:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:fileName]];
}

+(NSString *)fileFullPathAtDocumentsDirectory:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(BOOL)writeToFile:(id)fileData_ fileName:(NSString *)fileName{
    NSString *path = [self fileFullPathAtDocumentsDirectory:fileName];
    
    if ([fileData_ isKindOfClass:[NSString class]]) {
        return [fileData_ writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    if ([fileData_ isKindOfClass:[NSData class]]) {
        return [fileData_ writeToFile:path atomically:NO];
    }
    if ([fileData_ isKindOfClass:[NSDictionary class]]) {
        return [fileData_ writeToFile:path atomically:NO];
    }
    
    DBG_MSG(@"wirte file '%@'failed!", fileName);
    return NO;
}

+(BOOL)deleteFileAtDocumentsDirectory:(NSString *)fileName
{
    if ([self fileExistAtDocumentsDirectory:fileName]) {
        return [[NSFileManager defaultManager] removeItemAtPath:[self fileFullPathAtDocumentsDirectory:fileName] error:nil];
    }
    return NO;
}

+(BOOL)deleteAllFilesAtDocumentsDirectory
{
    BOOL result = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess && result) {
                result = NO;
            }
        }
    } else {
        result = NO;
    }
    return result;
}
+(void)deleteImageCacheAtLibrary
{
    
    NSString *home = NSHomeDirectory();
    NSString *path = [home stringByAppendingPathComponent:@"/Library/Caches/ImageCache"];
    NSError *error = nil;
    if([[NSFileManager defaultManager] removeItemAtPath:path error:&error]){
        DBG_MSG(@"文件移除成功");
    }
    else {
        DBG_MSG(@"error=%@", error);
    }
   

}
@end
