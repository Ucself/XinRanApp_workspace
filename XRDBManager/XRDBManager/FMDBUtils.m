//
//  FMDBUtils.m
//  XinRanApp
//
//  Created by tianbo on 15-3-3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "FMDBUtils.h"
#import "FMDB.h"


#define DBNAME   @"Database"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@implementation FMDBUtils

+(BOOL)fmdbExec_Update:(NSString*)sql
{
    //FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FMDBUtils getDBFile]];
    //FMDBQuickCheck(queue);
    
    __block BOOL ret = NO;
    [[FMDBUtils instanceDBQueue] inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
        FMDBQuickCheck(ret);
    }];
    
    return ret;
}

+(void)fmdbExec_Query:(NSString*)sql result:(void(^)(FMResultSet *rs))result
{
    [[FMDBUtils instanceDBQueue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result(rs);
        }

        [rs close];
    }];

}


+(void)fmdbExec_Query:(NSString*)sql dbFile:(NSString*)dbFile result:(void(^)(FMResultSet *rs))result
{

    [[FMDBUtils instanceDBQueue:dbFile] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result(rs);
        }

        [rs close];
    }];
}

+(FMDatabaseQueue*)instanceDBQueue
{
    static FMDatabaseQueue *queue = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        queue = [FMDatabaseQueue databaseQueueWithPath:[FMDBUtils getDBFile]];
        FMDBQuickCheck(queue);
    });
    
    return queue;
}

+(FMDatabaseQueue*)instanceDBQueue:(NSString*)dbFile
{
    static FMDatabaseQueue *queue = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        queue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
        FMDBQuickCheck(queue);
    });
    
    return queue;
}


#pragma mark-
+(void)dropDB
{
    NSString *dbName = [FMDBUtils getDBFileName];
    //修改防止文件不存在
    if ([FileManager fileExistAtDocumentsDirectory:dbName]) {
        [FileManager deleteFileAtDocumentsDirectory:dbName];
    }
}

+(BOOL)checkDB
{
    NSString *dbName = [FMDBUtils getDBFileName];
    //修改防止文件不存在
    if ([FileManager fileExistAtDocumentsDirectory:dbName]) {
        DBG_MSG(@"file %@ is there",dbName);
        
        return YES;
    }
    
    return NO;
    
//    FMDatabase * db = [FMDatabase databaseWithPath:[FileManager fileFullPathAtDocumentsDirectory:dbName]];
//    if (!db) {
//        DBG_MSG(@"创建数据库失败");
//    }
//    [db close];
//    
//    //创建表格
//    [FMDBUtils exeCreateTable];
}

//创建数据库
+(BOOL)createDB
{
    NSString *dbName = [FMDBUtils getDBFileName];
    FMDatabase * db = [FMDatabase databaseWithPath:[FileManager fileFullPathAtDocumentsDirectory:dbName]];
    if (!db) {
        DBG_MSG(@"创建数据库失败");
        return NO;
    }
    [db close];
    
    return YES;
    
//    NSString *dbName = [FMDBUtils getDBFileName];
//    //修改防止文件不存在
//    if ([FileManager fileExistAtDocumentsDirectory:dbName]) {
//        DBG_MSG(@"file %@ is there",dbName);
//        
//        return;
//    }
//    
//    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSString *alterPath = [path stringByAppendingPathComponent:Default_DB_NAME];
//    
//    [[NSFileManager defaultManager] copyItemAtPath:alterPath toPath:[FileManager fileFullPathAtDocumentsDirectory:dbName] error:nil];
//
//    //创建表格
//    [FMDBUtils exeCreateTable];
}

//得到数据库文件
+(NSString *)getDBFile
{
    NSString *fileName = [FMDBUtils getDBFileName];
    return [FileManager fileFullPathAtDocumentsDirectory:fileName];
}

+(NSString *)getDBFileName{
    NSString *fileName = [[NSString stringWithFormat:@"%@", DBNAME] stringByAppendingString:@".sqlite"];
    return fileName;
}

//建表
+ (void)createTable:(NSString *)sql
{
    [FMDBUtils fmdbExec_Update:sql];
}

//根据Where删除数据
+ (BOOL)delete:(NSString *)deleteSql
{
    return [FMDBUtils fmdbExec_Update:deleteSql];
}

//查询
+ (void)query:(NSString *)querySql result:(void(^)(FMResultSet *rs))result
{
    [FMDBUtils fmdbExec_Query:querySql result:result];
}
//查询
+ (void)query:(NSString *)querySql dbFile:(NSString*)dbFile result:(void(^)(FMResultSet *rs))result
{
    [FMDBUtils fmdbExec_Query:querySql dbFile:dbFile result:result];
}

//插入数据
+(BOOL)insert:(NSString *)insertSql
{
    return [FMDBUtils fmdbExec_Update:insertSql];
}

//插入数据
+(BOOL)insertWithArray:(NSMutableArray *)sqls
{
    //[FMDBUtils fmdbExec_Update:sqls];
    return YES;
}

//更新数据
+(BOOL)update:(NSString *)updateSql
{
    return [FMDBUtils fmdbExec_Update:updateSql];
}

//插入数据
+(BOOL)updateWithArray:(NSMutableArray *)sqls
{
    //[FMDBUtils fmdbExec_Update:sqls];
    return YES;
}

//判断是否存在
+(BOOL)exist:(NSString *)existSql
{
    //FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FMDBUtils getDBFile]];
    
    __block BOOL ret = NO;
    [[FMDBUtils instanceDBQueue] inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:existSql];
        
        if ([rs next]) {
            ret = YES;
        }
        else {
            ret = NO;
        }

        [rs close];
    }];
    
    return ret;
}
@end
