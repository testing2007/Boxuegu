//
//  BXGSearchVC.m
//  Boxuegu
//
//  Created by apple on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchVC.h"
#import "UIView+Frame.h"
#import "BXGSearchResultView.h"
#import "BXGSearchRecommendView.h"
#import "BXGTextField.h"
#import "BXGSearchBar.h"

@interface BXGSearchVC ()<UISearchBarDelegate>

//@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) BXGSearchBar *textField;
@property (nonatomic, weak) BXGSearchResultView *resultView;
@property (nonatomic, weak) BXGSearchRecommendView *recommendView;

@end

@implementation BXGSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageName = @"搜索";
    
    // Do any additional setup after loading the view.
    BXGSearchBar *searchBar = [[BXGSearchBar alloc] initWithFrame:CGRectMake(0,
                                                                          8,
                                                                          SCREEN_WIDTH-60-15,
                                                                          28)];
//    if (@available(iOS 11.0, *)) {
//        [searchBar.heightAnchor constraintEqualToConstant:28].active = YES;
//    }
    [searchBar setImage:[UIImage imageNamed:@"搜索-搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setPositionAdjustment:UIOffsetMake(5, 0) forSearchBarIcon:UISearchBarIconSearch];
    [searchBar setImage:[UIImage imageNamed:@"搜索-清除"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    searchBar.backgroundImage = [[UIImage alloc] init];//设置背景图是为了去掉上下黑线

    searchBar.tintColor = [UIColor colorWithHex:0xFFFFFF];//光标颜色
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    _textField = searchBar;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0,//_textField.x+_textField.width+15,
                                   14.5,
                                   30,
                                   15)];
    [cancelBtn addTarget:self action:@selector(onCancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    UIBarButtonItem *barSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpace.width = 8;
    UIBarButtonItem *barSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    barSpace2.width = -6;
    self.navigationItem.leftBarButtonItems = @[barSpace2, leftItem, barSpace, rightItem];
    
    BXGSearchResultView *resultView = [BXGSearchResultView new];
    [self.view addSubview:resultView];
    _resultView = resultView;
    
    BXGSearchRecommendView *recommendView = [BXGSearchRecommendView new];
    recommendView.tapKeyword = ^(NSString *keyword) {
        [self.resultView doSearchByKeyword:keyword];
        [self cacheSearchKeyword:keyword];
        [self showResultView];
        [self.textField resignFirstResponder];
        [self.textField setText:keyword];
    };
    recommendView.closeKeyboard = ^{
        [self.textField resignFirstResponder];
//        [self searchBarTextDidEndEditing:self.textField];
    };
    [self.view addSubview:recommendView];
    _recommendView = recommendView;
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
    }];
    [recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
    }];

    [self showRecommendView];
    
    [self.textField becomeFirstResponder];
}

- (void)showResultView {
    self.resultView.hidden = NO;
    self.recommendView.hidden = YES;
}

- (void)showRecommendView {
    self.resultView.hidden = YES;
    self.recommendView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelSearch {
    [self.textField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.textField becomeFirstResponder];
    [self showRecommendView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchText=%@", searchBar.text);
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!searchBar.text || searchBar.text.length==0) {
        [[BXGHUDTool share] showHUDWithString:@"请输入要搜索的内容"];
        return ;
    }
    
    if([searchBar.text stringContainsEmoji]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return ;
    }
    
    [self.resultView doSearchByKeyword:searchBar.text];
    [self cacheSearchKeyword:searchBar.text];
    [self showResultView];
    
    [self.textField resignFirstResponder];
}

- (void)cacheSearchKeyword:(NSString*)newSearchKeyword {
    if(!newSearchKeyword || newSearchKeyword.length==0) {
        return ;
    }
    
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatSearchEventTypeSearchKeyWord andLabel:newSearchKeyword];
    
    NSMutableArray *arr = [[BXGUserDefaults share] arrHistorySearchRecord];
    NSUInteger nIndex = [arr indexOfObject:newSearchKeyword];
    if(nIndex != NSNotFound) {
        [arr removeObjectAtIndex:nIndex];
    }
    [arr insertObject:newSearchKeyword atIndex:0];
    [[BXGUserDefaults share] setArrHistorySearchRecord:arr] ;
}

@end
