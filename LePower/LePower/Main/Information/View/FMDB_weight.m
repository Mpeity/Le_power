//
//  FMDB_weight.m
//  LePower
//
//  Created by nick_beibei on 16/3/31.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "FMDB_weight.h"

@implementation FMDB_weight

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)createDb {
    NSLog(@"%@",NSHomeDirectory());
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"weight.sqlite"];
    // 创建数据库实例
    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    // 创建数据库表
    // 提供一个多线程安全的数据库实例
//    [queue inDatabase:^(FMDatabase *db) {
//        BOOL flag = [db executeUpdate:@"create table if not exists t_weight (id integer primary key autoincrement,count integer,currentDate text,weightData text)"];
//        if (flag) {
//            NSLog(@"创建表 success");
//        } else {
//            NSLog(@"创建表 failed");
//        }
//        
//    }];
//    _queue = queue; //  [db lastInsertRowId]
    
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    // 打开数据库
    BOOL flag1 = [db open];
    if (flag1) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
    }
    
    BOOL flag = [db executeUpdate:@"create table if not exists t_weight (id integer primary key autoincrement,count integer,currentDate text,weightData text)"];
    if (flag) {
        NSLog(@"创建表 success");
    } else {
        NSLog(@"创建表 failed");
    }
    _db = db;
}

// 添加数据
- (void)addIndex:(NSInteger)count WithData:(NSString *)weightData WithCurrentDate:(NSDate *)currentDate {
//    [_queue inDatabase:^(FMDatabase *db) {
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *strDate = [dateFormatter stringFromDate:currentDate];
//        
//        BOOL flag = [db executeUpdate:@"insert into t_weight (count,currentDate,weightData) values (?,?,?)",[NSNumber numberWithInteger:count],strDate,weightData];
//        if (flag) {
//            NSLog(@"add success");
//        } else {
//            NSLog(@"add failed");
//        }
//        [self updateBtn:count];
//    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:currentDate];
    
    BOOL flag = [_db executeUpdate:@"insert into t_weight (count,currentDate,weightData) values (?,?,?)",[NSNumber numberWithInteger:count],strDate,weightData];
    if (flag) {
        NSLog(@"add success");
    } else {
        NSLog(@"add failed");
    }

    
}

//删除数据
- (void)deleteDataWithIndex:(NSInteger)count {
    //DELETE FROM SUser WHERE uid = '%@'",uid
    
//    FMResultSet *result = [_db executeQuery:@"select * from t_weight;"];
//    while ([result next]) {
//        NSInteger identy = [[result stringForColumn:@"id"] integerValue];
//    }
    
//
//    [_queue inDatabase:^(FMDatabase *db) {
//        BOOL flag = [db executeUpdate:@"delete from t_weight where count = ?",[NSNumber numberWithInteger:count]];
//        if (flag) {
//            NSLog(@"delete %ld success",count);
//        } else {
//            NSLog(@"delete %ld failed",count);
//        }
//        
//    }];
//    
    BOOL flag = [_db executeUpdate:@"delete from t_weight where count = ?",[NSNumber numberWithInteger:count]];
    if (flag) {
        NSLog(@"delete %ld success",count);
    } else {
        NSLog(@"delete %ld failed",count);
    }

}


//修改数据
- (void)updateBtn:(NSInteger)count {
    
//    [_queue inDatabase:^(FMDatabase *db) {
//        // 开启事务
//        [db beginTransaction];
//        
//        BOOL flag = [db executeUpdate:@"update t_weight set money = ? where name = ?;",@500,@"zhangsan"];
//        if (flag) {
//            NSLog(@"update success");
//        } else {
//            NSLog(@"update failed");
//            // 回滚
//            [db rollback];
//        }
//        
//        BOOL flag1 = [db executeUpdate:@"update t_user set money = ? where name = ?;",@1000,@"lisi"];
//        if (flag1) {
//            NSLog(@"update success");
//        } else {
//            NSLog(@"update failed");
//            // 回滚
//            [db rollback];
//        }
//        // 全部操作完成时再提交
//        [db commit];
//        
//    }];
//    [_queue inDatabase:^(FMDatabase *db) {
//        // 开启事务
//        [db beginTransaction];
//
//        BOOL flag = [db executeUpdate:@"update t_weight count = ?;",[NSNumber numberWithInteger:count]];
//        if (flag) {
//            NSLog(@"update success");
//        } else {
//            NSLog(@"update failed");
//        }
//        // 回滚
//        [db rollback];
//    }];
 
    BOOL flag = [_db executeUpdate:@"update t_weight count = ?;",[NSNumber numberWithInteger:count]];
    if (flag) {
        NSLog(@"update success");
    } else {
        NSLog(@"update failed");
    }

}

//查询数据
- (NSString *)queryBtn {
    // count,currentDate,weightData
    
    NSString *weightData = nil;

//    [_queue inDatabase:^(FMDatabase *db) {
//
//        FMResultSet *result = [db executeQuery:@"select * from t_weight;"];
//        while ([result next]) {
//            NSString *curentDate = [result stringForColumn:@"currentDate"];
//            weightData = [result stringForColumn:@"weightData"];
//            NSInteger count = [[result stringForColumn:@"count"] integerValue];
//            NSInteger identy = [[result stringForColumn:@"id"] integerValue];
//            NSLog(@"%@ %@ %ld %ld",curentDate,weightData,count,identy);
//        }
//        
//    }];
    
    FMResultSet *result = [_db executeQuery:@"select * from t_weight;"];
    while ([result next]) {
        NSString *curentDate = [result stringForColumn:@"currentDate"];
        weightData = [result stringForColumn:@"weightData"];
        NSInteger count = [[result stringForColumn:@"count"] integerValue];
        NSInteger identy = [[result stringForColumn:@"id"] integerValue];
        NSLog(@"%@ %@ %ld %ld",curentDate,weightData,count,identy);
    }
    return weightData;
}



@end
