//
//  BXGBaseNoteVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseNote.h"
#import "BXGNoteCell.h"
#import "BXGMaskView.h"
#import "BXGNoteDetailVC.h"

static NSString *cellIdentifier = @"BXGNoteCell";

@interface PraiseNoteStatus : NSObject
@property(nonatomic, strong) NSString *noteId;
@property(nonatomic, assign) BOOL bPraise;
@property(nonatomic, assign) NSInteger praiseNum;
@end
@implementation PraiseNoteStatus
@end
/*
@interface CollectNoteStatus : NSObject
@property(nonatomic, strong) NSString *noteId;
@property(nonatomic, assign) BOOL bCollect;
@end
@implementation CollectNoteStatus
@end
//*/
@interface LocalInfoRecord : NSObject

@property(nonatomic, strong) NSMutableDictionary<NSString*/*noteId*/, PraiseNoteStatus*> *dictPraiseNoteStatus;
//@property(nonatomic, strong) NSMutableDictionary<NSString*/*noteId*/, CollectNoteStatus*> *dictCollectNoteStatus;

@end

@implementation LocalInfoRecord

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static LocalInfoRecord* instance = NULL;
    dispatch_once(&onceToken, ^{
        instance = [[LocalInfoRecord alloc] init];
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _dictPraiseNoteStatus = [NSMutableDictionary new];
        //_dictCollectNoteStatus = [NSMutableDictionary new];
    }
    return self;
}

-(void)clearInfo
{
    [_dictPraiseNoteStatus removeAllObjects];
    //[_dictCollectNoteStatus removeAllObjects];
}

#define LocalInfoRecordInstance [LocalInfoRecord shareInstance]

@end

@interface BXGBaseNote ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UIViewController *targetVC;
@property(nonatomic, assign) NOTE_TYPE type;
@property(nonatomic, weak) NSString *courseId;
@property(nonatomic, strong) BXGCourseNoteDetailViewModel *courseNoteDetailViewModel;
@property(nonatomic, weak) UITableView *tableView;

//@property(nonatomic, strong)
//@property(nonatomic, strong)
@end

@implementation BXGBaseNote

-(instancetype)initWithTargetVC:(UIViewController*)targetVC
                    andNoteType:(NOTE_TYPE)noteType
                    andCourseId:(NSString*)courseId
{
    self = [super init];
    if(self)
    {
        _targetVC = targetVC;
        _type = noteType;
        _courseId = courseId;
        
        _courseNoteDetailViewModel = [BXGCourseNoteDetailViewModel new];
    }
    return self;
}

-(void)dealloc
{
    if(LocalInfoRecordInstance.dictPraiseNoteStatus)
    {
        for(PraiseNoteStatus *item in  LocalInfoRecordInstance.dictPraiseNoteStatus.allValues)
        {
            [self.courseNoteDetailViewModel updatePraiseNoteId:item.noteId
                                                 andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                     if(succeed)
                                                     {
                                                         NSLog(@"successful to update collect notd id=%@", item.noteId);
                                                     }
                                                 }];
        }
    }
    /*
    if(LocalInfoRecordInstance.dictCollectNoteStatus)
    {
        for(CollectNoteStatus *item in  LocalInfoRecordInstance.dictCollectNoteStatus.allValues)
        {
            [self.courseNoteDetailViewModel updateCollectNoteId:item.noteId
                                                 andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                     if(succeed)
                                                     {
                                                         NSLog(@"successful to update collect notd id=%@", item.noteId);
                                                     }
                                                 }];
        }
    }
    //*/

    [LocalInfoRecordInstance clearInfo];
    NSLog(@"BXGBaseNote is dealloc, %@", NSStringFromClass([self class]));
}

-(void)installUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.estimatedRowHeight = 94;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    [_targetVC.view addSubview:tableView];
    _tableView = tableView;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_offset(64);
        make.top.right.bottom.left.offset(0);
    }];
    
    [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    // _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       // [weakSelf refreshUI:YES];
    //}];
    [_tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI:YES];
    }];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    // self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       // [weakSelf refreshUI:NO];
    // }];
    [self.tableView bxg_setFootterRefreshBlock:^{
        [weakSelf refreshUI:NO];
    }];
    
    // 马上进入刷新状态
    // [self.tableView.mj_header beginRefreshing];
    [self.tableView bxg_beginHeaderRefresh];
    [self.tableView bxg_endFootterRefreshNoMoreData];
}

-(void)refreshUI:(BOOL)bRefresh
{
    //__weak UITableView *tableView = self.tableView;
    __weak typeof(self) weakSelf = self;
    [_courseNoteDetailViewModel requestCourseNoteDetailWithRefresh:bRefresh
                                                       andCourseId:_courseId
                                                           andType:_type
                                                    andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                        if(succeed)
                                                        {
                                                            [weakSelf.tableView removeMaskView];
                                                            [weakSelf.tableView reloadData];
                                                        }
                                                        else
                                                        {
                                                            NSLog(@"fail to get note detail data");
                                                        }
                                                        [weakSelf.tableView bxg_endHeaderRefresh];
                                                        if(weakSelf.courseNoteDetailViewModel.bHaveMoreData)
                                                        {
                                                            [weakSelf.tableView bxg_endFootterRefresh];
                                                        }
                                                        else
                                                        {
                                                            [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
                                                        }
                                                        if(weakSelf.courseNoteDetailViewModel.arrNote.count == 0)
                                                        {
                                                            if(bRefresh)
                                                            {
                                                                [weakSelf.tableView installMaskView:BXGMaskViewTypeNoNote];
                                                            }
                                                            else
                                                            {
                                                                [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
                                                            }
                                                        }
                                                    }];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _courseNoteDetailViewModel.arrNote.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXGNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!_courseNoteDetailViewModel.arrNote || indexPath.row>=_courseNoteDetailViewModel.arrNote.count)
        return cell;
    //*
    BXGCourseNoteDetailModel *model = _courseNoteDetailViewModel.arrNote[indexPath.row];
    
    [cell.userPortraitImageView sd_setImageWithURL:[NSURL URLWithString:model.small_head_photo] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    cell.nickNameLabel.text = model.user_name;
    cell.dateLabel.text = model.create_time;
    cell.noteDetailLabel.text = model.content;
    
    [self installLeftRichLabelForCell:cell andModel:model andType:_type];
    [self installRightRichLabelForCell:cell andModel:model andType:_type];
    //*/
    return cell;
}

-(void)installLeftRichLabelForCell:(BXGNoteCell*)cell andModel:(BXGCourseNoteDetailModel*)model andType:(NOTE_TYPE)type
{
    cell.leftRichLable.text = @"";
    if(_type == NOTE_TYPE_ALL || _type == NOTE_TYPE_COLLECT)
    {
        if([model.user_id isEqualToString:_courseNoteDetailViewModel.userModel.user_id])
        {
            //我自己的不能收藏
            cell.leftRichLable.hidden = YES;
        }
        else
        {
            //[self updateCurrentModelIfExistCollectInLocal:model];
            
            cell.leftRichLable.hidden = NO;
            __weak typeof(self) weakSelf = self;
            [cell.leftRichLable setRichLabelActiveImage:[UIImage imageNamed:@"收藏-选中"]
                                          inactiveImage:[UIImage imageNamed:@"收藏-未选中"]
                                                bActive:model.collect.boolValue
                                            activeBlock:^(SingleLineRichLabel *richLabel, void (^callbackTask)(BOOL bSuccess)) {
                                                //收藏
                                                /*
                                                CollectNoteStatus *noteStatus = nil;
                                                if(LocalInfoRecordInstance.dictCollectNoteStatus && [LocalInfoRecordInstance.dictCollectNoteStatus.allKeys containsObject:model.idx])
                                                {
                                                    noteStatus = LocalInfoRecordInstance.dictCollectNoteStatus[model.idx];
                                                    noteStatus.noteId = model.idx;
                                                    noteStatus.bCollect = YES;
                                                }
                                                else
                                                {
                                                    noteStatus = [CollectNoteStatus new];
                                                    noteStatus.noteId = model.idx;
                                                    noteStatus.bCollect = YES;
                                                }
                                                [LocalInfoRecordInstance.dictCollectNoteStatus setObject:noteStatus forKey:model.idx];
                                                //*/
                                                //*
                                                [weakSelf.courseNoteDetailViewModel updateCollectNoteId:model.idx
                                                                                     andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                                                         callbackTask(succeed);
                                                                                     }];
                                                 //*/
                                                
                                            } inactiveBlock:^(SingleLineRichLabel *richLabel, void (^callbackTask)(BOOL bSuccess)) {
                                                //取消收藏
                                                /*
                                                CollectNoteStatus *noteStatus = nil;
                                                if(LocalInfoRecordInstance.dictCollectNoteStatus && [LocalInfoRecordInstance.dictCollectNoteStatus.allKeys containsObject:model.idx])
                                                {
                                                    noteStatus = LocalInfoRecordInstance.dictCollectNoteStatus[model.idx];
                                                    noteStatus.noteId = model.idx;
                                                    noteStatus.bCollect = NO;
                                                }
                                                else
                                                {
                                                    noteStatus = [CollectNoteStatus new];
                                                    noteStatus.noteId = model.idx;
                                                    noteStatus.bCollect = NO;
                                                }
                                                [LocalInfoRecordInstance.dictCollectNoteStatus setObject:noteStatus forKey:model.idx];
                                                //*/
                                                //### [weakSelf.tableView reloadData];
                                                //*
                                                [weakSelf.courseNoteDetailViewModel updateCollectNoteId:model.idx
                                                                                     andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                                                         callbackTask(succeed);
                                                                                     }];
                                                 //*/
                                            }];
            
        }
    }
    else if(_type == NOTE_TYPE_ME)
    {
        cell.leftRichLable.hidden = YES;
    }
}

-(void)installRightRichLabelForCell:(BXGNoteCell*)cell andModel:(BXGCourseNoteDetailModel*)model andType:(NOTE_TYPE)type
{
    cell.rightRichLabel.text = @"";
    if(_type == NOTE_TYPE_ALL || _type == NOTE_TYPE_ME || _type == NOTE_TYPE_COLLECT)
    {
        __weak typeof(self) weakSelf = self;
        
        [self updateCurrentModelIfExistPraiseInLocal:model];
        
        if(model.praise.boolValue)
        {
            if(model.praise_sum.integerValue<=0)
            {
                model.praise_sum = [NSNumber numberWithInteger:1];
            }
        }
        else
        {
            if(model.praise_sum.integerValue<0)
            {
                model.praise_sum = [NSNumber numberWithInteger:0];
            }
        }
        
        [cell.rightRichLabel setRichLabelActiveImage:[UIImage imageNamed:@"点赞-选中"]
                                       inactiveImage:[UIImage imageNamed:@"点赞-未选中"]
                                               value:model.praise_sum.integerValue
                                             bActive:model.praise.boolValue
                                         activeBlock:^(SingleLineRichLabel *richLabel, void (^callbackTask)(BOOL bSuccess)) {
                                             //点赞
                                             PraiseNoteStatus *noteStatus = nil;
                                             if(LocalInfoRecordInstance.dictPraiseNoteStatus && [LocalInfoRecordInstance.dictPraiseNoteStatus.allKeys containsObject:model.idx])
                                             {
                                                 noteStatus = LocalInfoRecordInstance.dictPraiseNoteStatus[model.idx];
                                                 noteStatus.noteId = model.idx;
                                                 noteStatus.bPraise = YES;
                                                 noteStatus.praiseNum = richLabel.value;
                                             }
                                             else
                                             {
                                                 noteStatus = [PraiseNoteStatus new];
                                                 noteStatus.noteId = model.idx;
                                                 noteStatus.bPraise = YES;
                                                 noteStatus.praiseNum = richLabel.value;
                                             }
                                             [LocalInfoRecordInstance.dictPraiseNoteStatus setObject:noteStatus forKey:model.idx];
                                             /*
                                             [weakSelf.courseNoteDetailViewModel updatePraiseNoteId:model.idx
                                                                                 andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                                                     callbackTask(succeed);
                                                                                 }];
                                              //*/
                                             
                                         } inactiveBlock:^(SingleLineRichLabel *richLabel, void (^callbackTask)(BOOL bSuccess)) {
                                             //取消点赞
                                             PraiseNoteStatus *noteStatus = nil;
                                             if(LocalInfoRecordInstance.dictPraiseNoteStatus && [LocalInfoRecordInstance.dictPraiseNoteStatus.allKeys containsObject:model.idx])
                                             {
                                                 noteStatus = LocalInfoRecordInstance.dictPraiseNoteStatus[model.idx];
                                                 noteStatus.noteId = model.idx;
                                                 noteStatus.bPraise = NO;
                                                 noteStatus.praiseNum = richLabel.value;
                                             }
                                             else
                                             {
                                                 noteStatus = [PraiseNoteStatus new];
                                                 noteStatus.noteId = model.idx;
                                                 noteStatus.bPraise = NO;
                                                 noteStatus.praiseNum = richLabel.value;
                                             }
                                             [LocalInfoRecordInstance.dictPraiseNoteStatus setObject:noteStatus forKey:model.idx];
                                             /*
                                             [weakSelf.courseNoteDetailViewModel updatePraiseNoteId:model.idx
                                                                                 andFinishBlock:^(BOOL succeed, NSString *errorMessage) {
                                                                                     callbackTask(succeed);
                                                                                 }];
                                              //*/
                                         }];
    }
}
/*
-(void)updateCurrentModelIfExistCollectInLocal:(BXGCourseNoteDetailModel*)model
{
    if(LocalInfoRecordInstance.dictCollectNoteStatus!=nil && [LocalInfoRecordInstance.dictCollectNoteStatus.allKeys containsObject:model.idx])
    {
        CollectNoteStatus *obj = LocalInfoRecordInstance.dictCollectNoteStatus[model.idx];
        model.collect = [NSNumber numberWithBool:obj.bCollect];
    }
}
 //*/

-(void)updateCurrentModelIfExistPraiseInLocal:(BXGCourseNoteDetailModel*)model
{
    if(LocalInfoRecordInstance.dictPraiseNoteStatus!=nil && [LocalInfoRecordInstance.dictPraiseNoteStatus.allKeys containsObject:model.idx])
    {
        PraiseNoteStatus *obj = LocalInfoRecordInstance.dictPraiseNoteStatus[model.idx];
        model.praise = [NSNumber numberWithBool:obj.bPraise];
        model.praise_sum = [NSNumber numberWithInteger:obj.praiseNum];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_courseNoteDetailViewModel.arrNote && indexPath.row < _courseNoteDetailViewModel.arrNote.count)
    {
        BXGCourseNoteDetailModel *model = _courseNoteDetailViewModel.arrNote[indexPath.row];
        NSString *content = model.content;
        BXGNoteDetailVC *vc = [BXGNoteDetailVC new];
        vc.content = content;
        [self.targetVC.navigationController pushViewController:vc animated:YES];
    }
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
