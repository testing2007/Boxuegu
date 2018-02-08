//
//  BXGDatabase.m
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGDatabase.h"
#import "BXGDownloadTable.h"
#import "BXGVideoInfoTable.h"
#import "BXGVideoInfoItemTable.h"
#import "BXGCourseTable.h"
#import "BXGPointTable.h"
#import "BXGVideoTable.h"
#import "BXGResourceManager.h"
#import "BXGHistoryTable.h"
#import "BXGLearnStatusTable.h"

NSString* DB_NAME = @"BXG.db";
@interface BXGDatabase()

@property(nonatomic, strong, readwrite) FMDatabase* db;
@property(nonatomic, strong, readwrite) BXGDownloadTable *downloadTable;
@end

@implementation BXGDatabase

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static BXGDatabase* instance;
    dispatch_once(&onceToken, ^{
        instance = [[BXGDatabase alloc] init];
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {

    }
    return self;
}

-(BOOL)createDatabase
{
    [[BXGResourceManager shareInstance] clearUserDirectory];
    NSString* dbPath = [[BXGResourceManager shareInstance] downloadDBPath];
    _db = [FMDatabase databaseWithPath:dbPath];
    BOOL bResult = [_db open];
    if(!bResult)
    {
        NSLog(@"fail to open database");
        return bResult;
    }
    
    bResult = [BXGDownloadTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create download table");
        return bResult;
    }
    
    bResult = [BXGVideoInfoTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create videoInfo table");
        return bResult;
    }
    bResult = [BXGVideoInfoItemTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create videoInfoItem table");
        return bResult;
    }
    bResult = [BXGCourseTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create course table");
        return bResult;
    }
    bResult = [BXGPointTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create point table");
        return bResult;
    }
    bResult = [BXGVideoTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create video table");
        return bResult;
    }
    
    bResult = [BXGHistoryTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create history table");
        return bResult;
    }
    
    bResult = [BXGLearnStatusTable createTable];
    if(!bResult)
    {
        NSLog(@"fail to create learn status table");
        return bResult;
    }
    
    return bResult;
}

-(BOOL)open
{
    BOOL bResult = [self createDatabase];
//    BOOL bResult = [_db open];
    if(bResult)
    {
        NSLog(@"success to open the db");
    }
    else
    {
        NSLog(@"fail to open the db, the code=%d, the reason=%@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)close
{
    BOOL bResult = [_db close];
    if(bResult)
    {
        NSLog(@"success to close the db");
    }
    else
    {
        NSLog(@"fail to close the db, the code=%d, the reason=%@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    return bResult;
}

@end
