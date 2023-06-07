//
//  UIImage+mtoast.m
//  MEDToast
//
//  Created by shun on 2022/11/10.
//

#import "UIImage+xstoast.h"
#import "XSToastTool.h"

@implementation UIImage (xstoast)

+ (nullable UIImage *)imageNamedMMToast:(NSString *)name {
    UIImage *img = [UIImage imageNamed:name inBundle:[self getMyBundle] compatibleWithTraitCollection:nil];
    return img;
}

+ (NSBundle *)getMyBundle {
    static NSBundle *rBundle = nil;
    if (!rBundle) {
        NSBundle *mainBundle = [NSBundle bundleForClass:[XSToastTool class]];
        NSString *path = [mainBundle pathForResource:@"XSToast" ofType:@"bundle"];
        rBundle = [NSBundle bundleWithPath:path]?:mainBundle;
    }
    return rBundle;
}


@end
