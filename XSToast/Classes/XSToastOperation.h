//
//  TDToastOperation.h
//  talkmedmetting
//
//  Created by shun on 2021/7/30.
//  Copyright © 2021 edoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSToastOperation : NSOperation

@property (nonatomic, weak) UIView *rootView;

+ (instancetype)showToast:(NSString *_Nullable)msg second:(int)second keyboardEndFrame:(CGRect)keyboardEndFrame;

@end

NS_ASSUME_NONNULL_END
