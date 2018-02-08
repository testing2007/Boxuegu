//
//  BoxueguTests.m
//  BoxueguTests
//
//  Created by RenyingWu on 2017/9/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BXGUserCenter.h"
#import "BXGUserSettingsViewModel.h"
#import <STAlertView/STAlertView.h>
#import "BXGUserInfoVC.h"

#define INIT \
XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];

#define NOTIFY \
[expectation fulfill];

#define WAIT(second) \
do { \
[self waitForExpectationsWithTimeout:second handler:^(NSError *error) {\
if (error) { \
NSLog(@"Timeout Error: %@", error); \
} else { \
NSLog(@"@@@response"); \
} \
}];\
} while(0);

@interface BoxueguTests : XCTestCase<BXGNotificationDelegate>
@property (nonatomic, strong) BXGUserSettingsViewModel *userSettingVM;
@property (nonatomic, assign) BOOL bLogin;
@property (nonatomic, strong) STAlertView *stAlertView;
@end

@implementation BoxueguTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _bLogin = NO;
    _userSettingVM = [BXGUserSettingsViewModel new];

    [self initialize];
}

- (void)initialize {
    INIT
    
    [[BXGUserCenter share] signInWithUserName:@"13261083093" passWord:@"123456" Finished:^(BXGUserModel *userModel, NSString *msg) {
        _bLogin = (userModel!=nil);
        NOTIFY
    }];
    WAIT(5)
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    _userSettingVM = nil;
    [super tearDown];
}

- (void)testPortrait {
    if(!_bLogin) {
        XCTAssert(FALSE);
    }
    Weak(weakSelf);
    INIT
    [self.userSettingVM loadPersonInfoWithFinishBlock:^(BOOL bSuccess) {
        if(bSuccess) {
            RWLog(@"success to load person info");
            UIImage *image = [UIImage imageNamed:@"AppIcon"];
            NSData * imageData = UIImageJPEGRepresentation(image,1);
            
            [weakSelf.userSettingVM loadUserRequestUpdateHeadPhotoByImageData:imageData andFileType:@"1" andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage, NSString * _Nullable portraitImageURL) {
                if(bSuccess) {
                    RWLog(@"success to loading portrait");
                    XCTAssertNotNil(portraitImageURL);
                } else {
                    RWLog(@"fail to load portrait");
                }
                
                NOTIFY
            }];
        } else {
            RWLog(@"fail to load person info");
        }
    }];
    WAIT(5)
}

- (void)testPassword {
    
}



//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end


