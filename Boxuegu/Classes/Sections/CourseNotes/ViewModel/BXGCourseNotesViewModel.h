//
//  BXGCourseNoteViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCourseNoteModel.h"


@interface BXGCourseNotesViewModel : BXGBaseViewModel

@property (nonatomic, strong) NSArray<BXGCourseNoteModel *> *arrCourseNote;

-(void)requestCourseNotesBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;


@end
