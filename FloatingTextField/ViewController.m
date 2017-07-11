//
//  ViewController.m
//  FloatingTextField
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2017/7/10.
//  Copyright © 2017年 WangChongyang. All rights reserved.
//

#import "ViewController.h"
#import "FloatingTextField.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet FloatingTextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTextField];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTextField {
    
    FloatingTextField *textField = [[FloatingTextField alloc]init];
    textField.borderInactiveColor = [UIColor redColor];
    textField.borderActiveColor = [UIColor greenColor];
    textField.placeholder = @"密码";
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.font = [UIFont systemFontOfSize:14];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:textField];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_textField attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_textField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_textField attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60]];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
