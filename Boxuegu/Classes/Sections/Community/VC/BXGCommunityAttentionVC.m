//
//  BXGCommunityAttentionVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityAttentionVC.h"
#import "PreviewImageVC.h"
#import "UIViewController+MOPopWindow.h"
#import "BXGAttentionViewModel.h"
#import "BXGAttentionContentCell.h"
#import "RWTableView.h"
#import "BXGCommunityReportVC.h"
#import "BXGPostDetailVC.h"
#import "BXGCommentVC.h"
#import "BXGPraisePersonVC.h"
#import "BXGMaskView.h"
#import "BXGNotificationTool.h"
#import "BXGUserLoginVC.h"

static NSString *attentionContentCellId = @"BXGAttentionContentCell";
@interface BXGCommunityAttentionVC() <BXGNotificationDelegate>
@property(nonatomic, strong) NSArray *arrImages;
@property (nonatomic, strong) BXGAttentionViewModel *viewModel;
@property (nonatomic, strong) NSArray<BXGCommunityPostModel *> *postModelArray;
@property (nonatomic, strong) RWTableView *tableView;
@property (nonatomic, assign) ShowType showType;
//@property (nonatomic, assign) BOOL isLoading;
@end

@implementation BXGCommunityAttentionVC

- (BXGAttentionViewModel *)viewModel {

    if(!_viewModel){
    
        _viewModel = [BXGAttentionViewModel new];
    }
    return _viewModel;
}

- (instancetype)init {

    self = [super init];
    if(self) {
    
        // [self installUI];
    }
    return self;
}
-(instancetype)initWithType:(ShowType)type; {

    self.showType = type;
    self = [self init];
    if(type == ShowTypeAttention) {
    
        self.title = @"关注";
    }else {
        
        self.title = @"我的帖子";
    }
    return self;
}

- (void)dealloc {

    [self uninstallObservers];
}

- (void)installObservers {

    [BXGNotificationTool addObserverForUserLogin:self];

}

- (void)uninstallObservers {
    
    
    [BXGNotificationTool removeObserver:self];
}

- (void)installUI {

    Weak(weakSelf);
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.offset(0);
        make.height.offset(9);
    }];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    RWTableView *tableView = [RWTableView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(spView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [tableView registerNib:[UINib nibWithNibName:@"BXGAttentionContentCell" bundle:nil] forCellReuseIdentifier:attentionContentCellId];
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGAttentionContentCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionContentCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = weakSelf.postModelArray[indexPath.row];
        
        
        cell.clickThumbListBlock = ^(BXGCommunityPostModel *model) {
            
            [weakSelf toPraisePersonListV:model];
        };
        cell.clickPraiseBtnBlock = ^(BXGCommunityPostModel *model) {
          
            [weakSelf thumbPost:model andIndexPath:indexPath];
        };
        
        cell.clickReportBtnBlock = ^(BXGCommunityPostModel *model) {
          
            [weakSelf onClickReportWithPostModel:model];
        };
        cell.clickMsgBtnBlock = ^(BXGCommunityPostModel *model, UIButton *sender) {
            
            [weakSelf toCommentWithPostModel:model andSender:sender];
        };
        return cell;
        // weakSelf.postModelArray
    };
    
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        
        return weakSelf.postModelArray.count;
    };
    
    tableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        [weakSelf onClickToDetail:weakSelf.postModelArray[indexPath.row]];
        
    };
    
    
    tableView.allowsSelection = true;
    self.tableView = tableView;
    tableView.estimatedRowHeight = 300;
    tableView.rowHeight = UITableViewAutomaticDimension;

    [tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadDataWithIsReflesh:true];
    }];
    
    [tableView bxg_setFootterRefreshBlock:^{
        [weakSelf loadDataWithIsReflesh:false];
    }];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self installObservers];
}

- (void)onClickToDetail:(BXGCommunityPostModel *)model {

    BXGPostDetailVC *postDetailVC = [BXGPostDetailVC new];
    postDetailVC.model = model;
    [self.navigationController pushViewController:postDetailVC animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    //self.view.backgroundColor = [UIColor randomColor];
    
    [self installUI];
    
    [self.view installLoadingMaskView];
    //[self loadDataWithIsReflesh:true];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    Weak(weakSelf);
    if(![BXGUserCenter share].userModel){
        
        self.postModelArray = nil;

        [self.view removeMaskView];
        [self.tableView removeMaskView];
        
        [self.view installMaskView:BXGButtonMaskViewTypeNoLogin buttonBlock:^{
            BXGUserLoginVC *loginVC = [BXGUserLoginVC new];
            BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:loginVC];
            [weakSelf presentViewController:nav animated:true completion:nil];
        }];
        
//        [self.view installMaskView:BXGMaskViewTypeNoLogin tapBlock:^{
//
//
//        }];
        
        [weakSelf.tableView bxg_endHeaderRefresh];
        [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
    }else {
    
        [self.view removeMaskView];
        if(self.postModelArray == nil) {
        
            [self.tableView bxg_beginHeaderRefresh];
        }else {
        
        }
    }
}

- (void)loadDataWithIsReflesh:(BOOL)isReflesh {
    
    Weak(weakSelf);
    
    if(![BXGUserCenter share].userModel){
        
        BXGUserLoginVC *loginVC = [BXGUserLoginVC new];
        BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:loginVC];
        
        [self.view removeMaskView];
        [self.tableView removeMaskView];
        [self.view installMaskView:BXGButtonMaskViewTypeNoLogin buttonBlock:^{
//            BXGUserLoginVC *loginVC = [BXGUserLoginVC new];
//            BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:loginVC];
            [weakSelf presentViewController:nav animated:true completion:nil];
        }];
//        [self.view installMaskView:BXGMaskViewTypeNoLogin tapBlock:^{
//
//            [weakSelf presentViewController:nav animated:true completion:nil];
//        }];
        [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
        [weakSelf.tableView bxg_endHeaderRefresh];
    }else {
        
        [self.viewModel requstIsBannedFinishedBlock:nil isRefresh:YES];
        
        void(^finished)(NSArray<BXGCommunityPostModel *> *modelArray, BOOL isNoMore) = ^(NSArray<BXGCommunityPostModel *> *modelArray, BOOL isNoMore) {
          
            [self.view removeMaskView];
            [self.tableView removeMaskView];
            
            if(modelArray){
                
                if(modelArray.count > 0) {
                    
                }else {
                    
                    if(self.showType == ShowTypeAttention){
                        
                        [self.tableView installMaskView:BXGMaskViewTypeNoAttentionPerson];
                        
                    }else {
                        
                        [self.tableView installMaskView:BXGMaskViewTypeNoTopicPage];
                    }
                }
                
            } else {
#warning 
                [weakSelf.view installMaskView:BXGButtonMaskViewTypeLoadFailed buttonBlock:^{
                    [weakSelf.view installLoadingMaskView];
                    [weakSelf loadDataWithIsReflesh:true];
                }];
                
//                [self.tableView installMaskView:BXGMaskViewTypeLoadFailed tapBlock:^{
//                    return;
//                    [weakSelf.view installLoadingMaskView];
//                    [weakSelf loadDataWithIsReflesh:true];
//                }];
            }
            
            weakSelf.postModelArray = modelArray;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView bxg_endHeaderRefresh];
//            [weakSelf.tableView.mj_header endRefreshing];
            if(isNoMore) {
                [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
//                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableView bxg_endFootterRefresh];
//                [weakSelf.tableView.mj_footer endRefreshing];
            }
        };
    
        if(self.showType == ShowTypeAttention){
        
            [self.viewModel loadPostListWithIsReflesh:isReflesh andFinished:finished];

        }else {
        
            [self.viewModel loadHomePostListWithIsReflesh:isReflesh andFinished:finished];
        }
    }
}

- (void)onClickReportWithPostModel:(BXGCommunityPostModel *)model; {

    BXGCommunityReportVC *reportVC = [BXGCommunityReportVC new];
    reportVC.model = model;
    [self.navigationController pushViewController:reportVC animated:true needLogin:true];
}

- (void)toCommentWithPostModel:(BXGCommunityPostModel *)model andSender:(UIButton*)sender {

    if(![self isNeedPresentLoginBlock:nil]) {
        
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        sender.enabled = false;
        [_viewModel requstIsBannedFinishedBlock:^(BannerType bannerType, NSString *errorMessage) {
            
            if(bannerType==BannerType_None) {
                [[BXGHUDTool share] closeHUD];
                BXGCommentVC *commentVC = [[BXGCommentVC alloc]initForPostCommentWithAttentionPostModel:model];
                [self.navigationController pushViewController:commentVC animated:true];
            }
            else if(bannerType==BannerType_Prohibit_Speak) {
                
                [[BXGHUDTool share] showHUDWithString:kBXGToastBannerProhibitSpeak];
            }
            else if(bannerType==BannerType_Black_Name_List) {
                
                [[BXGHUDTool share] showHUDWithString:kBXGToastBannerBlackList];
            }
            else { //if(bannerType==BannerType_Unknow) {
                
                [[BXGHUDTool share] showHUDWithString:kBXGToastBannerException];
            }
            
            sender.enabled = true;
        } isRefresh:NO];
    }
    
}

- (void)thumbPost:(BXGCommunityPostModel *)model andIndexPath:(NSIndexPath *)indexPath {
    
//    if(model.isPraise) {
//
//        model.isPraise = false;
//        //[self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
//        if(model.praiseSum && [model.praiseSum integerValue] > 0) {
//
//            model.praiseSum = @([model.praiseSum integerValue] - 1);
//        }
//    }else {
//
//        model.isPraise = true;
//        //[self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
//        if(model.praiseSum) {
//
//            model.praiseSum = @([model.praiseSum integerValue] + 1);
//        }
//    }
    if(!model.isPraise) {
        
//        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
        model.isPraise = true;
        if(model.praiseSum) {
            
            model.praiseSum = @([model.praiseSum integerValue] + 1);
        }
        [self.viewModel thumbPostWithPostId:model.idx
                                 andOperate:model.isPraise
                              andPostUserId:model.userId
                                andFinished:^(BOOL succeed) {
                                    
                                    // 成功
                                }];
        
        NSMutableArray *praisedUserList = [[NSMutableArray alloc]initWithArray:model.praisedUserList];
        
        if([BXGUserCenter share].userModel){
            
            model.praisedUserList = [praisedUserList arrayByAddingObject:[BXGUserCenter share].userModel.communityUserModel];
        }

    }else {
        
        
        model.isPraise = false;
        if(model.praiseSum && [model.praiseSum integerValue] > 0) {
            
            model.praiseSum = @([model.praiseSum integerValue] - 1);
        }
        [self.viewModel thumbPostWithPostId:model.idx
                                 andOperate:model.isPraise
                              andPostUserId:model.userId
                                andFinished:^(BOOL succeed) {
                                    
                                    // 成功
                                }];
        
        NSMutableArray<BXGCommunityUserModel *> *praisedUserList = [[NSMutableArray alloc]initWithArray:model.praisedUserList];
        if([BXGUserCenter share].userModel){
            
            for (NSInteger i = 0; i < praisedUserList.count; i++) {
                
                if(praisedUserList[i].userId.integerValue == [BXGUserCenter share].userModel.communityUserModel.userId.integerValue) {
                    
                    [praisedUserList removeObject:praisedUserList[i]];
                }
            }
            model.praisedUserList = praisedUserList;
        }
        
        
        
    
        // [self.tableView reloadData];
        
    }
    BXGAttentionContentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        
        cell.model = model;
    }
    // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)toThumbList:(BXGCommunityPostModel *)model {

    BXGPraisePersonVC *vc = [[BXGPraisePersonVC alloc]init];
    
    vc.postId = model.idx;
    [self.navigationController pushViewController:vc animated:true];
}
- (void)catchUserLoginNotificationWith:(BOOL)isLogin; {

    if(isLogin) {
    
        [self.view installLoadingMaskView];
    }
    
    self.postModelArray = nil;
    [self.tableView reloadData];
    
}

- (void)toPraisePersonListV:(BXGCommunityPostModel *) model{
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    BXGPraisePersonVC *praiseVC = [BXGPraisePersonVC new];
    praiseVC.postId = model.idx;
    [self.navigationController pushViewController:praiseVC animated:true];
}
@end
