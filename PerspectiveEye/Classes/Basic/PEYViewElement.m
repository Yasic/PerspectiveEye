//
//  PEYViewElement.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "PEYViewElement.h"

@interface PEYViewElement()

@end

@implementation PEYViewElement

- (instancetype)initWithView:(UIView *)view
{
    self = [self init];
    if (self) {
        self.targetView = view;
    }
    return self;
}

- (NSString *)nodeName
{
    if (!self.targetView) {
        return @"";
    }
    if ([self neareastViewController:self.targetView].view == self.targetView) {
        return [[[self neareastViewController:self.targetView] class] description];
    }
    return [[self.targetView class] description];
}

- (CGRect)frame
{
    if ([self.targetView.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.targetView.superview;
        return CGRectOffset(self.targetView.frame, -scrollView.contentOffset.x, -scrollView.contentOffset.y);
    }
    return self.targetView.frame;
}

/**
 元素的截图

 @return 返回当前元素的截图
 */
- (CGImageRef)snapShotImage
{
    if ([self.targetView.superview isKindOfClass:[UIVisualEffectView class]] && self.targetView.superview.subviews.firstObject == self.targetView) {
        _snapShotImage = [self snapShotImageForVisualEffectBackdropView:self.targetView];
        return _snapShotImage;
    }
    NSMutableArray *hiddenSubView = [NSMutableArray array];
    [self.targetView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![subView isKindOfClass:NSClassFromString(@"PEYPerspectiveView")]) {
            [hiddenSubView addObject:@(subView.hidden)];
            subView.hidden = YES;
        }
    }];
    CGImageRef res = [self drawImage:self.targetView];
    [self.targetView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![subView isKindOfClass:NSClassFromString(@"PEYPerspectiveView")]) {
            if (idx >= hiddenSubView.count) {
                *stop = YES;
                return;
            }
            subView.hidden = ((NSNumber *)hiddenSubView[idx]).boolValue;
        }
    }];
    _snapShotImage = res;
    return _snapShotImage;
}

/**
 针对 VisualEffectBackdropView 特殊处理截图

 @param bdView VisualEffectBackdropView 对象
 @return 返回 VisualEffectBackdropView 对象的截图
 */
- (CGImageRef)snapShotImageForVisualEffectBackdropView:(UIView *)bdView
{
    UIView *window = bdView.window;
    if (!window) {
        return nil;
    }
    CGImageRef cropImage = [UIImage new].CGImage;
    NSMutableArray *hiddenSubView = [NSMutableArray array];
    if ([self hideViewsBeforeView:bdView rootView:window hiddenSubView:hiddenSubView]) {
        CGImageRef res = [self drawImage:window];
        CGRect cropRect = [window convertRect:bdView.bounds toView:window];
        cropImage = CGImageCreateWithImageInRect(res, cropRect);
    }
    [hiddenSubView enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.hidden = NO;
    }];
    return cropImage;
}

- (BOOL)hideViewsBeforeView:(UIView *)targetView rootView:(UIView *)rootView hiddenSubView:(NSMutableArray *)hiddenSubView
{
    if (targetView == rootView) {
        return YES;
    }
    __block BOOL foundView = NO;
    [[rootView.subviews.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self hideViewsBeforeView:targetView rootView:subView hiddenSubView:hiddenSubView]) {
            foundView = YES;
            *stop = YES;
        }
    }];
    if (!foundView) {
        if (!rootView.hidden) { // 在targetView之上的未隐藏的view都需要隐藏
            [hiddenSubView addObject:rootView];
            rootView.hidden = YES;
        }
    }
    return foundView;
}

- (CGImageRef)drawImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res.CGImage;
}

- (NSArray<PEYViewElement *> *)subElements
{
    return [[self.targetView.subviews pey_filter:^BOOL(UIView *subView, NSUInteger idx) {
        return !([subView isKindOfClass:NSClassFromString(@"PEYPerspectiveView")])
        && !subView.isHidden
        && subView.frame.size.width > 0
        && subView.frame.size.height > 0
        && ![[self neareastViewController:subView] isKindOfClass:NSClassFromString(@"PEYPerspectiveViewController")];
    }] pey_map:^id _Nonnull(UIView *subView, NSUInteger idx) {
        return [[PEYViewElement alloc] initWithView:subView];
    }];
}

/**
 当前view所属的 UIViewController

 @param responder 当前 view
 @return 返回 UIViewController 或 nil
 */
- (UIViewController *)neareastViewController:(UIResponder *)responder
{
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    if (responder.nextResponder) {
        [self neareastViewController:responder.nextResponder];
    }
    return nil;
}

- (NSString *)elementIdentifier
{
    if (!_elementIdentifier) {
        _elementIdentifier = [[NSUUID UUID] UUIDString];
    }
    return _elementIdentifier;
}

- (NSString *)elementDescrption
{
    return [NSString stringWithFormat:@"%@:%p (%.1f, %.1f, %.1f, %.1f)", self.targetView.class, self.targetView, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height];
}

@end
