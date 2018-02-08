//
//  BXGAllNotesVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGAllNotesVC.h"
#import "BXGBaseNote.h"

@interface BXGAllNotesVC ()
@property(nonatomic, strong) BXGBaseNote *baseNote;
@end

@implementation BXGAllNotesVC

-(instancetype)initWithCourseId:(NSString*)courseId
{
    self = [super init];
    if(self)
    {
        _baseNote = [[BXGBaseNote alloc] initWithTargetVC:self andNoteType:NOTE_TYPE_ALL andCourseId:courseId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_baseNote installUI];
    [_baseNote installPullRefresh];
}

-(void)dealloc
{
    NSLog(@"BXGAllNotesVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
