//
//  BXGBaseNaviController.m
//  Boxuegu
//
//  Created by RW on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseNaviController.h"
#import "UIImage+Extension.h"
#import "BXGUserLoginVC.h"
#import "BXGUserDefaults.h"

@implementation BarElement
@end


@interface BXGBaseNaviController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BXGBaseNaviController

- (instancetype)init {

    self = [super init];
    if (self) {
        
        self.delegate = self;
    }

    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        self.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interactivePopGestureRecognizer.delegate = self;
    // 隐藏 navigationBar
    
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage new]];

    // 设置 navigationBar 颜色
    
    [self.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:0x38ADFF] frame:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageFromColor:[UIColor colorWithHex:0x38ADFF] frame:CGRectMake(0, 0, 1, 1)]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationBar.translucent = true;
    
    // self.navigationBar.maskView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    // [self.navigationBar setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
    // [UIImage imageFromColor:[UIColor colorWithHex:0x38ADFF] frame:CGRectZero];
    
    // self.navigationBar.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    
    [self.navigationBar setBackIndicatorImage:[[UIImage imageNamed:@"返回-白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"返回-白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

#pragma mark - UINavigationControllerDelegate

// 隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[viewController class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


// 设置返回Item
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if(self.childViewControllers.count >= 1) {
        
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回-白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@ ];
//        viewController.navigationItem.leftBarButtonItem = backItem;
//        // 设置返回按钮位置
//        [backItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
//        
//        viewController.hidesBottomBarWhenPushed = true;
//        self.navigationBarHidden = false;
        // 隐藏tabbar
        UIBarButtonItem *backItem = [self createBackItemTarget:self withAction:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        viewController.hidesBottomBarWhenPushed = true;
        self.navigationBarHidden = false;
        
        
        
    }
    [super pushViewController:viewController animated:animated];
    // 修复iOS自身BUG: tabBar的frame
    if(self.tabBarController) {
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withTarget:(id)target backAction:(SEL)backAction
{
    
    if(self.childViewControllers.count >= 1) {
        UIBarButtonItem *backItem = [self createBackItemTarget:target withAction:backAction];
        viewController.navigationItem.leftBarButtonItem = backItem;
        viewController.hidesBottomBarWhenPushed = true;
        self.navigationBarHidden = false;
    }
    [super pushViewController:viewController animated:animated];
}

-(UIBarButtonItem*)createBackItemTarget:(id)target withAction:(SEL)backAction
{
    UIImage *imageIcon = [[UIImage imageNamed:@"返回-白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:imageIcon
                                                                 style:UIBarButtonItemStylePlain
                                                                target:target
                                                                action:backAction==nil ? @selector(back) : backAction];
    // 设置返回按钮位置
    [backItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    
    return backItem;
}

-(NSArray<UIBarButtonItem*>*)createNaviBarItemsWithBarElements:(NSArray<BarElement*>*)arrBarElements andBarItemSpace:(CGFloat)diffSpace
{
    //*
    if(!arrBarElements || arrBarElements.count<=0)
    {
        return nil;
    }
    UIBarButtonItem *barItemSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barItemSpace.width=diffSpace;

    NSMutableArray *mutableBarItems = [NSMutableArray new];
    [[arrBarElements.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(BarElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx>=1)
        {
            [mutableBarItems addObject:barItemSpace];
        }
        UIButton *buttonItem = [UIButton buttonWithType:0];
        buttonItem.frame = CGRectMake(0, 0, obj.size.width, obj.size.height);
//        UIButton *buttonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, obj.size.width, obj.size.height)];
        if(obj.imageName!=nil)
        {
            [buttonItem setImage:[UIImage imageNamed:obj.imageName] forState:UIControlStateNormal];
            [buttonItem setImage:[UIImage imageNamed:obj.imageName] forState:UIControlStateHighlighted];
        }
        else if(obj.text!=nil)
        {
            [buttonItem setTitle:obj.text forState:UIControlStateNormal];
        }
        else
        {
            NSAssert(FALSE, @"Both imageName and text shouldn't be nil");
        }
        [buttonItem addTarget:obj.target action:obj.sel forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:buttonItem];
        [barButtonItem setTintColor:obj.tintColor];
        
        [mutableBarItems addObject:barButtonItem];
    }];
    
    if(!mutableBarItems || mutableBarItems.count<=0)
        return nil;
    
    return [NSArray arrayWithArray:mutableBarItems];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^)())completion{

    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    if(completion){
    
        completion();
    }
    
    return vc;
    
}
//- (void)P:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    if(self.childViewControllers.count >= 1) {
//        
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回-白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action: @selector(back)];
//        viewController.navigationItem.leftBarButtonItem = backItem;
//        // 设置返回按钮位置
//        [backItem setImageInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
//        
//        viewController.hidesBottomBarWhenPushed = true;
//        self.navigationBarHidden = false;
//        // 隐藏tabbar
//    }
//    [super pushViewController:viewController animated:animated];
//}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    
    return self.childViewControllers.count > 1;
}

#pragma mark - 自定义状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {

    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{

    return self.topViewController.prefersStatusBarHidden;
}


- (void)back {

    [self popViewControllerAnimated:true];
}

#pragma mark - 自定义控制器的旋转

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

@end

@implementation UINavigationController(BXGBaseNaviController)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated needLogin:(BOOL)needLogin {
    
    if(![BXGUserDefaults share].userModel && needLogin) {
        UIViewController * toViewController = [[BXGBaseNaviController alloc]initWithRootViewController:[BXGUserLoginVC new]];
        [[self topViewController] presentViewController:toViewController animated:true completion:nil];
    }else {
        [self pushViewController:viewController animated:animated];
    }
}

- (void)dealloc {
    
}

@end

