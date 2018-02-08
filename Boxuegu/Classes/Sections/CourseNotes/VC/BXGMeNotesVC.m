//
//  BXGMeNotesVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeNotesVC.h"
#import "BXGBaseNote.h"

@interface BXGMeNotesVC ()
@property(nonatomic, strong) BXGBaseNote *baseNote;
@end

@implementation BXGMeNotesVC

-(instancetype)initWithCourseId:(NSString*)courseId
{
    self = [super init];
    if(self)
    {
        _baseNote = [[BXGBaseNote alloc] initWithTargetVC:self andNoteType:NOTE_TYPE_ME andCourseId:courseId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_baseNote installUI];
    [_baseNote installPullRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"me viewWillAppear");
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
