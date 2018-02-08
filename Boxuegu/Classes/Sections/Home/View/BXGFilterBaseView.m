//
//  BXGFilterBaseView.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGFilterBaseView.h"

@interface BXGFilterBaseTableViewCell : UITableViewCell
@end

@implementation BXGFilterBaseTableViewCell
-(void)layoutSubviews {
    [self.textLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
//        make.height.equalTo(@19);
//        make.width.equalTo(@19);
    }];
    
    [super layoutSubviews];
}
@end

static NSString *BXGFilterBaseTableViewCellId = @"BXGFilterBaseTableViewCellId";

@interface BXGFilterBaseView()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UITableView *tableView;

@end

@implementation BXGFilterBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if(self) {
//        [self installUI];
//
//        [_tableView registerClass:[BXGFilterBaseTableViewCell class] forCellReuseIdentifier:BXGFilterBaseTableViewCellId];
//        [_tableView reloadData];
//    }
//    return self;
//}

-(instancetype)initWithDataSource:(NSArray<NSString*> *)dataSource {
    self = [super init];
    if(self) {
        self.dataSource = dataSource;
        [self installUI];

        [_tableView reloadData];
    }
    return self;
}

-(void)installUI {
    UIView *spTopView = [UIView new];
    spTopView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self addSubview:spTopView];

    
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    _tableView = tableView;
    
    [spTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.equalTo(@9);
    }];
    
    NSArray *ds = self.dataSource;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spTopView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.equalTo(@(ds.count*44));
    }];
}

-(NSNumber*)selIndex{
    return nil;//子类去实现
}

-(NSNumber*)convertNetworkTypeValue {
    return nil;//子类去实现
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrDataSource = self.dataSource;
    if(arrDataSource)
        return arrDataSource.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXGFilterBaseTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:BXGFilterBaseTableViewCellId];
    if(!cell) {
        cell = [[BXGFilterBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BXGFilterBaseTableViewCellId];
    }
    NSArray *arrDataSource = self.dataSource;
    cell.textLabel.text = arrDataSource[indexPath.row];
    if((!_selIndex&&indexPath.row==0) || (_selIndex&& _selIndex.integerValue==indexPath.row) ) {
        cell.textLabel.textColor = [UIColor colorWithHex:0x38ADFF];
        cell.imageView.image = [UIImage imageNamed:@"选中"];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.imageView.image = [UIImage new];
//        cell.imageView.image = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selIndex = [NSNumber numberWithInteger:indexPath.row];
    if(_didSelectBlock) {
        NSArray *arrDataSource = self.dataSource;
        _didSelectBlock([self convertNetworkTypeValue], arrDataSource[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

-(void)render {
    [self.tableView reloadData];
}

@end
