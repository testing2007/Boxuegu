//
//  BXGQADetailVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGQADetailVC.h"
#import "RWTableView.h"
#import "BXGCommunityCell.h"
#import "BXGCommunityReplyCell.h"

@interface BXGQADetailVC ()

@end

@implementation BXGQADetailVC
static NSString *communityCellId = @"BXGCommunityCell";
static NSString *communityReplyCellId = @"BXGCommunityReplyCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问答精灵";
    [self installUI];
}

- (void)installUI {
    
    // table view
    RWTableView *tableView = [[RWTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
    }];
    
    [tableView registerNib:[UINib nibWithNibName:@"BXGCommunityCell" bundle:nil] forCellReuseIdentifier:communityCellId];
    [tableView registerNib:[UINib nibWithNibName:@"BXGCommunityReplyCell" bundle:nil] forCellReuseIdentifier:communityReplyCellId];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // footer view
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        if(section == 0){
            
            return 1;
        }
        if(section == 1){
            
            return 10;
        }
        return 0;
    };
    tableView.numberOfSectionsInTableViewBlock = ^NSInteger(UITableView *__weak tableView) {
        return 2;
    };
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        if(indexPath.section == 0){
            
            BXGCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:communityCellId forIndexPath:indexPath];
            return cell;
            
        }else {
            
            BXGCommunityReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:communityReplyCellId forIndexPath:indexPath];
            // if(section == 1){
            return cell;
        }
    };
    tableView.viewForHeaderInSectionBlock = ^UIView *(UITableView *__weak tableView, NSInteger section) {
        
        if(section != 1) {
            
            return nil;
        }
        
        
        UIView *sectionHeaderView = [UIView new];
        sectionHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        [sectionHeaderView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.offset(0);
            make.right.offset(-15);
            make.height.lessThanOrEqualTo(sectionHeaderView);
        }];
        
        label.font = [UIFont bxg_fontRegularWithSize:16];
        label.textColor = [UIColor colorWithHex:0x333333];
        [sectionHeaderView addSubview:label];
        label.text = @"评论:1";
        return sectionHeaderView;
    };
    tableView.heightForHeaderInSectionBlock = ^CGFloat(UITableView *__weak tableView, NSInteger section) {
        if(section != 1) {
            
            return 0;
        }
        return 50;
    };
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    // footer view
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
//    footerView.backgroundColor = [UIColor randomColor];
    tableView.tableFooterView = footerView;
    // reply view
    UIView *replyView = [UIView new];
    replyView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    // sub
    UITextField *replyTF = [UITextField new];
    UIButton *imgBtn = [UIButton new];
    UIButton *sendBtn = [UIButton new];
    [sendBtn setImage:[UIImage imageNamed:@"问答-发送-未点亮"] forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"问答-图片"] forState:UIControlStateNormal];
    //    UITextBorderStyleLine,
    //    UITextBorderStyleBezel,
    //    UITextBorderStyleRoundedRect
    // replyTF.borderStyle = UITextBorderStyleLine;
    replyTF.backgroundColor = [UIColor colorWithHex:0xffffff];
    replyTF.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    replyTF.layer.borderWidth = 1;
    replyTF.layer.cornerRadius = 2.5;
    replyTF.layer.masksToBounds = true;
    
    [replyView addSubview:replyTF];
    [replyView addSubview:imgBtn];
    [replyView addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.width.height.offset(20);
    }];
    
    [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(sendBtn.mas_left).offset(-20);
        make.centerY.offset(0);
        make.width.height.offset(20);
    }];
    
    [replyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.offset(30);
        make.right.equalTo(imgBtn.mas_left).offset(-20);
    }];
    
    replyTF.placeholder = @"发表评论";
    
    [self.view addSubview:replyView];
    [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(50);
        make.bottom.offset(0);
    }];
}
@end
