#import <UIKit/UIKit.h>

@interface UIImage (wrapper)

+ (UIImage *)scaleFromImage:(UIImage *)image withSize:(CGSize)size; //缩放

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image withSize:(CGSize)size;  //压缩


+ (BOOL)deleteUserPhoto;

// 创建边框为虚线的图
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

+ (UIImage*)createImageWithColor:(UIColor*)color;
@end
