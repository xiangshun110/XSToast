//
//  TDToastOperation.m
//  talkmedmetting
//
//  Created by shun on 2021/7/30.
//  Copyright © 2021 edoctor. All rights reserved.
//

#import "XSToastOperation.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface XSToastOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic,strong) NSString    *msg;
@property (nonatomic,assign) int         second;

@property (nonatomic, assign) CGRect            keyboardEndFrame;

@end

@implementation XSToastOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)showToast:(NSString *_Nullable)msg second:(int)second keyboardEndFrame:(CGRect)keyboardEndFrame {
    XSToastOperation *op = [[XSToastOperation alloc] init];
    op.msg = msg;
    op.second = second;
    op.keyboardEndFrame = keyboardEndFrame;
    return op;
}

- (void)dealloc {
    NSLog(@"-----------dealloc TDToastOperation:%@",self);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (void)start {
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    
    @autoreleasepool {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf makeToast];
        });
    }
}

- (void)makeToast {
    UIView *view = self.rootView;
    if (!view) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.numberOfLines = 0;
    hud.label.text = self.msg;
    hud.label.numberOfLines = 0;
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
//    hud.offset = CGPointMake(0.f, [UIApplication sharedApplication].keyWindow.frame.size.height / 3);
    
//    hud.contentColor = [UIColor blackColor];
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
    __weak __typeof(self) weakSelf = self;
    
    
    //计算自己的高度
    float msgHeight =  [self heightWithFont:hud.label.font width:[UIScreen mainScreen].bounds.size.width - hud.margin * 2 msg:self.msg];
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
    
    hud.completionBlock = ^{
        weakSelf.executing = NO;
        weakSelf.finished = YES;
    };
    
    [hud hideAnimated:YES afterDelay:self.second];
    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.second * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        //[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        [hud hideAnimated:YES];
//        weakSelf.executing = NO;
//        weakSelf.finished = YES;
//    });
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


#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
