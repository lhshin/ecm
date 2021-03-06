//
//  DBQueue.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
@class SKMessageEntity;
@class LocalDataMeta;
@interface DBQueue : NSObject
{
    FMDatabaseQueue     *dbQueue;
}

@property(nonatomic,strong)FMDatabaseQueue *dbQueue;

/**
 *  获取单例数据库实例
 *
 *  @return 返回DBQueue
 */
+(DBQueue*)sharedbQueue;

//返回成功插入的记录数


-(void)insertDataToTableWithDataArray:(SKMessageEntity*)entity TableName:(NSString*)table;

-(void)insertDataToTableWithDataArray:(SKMessageEntity*)entity LocalDataMeta:(LocalDataMeta*)dataMeta;

/**
 *  获取查询sql记录的条数
 *
 *  @param sql 查询的sql
 *
 *  @return 记录的条数
 */
-(NSInteger)CountOfQueryWithSQL:(NSString*)sql;

/**
 *  执行某条非查询语句
 *
 *  @param sql sql语句
 *
 *  @return 返回是否执行成功
 */
-(BOOL)updateDataTotableWithSQL:(NSString*)sql;

/**
 *  获取某条记录
 *
 *  @param sql sql语句
 *
 *  @return 记录值
 */
-(NSDictionary*)getSingleRowBySQL:(NSString*)sql;

/**
 *  获取某条sql的结果集
 *
 *  @param sql sql语句
 *
 *  @return 结果集数组
 */
-(NSArray*)recordFromTableBySQL:(NSString*)sql;

/**
 *  取单列数据集合
 *
 *  @param sql
 *
 *  @return array
 */
-(NSArray*)arrayFromTableBySQL:(NSString*)sql;

/**
 *  获取某条sql的结果集
 *
 *  @param sql sql语句
 *
 *  @return 结果集
 */
-(FMResultSet*)RSFromTableBySQL:(NSString*)sql;

/**
 *  获取某个sql查询的整型值
 *
 *  @param sql sql语句
 *
 *  @return 返回整型值
 */
-(int)intValueFromSQL:(NSString*)sql;

/**
 *  获取某个sql查询的字符串
 *
 *  @param sql sql语句
 *
 *  @return 字符串
 */
-(NSString*)stringFromSQL:(NSString*)sql;

/**
 *  查询日期
 *
 *  @param sql 查询语句
 *
 *  @return 日期
 */
-(NSDate*)dateFromSql:(NSString*)sql;
@end
