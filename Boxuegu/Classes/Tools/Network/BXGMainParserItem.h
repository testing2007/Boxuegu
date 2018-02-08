//
//  BXGMainParserItem.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGMainParserItem : NSObject
@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) id resultObject;
@end
