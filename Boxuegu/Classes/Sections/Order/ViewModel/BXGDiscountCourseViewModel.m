//
//  BXGDiscountCourseViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDiscountCourseViewModel.h"
#import "BXGHomeCourseModel.h"

@interface BXGDiscountCourseViewModel()
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) bool isNoMore;
@property (nonatomic, copy) NSString* couponId;
@end
@implementation BXGDiscountCourseViewModel
- (instancetype)initWithCouponId:(NSString *)couponId; {
    self = [super init];
    if(self) {
        self.couponId = couponId;
    }
    return self;
}
- (void)loadWithIsRefresh:(BOOL)isRefresh andFinished:(void(^)(NSArray<BXGHomeCourseModel *> *models))finished {
    Weak(weakSelf);
    
    if(isRefresh) {
        self.pageNumber = 0;
        weakSelf.isNoMore = false;
    }
     self.pageNumber += 1;
    [self.networkTool requestCouponCoursesWithCouponId:self.couponId andPageNumber:@(self.pageNumber) andPageSize:@(20) andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            if([result isKindOfClass:[NSDictionary class]] && [result[@"items"] isKindOfClass:[NSArray class]]) {
                id items = result[@"items"];
                NSMutableArray *models = [NSMutableArray new];
                for (NSInteger i = 0; i < [items count]; i ++) {
                    BXGHomeCourseModel *model = [BXGHomeCourseModel yy_modelWithDictionary:items[i]];
                    if(model) {
                        [models addObject:model];
                    }
                }
                finished(models);
            }else {
                weakSelf.pageNumber = 0;
                finished(nil);
            }
        }];
    } andFailed:^(NSError * _Nonnull error) {
        finished(nil);
        weakSelf.pageNumber = 0;
    }];
}
@end
