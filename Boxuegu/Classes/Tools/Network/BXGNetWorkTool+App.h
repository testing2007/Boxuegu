//
//  BXGNetWorkTool+App.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool.h"

@interface BXGNetWorkTool (App)

#pragma mark - 1.2.1
#pragma mark - 登录注册用户信息模块

/// 用户: 登录 (已验证)
- (void)appRequestLoginUserName:(NSString * _Nullable)userName
                      Password:(NSString * _Nullable)password
                      Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求执行 "注册手机号注册用户" (已废弃)
- (void)requestPhoneRegistWithUserName:(NSString * _Nullable)userName
                              passWord:(NSString * _Nullable)passWord
                                mobile:(NSString * _Nullable)mobile
                                  code:(NSString * _Nullable)code
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestPhoneRegistWithUserName:(NSString * _Nullable)userName
                              PassWord:(NSString * _Nullable)password
                                Mobile:(NSString * _Nullable)mobile
                                  Code:(NSString * _Nullable)code
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
/// 请求执行 "发送动态码" (注册)
- (void)requestRegistCodeWithMobile:(NSString * _Nullable)mobile
                          Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestRegistCodeWithMobile:(NSString * _Nullable)mobile
                          Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求执行 "发送动态码" (重置)
-(void)requestResetPasswordCodeWithMobile:(NSString * _Nullable)mobile
                                 Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)appRequestCodeWithMobile:(NSString * _Nullable)mobile
                                  withIsBind:(BOOL)bBind
                                 Finished:(BXGNetworkCallbackBlockType _Nullable) finished;


/// 请求执行 "退出登录操作"
- (void)requestLogoutWithUserID:(NSString * _Nullable)userID
                        andSign:(NSString * _Nullable)sign
                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                         Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestLogoutWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求执行 "校验用户是否注册"
- (void)requestUserExistsWithMobile:(NSString * _Nullable)mobile
                            andCode:(NSString * _Nullable)code
                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestUserExistsWithMobile:(NSString * _Nullable)mobile
                                  Code:(NSString * _Nullable)code
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求执行 "校验动态码" (注册)
- (void)requestCheckVerificationCodeForRegist:(NSString * _Nullable)code
                                       mobile:(NSString * _Nullable)mobile
                                  andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                       Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestCheckVerificationCodeForRegist:(NSString * _Nullable)code
                                          Mobile:(NSString * _Nullable)mobile
                                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求执行 "校验动态码" (重置密码)
- (void)requestCheckVerificationCodeForResetPsw:(NSString * _Nullable)code
                                         mobile:(NSString * _Nullable)mobile
                                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                         Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestCheckVerificationCodeForResetPsw:(NSString * _Nullable)code
                                            Mobile:(NSString * _Nullable)mobile
                                          Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求执行 "重置密码操作"
- (void)requestResetPasswordWithPhoneNumber:(NSString * _Nullable)phoneNumber
                                andPassword:(NSString * _Nullable)psw
                                andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                     Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestResetPasswordWithPhoneNumber:(NSString * _Nullable)phoneNumber
                                Password:(NSString * _Nullable)psw
                                Finished:(BXGNetworkCallbackBlockType _Nullable) finished;


/// 请求获取 "用户信息"
- (void)requestUserinfomationWithUserId:(NSString * _Nullable)userId
                                andSign:(NSString * _Nullable)sign
                            andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestUserinfomationWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

#pragma mark - 意见反馈
/// 反馈请求
- (void)requestFeedBackWithUserID:(NSString * _Nullable)userID
                          andSign:(NSString * _Nullable)sign
                   andPhoneNumber:(NSString * _Nullable)phoneNumber
                          andText:(NSString * _Nullable)fbText
                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestFeedBackWithPhoneNumber:(NSString * _Nullable)phoneNumber
                                  Text:(NSString * _Nullable)fbText
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

#pragma mark - 学习中心
/// 请求获取 "所有免费微课课程" 备注:is_free 1:免费 0:收费,course_type 1:微课 0:就业课
- (void)requestFreeMicroCoursesWithSign:(NSString * _Nullable)sign
                               Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestFreeMicroCoursesWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求获取 "所有已购买的微课,职业课课程详情"
- (void)requestAppCourceWithUserID:(NSString * _Nullable)userID
                           andSign:(NSString * _Nullable)sign
                       andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestAppCourceWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求获取 "课程学习进度"
- (void)requestCourseProgessWithUserId:(NSString * _Nullable)userId
                           andCourseId:(NSString * _Nullable)courseId
                               andSign:(NSString * _Nullable)sign
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestCourseProgessWithCourseId:(NSString * _Nullable)courseId
                               andSign:(NSString * _Nullable)sign
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求获取课程"月"计划
- (void)requestCalendarCourseMonthPlanWithUserId:(NSString * _Nullable)userId
                                     andCourseId:(NSString * _Nullable)courseId
                                         andSign:(NSString * _Nullable)sign
                                   andDateString:(NSString * _Nullable)dateString
                                        Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestCalendarCourseMonthPlanWithCourseId:(NSString * _Nullable)courseId
                                           DateString:(NSString * _Nullable)dateString
                                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 获取我的职业课程
- (void)requestMyVocationalWithUserID:(NSString * _Nullable)userID
                          andCourseId:(NSString * _Nullable)courseId
                              andSign:(NSString * _Nullable)sign
                              andDate:(NSString * _Nullable)date
                              andPage:(NSString * _Nullable)page
                          andPageSize:(NSString * _Nullable) pageSize
                          andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                               Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestMyVocationalWithCourseId:(NSString * _Nullable)courseId
                                   Date:(NSString * _Nullable)date
                                   Page:(NSString * _Nullable)page
                               PageSize:(NSString * _Nullable) pageSize
                               Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/// 请求获取 "课程大纲详情"
- (void)requestCourceOutlineWithCourseID:(NSString * _Nullable)courseID
                               andUserID:(NSString * _Nullable)userID
                                 andSign:(NSString * _Nullable)sign
                             andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                  Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestCourceOutlineWithCourseID:(NSString * _Nullable)courseID
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/**
 请求串讲信息
 */
- (void)requestConstrueWithPlanID:(NSString * _Nullable)planID
                        andUserID:(NSString * _Nullable)userID
                          andSign:(NSString * _Nullable)sign
                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                           Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestConstrueWithPlanID:(NSString * _Nullable)planID
                            Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/**
 请求微课课程信息
 */
- (void)requestMiniCourceWithUserID:(NSString * _Nullable)userID
                            andSign:(NSString * _Nullable)sign
                            andPage:(NSString * _Nullable)page
                        andPageSize:(NSString * _Nullable)pageSize
                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestMiniCourceWithPage:(NSString * _Nullable)page
                        PageSize:(NSString * _Nullable)pageSize
                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/**
 请求所有课程信息
 */
- (void)requestAllCourceWithUserID:(NSString * _Nullable)userID
                           andSign:(NSString * _Nullable)sign
                           andPage:(NSString * _Nullable)page
                       andPageSize:(NSString * _Nullable)pageSize
                       andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestAllCourceWithPage:(NSString * _Nullable)page
                       PageSize:(NSString * _Nullable)pageSize
                       Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

/**
 请求已购买的课程
 */
- (void)requestPayCourseWithUserId:(NSString * _Nullable)userId
                           andSign:(NSString * _Nullable)sign
                       andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestPayCourseWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

/**
 请求更新视频学习状态
 
 studyStatus:学习状态  0：未学习，1：已学习，2：学习中
 */
- (void)requestUpdateStudyStateWithUserId:(NSString * _Nullable)userId
                              andCourseId:(NSString * _Nullable)courseId
                               andVideoId:(NSString *_Nullable)videoId
                                  andSign:(NSString * _Nullable)sign
                                 andState:(NSString * _Nullable)state
                              andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestUpdateStudyStateWithCourseId:(NSString * _Nullable)courseId
                                       VideoId:(NSString *_Nullable)videoId
                                         State:(NSString * _Nullable)state
                                      Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

#pragma mark - 观看记录模块
/**
 请求获取 "所有课程已观看记录"
 */
- (void)requestCourseHistoryWithUserID:(NSString * _Nullable)userID
                               andSign:(NSString * _Nullable)sign
                           andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock;

- (void)appRequestCourseHistoryWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

//#pragma mark - 购买模块
//
///**
// 请求执行 "购买免费微课" 1.0.1
// */
//- (void)requestBuyFreeMicroCourse:(NSString * _Nullable)courseId
//                        andUserId:(NSString * _Nullable)userId
//                          andSign:(NSString * _Nullable)sign
//                         Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
//                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
//
//- (void)appRequestBuyFreeMicroCourse:(NSString * _Nullable)courseId
//                            Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

#pragma mark - 我的消息模块

/**
 请求获取 "统计用户未读消息总数"
 */
- (void)requestMyMessageCountWithUserId:(NSString * _Nullable)userId
                                andSign:(NSString * _Nullable)sign
                               Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;



/**
 请求执行 "更新消息状态"
 */
- (void)requestUpdateMessageStatus:(NSString * _Nullable)userId
                           andSign:(NSString * _Nullable)sign
                           andType:(NSString * _Nullable)type
                          Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;


/**
 请求执行 "清空课程消息"
 */
- (void)requestDeleteMessage:(NSString * _Nullable)userId
                     andSign:(NSString * _Nullable)sign
                     andType:(NSString * _Nullable)type
                    Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;



/**
 请求获取 "根据消息类型查询消息列表"
 */
- (void)requestMessageList:(NSString * _Nullable)userId
                   andSign:(NSString * _Nullable)sign
                   andType:(NSString * _Nullable)type
                  Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                    Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;



/// 请求获取 "课程大纲-章节"
- (void)requestCourseChapterList:(NSString * _Nullable)courseId
                       andUserId:(NSString * _Nullable)userId
                         andSign:(NSString * _Nullable)sign
                        Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestCourseChapterList:(NSString * _Nullable)courseId
                       Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
/// 请求获取 "课程大纲-点视频"
- (void)requestCourseSectionAndVideoList:(NSString * _Nullable)courseId
                               andUserId:(NSString * _Nullable)userId
                            andSectionId:(NSString * _Nullable)sectionId
                                 andSign:(NSString * _Nullable)sign
                                Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                  Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestCourseSectionAndVideoList:(NSString * _Nullable)courseId
                               SectionId:(NSString * _Nullable)sectionId
                                Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
/// 请求获取 "课程大纲-评论列表"
- (void)requestStudentCriticizeListWithCourseId:(NSString * _Nullable)courseId
                                        andPage:(NSString * _Nullable)page
                                    andPageSize:(NSString * _Nullable)pageSize
                                        andSign:(NSString * _Nullable)sign
                                       Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestStudentCriticizeListWithCourseId:(NSString * _Nullable)courseId
                                           Page:(NSString * _Nullable)page
                                       PageSize:(NSString * _Nullable)pageSize
                                       Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
/// 请求提交 课程评论
- (void)requestCommitStudentCriticizeWithUserId:(NSString * _Nullable)userId
                                       CourseId:(NSString * _Nullable)courseId
                                        PointId:(NSString * _Nullable)pointId
                                     andVideoId:(NSString * _Nullable)videoId
                                   andStarLevel:(NSNumber * _Nullable)starLevel
                                     andContent:(NSString * _Nullable)content
                                        andSign:(NSString * _Nullable)sign
                                       Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

- (void)appRequestCommitStudentCriticizeWithCourseId:(NSString * _Nullable)courseId
                                     andVideoId:(NSString * _Nullable)videoId
                                   andStarLevel:(NSNumber * _Nullable)starLevel
                                     andContent:(NSString * _Nullable)content
                                       Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
/// 请求获取 观看记录
- (void)requestCourseHistoryWithUserId:(NSString * _Nullable)userId
                           andCourseId:(NSString * _Nullable)courseId
                               andSign:(NSString * _Nullable)sign
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
/// 请求同步 离线学习状态
- (void)requestUpdateOfflineStudyStatusWithVideoData:(NSString * _Nullable)videoData
                                             andSign:(NSString * _Nullable)sign
                                           andUserId:(NSString * _Nullable)userId
                                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
/// 请求获取 上次学习视频
- (void)requestLastlearnHistoryWithSign:(NSString * _Nullable)sign
                              andUserId:(NSString * _Nullable)userId
                            andCourseId:(NSString * _Nullable)courseId // 可选
                            andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
#pragma mark - 笔记模块
/// 所有课程笔记
- (void)requestCourseNotesWithUserId:(NSString* _Nullable)userId
                             andSign:(NSString* _Nullable)sign
                            Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
/// 指定课程笔记
- (void)requestCourseNoteDetailWithUserId:(NSString* _Nullable)userId
                                  andPage:(NSString* _Nullable)page
                              andPageSize:(NSString* _Nullable)pageSize
                              andCourseId:(NSString* _Nullable)courseId
                                  andType:(NSString* _Nullable)type
                                  andSign:(NSString* _Nullable)sign
                                 Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
/// 更新点赞
- (void)requestUpdatePraiseNoteUserId:(NSString* _Nullable)userId
                          andUserName:(NSString* _Nullable)userName
                            andNoteId:(NSString* _Nullable)noteId
                              andSign:(NSString* _Nullable)sign
                             Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                               Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
/// 更新收藏
- (void)requestUpdateCollectNoteUserId:(NSString* _Nullable)userId
                           andUserName:(NSString* _Nullable)userName
                             andNoteId:(NSString* _Nullable)noteId
                               andSign:(NSString* _Nullable)sign
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
/// 删除笔记
- (void)requestDeleteNoteUserId:(NSString* _Nullable)userId
                    andUserName:(NSString* _Nullable)userName
                      andNoteId:(NSString* _Nullable)noteId
                        andSign:(NSString* _Nullable)sign
                       Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;





/// 分类：加载分类页所有学科
- (void)requestCourseCategorySubjectWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

/// 分类：根据学科Id加载分类信息
- (void)requestCourseCategoryInfoWithSubjectId:(NSString * _Nullable)subjectId andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

/// 首页：获取课程列表（就业课、精品微课、免费微课）
// /bxg/index/getCourse
- (void)requestCourseListInfoFinish:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock;

/// 就业课：更多就业课
// /bxg/index/getMoreCareerCourse
- (void)requestMoreCareerCourseFinish:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                               Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock;
/// 课程信息：课程大纲
// /bxg/course/getCourseOutline
- (void)requestCourseInfoOutlineWithCourseId:(NSString *_Nullable)courseId
                                 andFinished:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                                      Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock;

/// 微课筛选页：获取所有微课的筛选条件
// /bxg/index/getChoiceList
// course_type    number    是    课程类型(1:微课 0：就业课)
// is_free    number    是    是否免费(1:免费 0：精品)
- (void)requestFilterCourseInfoWithCourseType:(NSNumber *  _Nullable)courseType
                                 andMicroType:(NSNumber * _Nullable)microType
                                  andFinished:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                                       Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock;

/// 微课筛选页：根据筛选条件获取微课
// /bxg/index/getMicroCourseByChoice
//参数名    类型    必需    描述    示例 e.g.
//directionId    string    否    学科方向
//subjectId    string    否    学科
//tagId    string    否    分类
//orderType    string    否    排序方式:0-综合 1-最新 2-最热
//courseLevel    string    否    课程等级:0-基础 1-进阶 2-提高
//contentType    string    否    课程内容:0-全部 1-知识点精讲 2-项目实战
//isFree    number    否    是否免费：0-精品微课 1-免费微课
//pageNo    number    否    当前页(默认为1)
//pageSize    number    否    每页显示的条数(默认为15)
- (void)requestFilterCourseInfoWithDirectionId:(NSNumber * _Nullable)directionId
                                  andSubjectId:(NSNumber * _Nullable)subjectId
                                      andTagId:(NSNumber * _Nullable)tagId
                                  andOrderType:(NSNumber * _Nullable)orderType
                                andCourseLevel:(NSNumber * _Nullable)courseLevel
                                andContentType:(NSNumber * _Nullable)contentType
                                        isFree:(NSNumber * _Nullable)bFree
                                        pageNo:(NSNumber * _Nullable)pageNo
                                      pageSize:(NSNumber * _Nullable)pageSize
                                   andFinished:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                                        Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock;

- (void)requestCourseCourseLecturerWithCourseId:(NSString *_Nullable)courseId
                                    andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;

/// 课程: 是否已购买课程 bxg/course/isApply para: course_id,user_id
- (void)requestCourseIsApplyWithCourseId:(NSString * _Nullable)courseId
                               andUserId:(NSString * _Nullable)userId
                             andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;
#pragma mark - Order 订单模块
/**
 提交订单: 订单确认 /bxg/order/doConfirm/
 
 @param userId string    是    用户id    2c9081915d34625c015d348e6467000d
 @param isInitial number    是    初次调用isInitial=0；非初次调用：isInitial=1    0
 @param sign <#sign description#>
 @param orderCourseIds array    是    订单的课程id数组,逗号分隔    443
 @param courseCouponId string    是    课程id-优惠券id映射    {200: 0, 384: 0, 443: 0, 536: 0}
 */
- (void)requestOrderSubmitOutlineWithUserId:(NSString *_Nullable)userId
                               andIsInitial:(NSNumber *_Nullable)isInitial
                                    andSign:(NSString *_Nullable)sign
                          andOrderCourseIds:(NSString *_Nullable)orderCourseIds
                          andCourseCouponId:(NSString *_Nullable)courseCouponId
                                andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;

/**
 提交订单：课程选择优惠券接口 /bxg/coupon/getCouponsByUserIdAndCouponIds
 
 @param userId string    是    用户id    2c9081915d34625c015d348e6467000d
 @param courseId number    是    使用优惠券的课程id    536
 @param couponIds array    是    优惠券id集合(array)    1022570 以逗号分隔
 @param useStatus number    是    该用户优惠券相对于此课程可使用状态，=1 可使用，=0 不可使用    1
 */
- (void)requstOrderSubmitCouponWithUserId:(NSString *_Nullable)userId
                              andCourseId:(NSString *_Nullable)courseId
                             andCouponIds:(NSString *_Nullable)couponIds
                             andUseStatus:(NSNumber *_Nullable)useStatus
                            andPageNumber:(NSNumber *_Nullable)pageNumber
                              andPageSize:(NSNumber *_Nullable)pageSize
                                  andSign:(NSString *_Nullable)sign
                              andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;


/**
 我的优惠券列表 /bxg/coupon/getMyCoupons
 
 @param userId string    是    用户id
 @param status number    是    优惠券状态(可使用:0已使用:1已过期:2)
 @param pageNumber number    是    当前页数
 @param pageSize number    是    每页数
 @param sign 登录sign
 */
- (void)requestMyCouponsWithUserId:(NSString *_Nullable)userId
                         andStatus:(NSNumber *_Nullable)status
                     andPageNumber:(NSNumber *_Nullable)pageNumber
                       andPageSize:(NSNumber *_Nullable)pageSize
                           andSign:(NSString *_Nullable)sign
                       andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded ;

/**
 我的订单：根据订单状态获取订单列表 /bxg/order/getMyOrder
 
 @param userId string    是    用户id    2c9081915d34625c015d348e6467000d
 @param orderStatus number    是    订单支付状态 0:未支付 1:已支付 2:已关闭    0
 @param pageNumber number    是    页数    1
 @param pageSize number    是    每页数    20
 */
- (void)requestMyOrdersWithUserId:(NSString *_Nullable)userId
                   andOrderStatus:(NSNumber *_Nullable)orderStatus
                    andPageNumber:(NSNumber *_Nullable)pageNumber
                      andPageSize:(NSNumber *_Nullable)pageSize
                      andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;


/**
 我的优惠券：根据优惠券id获取优惠券可优惠课程 /bxg/coupon/getCouponCourses
 
 @param couponId   number    是    优惠券id
 @param pageNumber number    是    当前页数
 @param pageSize   number    是    每页数
 */
- (void)requestCouponCoursesWithCouponId:(NSString *_Nullable)couponId
                           andPageNumber:(NSNumber *_Nullable)pageNumber
                             andPageSize:(NSNumber *_Nullable)pageSize
                             andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded ;

/**
 我的优惠券：绑定优惠券 /bxg/coupon/bindCouponToUser
 
 @param serialNo  string    是    优惠券码    LmLdzjs5Q4F2
 @param courseId  string    是    课程Id
 */
- (void)requestBindCouponWithSerialNo:(NSString *_Nullable)serialNo
                          andCourseId:(NSString *_Nullable)courseId
                          andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;

/**
 课程播放: 试学大纲 bxg/course/getCourseTryOutLine
 
 @param courseId 课程id
 */
- (void)requestCourseTryOutlineWithCourseId:(NSString * _Nullable)courseId
                                andFinished:BXGNetworkFinishedBlockType finished
andFailed:BXGNetworkFailedBlockType failded;


/// 订单：订单详情 /bxg/order/orderDetail
- (void)requestOrderDetailWithOrderId:(NSString *_Nullable)orderId
                          andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded ;

/// 课程详情页：报名之前检测课程下是否有视频的接口 /bxg/video/existVideosByCourseId
- (void)requestExistVideosByCourseIdWithCourseId:(NSString * _Nullable)courseId
                                     andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded ;

/// 取消订单 bxg/order/updateOrderStatus type 0删除订单（暂不支持删除），1取消订单
- (void)requestCancelOrderWithOrderNo:(NSString *_Nullable)orderNo
                              andType:(NSString *_Nullable)type
                          andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;

/// 支付：保存订单（接口调用详见文档-详细说明）（非免费课程逻辑未完成）/bxg/order/saveOrder
- (void)requestOrderSaveOrderWithOrderStr:(id _Nullable)orderJson andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;


/// 课程详情页: 课程详情信息 /bxg/course/getCourseByCourseId
- (void)requestCourseDetailWithCourseId:(NSString * _Nullable)courseId Finished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed;

/// 订单查询 URL: /bxg/order/queryOrder type 支付方式：0-微信 1-支付宝 2-网银
- (void)requestOrderSearchWithOrderNo:(NSString * _Nullable)orderNo
                              andType:(NSString * _Nullable)type
                          andFinished:BXGNetworkFinishedBlockType finished
andFailed:BXGNetworkFailedBlockType failed;

/// 支付: 立即支付 /bxg/order/topay type 支付类型 0:微信 1:支付宝 2:网银
- (void)requestOrderToPayWithOrderId:(NSString * _Nullable)orderId
                          andOrderNo:(NSString * _Nullable)orderNo
                             andType:(NSString * _Nullable)type
                         andFinished:BXGNetworkFinishedBlockType finished
andFailed:BXGNetworkFailedBlockType failed;

/// 用户：获取当前用户咨询报名信息 /bxg/onlineUser/getApplyInfo
- (void)requestGetApplyInfoWithFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;


#pragma mark - 消息中心
/*
 消息中心 info
 
 // 统计用户未读消息总数 /bxg/message/myMessageCount 周期调用一次
 // 更新消息状态 /bxg/message/updateMessageStatus 打开详情调用
 // 根据消息类型查询消息列表 bxg/message/messageList 打开详情页 需要加分页
 // 清空课程消息 bxg/message/deleteMessage 功能未实现
 // 根据课程类型查找未读消息的总数+最后创建的消息 /bxg/message/getLastMessageByType 二级页面
 */
- (void)appRequestMyMessageCountWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;
- (void)appRequestUpdateMessageStatusByType:(NSString * _Nullable)type
                                 Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
- (void)appRequestDeleteMessageByType:(NSString * _Nullable)type
                           Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
- (void)appRequestMessageListByType:(NSString * _Nullable)type
                         PageNumber:(NSString *_Nullable)pageNumber
                           PageSize:(NSString *_Nullable)pageSize
                           Finished:(BXGNetworkCallbackBlockType _Nullable) finished;
- (void)appRequestGetLastMessageByType:(NSString * _Nullable)type
                         Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

///搜索课程列表 /bxg/search/courseSearch
- (void)appRequestSearchCourseListByKeyword:(NSString *_Nullable)keyword
                                 PageNumber:(NSString *_Nullable)pageNumber
                                   PageSize:(NSString *_Nullable)pageSize
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

///获取热门搜索关键字 /bxg/search/searchHotWord
- (void)appRequestSearchHotKeywordWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished;


#pragma mark - 个人设置
///用户基本信息的获取（点击个人设置需要调用）/bxg/onlineUser/getBaseUserInfo
- (void)appRequestUserBaseSettingInfoWithFinished:(BXGNetworkCallbackBlockType _Nullable)finished;

///三方账号绑定与否列表（点击个人设置需要调用）bxg/onlineUser/getCurrAccountInfo
- (void)appRequestUserThirdBindInfoWithFinished:(BXGNetworkCallbackBlockType _Nullable)finished;

#pragma mark - 直播

/// 直播: 月计划显示列表
- (void)appRequestConstruePlanByMonthWithMenuId:(NSString * _Nullable)menuId
                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

/// 直播: 日计划显示列表
- (void)appRequestConstruePlanByDayWithMenuId:(NSString * _Nullable)menuId
                                          Day:(NSString * _Nullable)day
                                     Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

/// 直播: 课程简介 /bxg/appConstruePlan/getConstruePlanById
- (void)appRequestConstrueIntroduceWithPlanId:(NSString * _Nullable)planId
                                     Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

/// 直播: 回放列表 /bxg/appConstruePlan/getCallBackPlanById
- (void)appRequestConstrueReplayListWithPlanId:(NSString * _Nullable)planId
                                     Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

/// 直播: 获取直播状态 /bxg/appConstruePlan/checkPlanStatusById
- (void)appRequestConstrueCheckStatusWithPlanId:(NSString * _Nullable)planId
                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished;
@end
