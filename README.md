# MEDToast

[![CI Status](https://img.shields.io/travis/shun/XSToast.svg?style=flat)](https://travis-ci.org/shun/XSToast)
[![Version](https://img.shields.io/cocoapods/v/XSToast.svg?style=flat)](https://cocoapods.org/pods/XSToast)
[![License](https://img.shields.io/cocoapods/l/XSToast.svg?style=flat)](https://cocoapods.org/pods/XSToast)
[![Platform](https://img.shields.io/cocoapods/p/XSToast.svg?style=flat)](https://cocoapods.org/pods/XSToast)

## 简介

请看效果
<video src="other/video.mp4"></video>

## 使用
1.设置全局rootView

```objective-c
#import <XSToast/XSToastTool.h>

[XSToastTool share].rootView = [UIApplication sharedApplication].keyWindow;//可以是其他的view
```

2.使用

```objective-c
#import <XSToast/XSToastTool.h>

[[XSToastTool share] showToast:@"你好啊" second:1];
```


## 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

MEDToast is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MEDToast'
```

## Author

xiangshun, 113648883@qq.cn

## License

MEDToast is available under the MIT license. See the LICENSE file for more info.
