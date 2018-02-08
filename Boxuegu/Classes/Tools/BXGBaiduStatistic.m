//
//  BXGBaiduStatistic.m
//  Boxuegu
//
//  Created by apple on 2017/9/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaiduStatistic.h"
#import "BaiduMobStat.h"

NSString *load_icon_01 = @"load_icon_01"; //登录按钮
NSString *forget_password_02 = @"forget_password_02";//   忘记密码
NSString *load_regist_03 = @"load_regist_03";//    注册账户
NSString *regist_nextstep_04 = @"regist_nextstep_04";//   下一步按钮
NSString *regist_sendcode_05 = @"regist_sendcode_05";//    获取动态码
NSString *regist_return_sjhzc_06 = @"regist_return-sjhzc_06";//    返回
NSString *regist_done_07 = @"regist_done_07";//    完成注册
NSString *regist_setcode_szmm_09 = @"regist_setcode_szmm_09";//    返回
NSString *xzgl_icon_08 = @"xzgl_icon_08";//    下载管理-icon
NSString *gkjl_icon_10 = @"gkjl_icon_10";//    观看记录-icon
NSString *xx_icon_11 = @"xx_icon_11";//    消息-icon
NSString *kczjxxjl_12 = @"kczjxxjl_12";//    最近学习记录（上次课程）
NSString *regist_return_spxzjybxq_13 = @"regist_return-spxzjybxq_13";//    返回
NSString *jybxxjd_14 = @"jybxxjd_14";//    最近学习记录（上次课程）
NSString *jybkcdg_15 = @"jybkcdg_15";//    课程大纲
NSString *jybxxjh_16 = @"jybxxjh_16";//    学习计划
NSString *xxjhgd_17 = @"xxjhgd_17";//    更多学习计划
NSString *jybjxx_button_18 = @"jybjxx_button_18";//    学习按钮
NSString *regist_return_rlxxjh_19 = @"regist_return-rlxxjh_19";//    返回
NSString *jybzsd_20 = @"jybzsd_20";//    知识点下载按钮
NSString *jybbf_21 = @"jybbf_21";//    播放
NSString *jybxxgl_22 = @"jybxxgl_22";//    学习过了按钮
NSString *jybqp_23 = @"jybqp_23";//    全屏
NSString *jybkj_24 = @"jybkj_24";//    快进
NSString *jybbs_25 = @"jybbs_25";//    倍速
NSString *jybxj_26 = @"jybxj_26";//    选集
NSString *jybpjan_27 = @"jybpjan_27";//    评价按钮
NSString *jybpjtj_28 = @"jybpjtj_28";//    评价提交按钮
NSString *jybgban_29 = @"jybgban_29";//    评价关闭按钮
NSString *productlisting_jybspbf_31 = @"productlisting_jybspbf_31";//    返回—播放页
NSString *xzymxz_30 = @"xzymxz_30";//    下载按钮
NSString *productlisting_spxz_32 = @"productlisting_spxz_32";//    返回
NSString *wkzsd_33 = @"wkzsd_33";//    知识点下载按钮
NSString *wkbf_34 = @"wkbf_34";//    播放
NSString *wkxxgl_35 = @"wkxxgl_35";//    学习过了按钮
NSString *wkqp_36 = @"wkqp_36";//    全屏
NSString *wkkj_37 = @"wkkj_37";//    快进
NSString *wkbs_38 = @"wkbs_38";//    倍速
NSString *productlisting_wkbfy_40 = @"productlisting_wkbfy_40";//    返回
NSString *wdxzgl_icon_41 = @"wdxzgl-icon_41";//    下载管理-icon
NSString *wdgkjl_icon = @"wdgkjl-icon";//    观看记录（总的）-icon
NSString *wdxx_icon = @"wdxx-icon";//    消息-icon
NSString *wdxzgl_icon_42 = @"wdxzgl-icon_42";//    下载管理
NSString *wdgkjl2_icon = @"wdgkjl2-icon";//    观看记录
NSString *wdkcbj = @"wdkcbj";//    课程笔记
NSString *wdyjfk = @"wdyjfk";//    意见反馈
NSString *wdsz = @"wdsz";//    设置
NSString *wdyjkktj = @"wdyjkktj";//    意见反馈提交按钮
NSString *productlisting_kecbj = @"productlisting_kecbj";//    返回
NSString *qbbj = @"qbbj";//    全部笔记
NSString *wdbj = @"wdbj";//    我的笔记
NSString *scdbj = @"scdbj";//    收藏的笔记
NSString *scbj = @"scbj";//    收藏
NSString *bjdz = @"bjdz";//    点赞
NSString *productlisting_bjxq = @"productlisting_bjxq";//    返回
NSString *productlisting_gkjl = @"productlisting_gkjl";//    返回
NSString *productlisting_gkjlgfy = @"productlisting_gkjlgfy";//    返回
NSString *productlisting_gkjltzbf = @"productlisting_gkjltzbf";//    返回
NSString *dsjyjsjyb_yxz = @"dsjyjsjyb-yxz";//    云计算之大数据在线就业班
NSString *qdzxtyb_yxz = @"qdzxtyb-yxz";//    前端在线体验班（返学费）
NSString *webqdzxjyb_yxz = @"webqdzxjyb-yxz";//    Web前端在线就业班
NSString *javajcbzxtyb_yxz = @"javajcbzxtyb-yxz";//    Java基础在线体验班（返学费）
NSString *javaEEzxjyb_yxz = @"javaEEzxjyb-yxz";//    JavaEE在线就业班
NSString *pythonzxtyb_yxz = @"pythonzxtyb-yxz";//    Python在线体验班（返学费）
NSString *pythonzxjyb_yxz_66 = @"pythonzxjyb-yxz_66";//    Python在线就业班
NSString *qzsjszxjyb_yxz = @"qzsjszxjyb-yxz";//    全栈设计师在线就业班
NSString *productlisting_xzgl = @"productlisting_xzgl";//    返回
NSString *bfsp_yxz = @"bfsp-yxz";//    播放按钮
NSString *productlisting_yxz = @"productlisting_yxz";//    返回
NSString *scyxzsp = @"scyxzsp";//    删除按钮
NSString *bf_lxsp = @"bf-lxsp";//    播放
NSString *kj_lxsp = @"kj-lxsp";//    快进
NSString *bs_lxsp = @"bs-lxsp";//    倍速
NSString *productlisting_lxsp = @"productlisting_lxsp";//    返回
NSString *bxq_gc = @"bxq-gc";//    广场
NSString *bxq_gz = @"bxq-gz";//    关注
NSString *bxq_ftan_1 = @"bxq-ftan_1";//    发帖按钮
NSString *bxq_dw = @"bxq-dw";//    定位-LBS
NSString *bxq_ftan = @"bxq-ftan";//    提醒谁看-按钮
NSString *bxq_tjtp = @"bxq-tjtp";//    添加图片-按钮
NSString *bxq_pz = @"bxq-pz";//    拍照-按钮
NSString *bxq_xcxz = @"bxq-xcxz";//    相册选择-按钮
NSString *bxq_ftfb = @"bxq-ftfb";//    发布按钮
NSString *productlisting_bxqft = @"productlisting_bxqft";//    返回
NSString *bxq_tzxq_gzan = @"bxq-tzxq-gzan";//    关注
NSString *bxq_tzxq_dz = @"bxq-tzxq-dz";//    点赞
NSString *bxq_tzxq_pl = @"bxq-tzxq-pl";//   评论-按钮
NSString *bxq_tzxq_wzpl = @"bxq-tzxq-wzpl";//    文字评论-按钮
NSString *bxq_tzxq_dzr = @"bxq-tzxq-dzr";//    点赞的人-按钮
NSString *productlisting_tzxq = @"productlisting_tzxq";//    返回
NSString *bxq_plfb = @"bxq-plfb";//    发布按钮
NSString *productlisting_bxq_pl = @"productlisting_bxq_pl";//    返回
NSString *bxq_dzdr_gzan = @"bxq-dzdr-gzan";//    关注
NSString *productlisting_dzdr_110=@"productlisting_dzdr_110";//    返回
NSString *spbf_bs1 = @"spbf_bs1";//1倍数播放
NSString *spbf_bs2 = @"spbf_bs1.25";//1.25倍数播放
NSString *spbf_bs3 = @"spbf_bs1.5";//1.5倍数播放
NSString *spbf_bs4 = @"spbf_bs1.75";//1.75倍数播放
NSString *spbf_bs5 = @"spbf_bs2";//2倍数播放

static BXGBaiduStatistic *_instance;

@interface BXGBaiduStatistic()
@end

@implementation BXGBaiduStatistic
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BXGBaiduStatistic new];
    });
    return _instance;
}

-(void)statisticEventString:(NSString*)eventString
         andParameter:(NSDictionary*)dict {
    [[BaiduMobStat defaultStat] logEvent:eventString eventLabel:eventString attributes:dict];
}

-(void)statisticEventString:(NSString *)eventId andLabel:(NSString *)label; {
    if(!label) {
        label = @"default";
    }
    [[BaiduMobStat defaultStat] logEvent:eventId eventLabel:label];
}

- (void)pageviewStartWithName:(NSString *)name {
    [[BaiduMobStat defaultStat] pageviewStartWithName:name];
}

- (void)pageviewEndWithName:(NSString *)name {
    [[BaiduMobStat defaultStat] pageviewEndWithName:name];
}

@end
