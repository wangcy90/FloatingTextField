//
//  FloatingTextField.m
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

#import "FloatingTextField.h"

@interface FloatingTextField ()

@property (strong,nonatomic)CALayer *borderLayer;

@property (strong,nonatomic)UILabel *placeholderLabel;

@property (nonatomic)CGPoint activePlaceholderPoint;

@property (nonatomic,assign)BOOL isActive;

@property (nonatomic,assign)BOOL drew;

@end

@implementation FloatingTextField

static CGFloat const inactiveBorderThickness = 0.7;
static CGFloat const activeBorderThickness = 2;
static CGPoint const textFieldInsets = {0, 10};
static CGPoint const placeholderInsets = {0, 6};

#pragma mark - lifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    
    self.activePlaceholderPoint = CGPointZero;
    
    self.borderInactiveColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    
    self.borderActiveColor = [UIColor colorWithRed:0.25 green:0.61 blue:0.97 alpha:1.00];
    
    self.placeholderColor = self.borderInactiveColor;
    
    self.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    
    if (self.drew) return;
    
    self.drew = YES;
    
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    self.placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y);
    
    self.placeholderLabel.font = self.font;
    
    [self updateBorderWithActive:NO];
    
    [self updatePlaceholder];
    
    [self.layer addSublayer:self.borderLayer];
    
    [self addSubview:self.placeholderLabel];
    
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    // Don't draw any placeholders.
}

- (void)updateBorderWithActive:(BOOL)isActive {
    
    self.borderLayer.frame = [self rectForBorderThickness:isActive ? activeBorderThickness : inactiveBorderThickness];

    self.borderLayer.backgroundColor = isActive ? self.borderActiveColor.CGColor : self.borderInactiveColor.CGColor;
}

- (void)updatePlaceholder {
    
    self.placeholderLabel.text = self.placeholder;
    
    self.placeholderLabel.textColor = self.placeholderColor;
    
    [self.placeholderLabel sizeToFit];
    
    [self layoutPlaceholderInTextRect];

}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

#pragma mark - Notification

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateViewsForTextChange) name:UITextFieldTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateViewsForTextEndEditing) name:UITextFieldTextDidEndEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateViewsForTextBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];
    }
}

- (void)animateViewsForTextChange {
    
    if (self.text.length == 0) {
        
        self.isActive = NO;
        
        self.placeholderLabel.font = self.font;
        
        [UIView animateWithDuration:0.45 animations:^{
            
            [self layoutPlaceholderInTextRect];
            
            self.placeholderLabel.alpha = 1.0;
            
            self.placeholderLabel.textColor = self.placeholderColor;
            
        }];
        
    }else {
        
        if (!self.isActive) {
            
            self.isActive = YES;
            
            self.placeholderLabel.alpha = 0;
            
            self.placeholderLabel.font = [UIFont boldSystemFontOfSize:self.font.pointSize];
            
            [self.placeholderLabel sizeToFit];
            
            [UIView animateWithDuration:0.45 animations:^{
                
                self.placeholderLabel.frame = CGRectMake(self.activePlaceholderPoint.x, self.activePlaceholderPoint.y, CGRectGetWidth(self.placeholderLabel.bounds), CGRectGetHeight(self.placeholderLabel.bounds));
                
                self.placeholderLabel.alpha = 1.0;
                
                self.placeholderLabel.textColor = self.borderActiveColor;
                
            }];
            
        }
        
    }
    
}

- (void)animateViewsForTextBeginEditing {
    if (self.text.length) {
        self.placeholderLabel.textColor = self.borderActiveColor;
    }
    [self updateBorderWithActive:YES];
}

- (void)animateViewsForTextEndEditing {
    self.placeholderLabel.textColor = self.placeholderColor;
    [self updateBorderWithActive:NO];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            CGRect frame = view.frame;
            frame.origin.y = self.placeholderLabel.frame.origin.y + self.placeholderLabel.frame.size.height + placeholderInsets.y;
            view.frame = frame;
            break;
        }
    }
}

- (CGRect)rectForBorderThickness:(CGFloat)thickness {
    return CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
}

- (void)layoutPlaceholderInTextRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGFloat originX = textRect.origin.x;
    
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
            originX += textRect.size.width/2 - self.placeholderLabel.bounds.size.width/2;
            break;
        case NSTextAlignmentRight:
            originX += textRect.size.width - self.placeholderLabel.bounds.size.width;
            break;
        default:
            break;
    }
    
    self.placeholderLabel.frame = CGRectMake(originX, textRect.size.height/2, CGRectGetWidth(self.placeholderLabel.bounds), CGRectGetHeight(self.placeholderLabel.bounds));
    
    self.activePlaceholderPoint = CGPointMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y - self.placeholderLabel.frame.size.height - placeholderInsets.y);
    
}

#pragma mark - setters

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    
    _borderInactiveColor = borderInactiveColor;
    
    [self updateBorderWithActive:NO];
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    
    _borderActiveColor = borderActiveColor;
    
    [self updateBorderWithActive:NO];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    [super setPlaceholder:placeholder];
    
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    
    [super setBounds:bounds];
    
    [self updateBorderWithActive:NO];
    
    [self updatePlaceholder];
}

#pragma mark - getters

- (CALayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [[CALayer alloc]init];
    }
    return _borderLayer;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
    }
    return _placeholderLabel;
}

- (id<UITextFieldDelegate>)delegate {
    [self animateViewsForTextChange];
    [self animateViewsForTextEndEditing];
    return [super delegate];
}

@end
