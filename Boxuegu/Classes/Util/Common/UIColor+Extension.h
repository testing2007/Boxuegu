#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (instancetype)colorWithHex:(uint32_t)hex;
+ (instancetype)randomColor;
+ (instancetype)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;
+ (instancetype)colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha;
+ (instancetype)themeColor;
-(UIImage*)convertImage;

@end
