//
//  FMDB_weight.h
//  LePower
//
//  Created by nick_beibei on 16/3/31.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDB_weight : NSObject

@property (nonatomic,strong) FMDatabaseQueue *queue;

@property (nonatomic,strong) FMDatabase *db;

- (void)createDb;

// 添加数据
- (void)addIndex:(NSInteger)count WithData:(NSString *)weightData WithCurrentDate:(NSDate *)currentDate;

//删除数据
- (void)deleteDataWithIndex:(NSInteger)count;

//查询数据
//- (void)queryBtn;

//- (FMResultSet *)queryBtn;

- (NSString *)queryBtn;

@end
