//
//  PEYConstraintsView.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/15.
//

#import <UIKit/UIKit.h>
#import "PEYSCNNodeCreator.h"

NS_ASSUME_NONNULL_BEGIN

@interface PEYConstraintsView : UIView

/**
 需要解析展示约束关系的目标视图
 */
@property (nonatomic, strong) UIView *targetView;

@property (nonatomic, strong) PEYSCNNodeCreator *creator;

@end

NS_ASSUME_NONNULL_END
