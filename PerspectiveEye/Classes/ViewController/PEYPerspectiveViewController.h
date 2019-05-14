//
//  PEYPerspectiveViewController.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import <UIKit/UIKit.h>
#import "PEYPerspectiveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PEYPerspectiveViewController : UIViewController

@property (nonatomic, strong, readonly) PEYPerspectiveView *persView;

- (instancetype)initWithTargetView:(UIView *)targetView;

@end

NS_ASSUME_NONNULL_END
