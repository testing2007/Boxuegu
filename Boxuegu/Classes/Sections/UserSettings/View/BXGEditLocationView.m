//
//  BXGEditLocationView.m
//  Boxuegu
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditLocationView.h"
#import "BXGLocation.h"
#import "UIView+Pop.h"

@interface BXGEditLocationView()<UIPickerViewDataSource,
                                 UIPickerViewDelegate>
@property (nonatomic, weak) UIButton *leftCancelBtn;
@property (nonatomic, weak) UIButton *rightConfirmBtn;
@property (nonatomic, weak) UIPickerView *locationView;
@property (nonatomic, strong) BXGLocationProvince *currentProvince;
@property (nonatomic, copy) FinishModifyLocationBlockType finishModifyLocationBlock;
@property (nonatomic, weak) BXGUserSettingsViewModel *settingVM;
@property (nonatomic, strong) BXGLocationCity *currentCity;
@end

@implementation BXGEditLocationView

- (instancetype)initCurrentProvince:(BXGLocationProvince*)currentProvince
                andandUserSettingVM:(BXGUserSettingsViewModel*)settingVM
       andFinishModifyLocationBlock:(FinishModifyLocationBlockType)finishModifyLocationBlock {
    self = [super init];
    if(self) {
        self.currentProvince = currentProvince;
//        self.currentCity = currentProvince.cityList[0];
        self.finishModifyLocationBlock = finishModifyLocationBlock;
        self.settingVM = settingVM;

//        __weak typeof(self) weakSelf = self;
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [self.settingVM loadProvinceAndCityListBlock:^(BXGLocation* location, NSString* errorMessage) {
            if(errorMessage!=nil) {
                [[BXGHUDTool share] showHUDWithString:@"访问失败"]; //TODO:为什么这个错误没有在底层库中捕获
            } else {
                [self installUI];
                if(!self.currentProvince) {
                    _currentProvince = [BXGLocationProvince new];
                    BXGLocationProvince *province = location.provinceList[0];
                    self.currentProvince.idx = province.idx;
                    self.currentProvince.name = province.name;
                    self.currentProvince.cityList = @[province.cityList[0]];
                    self.currentCity = province.cityList[0];
                }
                [self.locationView reloadAllComponents];
                [[BXGHUDTool share] closeHUD];
            }
        }];
    }
    return self;
}

- (void)installUI {
    //    __weak typeof(self) weakSelf = self;
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithHex:0xFCFCFC];
    [self addSubview:headView];
    UIButton *leftCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftCancelBtn setTitleColor:[UIColor colorWithRed:31 green:211 blue:255] forState:UIControlStateNormal];
    [leftCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftCancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftCancelBtn];
    self.leftCancelBtn = leftCancelBtn;
    UIButton *rightConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightConfirmBtn setTitleColor:[UIColor colorWithRed:31 green:211 blue:255] forState:UIControlStateNormal];
    [rightConfirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightConfirmBtn addTarget:self action:@selector(confirmSelect) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightConfirmBtn];
    self.rightConfirmBtn = rightConfirmBtn;

    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.equalTo(@42);
    }];
    [self.leftCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [self.rightConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];

    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.backgroundColor = [UIColor colorWithHex:0xE8E8E8];
    pickView.delegate = self;
    pickView.dataSource = self;
    [self addSubview:pickView];
    self.locationView = pickView;
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
}

- (void)cancelSelect {
    [self hideView];
}

- (void)confirmSelect {
    [self hideView];
    if(_finishModifyLocationBlock) {
        _currentProvince.cityList = @[_currentCity];
        return _finishModifyLocationBlock(_currentProvince);
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.settingVM numberOfComponetents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger nCount = 0;
    if(component==0) {
        nCount = [self.settingVM getProvincesCount];
    } else {
        nCount = [self.settingVM getCitiesCountByProvinceId:_currentProvince.idx];
    }
    return nCount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
        return [self.settingVM getProvinceNameByIndex:row];
    }
    else
    {
        return [self.settingVM getCityNameByProvinceId:_currentProvince.idx andIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if(component==0)
    {
        _currentProvince = [self.settingVM getLocationProvinceByIndex:row];
        _currentCity = [self.settingVM getLocationCityByProvinceId:_currentProvince.idx andIndex:0];
    }
    else
    {
        _currentCity = [self.settingVM getLocationCityByProvinceId:_currentProvince.idx andIndex:row];
    }
    
    //级联互动, 上级改变了,下级要随动, 但是上级不需要联动
    for(long i=component+1; i<pickerView.numberOfComponents; ++i) {
        [pickerView reloadComponent:i];
    }
}

@end
