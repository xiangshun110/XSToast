//
//  TDToastManager.h
//  talkmedmetting
//
//  Created by shun on 2021/7/30.
//  Copyright © 2021 edoctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>


//#define showToast(msg)          [[TDToastManager sharedManager] showToast:msg second:2]
//#define showSingleToast(msg)    [[TDToastManager sharedManager] showSingleToast:msg second:2]
//#define showSuccess(msg)        [[TDToastManager sharedManager] showSuccess:msg]
//#define showError(msg)          [[TDToastManager sharedManager] showError:msg]

NS_ASSUME_NONNULL_BEGIN

@interface XSToastTool : NSObject


/// toast在这个上面
@property (nonatomic, weak) UIView *rootView;

/// 单例
+ (instancetype)share;


/// 显示一个toast，消失时间根据msg长度计算，最多6秒
/// @param msg 内容
- (void)showToast:(NSString *_Nullable)msg;


/// 显示一个toast
/// @param msg 内容
/// @param second 几秒后自动消失
- (void)showToast:(NSString *_Nullable)msg second:(int)second;


/// 跟showToast区别就是，如果上个toast没有消失，会先消除上一个
/// @param msg 内容
/// @param second 几秒后自动消失
- (void)showSingleToast:(NSString *_Nullable)msg second:(int)second;


/// 成功，带图标
/// @param msg 消息
- (void)showSuccess:(NSString * _Nullable)msg;

/// 失败，带图标
/// @param msg 消息
- (void)showError:(NSString * _Nullable)msg;

/// 显示一个单例loading
/// @param msg 消息
/// @param view 父视图
- (void)showSingleLoading:(NSString *_Nullable)msg view:(UIView *)view;

/// 移除一个单例loading
- (void)removeSingleLoading;


/// 显示一个lading
/// @param msg 文字
/// @param view 父视图
- (MBProgressHUD *)showLoading:(NSString *_Nullable)msg view:(UIView *)view;


///  显示一个圆形进度
/// @param msg 消息
/// @param view 父视图
- (MBProgressHUD *)showProgress:(NSString *_Nullable)msg view:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
