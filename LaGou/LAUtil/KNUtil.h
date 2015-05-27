//
//  KNUtil.h
//  KNUtils
//
//  Created by huangzekai on 14-4-22.
//  Copyright (c) 2014年 kennyHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KNUtil : NSObject

@end

#pragma mark - NSObject

@interface NSObject (KN)

///添加监听
- (void)addObserverSelector:(SEL)selector withName:(NSString *)name object:(id)object;
///移除监听
- (void)removeObserverWithName:(NSString *)name object:(id)object;

@end

#pragma mark - UIColor

@interface UIColor(KN)

///根据十六进制rgb值获取颜色
+ (UIColor *)colorWithUInt:(NSUInteger)rgbHex;

@end

#pragma mark - UIImage

@interface UIImage (KN)

///根据颜色值生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

///无缓存加载图片
+ (UIImage *)imageWithResource:(NSString *)imageName;

///拉伸图片
+ (UIImage *)imageStretchCenterWithNamed:(NSString *)name;

@end

#pragma mark - NSString

@interface NSString (KN)
/**
 *  清除两边空白字符集,包括空格和tab格(不清除换行符)
 *
 */
- (NSString *)clearMarginSpace;

///将字符串转换成日期
- (NSDate *)date;

///是否匹配某个正则表达式
- (BOOL)isRegularMatchString:(NSString *)regular;

@end

#pragma mark - NSDate

@interface NSDate (KN)

/**
 *  根据格式将日期转换成特定字符串
 *
 */
- (NSString *)dateWithFormatString:(NSString *)format;

@end

#pragma mark - KNAlertView

@interface KNAlertView : UIAlertView<UIAlertViewDelegate>

///点击回调
- (void)showUsingClickBlock:(void (^)(UIAlertView *alertView, NSInteger atIndex))block;
///将要消失的时候回调
- (void)showUsingWillDismissBlock:(void (^)(UIAlertView *alertView, NSInteger atIndex))block;
///正在消失的时候回调
- (void)showUsingDidDismissBlock:(void (^)(UIAlertView *alertView, NSInteger atIndex))block;
///点击、将要消失、正在消失回调
- (void)showUsingClickBlock:(void (^)(UIAlertView *alertView, NSInteger atIndex))clickBlock
            WillDismissBlock:(void (^)(UIAlertView *alertView, NSInteger atIndex))willDismissBlock
            DidDismissBlock:(void (^)(UIAlertView *alertView, NSInteger atIndex))didDismissBlock;
@end

#pragma mark - KNActionSheet

@interface KNActionSheet : UIActionSheet<UIActionSheetDelegate>

///点击回调
- (void)showInView:(UIView *)view usingClickBlock:(void (^)(UIActionSheet *actionSheet, NSInteger atIndex))block;
///将要消失的时候回调
- (void)showInView:(UIView *)view usingWillDismissBlock:(void (^)(UIActionSheet *actionSheet, NSInteger atIndex))block;
///正在消失的时候回调
- (void)showInView:(UIView *)view usingDidDismissBlock:(void (^)(UIActionSheet *actionSheet, NSInteger atIndex))block;
///点击、将要消失、正在消失回调
- (void)showInView:(UIView *)view usingClickBlock:(void (^)(UIActionSheet *actionSheet, NSInteger atIndex))clickBlock
           WillDismissBlock:(void (^)(UIActionSheet *actionSheet, NSInteger atIndex))willDismissBlock
            DidDismissBlock:(void (^)(UIActionSheet *actionSheet, NSInteger atIndex))didDismissBlock;

@end

#pragma mark - UIViewController

@interface UIViewController (KN)

///不全屏显示
- (UIRectEdge)edgesForExtendedLayout;

@end
