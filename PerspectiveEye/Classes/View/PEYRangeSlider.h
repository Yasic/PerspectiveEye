//
//  PEYRangeSlider.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PEYRangeSlider : UIView

/**
 区间值变化回调
 */
@property (nonatomic, copy) void (^rangeSliderValueChanged)(CGFloat location, CGFloat length);

@end

NS_ASSUME_NONNULL_END
