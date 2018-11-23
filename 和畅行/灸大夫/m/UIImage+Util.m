//
//  UIImage+Util.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/17.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

// --------------------------------------------------
// Resize an image
// --------------------------------------------------
- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height {
    
    //    CGFloat destW = width;
    //    CGFloat destH = height;
    //    CGFloat sourceW = width;
    //    CGFloat sourceH = height;
    //
    //    CGImageRef imageRef = self.CGImage;
    //    CGContextRef bitmap = CGBitmapContextCreate(NULL,
    //                                                destW,
    //                                                destH,
    //                                                CGImageGetBitsPerComponent(imageRef),
    //                                                4*destW,
    //                                                CGImageGetColorSpace(imageRef),
    //                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    //
    //    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    //
    //    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    //    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    //    CGContextRelease(bitmap);
    //    CGImageRelease(ref);
    //
    //    return resultImage;
    
    //    CGSize size = CGSizeMake(width, height);
    //    UIGraphicsBeginImageContext(size);
    //    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return scaledImage;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //Determine whether the screen is retina
    //    if([[UIScreen mainScreen] scale] == 2.0){
    //        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    //    }else{
    //        UIGraphicsBeginImageContext(size);
    //    }
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height
                     scale:(CGFloat)scale
{
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)newImageNotCached:(NSString *)filename {
    return [self imageNamed:filename];
    //    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    //    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    //    return image;
}

+ (UIImage *)newImageByColor:(UIColor*)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// 把图片归正
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    UIImage *aImage = self;
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
