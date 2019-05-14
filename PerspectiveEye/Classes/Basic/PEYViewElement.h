//
//  PEYViewElement.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PEYViewElement : NSObject

/**
 视图节点名称
 */
@property (nonatomic, strong) NSString *nodeName;

/**
 视图节点的frame
 */
@property (nonatomic, assign) CGRect frame;

/**
 视图节点的截图
 */
@property (nonatomic, assign) CGImageRef snapShotImage;

/**
 视图节点的子视图节点集合
 */
@property (nonatomic, copy) NSArray<PEYViewElement *> *subElements;

/**
 视图节点对应的 UIView
 */
@property (nonatomic, weak) UIView *targetView;

/**
 节点唯一标识
 */
@property (nonatomic, strong) NSString *elementIdentifier;

/**
 节点描述信息
 */
@property (nonatomic, strong) NSString *elementDescrption;

- (instancetype)initWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
