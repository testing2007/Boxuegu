//
//  BXGCourseOutlineChapterModel.m
//  Boxuegu
//
//  Created by RW on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseOutlineChapterModel.h"

@implementation BXGCourseOutlineChapterModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"idx" :@"id"
            ,@"jie":@[@"chapters",@"jie"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"jie":[BXGCourseOutlineSectionModel class],@"chapters":[BXGCourseOutlineSectionModel class]};
}

- (NSArray<BXGCourseOutlinePointModel *> *)dianArray {

    if(!_dianArray) {
        
        NSMutableArray *allDianArray = [NSMutableArray new];
        if(self.jie){
        
            for(NSInteger i = 0; i < self.jie.count; i++) {
            
                if(self.jie[i].dian && self.jie[i].dian.count > 0) {
                
                    [allDianArray addObjectsFromArray:self.jie[i].dian];
                }
            }
        }
        _dianArray = allDianArray;
    }
    return _dianArray;
}
@end
