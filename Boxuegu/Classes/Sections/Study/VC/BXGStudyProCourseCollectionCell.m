
#import "BXGStudyProCourseCollectionCell.h"
#import "MOPopWindow.h"
#import "MJRefresh.h"
#import "BXGStudyViewModel.h"
#import "BXGStudyConstruePopVC.h"
#import "BXGConstrueModel.h"

#import "BXGProCorCell.h"


#import "BXGStudyProCoursePlanTableVC.h"

@interface BXGStudyProCourseCollectionCell()
@property (nonatomic, strong) BXGStudyProCoursePlanTableVC *tableVC;

@end

/**
 职业课程日详情页
 */
@implementation BXGStudyProCourseCollectionCell

- (void)setPlanDate:(NSDate *)planDate {

    _planDate = planDate;
    self.tableVC.planDate = planDate;
    
}

- (void)setViewModel:(BXGProCoursePlanViewModel *)viewModel {
    
    _viewModel = viewModel;
    
    self.tableVC.viewModel = _viewModel;
}

#pragma mark - Init

- (BXGStudyProCoursePlanTableVC *)tableVC {
    
    if(!_tableVC){
        
        _tableVC = [BXGStudyProCoursePlanTableVC new];
        
    
    }
    return _tableVC;
}

- (void)setDidSelectProCoursePlanBlock:(DidSelectProCoursePlanBlockType)didSelectProCoursePlanBlock {

    _didSelectProCoursePlanBlock = didSelectProCoursePlanBlock;

    if(didSelectProCoursePlanBlock){
        
        self.tableVC.didSelectProCoursePlanBlock = self.didSelectProCoursePlanBlock;
    }
}


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)installUI {

    
    [self.contentView addSubview:self.tableVC.view];
    [self.tableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    self.backgroundColor = [UIColor colorWithHex:0xF5F5F5 alpha:1];
}
@end
