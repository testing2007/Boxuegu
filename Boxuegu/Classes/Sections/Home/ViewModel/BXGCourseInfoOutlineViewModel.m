//
//  BXGCourseInfoOutlineViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoOutlineViewModel.h"
#import "BXGCourseInfoChapterModel.h"

@implementation BXGCourseInfoOutlineViewModel

#pragma mark - Interface

- (instancetype)initWithCourseId:(NSString *)courseId {
    self = [super init];
    if(self) {
        _courseId = courseId;
    }
    return self;
}

- (void)loadCourseInfoOutlineWithFinishedBlock:(void(^)(NSMutableArray<BXGCourseInfoChapterModel*>*chapterModels)) finishedBlock {
    
    [self.networkTool requestCourseInfoOutlineWithCourseId:self.courseId andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                    
                case BXGNetworkResultStatusSucceed: {
                    NSMutableArray<BXGCourseInfoChapterModel *> *chapters = [NSMutableArray new];
                    if([result isKindOfClass:[NSArray class]]) {
                        for (NSInteger i = 0; i < [result count];i++) {
                            BXGCourseInfoChapterModel *model = [BXGCourseInfoChapterModel yy_modelWithDictionary:result[i]];
                            if(model) {
                                [chapters addObject:model];
                            }
                        }
                    }
                    finishedBlock(chapters);
                    return;
                }break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    
                    break;
            }
            finishedBlock(nil);
            return;
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(nil);
    }];
}
@end
