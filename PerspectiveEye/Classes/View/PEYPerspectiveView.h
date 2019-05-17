//
//  PEYPerspectiveView.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import <UIKit/UIKit.h>
#import "PEYViewElement.h"

NS_ASSUME_NONNULL_BEGIN

@interface PEYPerspectiveView : UIView

/**
 透视视图根节点
 */
@property (nonatomic, strong) PEYViewElement *rootElement;

- (instancetype)initWithViewElement:(PEYViewElement *)viewElement;

- (void)onlyWireframe:(BOOL)isOn;
- (void)showConstrants:(BOOL)isOn;
- (void)showHeader:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_END
