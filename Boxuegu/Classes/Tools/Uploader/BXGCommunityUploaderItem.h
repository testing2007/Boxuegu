//
//  BXGCommunityUploaderItem.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SucceedBlockType)(NSArray<NSString *> *urlStringArray);
typedef void(^FailedBlockType)();

@interface BXGCommunityUploaderItem : NSObject

@property (nonatomic, strong) NSArray *imageArray;
@property (atomic, strong) NSMutableDictionary *imageDictionary;
@property (nonatomic, copy) SucceedBlockType succeedBlock;
@property (nonatomic, copy) FailedBlockType failedBlock;

- (void)start;


@end
