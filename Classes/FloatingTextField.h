//
//  FloatingTextField.h
//  FloatingTextField
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 16/9/12.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingTextField : UITextField

@property (strong,nonatomic)UIColor *borderInactiveColor;

@property (strong,nonatomic)UIColor *borderActiveColor;

@property (strong,nonatomic)UIColor *placeholderColor;

// for override
- (void)animateViewsForTextChange;

@end
