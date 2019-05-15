//
//  PEYRangeSlider.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/13.
//

#import "PEYRangeSlider.h"

static CGFloat const kSlideControlRadius = 24;

@interface PEYRangeSlideControl : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void (^moveAction)(UITouch *touch);

@end

@implementation PEYRangeSlideControl

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self addViews];
        [self makeConstraints];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image) {
        return;
    }
    CGSize contextSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, contextSize.width, contextSize.height) cornerRadius:contextSize.width/2.0];
    CGContextAddPath(context, roundPath.CGPath);
    CGContextClip(context);
    
    CGContextSetFillColorWithColor(context, HEXCOLOR(0x3399ff).CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, contextSize.width, contextSize.height));
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = result;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch && self.moveAction) {
        self.moveAction(touch);
    }
}

- (void)addViews
{
    [self addSubview:self.imageView];
}

- (void)makeConstraints
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end

@interface PEYRangeSlider()

/**
 背景线条视图
 */
@property (nonatomic, strong) UIView *lineView;

/**
 下界控制器
 */
@property (nonatomic, strong) PEYRangeSlideControl *minimunControl;

/**
 上界控制器
 */
@property (nonatomic, strong) PEYRangeSlideControl *maxmunControl;

@end

@implementation PEYRangeSlider

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self addViews];
        [self makeConstraints];
        [self addEvents];
    }
    return self;
}

- (void)addViews
{
    [self addSubview:self.lineView];
    [self addSubview:self.minimunControl];
    [self addSubview:self.maxmunControl];
}

- (void)makeConstraints
{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    [self.minimunControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(kSlideControlRadius));
    }];
    [self.maxmunControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(kSlideControlRadius));
    }];
}

- (void)addEvents
{
    __weak __typeof(&*self) weak_self = self;
    self.minimunControl.moveAction = ^(UITouch *touch) {
        __strong __typeof(&*weak_self) self = weak_self;
        CGPoint point = [touch locationInView:self];
        point.x = MIN(self.maxmunControl.center.x - kSlideControlRadius/2.0, point.x);
        point.x = MAX(kSlideControlRadius/2.0, point.x);
        self.minimunControl.center = CGPointMake(point.x, self.minimunControl.center.y);
        if (self.rangeSliderValueChanged) {
            self.rangeSliderValueChanged(self.minimunControl.center.x/self.frame.size.width, (self.maxmunControl.center.x - self.minimunControl.center.x)/self.frame.size.width);
        }
    };
    self.maxmunControl.moveAction = ^(UITouch *touch) {
        __strong __typeof(&*weak_self) self = weak_self;
        CGPoint point = [touch locationInView:self];
        point.x = MIN(self.frame.size.width - kSlideControlRadius/2.0, point.x);
        point.x = MAX(self.minimunControl.center.x + kSlideControlRadius/2.0, point.x);
        self.maxmunControl.center = CGPointMake(point.x, self.maxmunControl.center.y);
        if (self.rangeSliderValueChanged) {
            self.rangeSliderValueChanged(self.minimunControl.center.x/self.frame.size.width, (self.maxmunControl.center.x - self.minimunControl.center.x)/self.frame.size.width);
        }
    };
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = HEXCOLOR(0x555555);
    }
    return _lineView;
}

- (PEYRangeSlideControl *)minimunControl
{
    if (!_minimunControl) {
        _minimunControl = [PEYRangeSlideControl new];
    }
    return _minimunControl;
}

- (PEYRangeSlideControl *)maxmunControl
{
    if (!_maxmunControl) {
        _maxmunControl = [PEYRangeSlideControl new];
    }
    return _maxmunControl;
}

@end
