//
//  BXGBaiduStatistic.h
//  Boxuegu
//
//  Created by apple on 2017/9/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ModelType_Me,
    ModelType_LoginRegister,
    ModelType_Course,
    ModelType_Community
}ModelType;

extern NSString *load_icon_01; //登录按钮
extern NSString *forget_password_02;//   忘记密码
extern NSString *load_regist_03;//    注册账户
extern NSString *regist_nextstep_04;//   下一步按钮
extern NSString *regist_sendcode_05;//    获取动态码
extern NSString *regist_return_sjhzc_06;//    返回
extern NSString *regist_done_07;//    完成注册
extern NSString *regist_setcode_szmm_09;//    返回
extern NSString *xzgl_icon_08;//    下载管理_icon
extern NSString *gkjl_icon_10;//    观看记录_icon
extern NSString *xx_icon_11;//    消息_icon
extern NSString *kczjxxjl_12;//    最近学习记录（上次课程）
extern NSString *regist_return_spxzjybxq_13;//    返回
extern NSString *jybxxjd_14;//    最近学习记录（上次课程）
extern NSString *jybkcdg_15;//    课程大纲
extern NSString *jybxxjh_16;//    学习计划
extern NSString *xxjhgd_17;//    更多学习计划
extern NSString *jybjxx_button_18;//    学习按钮
extern NSString *regist_return_rlxxjh_19;//    返回
extern NSString *jybzsd_20;//    知识点下载按钮
extern NSString *jybbf_21;//    播放
extern NSString *jybxxgl_22;//    学习过了按钮
extern NSString *jybqp_23;//    全屏
extern NSString *jybkj_24;//    快进
extern NSString *jybbs_25;//    倍速
extern NSString *jybxj_26;//    选集
extern NSString *jybpjan_27;//    评价按钮
extern NSString *jybpjtj_28;//    评价提交按钮
extern NSString *jybgban_29;//    评价关闭按钮
extern NSString *productlisting_jybspbf_31;//    返回—播放页
extern NSString *xzymxz_30;//    下载按钮
extern NSString *productlisting_spxz_32;//    返回
extern NSString *wkzsd_33;//    知识点下载按钮
extern NSString *wkbf_34;//    播放
extern NSString *wkxxgl_35;//    学习过了按钮
extern NSString *wkqp_36;//    全屏
extern NSString *wkkj_37;//    快进
extern NSString *wkbs_38;//    倍速
extern NSString *productlisting_wkbfy_40;//    返回
extern NSString *wdxzgl_icon_41;//    下载管理_icon
extern NSString *wdgkjl_icon;//    观看记录（总的）_icon
extern NSString *wdxx_icon;//    消息_icon
extern NSString *wdxzgl_icon_42;//    下载管理
extern NSString *wdgkjl2_icon;//    观看记录
extern NSString *wdkcbj;//    课程笔记
extern NSString *wdyjfk;//    意见反馈
extern NSString *wdsz;//    设置
extern NSString *wdyjkktj;//    意见反馈提交按钮
extern NSString *productlisting_kecbj;//    返回
extern NSString *qbbj;//    全部笔记
extern NSString *wdbj;//    我的笔记
extern NSString *scdbj;//    收藏的笔记
extern NSString *scbj;//    收藏
extern NSString *bjdz;//    点赞
extern NSString *productlisting_bjxq;//    返回
extern NSString *productlisting_gkjl;//    返回
extern NSString *productlisting_gkjlgfy;//    返回
extern NSString *productlisting_gkjltzbf;//    返回
extern NSString *dsjyjsjyb_yxz;//    云计算之大数据在线就业班
extern NSString *qdzxtyb_yxz;//    前端在线体验班（返学费）
extern NSString *webqdzxjyb_yxz;//    Web前端在线就业班
extern NSString *javajcbzxtyb_yxz;//    Java基础在线体验班（返学费）
extern NSString *javaEEzxjyb_yxz;//    JavaEE在线就业班
extern NSString *pythonzxtyb_yxz;//    Python在线体验班（返学费）
extern NSString *pythonzxjyb_yxz_66;//    Python在线就业班
extern NSString *qzsjszxjyb_yxz;//    全栈设计师在线就业班
extern NSString *productlisting_xzgl;//    返回
extern NSString *bfsp_yxz;//    播放按钮
extern NSString *productlisting_yxz;//    返回
extern NSString *scyxzsp;//    删除按钮
extern NSString *bf_lxsp;//    播放
extern NSString *kj_lxsp;//    快进
extern NSString *bs_lxsp;//    倍速
extern NSString *productlisting_lxsp;//    返回
extern NSString *bxq_gc;//    广场
extern NSString *bxq_gz;//    关注
extern NSString *bxq_ftan_1;//    发帖按钮
extern NSString *bxq_dw;//    定位_LBS
extern NSString *bxq_ftan;//    提醒谁看_按钮
extern NSString *bxq_tjtp;//    添加图片_按钮
extern NSString *bxq_pz;//    拍照_按钮
extern NSString *bxq_xcxz;//    相册选择_按钮
extern NSString *bxq_ftfb;//    发布按钮
extern NSString *productlisting_bxqft;//    返回
extern NSString *bxq_tzxq_gzan;//    关注
extern NSString *bxq_tzxq_dz;//    点赞
extern NSString *bxq_tzxq_pl;//   评论_按钮
extern NSString *bxq_tzxq_wzpl;//    文字评论_按钮
extern NSString *bxq_tzxq_dzr;//    点赞的人_按钮
extern NSString *productlisting_tzxq;//    返回
extern NSString *bxq_plfb;//    发布按钮
extern NSString *productlisting_bxq_pl;//    返回
extern NSString *bxq_dzdr_gzan;//    关注
extern NSString *productlisting_dzdr_110;//    返回
extern NSString *spbf_bs1;//1倍数播放
extern NSString *spbf_bs2;//1.25倍数播放
extern NSString *spbf_bs3;//1.5倍数播放
extern NSString *spbf_bs4;//1.75倍数播放
extern NSString *spbf_bs5;//2倍数播放

// 首页
#define kBXGStatHomeRootEventTypeBanner @"Banner121"
#define kBXGStatHomeRootEventTypeMyMessage @"wdxx_116"// 我的消息icon-首页    wdxx_116
#define kBXGStatHomeRootEventTypeLearnHistory @"gkjl272"// 观看记录icon-首页    gkjl272
#define kBXGStatHomeRootEventTypeDownload @"xzgl_117"// 下载管理icon-首页    xzgl_117
#define kBXGStatHomeRootEventTypeMoreCaareerCourse @"gdjyk_118"// 更多-就业班    gdjyk_118
#define kBXGStatHomeRootEventTypeMoreMiniCourse @"gdjpwk_119"// 更多-精品微课    gdjpwk_119
#define kBXGStatHomeRootEventTypeMoreFreeCourse @"gdmfwk_120"// 更多-免费微课    gdmfwk_120

// 底部导航
#define kBXGStatMainTabEventTypeHome @"sy_111"//首页    sy_111
#define kBXGStatMainTabEventTypeCategory @"fl_112"//分类    fl_112
#define kBXGStatMainTabEventTypeCommunity @"bxq_113"//博学圈    bxq_113
#define kBXGStatMainTabEventTypeStudy @"kc_114"//课程    kc_114
#define kBXGStatMainTabEventTypeMe @"wd_115"//我的    wd_115

// 咨询
#define kBXGStatCourseInfoProCourseEventTypeCancleConsult @"qxzx136" //取消咨询-就业班  qxzx136
#define kBXGStatCourseInfoProCourseEventTypeCommitConsult @"tjzx137" //提交咨询-就业班  tjzx137
#define kBXGStatCourseInfoProCourseEventTypePhoneNumber @"dhhm139" //电话号码-就业班    dhhm139

// 弹窗
#define kBXGStatCourseInfoFreeCourseEventTypeStudy @"ljxx203" //立即学习-免费微课    ljxx203
#define kBXGStatCourseInfoFreeCourseEventTypeFillOrder @"qdbm204" //确定报名-免费微课    qdbm204
#define kBXGStatCourseInfoFreeCourseEventTypeCancle @"qxbm205" //取消报名-免费微课    qxbm205

// 试学: 精品微课
#define kBXGStatSamplePlayerMiniCourseEventTypeFillOrder @"ljbm178" //立即报名-精品微课    ljbm178
#define kBXGStatSamplePlayerMiniCourseEventTypeToastFillOrder @"qdbm179" //确定报名-微课-试学结束    qdbm179
#define kBXGStatSamplePlayerMiniCourseEventTypeToastCancle @"qxbm180" //取消报名-微课-试学结束    qxbm180

// 试学: 就业课
#define kBXGStatSamplePlayerProCourseEventTypeFillOrder @"ljbm146" //立即报名-就业班-试学页    ljbm146
#define kBXGStatSamplePlayerProCourseEventTypeConsult @"zxkc145" //咨询课程-就业班-试学页    zxkc145
#define kBXGStatSamplePlayerProCourseEventTypeToastFillOrder @"qdbm147" //确定报名-就业班-试学结束    qdbm147
#define kBXGStatSamplePlayerProCourseEventTypeToastCancle @"qxbm148" //取消报名-就业班-试学结束    qxbm148

// Course Info 就业课
#define kBXGStatCourseInfoProCourseEventTypeDetail @"xq127" //详情-就业班    xq127
#define kBXGStatCourseInfoProCourseEventTypeOutline @"dg128" //大纲-就业班    dg128
#define kBXGStatCourseInfoProCourseEventTypeLecturer @"ds129" //导师-就业班    ds129
#define kBXGStatCourseInfoProCourseEventTypeComment @"pj130" //评价-就业班    pj130

#define kBXGStatCourseInfoProCourseEventTypeTryLearn @"sxkc132" //试学课程-就业班    sxkc132
#define kBXGStatCourseInfoProCourseEventTypeConsult  @"zxkc133" //咨询课程-就业班    zxkc133
#define kBXGStatCourseInfoProCourseEventTypeFillOrder  @"ljbm134" //立即报名-就业班    ljbm134
#define kBXGStatCourseInfoProCourseEventTypeStudy  @"ljxx135" //立即学习-就业班 ljxx135

// Course Info 精品微课
#define kBXGStatCourseInfoMiniCourseEventTypeDetail @"xq166" //详情-精品微课    xq166
#define kBXGStatCourseInfoMiniCourseEventTypeOutline @"dg167" //大纲-精品微课    dg167
#define kBXGStatCourseInfoMiniCourseEventTypeLecturer @"ds168" //导师-精品微课    ds168
#define kBXGStatCourseInfoMiniCourseEventTypeComment @"pj170" //评价-精品微课    pj170
#define kBXGStatCourseInfoMiniCourseEventTypeQA @"QA171" //Q&A-精品微课    QA171

#define kBXGStatCourseInfoMiniCourseEventTypeTryLearn @"sxkc172" //试学课程-精品微课    sxkc172
#define kBXGStatCourseInfoMiniCourseEventTypeFillOrder  @"ljbm173" //立即报名-精品微课    ljbm173
#define kBXGStatCourseInfoMiniCourseEventTypeStudy  @"ljxx173" //立即学习-精品微课    ljxx173

// Course Info 免费微课
#define kBXGStatCourseInfoFreeCourseEventTypeDetail @"xq198" //详情-免费微课    xq198
#define kBXGStatCourseInfoFreeCourseEventTypeOutline @"dg199" //大纲-免费微课    dg199
#define kBXGStatCourseInfoFreeCourseEventTypeLecturer @"ds200" //导师-免费微课    ds200
#define kBXGStatCourseInfoFreeCourseEventTypeQA @"QA202" //Q&A-免费微课    QA202

// 我的
#define kBXGStatMeRootEventTypeMeOrder @"wdwddd273" // 我的订单

// 我的优惠券
#define kBXGStatMeCouponEventTypeUsable @"ksy265" // 可使用
#define kBXGStatMeCouponEventTypeUsed @"ysy266" // 已使用
#define kBXGStatMeCouponEventTypeInvalid @"ygq267" // 已过期
#define kBXGStatMeCouponEventTypeBindCoupon @"dh268" //兑换-优惠券
#define kBXGStatMeCouponEventTypeUseCoupon @"ljsy269" //立即使用-优惠券
#define kBXGStatMeCouponEventTypeCouponProtocol @"sysm270" //使用说明-优惠券
#define kBXGStatMeCouponEventTypeRecommendCourse @"rmtj271" //热门推荐-优惠券

// 分类
#define kBXGStatCategoryEventTypeSubject @"category_subject" //分类页面-学科按钮
#define kBXGStatCategoryEventTypeProCourse @"category_detail_career" // 分类页面-详情-就业课
#define kBXGStatCategoryEventTypeMiniCourse @"category_detail_mini" // 分类页面-详情-精品微课
#define kBXGStatCategoryEventTypeMessage @"wdxx232" // 分类页面-我的消息
#define kBXGStatCategoryEventTypeHistory @"gkjl233" // 分类页面-观看记录
#define kBXGStatCategoryEventTypeDownload @"xzgl234" // 分类页面-下载管理

// 订单确认页
#define kBXGStatFillOrderEventTypeWeChatPay @"wxzf207" //微信支付    wxzf207
#define kBXGStatFillOrderEventTypeAliPay @"zfb208"//支付宝支付    zfb208
#define kBXGStatFillOrderEventTypeSelectCoupon @"yhqxz209"//优惠券选择    yhqxz209
#define kBXGStatFillOrderEventTypeCommitOrder @"tjdd210"//提交订单    tjdd210

// 订单成功页
#define kBXGStatOrderResultEventTypeStudyCenter @"back219"//学习中心-按钮    back219
#define kBXGStatOrderResultEventTypeMeOrder @"ckdd220"//我的订单-支付成功页    ckdd220

// 支付弹窗
#define kBXGStatOrderToastEventTypePaySucceedBtn @"ddqrzfcg220"//10039    iOS-订单确认页    订单确认页-支付成功-按钮    ddqrzfcg220
#define kBXGStatOrderToastEventTypePayFailedBtn @"ddqrzfsb220"//订单确认页-支付失败-按钮    ddqrzfsb220

// 我的订单
#define kBXGStatMeOrderEventTypeOrderNoPay @"dzf222"//待支付    dzf222
#define kBXGStatMeOrderEventTypeOrderDone @"ywc223"////已完成    ywc223
#define kBXGStatMeOrderEventTypeOrderExpired @"ysx224"// //已失效    ysx224
#define kBXGStatMeOrderEventTypeToPay @"ljzf225"// //立即支付    ljzf225
#define kBXGStatMeOrderEventTypeReFillOrder @"cxgm226"//重新购买    cxgm226
#define kBXGStatMeOrderEventTypeRecommendCourse @"rmtj227"//热门推荐-订单    rmtj227

// 订单详情页
#define kBXGStatOrderDetailEventTypeCancleOrder @"qxdd228"//取消订单-待支付详细页    qxdd228
#define kBXGStatOrderDetailEventTypeCancleOrderToastAccept @"qxddtcqd228"//取消订单弹窗-确定    qxddtcqd228
#define kBXGStatOrderDetailEventTypeCancleOrderToastCancle @"qxddtcqx228"//取消订单弹窗-取消    qxddtcqx228
#define kBXGStatOrderDetailEventTypeWeChatPay @"wxzf229"//微信支付    wxzf229
#define kBXGStatOrderDetailEventTypeAliPay @"ljfk231"//立即支付    ljfk231
#define kBXGStatOrderDetailEventTypeReFillOrder @"cxgmanysxxqy228"//重新购买按钮-已失效详情页    cxgmanysxxqy228

//*
//MoreMicroCourse
#define kBXGStatMoreMicroCourseEventTypeHotCoureseRecommend @"rmkc263"       //热门课程-推荐-分类

#define kBXGStatMoreMicroCourseEventTypeFreeSubject @"xkxz182"                   //学科选择-免费微课
#define kBXGStatMoreMicroCourseEventTypeFreeSujectConfirm @"more_free_course_filter" //学科确认按钮
//#define kBXGStatMoreMicroCourseEventTypeFreeSubjectConfirm @"qdxk183"            //学科确认按钮
//#define kBXGStatMoreMicroCourseEventTypeFreeLevel  @"ndxz184"                    //难度级别排序:全部/基础/进阶/提高
#define kBXGStatMoreMicroCourseEventTypeFreeLevelAll  @"qbnd187"                 //--全部
#define kBXGStatMoreMicroCourseEventTypeFreeLevelBasic @"jc188"                  //--基础
#define kBXGStatMoreMicroCourseEventTypeFreeLevelAdvanced @"jj189"               //--进阶-分类
#define kBXGStatMoreMicroCourseEventTypeFreeLevelImprove @"tg190"                //--提高-分类
//#define kBXGStatMoreMicroCourseEventTypeFreeContent  @"lxxz185"                  //内容排序: 全部/知识点精讲/项目实战
#define kBXGStatMoreMicroCourseEventTypeFreeContentAll @"qblx191"                //--全部分类
#define kBXGStatMoreMicroCourseEventTypeFreeContentProjectPractice @"xmsz192"    //--项目实战分类
#define kBXGStatMoreMicroCourseEventTypeFreeContentIncisive @"ssd193"            //--知识点精讲-分类
//#define kBXGStatMoreMicroCourseEventTypeFreeOrder  @"zxzr252"                    //排序选择分类: 综合/最新/最热
#define kBXGStatMoreMicroCourseEventTypeFreeOrderComprehensive @"zh194"          //--综合-分类
#define kBXGStatMoreMicroCourseEventTypeFreeOrderHottest @"zr195"                //--最热-分类
#define kBXGStatMoreMicroCourseEventTypeFreeOrderLatest @"zx196"                 //--最新-分类

//#define kBXGStatMoreMicroCourseEventTypeBoutiqueSubject @"xkxz182"                   //学科选择-免费微课
#define kBXGStatMoreMicroCourseEventTypeBoutiqueSubjectConfirm @"qdxk151"            //学科确认按钮
#define kBXGStatMoreMicroCourseEventTypeBoutiqueSujectConfirm @"more_mini_course_filter" //学科确认按钮
//#define kBXGStatMoreMicroCourseEventTypeBoutiqueLevel  @"ndxz184"                    //难度级别排序:全部/基础/进阶/提高
#define kBXGStatMoreMicroCourseEventTypeBoutiqueLevelAll  @"qbnd155"                 //--全部-精品微课
#define kBXGStatMoreMicroCourseEventTypeBoutiqueLevelBasic @"jc156"                  //--基础-精品微课
#define kBXGStatMoreMicroCourseEventTypeBoutiqueLevelAdvanced @"jj189"               //--进阶-分类
#define kBXGStatMoreMicroCourseEventTypeBoutiqueLevelImprove @"tg158"                //--提高-分类
//#define kBXGStatMoreMicroCourseEventTypeBoutiqueContent  @"lxxz185"                  //内容排序: 全部/知识点精讲/项目实战
#define kBXGStatMoreMicroCourseEventTypeBoutiqueContentAll @"qblx159"                //--全部分类
#define kBXGStatMoreMicroCourseEventTypeBoutiqueContentProjectPractice @"xmsz192"    //--项目实战分类
#define kBXGStatMoreMicroCourseEventTypeBoutiqueContentIncisive @"ssd161"            //--知识点精讲-分类
//#define kBXGStatMoreMicroCourseEventTypeBoutiqueOrder  @"zxzr252"                    //排序选择分类: 综合/最新/最热
#define kBXGStatMoreMicroCourseEventTypeBoutiqueOrderComprehensive @"zh162"          //--综合-分类
#define kBXGStatMoreMicroCourseEventTypeBoutiqueOrderHottest @"zr163"                //--最热-分类
#define kBXGStatMoreMicroCourseEventTypeBoutiqueOrderLatest @"zx164"                 //--最新-分类

// v3.2.1
#define kBXGStatSocialEventTypeSocialPlatFormLogin @"social_platform_login"         // 使用三方登录
#define kBXGStatSocialEventTypeSocialBindId @"social_bind_id"                       // social_bind_id  绑定三方登录账号
#define kBXGStatSearchEventTypeIntoSearchPage @"search_into_search_page"            // 进入搜索页 label(首页/分类)
#define kBXGStatSearchEventTypeSearchKeyWord @"search_keyword"                      // 搜索的关键词 label(<关键词>)
#define kBXGStatSearchEventTypeSearchHotKeyWord @"search_hot_keyword"               // 热门搜索关键词 label(<关键词>)
#define kBXGStatMessageEventTypeMessageIntoType @"message_into_type"                // 消息种类 label(系统消息,课程消息,学习反馈)

@interface BXGBaiduStatistic : NSObject

+ (instancetype)share;
- (void)statisticEventString:(NSString*)eventString
               andParameter:(NSDictionary*)dict;
- (void)statisticEventString:(NSString *)eventId andLabel:(NSString *)label;
- (void)pageviewStartWithName:(NSString *)name;
- (void)pageviewEndWithName:(NSString *)name;

@end
