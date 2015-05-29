//
//  KNUtil.m
//  KNUtils
//
//  Created by huangzekai on 14-4-22.
//  Copyright (c) 2014年 kennyHuang. All rights reserved.
//

#import "KNUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

#define kImagePathExtensionPNG @"png"

@implementation KNUtil

@end

@implementation NSObject (KN)

- (void)addObserverSelector:(SEL)selector withName:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:object];
}

- (void)removeObserverWithName:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:name object:object];
}

@end

@implementation UIColor (KN)

+ (UIColor *)colorWithUInt:(NSUInteger)rgbHex
{
    return [self colorWithUInt:rgbHex alpha:1.0];
}

+ (UIColor *)colorWithUInt:(NSUInteger)rgbHex alpha:(CGFloat)alpha
{
    //红色
    CGFloat r = (rgbHex >> 16) / 250.0;
    //绿色
    CGFloat g = (rgbHex >> 8 & 0X0000FF) / 250.0;
    //蓝色
    CGFloat b = (rgbHex & 0X0000FF) / 250.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end


@implementation UIImage (KN)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect frame = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, frame);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithResource:(NSString *)imageName
{
    if (!imageName) return nil;
    
    NSString *type = nil;
    
    if (!imageName.pathExtension.length)
    {
        type = kImagePathExtensionPNG;
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:type];
    NSData *data   = [NSData dataWithContentsOfFile:path];
    
    //获取缩放比例
    if([self instancesRespondToSelector:@selector(imageWithData:scale:)])
    {
        return [self imageWithData:data scale:2.0];
    }
    else
    {
        UIImage *image = [self imageWithData:data];
        return [self imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
    }
}

+ (UIImage *)imageStretchCenterWithNamed:(NSString *)name
{
    UIImage *image = [UIImage imageWithResource:name];
    
    if (image)
    {
        image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    }
    
    return image;
}

@end

@implementation NSString (KN)

- (NSString *)clearMarginSpace
{
    NSCharacterSet *spaceCharateSet = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:spaceCharateSet];
}

- (NSDate *)date
{
    return [self dateWithFormatString:@"yy-MM-dd HH:mm:ss"];
}

- (NSDate *)dateWithFormatString:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:self];
}

//删除空格、回车、TAB
- (NSString *)stringTrimWhitespace
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSMutableString *string = [[self stringByTrimmingCharactersInSet:set] mutableCopy];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"\t" withString:@"" options:0 range:NSMakeRange(0, string.length)];
    return string;
}

- (BOOL)isRegularMatchString:(NSString *)regular
{
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regular
                                                                                options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange range = [expression rangeOfFirstMatchInString:self
                                                  options:NSMatchingReportProgress
                                                    range:NSMakeRange(0, self.length)];
    
    return range.length;
}

- (NSString *)md5Lowercase
{
    return [[self MD5Uppercase] lowercaseString];
}

- (NSString *)MD5Uppercase {
    if ([self length] == 0) {
        return nil;
    }
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation NSDate (KN)

- (NSString *)dateWithFormatString:(NSString *)format
{
    if (!format.length)
    {
        return nil;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end


typedef void (^KNAlertViewClickBlock) (UIAlertView *alertView, NSInteger clickIndex);
typedef void (^KNAlertViewWillDismissBlock) (UIAlertView *alertView, NSInteger index);
typedef void (^KNAlertViewDidDismisaBlock) (UIAlertView *alertView, NSInteger index);

@interface KNAlertView ()

@property (nonatomic, strong) KNAlertViewClickBlock clickButtonBlock;
@property (nonatomic, strong) KNAlertViewWillDismissBlock willDismissBlock;
@property (nonatomic, strong) KNAlertViewDidDismisaBlock didDismissBlock;
@property (nonatomic, weak) id<UIAlertViewDelegate> alertDelegate;

@end

@implementation KNAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    if (self)
    {
        va_list args;
        ///args中指针指向otherButtonTitles
        va_start(args, otherButtonTitles);
        
        if (otherButtonTitles)
        {
            [self addButtonWithTitle:otherButtonTitles];
            NSString *title = nil;
            
            //遍历
            while ((title = va_arg(args, NSString *)))
            {
                [self addButtonWithTitle:title];
            }
        }
    }
    return self;
}

- (void)setDelegate:(id)delegate
{
    super.delegate = self;
    self.alertDelegate = delegate;
}

- (void)showUsingClickBlock:(void (^)(UIAlertView *, NSInteger))block
{
    _clickButtonBlock = block;
    ///必须在主线程弹出（解决崩溃）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showUsingWillDismissBlock:(void (^)(UIAlertView *, NSInteger))block
{
    _willDismissBlock = block;
    ///必须在主线程弹出（解决崩溃）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showUsingDidDismissBlock:(void (^)(UIAlertView *, NSInteger))block
{
    _didDismissBlock = block;
    ///必须在主线程弹出（解决崩溃）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)showUsingClickBlock:(void (^)(UIAlertView *, NSInteger))clickBlock WillDismissBlock:(void (^)(UIAlertView *, NSInteger))willDismissBlock DidDismissBlock:(void (^)(UIAlertView *, NSInteger))didDismissBlock
{
    _clickButtonBlock = clickBlock;
    _willDismissBlock = willDismissBlock;
    _didDismissBlock  = didDismissBlock;
    
    ///必须在主线程弹出（解决崩溃）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickButtonBlock)
    {
        self.clickButtonBlock(alertView, buttonIndex);
    }
    else
    {
        if ([self.alertDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.alertDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissBlock)
    {
        self.willDismissBlock(alertView, buttonIndex);
    }
    else
    {
        if ([self.alertDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
        {
            [self.alertDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissBlock)
    {
        self.didDismissBlock(alertView, buttonIndex);
    }
    else
    {
        if ([self.alertDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
        {
            [self.alertDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
        }
    }
}

@end

#pragma mark - UIActionSheet

typedef void (^KNActionSheetClickBlock) (UIActionSheet *actionSheet, NSInteger atIndex);
typedef void (^KNActionSheetWillDismissBlock) (UIActionSheet *actionSheet, NSInteger atIndex);
typedef void (^KNActionSheetDidDismissBlock) (UIActionSheet *actionSheet, NSInteger atIndex);

@interface KNActionSheet ()

@property (nonatomic, strong) KNActionSheetClickBlock clickBlock;
@property (nonatomic, strong) KNActionSheetWillDismissBlock willDismissBlock;
@property (nonatomic, strong) KNActionSheetDidDismissBlock didDismissBlock;
@property (nonatomic, weak) id<UIActionSheetDelegate> actionSheetDelegate;

@end

@implementation KNActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    
    if (self)
    {
        va_list args;
        va_start(args, otherButtonTitles);
        
        if (otherButtonTitles)
        {
            [self addButtonWithTitle:otherButtonTitles];
            
            NSString *title = nil;
            
            while ((title = va_arg(args, NSString *)))
            {
                [self addButtonWithTitle:title];
            }
        }
        self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
        self.actionSheetDelegate = delegate;
    }
    return self;
}


- (void)setDelegate:(id)delegate
{
    super.delegate = self;
    self.actionSheetDelegate = delegate;
}

- (void)showInView:(UIView *)view usingClickBlock:(void (^)(UIActionSheet *, NSInteger))block
{
    _clickBlock = block;
    [self showInView:view];
}

- (void)showInView:(UIView *)view usingWillDismissBlock:(void (^)(UIActionSheet *, NSInteger))block
{
    _willDismissBlock = block;
    [self showInView:view];
}

- (void)showInView:(UIView *)view usingDidDismissBlock:(void (^)(UIActionSheet *, NSInteger))block
{
    _didDismissBlock = block;
    
    [self showInView:view];
}

- (void)showInView:(UIView *)view usingClickBlock:(void (^)(UIActionSheet *, NSInteger))clickBlock WillDismissBlock:(void (^)(UIActionSheet *, NSInteger))willDismissBlock DidDismissBlock:(void (^)(UIActionSheet *, NSInteger))didDismissBlock
{
    _clickBlock = clickBlock;
    _willDismissBlock = willDismissBlock;
    _didDismissBlock = didDismissBlock;
    
    [self showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickBlock)
    {
        self.clickBlock(actionSheet, buttonIndex);
    }
    else
    {
        if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        {
            [self.actionSheetDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissBlock)
    {
        self.willDismissBlock(actionSheet, buttonIndex);
    }
    else
    {
        if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)])
        {
            [self.actionSheetDelegate actionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissBlock)
    {
        self.didDismissBlock(actionSheet, buttonIndex);
    }
    else
    {
        if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
        {
            [self.actionSheetDelegate actionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
        }
    }
}
@end

#pragma mark - UIViewController

@implementation UIViewController (KN)


- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeLeft | UIRectEdgeRight;
}

@end
