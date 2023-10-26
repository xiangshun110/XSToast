//
//  TDToastManager.m
//  talkmedmetting
//
//  Created by shun on 2021/7/30.
//  Copyright © 2021 edoctor. All rights reserved.
//

#import "XSToastTool.h"
#import "XSToastOperation.h"
#import "UIImage+xstoast.h"

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface XSToastTool ()

@property (nonatomic, strong) NSOperationQueue  *queue1;

@property (nonatomic, strong) MBProgressHUD     *singleHud;

@property (nonatomic, strong) MBProgressHUD     *singleToast;

@property (nonatomic, assign) CGRect            keyboardEndFrame;

@property (nonatomic, assign) XSToastPosition   position;


@end

@implementation XSToastTool

+ (instancetype)share
{
    static XSToastTool *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XSToastTool alloc] init];
        [manager initOther];
    });
    return manager;
}


- (void)initOther {
    self.keyboardEndFrame = CGRectZero;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardBeginFrame;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    self.keyboardEndFrame = keyboardEndFrame;

//    CGFloat offsetHeight = [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.origin.y ;
//    offsetHeight = offsetHeight > 0 ? offsetHeight : 0;
//
//    NSLog(@"willShowNotification : %f\n, keyboardBeginFrame = %@\n,keyboardEndFrame = %@", offsetHeight,NSStringFromCGRect(keyboardBeginFrame),NSStringFromCGRect(keyboardEndFrame));
    
}

- (void)keyboardDidHide:(NSNotification *)noti {
    self.keyboardEndFrame = CGRectZero;
}

- (void)setRootView:(UIView *)rootView {
    _rootView = rootView;
}


- (BOOL)checkRootView {
//    NSAssert(self.rootView, @"root view is nil");
    if (self.rootView) return YES;
    NSLog(@"rootView is null, please set [TDToastManager sharedManager].rootView");
    return NO;
}

- (void)setGlobalPosition:(XSToastPosition)position {
    self.position = position;
}

- (void)showToast:(NSString *_Nullable)msg second:(int)second {
    if (![self checkRootView]) return;
    XSToastOperation *op = [XSToastOperation showToast:msg second:second keyboardEndFrame:self.keyboardEndFrame];
    op.position = self.position;
    op.rootView = self.rootView;
    [self.queue1 addOperation:op];
}

- (void)showToast:(NSString *_Nullable)msg {
    int second = 2;
    if (msg.length < 10) {
        second = 2;
    } else if (msg.length >=10 && msg.length < 20) {
        second = 3;
    } else if (msg.length >=20 && msg.length < 30) {
        second = 4;
    } else if (msg.length >=30 && msg.length < 40) {
        second = 5;
    } else {
        second = 6;
    }
    [self showToast:msg second:second];
}

- (void)showSingleToast:(NSString *_Nullable)msg second:(int)second {
    if (![self checkRootView]) return;
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.singleToast) {
            [self.singleToast hideAnimated:NO];
            self.singleToast = nil;
        }
        
        UIView *view = self.rootView;
        if (!view) return;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.label.numberOfLines = 0;
        hud.label.text = msg;

        hud.contentColor = [UIColor whiteColor];
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.backgroundView.color = [UIColor darkGrayColor];
        
        //背景
    //    hud.bezelView.color = [UIColor whiteColor];
        hud.bezelView.color = rgb(30, 30, 30);
        hud.bezelView.layer.borderColor = rgb(170, 170, 170).CGColor;
        hud.bezelView.layer.borderWidth = 0.5;
    //    hud.bezelView.alpha = 0.9;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        //阴影
        hud.layer.shadowColor = [UIColor blackColor].CGColor;
        hud.layer.shadowOffset = CGSizeMake(0, 0);
        hud.layer.shadowOpacity = 0.5;
        hud.layer.shadowRadius = 6;
        
        hud.margin = 15.0;
        hud.bezelView.layer.cornerRadius = 6;
        hud.removeFromSuperViewOnHide = YES;
        
        hud.userInteractionEnabled = NO;
        
        //        hud.offset = CGPointMake(0.f, 0);// 0-是正中央
        //计算自己的高度
        float msgHeight =  [self heightWithFont:hud.label.font width:[UIScreen mainScreen].bounds.size.width - hud.margin * 2 msg:msg];
        msgHeight += hud.margin * 2; //margin
        
        
        float offsetY = view.frame.size.height / 2;
        
        if (self.keyboardEndFrame.origin.y > 0) {
            offsetY = self.keyboardEndFrame.origin.y - offsetY - msgHeight;
        } else {
            if (@available(iOS 11.0, *)) {
                offsetY -= view.safeAreaInsets.bottom;
            }
            offsetY -= msgHeight;
        }
       
        hud.offset = CGPointMake(0.f, offsetY);
        
        [hud hideAnimated:YES afterDelay:second];
        
        
        hud.completionBlock = ^{
            weakSelf.singleToast = nil;
        };
        
        self.singleToast = hud;
    });
}


- (NSOperationQueue *)queue1
{
    if (_queue1 == nil) {
        _queue1 = [[NSOperationQueue alloc] init];
        _queue1.maxConcurrentOperationCount = 1;
    }
    return _queue1;
}

- (void)removeSingleLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.singleHud) {
            [self.singleHud hideAnimated:YES];
            self.singleHud = nil;
        }
    });
}

- (void)showSuccess:(NSString *)msg {
    [self showToastWithType:1 msg:msg];
}

- (void)showError:(NSString *)msg {
    [self showToastWithType:2 msg:msg];
}

- (void)showSingleLoading:(NSString *_Nullable)msg view:(UIView *)view; {
    if (!view) return;
    if (self.singleHud) {
        [self removeSingleLoading];
    }
    _singleHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _singleHud.mode = MBProgressHUDModeIndeterminate;
//    _singleHud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
//    _singleHud.bezelView.color = [UIColor blackColor];
    
    _singleHud.bezelView.color = rgba(16, 16, 16, 0.7);
    _singleHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    _singleHud.contentColor = [UIColor whiteColor];
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    if (msg) {
        _singleHud.label.text = msg;
    }
    _singleHud.removeFromSuperViewOnHide = YES;
    _singleHud.userInteractionEnabled = NO;
}


- (void)showToastWithType:(int)type msg:(NSString *)msg {
    if (![self checkRootView]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.singleHud) {
            [self removeSingleLoading];
        }
//        iOSApplicationExtension NS_EXTENSION_UNAVAILABLE_IOS
//        if @available(iOSApplicationExtension, unavailable) {
//
//        }
        
        
//        NS_EXTENSION_UNAVAILABLE_IOS
        UIView *view = self.rootView;
//        if (@available(iOSApplicationExtension 11.0, *)) {
//            view = [UIApplication sharedApplication].keyWindow;
//        }
        
        if (!view) return;

        self.singleHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        self.singleHud.label.numberOfLines = 0;
        self.singleHud.mode = MBProgressHUDModeCustomView;
        self.singleHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    singleHud.bezelView.color = [UIColor blackColor];
        self.singleHud.bezelView.backgroundColor = [UIColor blackColor];
        self.singleHud.contentColor = [UIColor whiteColor];
        if (msg) {
            self.singleHud.label.text = msg;
        }
        
    //    singleHud.label.text = @"打大山里的喀什；反馈；SDK放了；水电费卡死了；待付款；塑料袋付款；塑料袋快疯了；SDK放了；SDK放了；上岛咖啡；上岛咖啡；塑料袋付款；收到反馈了；水电费可；塑料袋付款是";
        self.singleHud.removeFromSuperViewOnHide = YES;
    //    singleHud.userInteractionEnabled = NO;
        
        UIImage *icon = nil;
        switch (type) {
            case 2:
                icon = [UIImage imageNamedMMToast:@"error"];
                break;
            default:
                icon = [UIImage imageNamedMMToast:@"success"];
                break;
        }
        
        self.singleHud.customView = [[UIImageView alloc] initWithImage:icon];
    //    singleHud.square = YES;
        
        __weak __typeof(self) weakSelf = self;
        self.singleHud.completionBlock = ^{
            weakSelf.singleHud = nil;
        };
        
        [self.singleHud hideAnimated:YES afterDelay:2];
    });
}


- (MBProgressHUD *)showLoading:(NSString *_Nullable)msg view:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
//    hud.bezelView.color = [UIColor blackColor];
    
    hud.bezelView.color = rgba(16, 16, 16, 0.7);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    
    hud.contentColor = [UIColor whiteColor];
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    if (msg) {
        hud.label.text = msg;
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    return hud;
}



- (MBProgressHUD *)showProgress:(NSString *_Nullable)msg view:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
//    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
//    hud.bezelView.color = [UIColor blackColor];
    
    hud.bezelView.color = rgba(16, 16, 16, 0.7);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.contentColor = [UIColor whiteColor];
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    if (msg) {
        hud.label.text = msg;
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    return hud;
}




- (CGFloat)heightWithFont:(UIFont *)font width:(float)width msg:(NSString *)msg {
    CGRect size = [msg boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{
                                                NSFontAttributeName:font
                                            }
                                            context:nil
    ];
    return size.size.height + 1;
}

@end
