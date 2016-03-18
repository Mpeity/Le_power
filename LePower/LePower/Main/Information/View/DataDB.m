//
//  DataDB.m
//  LePower
//
//  Created by nick_beibei on 16/1/20.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import "DataDB.h"
#define DANAME     @"personInfo.sqlite"
#define NAME       @"name"
#define AGE        @"age"
#define ADDRESS    @"address"
#define TABLENAME  @"PERSONINFO"
#define WEIGHTDATA @"weightData"
#define TIME       @"time"

@implementation DataDB
{
    sqlite3 *_pDb;
}

- (void)createDBWithIndex:(NSInteger)count WithData:(NSString *)data WithCurrentData:(NSDate *)date {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *dataBase_path = [[paths objectAtIndex:0] stringByAppendingPathComponent:DANAME];
    if (sqlite3_open([dataBase_path UTF8String], &_pDb) != SQLITE_OK) {
        sqlite3_close(_pDb);
        NSLog(@"db open failed!");
    }
    else {
        NSLog(@"db open successed!");
//        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age INTEGER,address TEXT)";
        NSString *sql = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT,weightData TEXT,date TEXT)";
//        [self execSqlWithString:sqlCreateTable];
        [self execSqlWithString:sql];
        [self insertIndex:count WithData:data WithCurrentDate:date];
//        [self addData];
        [self searchValues];
    }
}


- (void)execSqlWithString:(NSString *)str{
    char *err;
    if (sqlite3_exec(_pDb, [str UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_pDb);
        NSLog(@"falied to create table----%s",err);
    }
    else {
        NSLog(@"successed to create table");
    }
}

- (void)insertIndex:(NSInteger)count WithData:(NSString *)weightData WithCurrentDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
//    const char *cDate = [strDate UTF8String]; // 时间
//    const char *cData = [data UTF8String]; // 体重
    
    NSString *sql3 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@') VALUES ('%@','%@')",TABLENAME,WEIGHTDATA,TIME,weightData,strDate];
    [self execSqlWithString:sql3];
    
    
//    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%@','%@')",TABLENAME,NAME,AGE,ADDRESS,@"张三",@"15",@"辽宁抚顺市望花区丹东路西段一号"];
//    NSString *sql2 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%@','%@')",TABLENAME,NAME,AGE,ADDRESS,@"流川枫",@"1212212",@"中国安徽安庆岳西"];
//    [self execSqlWithString:sql1];
//    [self execSqlWithString:sql2];

}

- (void)addData {
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%@','%@')",TABLENAME,NAME,AGE,ADDRESS,@"张三",@"15",@"辽宁抚顺市望花区丹东路西段一号"];
    NSString *sql2 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%@','%@')",TABLENAME,NAME,AGE,ADDRESS,@"流川枫",@"1212212",@"中国安徽安庆岳西"];
    [self execSqlWithString:sql1];
    [self execSqlWithString:sql2];
}

- (void)searchValues {
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_pDb, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *data = (char *)sqlite3_column_text(statement, 1);
            NSString *dataStr = [[NSString alloc] initWithUTF8String:data];
//            int age = sqlite3_column_int(statement, 2);
            char *date = (char *)sqlite3_column_text(statement, 3);
            NSString *dateStr = [[NSString alloc] initWithUTF8String:date];
            NSLog(@"data:%@ date:%@",dataStr,dateStr);
        }
    }
    sqlite3_close(_pDb);
}


     








//- (NSString *)filePath {
//    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",@"data.db"];
//    NSLog(@"%@",path);
//    return path;
//}
/*
// 创建打开表
- (void)createTable {
    NSString *filePath = [self filePath];
//    // 文件管理器
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //
//    BOOL isFound = [fileManager fileExistsAtPath:filePath];
//    if (isFound) {
//        NSLog(@"Database file have already existed");
//    }
//    sqlite3 *pDb = NULL;
    // 01 打开数据库 pDb 以后用来操作数据库，跟文件操作的句柄相似
    int result = sqlite3_open([filePath UTF8String], &_pDb);
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败");
    }
    // 02 构建SQL语句
    NSString *sql = @"create table weightData(count int,data text)";
    // 03 执行SQL语句
    char *error = NULL;
    result = sqlite3_exec(_pDb, [sql UTF8String], NULL, NULL, &error);
    if (result != SQLITE_OK) {
        NSLog(@"sqlite3_exec error    -----%s",error);
        sqlite3_close(_pDb);
        return;
    }
    // 04 关闭链接
    NSLog(@"创建表成功");
    sqlite3_close(_pDb);
}

// 插入数据
- (void)insertIndex:(NSInteger)count WithData:(NSString *)data WithCurrentDate:(NSDate *)date {
    NSString *filePath = [self filePath];
    sqlite3 *pDb = NULL;
    sqlite3_stmt *statement = NULL;
    
    // 01 打开数据库
    int result = sqlite3_open([filePath UTF8String], &pDb);
    if (result != SQLITE_OK) {
        NSLog(@"open error");
    }
    // 02 构建SQL语句 编译语句
    NSString *sql = @"insert into weightData values(?,?,?)";
    
    //第一个参数跟前面一样，是个sqlite3 *类型变量，
    //第二个参数是一个sql语句。
    //第三个参数我写的是-1，这个参数含义是前面sql语句的长度。如果小于0，sqlite会自动计算它的长度（把sql语句当成以0结尾的字符串）。
    //第四个参数是sqlite3_stmt的指针的指针。解析以后的sql语句就放在这个结构里。
    //第五个参数我也不知道是干什么的。为nil就可以了。
    result = sqlite3_prepare_v2(pDb, [sql UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"sqlite3_prepare_v2 errror--------------");
    }
    // 向占位符填充数据,构建好完整的 SQL

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    const char *cDate = [strDate UTF8String];
    const char *cData = [data UTF8String];
//    int cCount = (int)count;
    sqlite3_bind_int(statement, 1, 2);
    sqlite3_bind_text(statement, 2, cData, -1, NULL);
    sqlite3_bind_text(statement, 3, cDate, -1, NULL);

//sqlite3_bind_int(<#sqlite3_stmt *#>, <#int#>, <#int#>)
//    sqlite3_bind_text(<#sqlite3_stmt *#>, <#int#>, <#const char *#>, <#int#>, <#void (*)(void *)#>)  第一个参数是statement指针 第二个参数为序号（从1开始）第三个参数为字符串值 第四个参数为字符串长度 第五个参数为一个函数指针
    
    // 03 执行一步 把数据添加到数据库里
    sqlite3_step(statement);
    // 04 关闭
    sqlite3_close(pDb);
    sqlite3_finalize(statement);
}

// 查询数据
- (void)queryData {
    NSString *filePath = [self filePath];
    sqlite3 *pDb = NULL;
    sqlite3_stmt *statement = NULL;
    // 01 打开数据库
    int result = sqlite3_open([filePath UTF8String], &pDb);
    if (result != SQLITE_OK) {
        NSLog(@"open error");
    }
    // 02 构建SQL语句 编译语句
    NSString *sql = @"select * from weightData";
    result = sqlite3_prepare_v2(pDb, [sql UTF8String], -1, &statement, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"sqlite3_prepare_v2 error----");
    }
    // 03 执行操作
    int hasData = sqlite3_step(statement);
    while (hasData == SQLITE_ROW) {
        // 起始列为 0
        int index = sqlite3_column_int(statement, 0);
        const unsigned char *data = sqlite3_column_text(statement, 1);
        const unsigned char *date = sqlite3_column_text(statement, 2);
        NSLog(@"index = %d,data = %s,date = %s",index,data,date);
        hasData = sqlite3_step(statement);
    }
    // 04 关闭
    sqlite3_close(pDb);
    sqlite3_finalize(statement);
}

*/



























@end
