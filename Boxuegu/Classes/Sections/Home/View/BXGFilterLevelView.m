//
//  BXGFilterLevelView.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGFilterLevelView.h"

@implementation BXGFilterLevelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(instancetype)initWithFrame:(CGRect)frame {
//    self =[super initWithFrame:frame];
//    if(self){
//        self.delegate =
//    }
//    return self;
//}

+(NSArray*) dataSource {
    return @[@"全部", @"基础", @"进阶", @"提高"];
}

-(NSNumber*)selIndex {
    if(_selIndex==nil)
        return nil;

    NSNumber *numberSelIndex = nil;
    switch (_selIndex.integerValue) {
        case 0:
            numberSelIndex = nil;
            break;
        case 1:
        case 2:
        case 3:
            numberSelIndex = [NSNumber numberWithInteger:_selIndex.integerValue-1];
            break;
        default:
            break;
    }
    return numberSelIndex;
}

-(void)setSelIndex:(NSNumber *)newSelIndex {
    if(!newSelIndex) {
        _selIndex=nil;
    } else {
        switch(newSelIndex.integerValue) {
            case 0:
            case 1:
            case 2://0-基础 1-进阶 2-提高
                _selIndex = [NSNumber numberWithInteger:newSelIndex.integerValue+1];//基础 / 进阶 /提高
                break;
            default:
                NSAssert(NO, @"couldn't be happen");
                break;
        }
    }
}

-(NSNumber*)convertNetworkTypeValue {
    return [self selIndex];
/*
    NSNumber *numberSelIndex = nil;
    if(!_selIndex) {
        numberSelIndex = nil;//默认选项
    } else {
        switch(_selIndex.integerValue) {
            case 0:
                numberSelIndex = nil;
                break;
            case 1:
            case 2:
            case 3:
                numberSelIndex = [NSNumber numberWithInteger:_selIndex.integerValue-1];
                break;
            default:
                NSAssert(NO, @"couldn't be happen");
                break;
        }
    }
    return numberSelIndex;
 //*/
}



@end
