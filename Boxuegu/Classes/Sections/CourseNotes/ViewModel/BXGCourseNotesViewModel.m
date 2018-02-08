//
//  BXGCourseNoteViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseNotesViewModel.h"

@implementation BXGCourseNotesViewModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

-(void)requestCourseNotesBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    __weak typeof (self) weakSelf = self;
    [self.networkTool requestCourseNotesWithUserId:self.userModel.user_id andSign:self.userModel.sign Finished:^(id  _Nullable responseObject) {
        if(!responseObject){
            
            if(finishedBlock){
                
                finishedBlock(false,@"失败");
            }
            return;
        }
        
        NSNumber *successValue = responseObject[@"success"];
        if(![successValue isKindOfClass:[NSNumber class]] || ![successValue boolValue]){
            
            if(finishedBlock){
                
                finishedBlock(false,@"失败");
            }
            return;
        }
        
        
        NSArray *resultObject = responseObject[@"resultObject"];
        if(![resultObject isKindOfClass:[NSArray class]]){
            if(finishedBlock){
                finishedBlock(false,@"失败");
            }
            return;
        }
        NSMutableArray<BXGCourseNoteModel *> *courseNotes = [NSMutableArray new];
        if(resultObject) {
            id arr = resultObject;
            if(arr && arr != [NSNull null] )
            {
                for(NSInteger i = 0; i < [arr count]; i++) {
                    
                    if([arr[i] isKindOfClass:[NSDictionary class]]) {
                        
                        BXGCourseNoteModel *model = [BXGCourseNoteModel yy_modelWithDictionary:arr[i]];
                        if(model){
                            [courseNotes addObject:model];
                        }
                    }else {
                        finishedBlock(false, @"解析异常");
                    }
                }
            }
            
            weakSelf.arrCourseNote = courseNotes.copy;
        }
        finishedBlock(true, nil);
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(false, error.debugDescription);
    }];
}

@end
