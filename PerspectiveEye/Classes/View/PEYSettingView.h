//
//  PEYSettingView.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/16.
//
// 设置面板视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PEYSettingOptions) {
    PEYSettingOptionsOnlyWireframe,
    PEYSettingOptionsShowConstraints
};

@interface PEYSettingItem : NSObject

@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) PEYSettingOptions option;

@end

@interface PEYSettingView : UIView

/**
 设置面板高度

 @return 浮点高度
 */
- (CGFloat)viewHeight;

/**
 设置更新回调
 */
@property (nonatomic, copy) void (^settingUpdateBlock)(PEYSettingItem *item);

@end

NS_ASSUME_NONNULL_END
