//
//  BXGCommunityCommentVC.m
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityCommentVC.h"
#import "BXGCommunityCommentCell.h"
#import "BXGCommunityCommentDetailModel.h"

@interface BXGCommunityCommentVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) NSArray<BXGCommunityCommentDetailModel*> *arrCommentDetailModel;

@property(nonatomic, weak) BXGCommunityCommentCell *commentCell;

//@property(nonatomic, strong) NSMutableDictionary<NSString*/*commentId*/, BXGCommunityCommentViewModel*> *dictCommentViewModel;

@end

@implementation BXGCommunityCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self installUI];
}

-(void) installUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    _tableView = tableView;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    _tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView  = [UIView new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BXGCommunityCommentCell" bundle:nil]
     forCellReuseIdentifier:@"BXGCommunityCommentCell"];
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

-(void)loadData:(NSArray<BXGCommunityCommentDetailModel*>*)arrCommentDetailModel
{
    _arrCommentDetailModel = arrCommentDetailModel;
    if(_arrCommentDetailModel)
    {
        [_tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrCommentDetailModel)
        return _arrCommentDetailModel.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXGCommunityCommentCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"BXGCommunityCommentCell" forIndexPath:indexPath];
    BXGCommunityCommentDetailModel *model = _arrCommentDetailModel[indexPath.row];
    [cell setupCell:model andTargetDelegate:nil];
    
    return nil;
}




@end
