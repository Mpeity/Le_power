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

- (void)createTable;
- (void)insertIndex:(NSInteger)count WithData:(NSString *)data WithCurrentDate:(NSDate *)date;
- (void)queryData;

@end
