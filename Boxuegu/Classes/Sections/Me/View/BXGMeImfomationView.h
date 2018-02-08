

#import <UIKit/UIKit.h>

@interface BXGMeImfomationView : UIView

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIButton *loginButton;

- (void)updateImfomation;
@end
