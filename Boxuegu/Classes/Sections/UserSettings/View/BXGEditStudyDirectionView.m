//
//  BXGEditStudyDirectionView.m
//  Boxuegu
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditStudyDirectionView.h"

@interface BXGEditStudyDirectionView()
//@property (nonatomic, strong) NSArray<NSString*> *source;
@end

@implementation BXGEditStudyDirectionView

-(instancetype)initDataSource:(NSArray<NSString*>*)dataSource
           andCurrentSelIndex:(NSNumber*)curSelIndex {
    self = [super initWithDataSource:dataSource];
    if(self) {
//        self.source = dataSource;
        if(self.dataSource && curSelIndex) {
            NSAssert(curSelIndex.integerValue<dataSource.count, @"current select index is equal or larger than data source count");
        }
        self.selIndex = !curSelIndex ? [NSNumber numberWithInteger:-1] : curSelIndex;
    }
    return self;
}

-(NSNumber*)selIndex {
    if(_selIndex==nil)
        return nil;
    
    NSNumber *numberSelIndex = [NSNumber numberWithInteger:_selIndex.integerValue];;
    return numberSelIndex;
}

-(NSNumber*)convertNetworkTypeValue {
    NSAssert(_selIndex!=nil, @"sel index shouldn't be nil");
    return [self.selIndex integerValue]==-1 ? nil : self.selIndex;
}

@end
