//
//  BXGPostDetailVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPostDetailVC.h"
#import "RWTableView.h"
#import "BXGPostDetailPostCell.h"
#import "BXGPostDetailCommentCell.h"
#import "BXGCommunityDetailViewModel.h"
#import "BXGCommunityDetailModel.h"
#import "BXGCommunityReportVC.h"
#import "BXGCommentVC.h"
#import "BXGMaskView.h"
#import "BXGPraisePersonVC.h"
#import "BXGCommunityCommentReplyModel.h"
#import "UIControl+Custom.h"
#import "UIButton+Extension.h"
#import "MJRefresh.h"


static NSString *postDetailPostCellId = @"BXGPostDetailPostCell";
static NSString *postDetailCommentCellId = @"BXGPostDetailCommentCell";
@interface BXGPostDetailVC ()
@property (nonatomic, strong) BXGCommunityDetailViewModel *viewModel;

@property (nonatomic, strong) BXGCommunityDetailModel *communityDetailModel;
@property (nonatomic, strong) NSArray<BXGCommunityCommentDetailModel*> *arrCommentityCommentDetailModel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL detailLoaded;
@property (nonatomic, assign) BOOL commentLoaded;
@property (atomic, assign) NSInteger loadCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) UILabel *commentCountLb;
@property (nonatomic, weak) UIButton *thumbBtn;
@property (nonatomic, weak) UIView *headerView;
@end

@implementation BXGPostDetailVC

- (BXGCommunityDetailViewModel *)viewModel{

    if(!_viewModel) {
    
        _viewModel = [BXGCommunityDetailViewModel new];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageName = @"博学圈帖子详情页";
    
    [self installUI];
    [self loadData];
    self.tableView.allowsSelection = false;
    self.title = @"帖子详情";
    [self.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
//    [self.view installMaskView:BXGMaskViewTypeLoading andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
}

- (void)loadData {
    Weak(weakSelf);
    
    [self.viewModel requstIsBannedFinishedBlock:nil isRefresh:YES];
    
    self.loadCount = 0;
    [self.viewModel requestCommunityId:self.model.idx andDetailBlock:^(BOOL succeed, NSString *errorMessage) {
        
        if(succeed) {
        
            if(weakSelf.viewModel.communityDetailModel) {
                
                weakSelf.communityDetailModel = weakSelf.viewModel.communityDetailModel;
                
                

                if(weakSelf.communityDetailModel && weakSelf.communityDetailModel.isPraise) {
                    
                     [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
                     [self.thumbBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
                    
                }else {
                    
                     [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
                    [self.thumbBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
                }
                
            }else {
                
                weakSelf.communityDetailModel = nil;
            }
            weakSelf.loadCount = weakSelf.loadCount + 1;
            if(weakSelf.loadCount >= 2) {
                
                [self.tableView reloadData];
                [self.view removeMaskView];
                weakSelf.loadCount = 0;
                [weakSelf.tableView bxg_endHeaderRefresh];
                
                
            }
        }else {
        
            [self.view installMaskView:BXGMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
        }
        

    }];
    
    [self.viewModel requestCommunityCommentPostId:self.model.idx andDetailBlock:^(BOOL succeed, NSString *errorMessage) {
        
        if(succeed) {
        
            if(weakSelf.viewModel.arrCommentityCommentDetailModel) {
                
                weakSelf.arrCommentityCommentDetailModel = weakSelf.viewModel.arrCommentityCommentDetailModel;
                
                weakSelf.commentCount = weakSelf.viewModel.arrCommentityCommentDetailModel.count;
                
                
                
            }else {
                
                weakSelf.arrCommentityCommentDetailModel = nil;
                weakSelf.commentCount = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    //weakSelf.commentCountLb.text = @"0";
                });
                
                
                
            }
            weakSelf.loadCount = weakSelf.loadCount + 1;
            if(weakSelf.loadCount >= 2) {
                
                [self.tableView reloadData];
                [self.view removeMaskView];
                [weakSelf.tableView bxg_endHeaderRefresh];
                weakSelf.loadCount = 0;
            }
        }else {
        
            [self.view installMaskView:BXGMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
        }
        
    }];
    
}



- (void)installUI {

    Weak(weakSelf);
    self.automaticallyAdjustsScrollViewInsets = false;
    [self commentHeaderView];
    RWTableView *tableView = [[RWTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        // make.bottom.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET + 9);
    }];
    
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
      
        if(section == 0) {
        
            if(weakSelf.communityDetailModel) {
                return 1;
            }else {
            
                return 0;
            }
            
        }else {
        
            return self.arrCommentityCommentDetailModel.count;
        }
        
    };
    
    tableView.numberOfSectionsInTableViewBlock = ^NSInteger(UITableView *__weak tableView) {
        return 2;
    };
    [tableView registerNib:[UINib nibWithNibName:@"BXGPostDetailPostCell" bundle:nil] forCellReuseIdentifier:postDetailPostCellId];
    [tableView registerNib:[UINib nibWithNibName:@"BXGPostDetailCommentCell" bundle:nil] forCellReuseIdentifier:postDetailCommentCellId];
    
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//       
//        [weakSelf loadData];
//    }];
    
    [tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadData];
    }];
    
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        if(indexPath.section == 0) {
            
            BXGPostDetailPostCell *cell = [tableView dequeueReusableCellWithIdentifier:postDetailPostCellId forIndexPath:indexPath];
            cell.detailModel = weakSelf.communityDetailModel;


            cell.clickReportBtnDetailModelBlock = ^(BXGCommunityDetailModel *model) {
                    [weakSelf reportWithPostModel:model];
            };
            
            cell.clickThumbListBlock = ^(BXGCommunityDetailModel *model) {
                
                [weakSelf toPraisePersonListV:model];
            };
            
            cell.clickPraiseBtnBlock = ^(BXGCommunityDetailModel *model) {
                
                [weakSelf thumbPost:model];
            };
            cell.clickAttentionBlock = ^(BXGCommunityDetailModel *model) {
              
                [weakSelf attention:weakSelf.communityDetailModel];
            };
            return cell;
            
        }else {
            
            BXGPostDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:postDetailCommentCellId forIndexPath:indexPath];
            cell.clickMsgBtnBlock = ^(BXGCommunityCommentDetailModel *commentModel) {
                
                [weakSelf postCommentReply:commentModel];
            };
            
            cell.clickReportCommentBtnBlock = ^(BXGCommunityCommentDetailModel *commentModel) {
                
                [weakSelf reportWithCommentModel:commentModel];
            };
            
            cell.tapReplyViewBlock = ^(BXGCommunityCommentReplyModel *model) {
                
                [weakSelf postCommentReplyReply:model];
            };
            
            cell.clickPraiseThumbBtnBlock = ^(BXGCommunityCommentDetailModel *model) {
//                [weakSelf thumbComment:model withIndexPath:indexPath];
                [weakSelf postCommentPraiseModel:model withIndexPath:indexPath];
            };
            
            
            cell.model = weakSelf.arrCommentityCommentDetailModel[indexPath.row];
            
            
            
            return cell;
        }
    };
    UIView *ttopSpView = [UIView new];
    [self.view addSubview:ttopSpView];
    [ttopSpView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(tableView.mas_top).offset(0);
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    ttopSpView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    tableView.viewForHeaderInSectionBlock = ^UIView *(UITableView *__weak tableView, NSInteger section) {
        if(section == 1) {
        
            return [weakSelf commentHeaderView];
            
        }else {
        
        
            return nil;
        }
    };
    
    tableView.viewForFooterInSectionBlock = ^UIView *(UITableView *__weak tableView, NSInteger section) {
      
        if(section == 1) {
            
            return [weakSelf commentFooterView];
            
        }else {
            
            
            return nil;
        }
    };
    
    tableView.heightForHeaderInSectionBlock = ^CGFloat(UITableView *__weak tableView, NSInteger section) {
        if(section == 1)  {
        
            return 100;
        }else {
        
            return 0.001;
        }
    };
    
    tableView.heightForFooterInSectionBlock = ^CGFloat(UITableView *__weak tableView, NSInteger section) {
        
        if(section == 1)  {
            
            if(self.arrCommentityCommentDetailModel.count > 0) {
            
                return 0.001;
            }else {
                
                return 200;
            }
            
        }else {
            
            return 9;
        }
    };
    self.tableView = tableView;
    
    
    
    // *** Bottom Tab Bar
    
    UIView *bottomTabBar = [UIView new];
    [self.view addSubview:bottomTabBar];
    [bottomTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(50);
        make.top.equalTo(tableView.mas_bottom);
    }];
    
    UIView *topSpView = [UIView new];
    [bottomTabBar addSubview:topSpView];
    [topSpView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(1);
    }];
    topSpView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    
    UIButton *thumbBtn = [UIButton buttonWithType:0];
    thumbBtn.custom_acceptEventInterval = 1;
    UIButton *commentBtn = [UIButton buttonWithType:0];
    // UIButton *starBtn = [UIButton buttonWithType:0];
    UIView *spView = [UIView new];
    
    
    [bottomTabBar addSubview:thumbBtn];
    [bottomTabBar addSubview:commentBtn];
    // [bottomTabBar addSubview:starBtn];
    [bottomTabBar addSubview:spView];
    
    
    // tableView.tableFooterView;
    
    commentBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    commentBtn.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    
    thumbBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    thumbBtn.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    
    [thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"学习圈-评论"] forState:UIControlStateNormal];
    [thumbBtn setTitle:@"赞" forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(onClickPostCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.custom_acceptEventInterval = 0.5;
    [commentBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    
    [thumbBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];

    
    self.thumbBtn = thumbBtn;
    [thumbBtn addTarget:self action:@selector(onClickThumbPostBtn) forControlEvents:UIControlEventTouchUpInside];
    [thumbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(thumbBtn.mas_right);
        make.height.offset(10);
        make.width.offset(1);
        make.centerY.offset(0);
    }];
    spView.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    spView.layer.cornerRadius = 0.5;
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(spView.mas_right).offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
        make.width.equalTo(thumbBtn);
    }];
    
    thumbBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
}

- (UIView *)commentHeaderView; {
    
    UIView *titleBlockView = [UIView new];
    titleBlockView.bounds = CGRectMake(0, 0, 0, 100);
    UIButton *commentBtn = [UIButton buttonWithType:0];
    [titleBlockView addSubview:commentBtn];
    [commentBtn setTitle:@"点完赞，发个评论，才是真正的认可！" forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"学习圈-编辑评论"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    [commentBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];

    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(6);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(39);
    }];
    commentBtn.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    commentBtn.custom_acceptEventInterval = 1;
    [commentBtn addTarget:self action:@selector(onClickPostCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topSpView = [UIView new];
    [titleBlockView addSubview:topSpView];
    [topSpView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(commentBtn.mas_bottom).offset(6);
    }];
    topSpView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    UILabel *tagLb = [UILabel new];
    tagLb.text = @"评论:";
    [titleBlockView addSubview:tagLb];
    [tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.equalTo(topSpView.mas_bottom).offset(10);
    }];
    
    UILabel *commentCountLb = [UILabel new];
    self.commentCountLb = commentCountLb;
    if(self.commentCount >= 0) {
        
        commentCountLb.text = @(self.commentCount).description;
    }else {
    
        commentCountLb.text = @"0";
    }
    
    [titleBlockView addSubview:commentCountLb];
    [commentCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(tagLb.mas_right).offset(0);
        make.centerY.equalTo(tagLb).offset(0);
    }];
    
    
    UIView *bottomSpView = [UIView new];
    [titleBlockView addSubview:bottomSpView];
    [bottomSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(tagLb.mas_bottom).offset(9);
        make.bottom.offset(0);
    }];
    bottomSpView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    titleBlockView.backgroundColor = [UIColor whiteColor];
    self.headerView = titleBlockView;
    return titleBlockView;
}

- (UIView *)commentFooterView; {
    
    UIView *footerView = [UIView new];
    
    if(self.arrCommentityCommentDetailModel.count > 0) {
    
    }else {
    
        [footerView installMaskView:BXGMaskViewTypeNoPraise];
    }
    
    return footerView;
}

                                         
- (void)toPraisePersonListV:(BXGCommunityDetailModel *) model{
    
    
    [[BXGBaiduStatistic share] statisticEventString:bxq_tzxq_dzr andParameter:nil];
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    BXGPraisePersonVC *praiseVC = [BXGPraisePersonVC new];
    praiseVC.postId = model.idx;
    [self.navigationController pushViewController:praiseVC animated:true];
}
                                         
                                         
- (void)onClickPostCommentBtn:(UIButton *)sender {
    
    
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    [self postComment:self.communityDetailModel];
}

- (void)reportWithPostModel:(BXGCommunityDetailModel *)model {

    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self checkVistPrevilidgeBlock:^(BOOL bHasPreviledge) {
        if(bHasPreviledge) {
            
            BXGCommunityReportVC *reportVC = [BXGCommunityReportVC new];
            reportVC.detailModel = model;
            reportVC.reportType = ReportTypePost;
            [weakSelf.navigationController pushViewController:reportVC animated:true];
        }
    }];
}

- (void)reportWithCommentModel:(BXGCommunityCommentDetailModel *)model {
    
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self checkVistPrevilidgeBlock:^(BOOL bHasPreviledge) {
        if(bHasPreviledge) {
            BXGCommunityReportVC *reportVC = [BXGCommunityReportVC new];
            reportVC.commentModel = model;
            reportVC.reportType = ReportTypeComment;
            [weakSelf.navigationController pushViewController:reportVC animated:true];
        }
    }];
}

- (void)postComment:(BXGCommunityDetailModel *)model{

    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    Weak(weakSelf);
    [weakSelf checkVistPrevilidgeBlock:^(BOOL bHasPreviledge) {
        if(bHasPreviledge) {
            
            BXGCommentVC *commentVC = [[BXGCommentVC alloc]initForPostCommentWithPostModel:model];
            commentVC.commentFinishedBlock = ^(BOOL succeed) {
                
                if(succeed) {
                    
                    [weakSelf.tableView bxg_beginHeaderRefresh];
                    // [weakSelf loadData];
                }
                
            };
            [weakSelf.navigationController pushViewController:commentVC animated:true];
        }
        
    }];
}

- (void)postCommentReply:(BXGCommunityCommentDetailModel *)model{
    
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    Weak(weakSelf);
    [weakSelf checkVistPrevilidgeBlock:^(BOOL bHasPreviledge) {
        if(bHasPreviledge) {
            BXGCommentVC *commentVC = [[BXGCommentVC alloc]initForPostCommentReplyCommentWithCommentModel:model];
            commentVC.commentFinishedBlock = ^(BOOL succeed) {
                
                if(succeed) {
                    
//                    [weakSelf loadData];
                    [weakSelf.tableView bxg_beginHeaderRefresh];
                }
            };
            [weakSelf.navigationController pushViewController:commentVC animated:true];
        }
        
    }];
}

- (void)postCommentReplyReply:(BXGCommunityCommentReplyModel *)model{
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    Weak(weakSelf);
    [weakSelf checkVistPrevilidgeBlock:^(BOOL bHasPreviledge) {
        if(bHasPreviledge) {
            BXGCommentVC *commentVC = [[BXGCommentVC alloc]initForPostCommentReplyReplyWithReplyModel:model];
            commentVC.commentFinishedBlock = ^(BOOL succeed) {
                
                if(succeed) {
                    
                    [weakSelf.tableView bxg_beginHeaderRefresh];
//                    [weakSelf loadData];
                }
                
            };
            [weakSelf.navigationController pushViewController:commentVC animated:true];
        }
    }];
}

-(void)postCommentPraiseModel:(BXGCommunityCommentDetailModel *)model withIndexPath:(NSIndexPath*)indexPath
{
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    if(model.isPraise) {
        
        model.isPraise = false;
        
        
        if(model.praiseSum && [model.praiseSum integerValue] > 0) {
            
            model.praiseSum = @([model.praiseSum integerValue] - 1);
        }
    }else {
        
        model.isPraise = true;
        if(model.praiseSum) {
            
            model.praiseSum = @([model.praiseSum integerValue] + 1);
        }
        
    }
    
    [self.viewModel  thumbCommentWithCommentId:model.idx andPostId:model.postId andPostUserId:model.userId andOperate:@(model.isPraise) andFinished:^(BOOL succeed) {
        //成功
    }];
    
    BXGPostDetailCommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell) {
        
        cell.model = model;
    }
}

//- (void)thumbCommentWithCommentId:(NSNumber *)commentId
//                        andPostId:(NSNumber *)postId
//                    andPostUserId:(NSNumber *)postUserId
//                       andOperate:(BOOL)isThumb
//                      andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock {




// [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
// [self.thumbBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
// [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
//[self.thumbBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];

    
    



- (void)thumbPost:(BXGCommunityDetailModel *)model{
    
    [[BXGBaiduStatistic share] statisticEventString:bxq_tzxq_dz andParameter:nil];
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    if(!model.isPraise) {
        
        
         [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
         [self.thumbBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];

        model.isPraise = true;
        if(model.praiseSum) {
            
            model.praiseSum = @([model.praiseSum integerValue] + 1);
        }
        [self.viewModel thumbPostWithPostId:model.idx
                                 andOperate:@(model.isPraise)
                              andPostUserId:model.userId
                                andFinished:^(BOOL succeed) {
                                    
                                    // 成功
                                }];
        
        NSMutableArray *praisedUserList = [[NSMutableArray alloc]initWithArray:self.communityDetailModel.userList];
        
        if([BXGUserCenter share].userModel){
            
            self.communityDetailModel.userList = [praisedUserList arrayByAddingObject:[BXGUserCenter share].userModel.communityUserModel];
        }

    }else {

         [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
        [self.thumbBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
            model.isPraise = false;
            if(model.praiseSum && [model.praiseSum integerValue] > 0) {
                
                model.praiseSum = @([model.praiseSum integerValue] - 1);
            }
            [self.viewModel thumbPostWithPostId:model.idx
                                     andOperate:@(model.isPraise)
                                  andPostUserId:model.userId
                                    andFinished:^(BOOL succeed) {
                                        
                                        // 成功
                                    }];
            
            NSMutableArray<BXGCommunityUserModel *> *praisedUserList = [[NSMutableArray alloc]initWithArray:self.communityDetailModel.userList];
            if([BXGUserCenter share].userModel){
                
                for (NSInteger i = 0; i < praisedUserList.count; i++) {
                    
                    if(praisedUserList[i].userId.integerValue == [BXGUserCenter share].userModel.communityUserModel.userId.integerValue) {
                        
                        [praisedUserList removeObject:praisedUserList[i]];
                    }
                }
                self.communityDetailModel.userList = praisedUserList;
            }
    }

    BXGPostDetailPostCell *postCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if(postCell) {
        
        postCell.detailModel = model;
    }
    
    
//    if(self.tableView.numberOfSections > 0 && [self.tableView numberOfRowsInSection:0] > 0) {
//
//
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }

}

- (void)thumbComment:(BXGCommunityCommentDetailModel *)model withIndexPath:(NSIndexPath *)indexPath{
    
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    if(model.isPraise) {
    
        model.isPraise = false;
        if(model.praiseSum && [model.praiseSum integerValue] > 0) {
        
            model.praiseSum = @([model.praiseSum integerValue] - 1);
        }
    }else {
    
        model.isPraise = true;
        if(model.praiseSum) {
            
            model.praiseSum = @([model.praiseSum integerValue] + 1);
        }
    }
    
   
    [self.viewModel thumbPostWithPostId:model.idx
                             andOperate:@(model.isPraise)
                          andPostUserId:model.userId
                            andFinished:^(BOOL succeed) {
        
        // 成功
    }];
    BXGPostDetailCommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        
        cell.model = model;
    }
}

- (void)attention:(BXGCommunityDetailModel *)model {
    
    [[BXGBaiduStatistic share] statisticEventString:bxq_tzxq_gzan andParameter:nil];
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    if(model.isAttention)
    {
        
        BXGAlertController *alert = [BXGAlertController confirmWithTitle:kBXGToastCancelAttention message:nil confirmHandler:^{
            
            if(model.isAttention) {
                // 取消关注
                model.isAttention = !model.isAttention;
                [self.viewModel updatePraiseStatusByFollowUUID:model.userId andAttention:@(model.isAttention) andFinishBlock:^(BOOL bSuccess, NSError *errorMessage) {
                }];
                [self.tableView reloadData];
            }
            
        } cancleHandler:^{
            
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        // 关注
        model.isAttention = !model.isAttention;
        [self.viewModel updatePraiseStatusByFollowUUID:model.userId andAttention:@(model.isAttention) andFinishBlock:^(BOOL bSuccess, NSError *errorMessage) {
        }];
        
        [self.tableView reloadData];
    }
}

- (void)onClickThumbPostBtn {
    
    // [[BXGBaiduStatistic share] statisticEventString:bxq_tzxq_dz andParameter:nil];
    if([self isNeedPresentLoginBlock:nil])
    {
        return;
    }
    
    Weak(weakSelf);
    [self.thumbBtn animationImage:self.communityDetailModel.isPraise?[UIImage imageNamed:@"点赞-未选中"] : [UIImage imageNamed:@"点赞-选中"]
                          bZoomIn:!self.communityDetailModel.isPraise
               andCompletionBlock:^{
                   [weakSelf thumbPost:self.communityDetailModel];
               }];
    
}

-(void)checkVistPrevilidgeBlock:(void (^)(BOOL bHasPreviledge))previledgeBlock
{
    NSAssert(_viewModel!=nil, @"_viewModel is nil");
    [_viewModel requstIsBannedFinishedBlock:^(BannerType bannerType, NSString *errorMessage) {
        
        if(bannerType==BannerType_None) {
            [[BXGHUDTool share] closeHUD];
            previledgeBlock(YES);
        }
        else if(bannerType==BannerType_Prohibit_Speak) {
            [[BXGHUDTool share] showHUDWithString:kBXGToastBannerProhibitSpeak];
            previledgeBlock(NO);
        }
        else if(bannerType==BannerType_Black_Name_List) {
            [[BXGHUDTool share] showHUDWithString:kBXGToastBannerBlackList];
            previledgeBlock(NO);
        }
        else { //if(bannerType==BannerType_Unknow) {
            [[BXGHUDTool share] showHUDWithString:kBXGToastBannerException];
            previledgeBlock(NO);
        }
    } isRefresh:NO];
}


@end
