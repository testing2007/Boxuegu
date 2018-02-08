//
//  BXGNetworkParameterRequestFactory.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetworkParameterRequestFactory.h"
#import "BXGUserCenter.h"
#import "NetworkParameter.h"
#import "DynamicParameter.h"

@implementation BXGNetworkParameterRequestFactory


//+(NSDictionary*)createRequestFilterCourseInfoParameterWithCourseType:(NSNumber *)courseType
//                                                        andMicroType:(NSNumber *)microType {
//    NetworkParameter *courseTypePara = [[NetworkParameter alloc] initObjectKey:@"courseType" value:courseType isOption:NO];
//    NetworkParameter *microTypePara = [[NetworkParameter alloc] initObjectKey:@"microType" value:microType isOption:NO];
//    DynamicParameter *dynamicParameter = [[DynamicParameter alloc] init];
//    [dynamicParameter setParameters:@[courseTypePara, microTypePara]];
//
//    NSDictionary *dict = @{@"/bxg/index/getChoiceList": dynamicParameter};
//    return dict;
//}

@end
