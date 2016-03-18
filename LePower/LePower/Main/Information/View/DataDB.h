//
//  DataDB.h
//  LePower
//
//  Created by nick_beibei on 16/1/20.
//  Copyright © 2016年 nick_beibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataDB : NSObject

//- (void)createTable;

- (void)createDB;

- (void)createDBWithIndex:(NSInteger)count WithData:(NSString *)data WithCurrentData:(NSDate *)date;
- (void)insertIndex:(NSInteger)count WithData:(NSString *)data WithCurrentDate:(NSDate *)date;

- (void)searchValues;

//- (void)queryData;

@end
