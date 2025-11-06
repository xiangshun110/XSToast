//
//  XSToastConstant.h
//  XSToast
//
//  Created by shun on 2023/10/26.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIView XSView;
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
typedef NSView XSView;
#endif

typedef enum : NSUInteger {
    XSToastPositionBottom,
    XSToastPositionCenter,
    XSToastPositionTop
} XSToastPosition;


