//
//  BXGDatabase.h
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB/FMDB.h"

#define BXGDATABASE ([BXGDatabase shareInstance].db)
extern NSString* DB_NAME;

@class BXGDownloadTable;
@interface BXGDatabase : NSObject

@property(nonatomic, strong, readonly) FMDatabase* db;

@property(nonatomic, strong, readonly) BXGDownloadTable *downloadTable;

+(instancetype)shareInstance;

-(BOOL)open;
-(BOOL)close;

@end
