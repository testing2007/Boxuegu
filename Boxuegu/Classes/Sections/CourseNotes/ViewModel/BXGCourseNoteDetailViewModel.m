//
//  BXGCourseNoteDetailViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseNoteDetailViewModel.h"

#define kPageSize  10

@implementation BXGCourseNoteDetailViewModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _currentPage = 0;
        _bHaveMoreData = YES;
    }
    return self;
}

-(void)requestCourseNoteDetailWithRefresh:(BOOL)bRefresh
                              andCourseId:(NSString*)courseId
                                  andType:(NOTE_TYPE)type
                           andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;
{
    __weak typeof (self) weakSelf = self;
    
    if(bRefresh)
    {
        _currentPage = 0;
        _bHaveMoreData = YES;
        _arrNote = [NSArray new];
    }
    if(!_bHaveMoreData)
    {
        return  finishedBlock(false, @"have no more data");
    }
    _currentPage = self.arrNote!=nil ? (self.arrNote.count/kPageSize)+1 : 0;
    
    if(!self.userModel)
    {
        return finishedBlock(false, @"userModel is nil");
    }
    if(!self.userModel.user_id)
    {
        return finishedBlock(false, @"userId is nil");
    }
    if(!self.userModel.sign)
    {
        return finishedBlock(false, @"sign is nil");
    }
    [self.networkTool requestCourseNoteDetailWithUserId:self.userModel.user_id
                                                andPage:[NSString stringWithFormat:@"%ld", _currentPage]
                                            andPageSize:[NSString stringWithFormat:@"%d", kPageSize]
                                            andCourseId:courseId
                                                andType:[NSString stringWithFormat:@"%d", type]
                                                andSign:self.userModel.sign
                                               Finished:^(id  _Nullable responseObject) {
                                                   
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
                                                   NSMutableArray<BXGCourseNoteDetailModel *> *courseDetailNote = [[NSMutableArray alloc]initWithArray:_arrNote];
                                                   if(resultObject) {
                                                       id arr = resultObject;
                                                       if(arr && arr != [NSNull null] )
                                                       {
                                                           NSInteger arrCount = [arr count];
                                                           for(NSInteger i = 0; i < arrCount; i++) {
                                                               
                                                               if([arr[i] isKindOfClass:[NSDictionary class]]) {
                                                                   
                                                                   BXGCourseNoteDetailModel *model = [BXGCourseNoteDetailModel yy_modelWithDictionary:arr[i]];
                                                                   if(model){
                                                                       [courseDetailNote addObject:model];
                                                                   }
                                                               }else {
                                                                   finishedBlock(false, @"解析异常");
                                                               }
                                                           }
                                                           
                                                           if(arrCount>=0 && arrCount<kPageSize)
                                                           {
                                                               _bHaveMoreData = NO;
                                                           }
                                                           
                                                           weakSelf.arrNote = courseDetailNote.copy;
                                                       }
                                                   }
                                                   finishedBlock(true, @"");
                                               } Failed:^(NSError * _Nonnull error) {
                                                   finishedBlock(false, error.debugDescription);
                                               }];
        
}

-(void)updatePraiseNoteId:(NSString*)noteId
         andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    //__weak typeof (self) weakSelf = self;
    if(!self.userModel)
    {
        return finishedBlock(false, @"userModel is nil");
    }
    if(!self.userModel.user_id)
    {
        return finishedBlock(false, @"userId is nil");
    }
    if(!self.userModel.username)
    {
        return finishedBlock(false, @"username is nil");
    }
    if(!self.userModel.sign)
    {
        return finishedBlock(false, @"sign is nil");
    }
    if(!noteId)
    {
        return finishedBlock(false, @"noteId is nil");
    }
    [self.networkTool requestUpdatePraiseNoteUserId:self.userModel.user_id
                                        andUserName:self.userModel.username
                                          andNoteId:noteId
                                            andSign:self.userModel.sign
                                           Finished:^(id  _Nullable responseObject) {
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
        finishedBlock(true, @"成功");
        
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(false, error.debugDescription);
    }];
}

-(void)updateCollectNoteId:(NSString*)noteId
          andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    //__weak typeof (self) weakSelf = self;
    if(!self.userModel)
    {
        return finishedBlock(false, @"userModel is nil");
    }
    if(!self.userModel.user_id)
    {
        return finishedBlock(false, @"userId is nil");
    }
    if(!self.userModel.username)
    {
        return finishedBlock(false, @"username is nil");
    }
    if(!self.userModel.sign)
    {
        return finishedBlock(false, @"sign is nil");
    }
    if(!noteId)
    {
        return finishedBlock(false, @"noteId is nil");
    }
    [self.networkTool requestUpdateCollectNoteUserId:self.userModel.user_id
                                         andUserName:self.userModel.username
                                           andNoteId:noteId
                                             andSign:self.userModel.sign
                                            Finished:^(id  _Nullable responseObject) {
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
        finishedBlock(true, @"成功");
        
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(false, error.debugDescription);
    }];
}

-(void)deleteNoteId:(NSString*)noteId
         andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    if(!self.userModel)
    {
        return finishedBlock(false, @"userModel is nil");
    }
    if(!self.userModel.user_id)
    {
        return finishedBlock(false, @"userId is nil");
    }
    if(!self.userModel.username)
    {
        return finishedBlock(false, @"username is nil");
    }
    if(!self.userModel.sign)
    {
        return finishedBlock(false, @"sign is nil");
    }
    if(!noteId)
    {
        return finishedBlock(false, @"noteId is nil");
    }
    [self.networkTool requestDeleteNoteUserId:self.userModel.user_id
                                  andUserName:self.userModel.username
                                    andNoteId:noteId
                                      andSign:self.userModel.sign
                                     Finished:^(id  _Nullable responseObject) {
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
        finishedBlock(true, @"成功");
        
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(false, error.debugDescription);
    }];
}

@end
