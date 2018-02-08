//
//  BXGCourseNoteModel.h
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCourseNoteModel : BXGBaseModel

@property(nonatomic, strong) NSString *courseId;
@property(nonatomic, strong) NSString *courseName;
@property(nonatomic, strong) NSString *smallImgPath;
@property(nonatomic, strong) NSString *notesCount;

@end
