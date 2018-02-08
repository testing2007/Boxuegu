//
//  BXGBaseNoteVC.h
//  Boxuegu
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseNoteDetailViewModel.h"

@interface BXGBaseNote :  NSObject

-(instancetype)initWithTargetVC:(UIViewController*)targetVC
                    andNoteType:(NOTE_TYPE)noteType
                    andCourseId:(NSString*)courseId;
-(void)installUI;

-(void)installPullRefresh;

@end
