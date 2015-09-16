//
//  UIView+Screenshot.m
//  Animation
//
//  Created by yuelixing on 14/12/19.
//  Copyright (c) 2014年 yuelixing. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage*)screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    return image;
}
- (UIImage *)getRightHuffImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    /**
     *  全图
     */
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    UIView * buffView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    buffView.clipsToBounds = YES;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = image;
    [buffView addSubview:imageView];
    imageView.transform = CGAffineTransformMakeTranslation(-self.frame.size.width/2, 0);
    UIImage * target = [buffView screenshot];
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ad"];
    [UIImageJPEGRepresentation(target, 1.0) writeToFile:path atomically:NO];
    
    return target;
}

- (UIImage *)getLeftHuffImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    /**
     *  全图
     */
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    UIView * buffView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    buffView.clipsToBounds = YES;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = image;
    [buffView addSubview:imageView];
    UIImage * target = [buffView screenshot];
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ad"];
    [UIImageJPEGRepresentation(target, 1.0) writeToFile:path atomically:NO];
    
    return target;
}

@end
