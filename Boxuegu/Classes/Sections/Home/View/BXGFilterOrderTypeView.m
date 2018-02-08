//
//  BXGFilterOrderTypeView.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGFilterOrderTypeView.h"

@implementation BXGFilterOrderTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(NSArray*) dataSource {
    return @[@"综合", @"最热", @"最新"];
}

-(NSNumber*)selIndex {
    if(_selIndex==nil)
        return nil;

    NSNumber *numberSelIndex = nil;
    switch (_selIndex.integerValue) {
        case 0:
        case 1:
        case 2:
            numberSelIndex = [NSNumber numberWithInteger:_selIndex.integerValue];
            break;
        default:
            break;
    }
    return numberSelIndex;
}

-(void)setSelIndex:(NSNumber *)newSelIndex {
    if(!newSelIndex) {
        _selIndex=[NSNumber numberWithInteger:0];//综合
    } else {
        switch(newSelIndex.integerValue) {
            case 0:
                _selIndex = [NSNumber numberWithInteger:0];//综合
                break;
            case 1:
                _selIndex = [NSNumber numberWithInteger:2];//最热
                break;
            case 2:
                _selIndex = [NSNumber numberWithInteger:1];//最新
                break;
            default:
                NSAssert(NO, @"couldn't be happen");
                break;
        }
    }
}

-(NSNumber*)convertNetworkTypeValue {
    NSNumber *numberSelIndex = nil;
    if(!_selIndex) {
        numberSelIndex = [NSNumber numberWithInteger:0];//默认选项
    } else {
        switch(_selIndex.integerValue) {
            case 0:
                numberSelIndex = [NSNumber numberWithInteger:0];//默认选项
                break;
            case 1:
                numberSelIndex = [NSNumber numberWithInteger:2];//最热
                break;
            case 2:
                numberSelIndex = [NSNumber numberWithInteger:1];//最新
                break;
            default:
                NSAssert(NO, @"couldn't be happen");
                break;
        }
    }
    return numberSelIndex;
}

@end
