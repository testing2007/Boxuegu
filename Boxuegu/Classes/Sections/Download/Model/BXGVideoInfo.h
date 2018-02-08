//
//  BXGVideoInfo.h
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGVideoInfo : NSObject<NSCoding>

@property(nonatomic, assign) NSInteger defaultDefinition;
@property(nonatomic, strong) NSArray* definitionDescription;
@property(nonatomic, strong) NSArray* definitions;
@property(nonatomic, assign) NSInteger status;
@property(nonatomic, strong) NSString* statusInfo;
@property(nonatomic, strong) NSString* token;//加密

-(instancetype) initWithInfo:(NSDictionary*)dict;

@end
