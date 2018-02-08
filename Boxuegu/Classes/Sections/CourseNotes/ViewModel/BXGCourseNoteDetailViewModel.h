//
//  BXGCourseNoteDetailViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCourseNoteDetailModel.h"

typedef enum _NOTE_TYPE {
    NOTE_TYPE_ALL,
    NOTE_TYPE_ME,
    NOTE_TYPE_COLLECT
}NOTE_TYPE;

@interface BXGCourseNoteDetailViewModel : BXGBaseViewModel


-(void)requestCourseNoteDetailWithRefresh:(BOOL)bRefresh
                              andCourseId:(NSString*)courseId
                                  andType:(NOTE_TYPE)type
                           andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;


-(void)updatePraiseNoteId:(NSString*)noteId
           andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;

-(void)updateCollectNoteId:(NSString*)noteId
            andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;

-(void)deleteNoteId:(NSString*)noteId
     andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;

@property(nonatomic, strong) NSArray<BXGCourseNoteDetailModel *> *arrNote;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) BOOL bHaveMoreData;

@end
