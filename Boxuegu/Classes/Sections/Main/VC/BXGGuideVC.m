//
//  BXGGuideVC.m
//  Boxuegu
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGGuideVC.h"
//#import "LoopView.h"
#import "BXGResourceManager.h"
#import "BXGLaunchView.h"

@interface BXGGuideVC ()<LaunchViewDelegate>
//@property(nonatomic, strong) LoopView *loopView;
@property(nonatomic, weak) BXGLaunchView *launcheView;
@end

@implementation BXGGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self installUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getLaunchStringKeyForCurVersion
{
    NSString *version = [[BXGResourceManager shareInstance] appVersion];
    NSString *keyLaunchString = [NSString stringWithFormat:@"%@_Launch", version];
    return keyLaunchString;
}

-(void)installUI
{
    //*
    BOOL bLaunchForVersion = [[NSUserDefaults standardUserDefaults] boolForKey:[self getLaunchStringKeyForCurVersion]];
    if(bLaunchForVersion)//for debugging
    {
        self.finishGuideBlock();
        return ;
    }
    //*/
    NSArray* arrLaunchImages = [self readLaunchImages];
    if(arrLaunchImages==nil)
    {
        //如果没有配置启动选项, 那么就直接标识引导页启动完成了.
        [self onFinishIntroduce];
        return ;
    }
    BXGLaunchView *launchView  = [BXGLaunchView new];
    [self.view addSubview:launchView];
    _launcheView = launchView;
    _launcheView.delegate = self;
    _launcheView.mode = LaunchViewMode_Introduce;
    
    [launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    int index= 0;
    NSMutableArray *arrRes = [NSMutableArray new];
    for(NSString *strItem in arrLaunchImages) {
        BXGLaunchRes *res = [BXGLaunchRes new];
        res.topicImagePath = strItem;
        res.textImagePath = [NSString stringWithFormat:@"%d", ++index];
        BXGLaunchItemView *launchItemView = [[BXGLaunchItemView alloc] initWithLaunchRes:res];
        [arrRes addObject:launchItemView];
    }
    
    if(arrRes && arrRes.count>0) {
        for(BXGLaunchItemView *item in arrRes) {
            [_launcheView addLaunchItemView:item];
        }
        [_launcheView layout];
    }
    
//    NSMutableArray* arrLinkImageView = [NSMutableArray new];
//    for (NSString* imageName in arrLaunchImages) {
//        NSLog(@"image Name=%@", imageName);
//        LinkImageView* linkImageView = [[LinkImageView alloc] initWithImage:[UIImage imageNamed:imageName]
//                                                              andLinkString:@""
//                                                                andTapBlock:^BOOL{
//                                                                    NSLog(@"tap");
//                                                                    return YES;
//                                                                }];
//        [arrLinkImageView addObject:linkImageView];
//    }
//
//    _loopView = [[LoopView alloc] initLinkImageViews:arrLinkImageView andRunMode:LoopViewMode_Introduce andDelegate:self];
//    [self.view addSubview:_loopView];
//
//    [_loopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.offset(0);
//    }];
    //[self.view layoutIfNeeded];
}

-(NSString *) dataFilePath{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"LaunchGuide"
                                                         ofType:@"plist"];
    return filePath;
    //    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentDirectory = [path objectAtIndex:0];
    //    return [documentDirectory stringByAppendingPathComponent:@"LaunchConfig.plist"];
}

-(NSArray*)readLaunchImages{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *arrImages = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
        return arrImages;
    }
    return nil;
}

#pragma LoopViewDelegate
-(void)onFinishIntroduce
{
    NSLog(@"response onFinishIntroduce");
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self getLaunchStringKeyForCurVersion]];

    self.finishGuideBlock();
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
