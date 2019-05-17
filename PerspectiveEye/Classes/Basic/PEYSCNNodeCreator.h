//
//  PEYSCNNodeCreator.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/7.
//
// 依据 UIView 对象，生成对应的 SCNNode，可以配置相关属性以控制 SCNNode

#import <Foundation/Foundation.h>
#import "PEYViewElement.h"
#import "PEYNodeSemanticNameManager.h"

typedef NS_ENUM(NSUInteger, PEVNodeGroupHeaderType) {
    PEVNodeGroupHeaderTypeSelf, // 当前选中的 view
    PEVNodeGroupHeaderTypeParentView, // 当前选中 view 的父视图
    PEVNodeGroupHeaderTypeRelativeView, // 与当前选中 view 有约束关系的 view
};

NS_ASSUME_NONNULL_BEGIN

@interface PEYSCNNodeCreator : NSObject

@property (nonatomic, strong, readonly) PEYNodeSemanticNameManager *semanticManager;

/**
 元素间距
 */
@property (nonatomic, assign, readonly) CGFloat spacing;

/**
 根据header类型获取主题色

 @param headerType header类型
 @return 对应的主题色
 */
- (UIColor *)colorForHeaderType:(PEVNodeGroupHeaderType)headerType;

/**
 构建 groupNode，作为基准 node，确定一个 view 衍生出的边框、header、内容区等 node 的父 node

 @param viewElement view 元素
 @param rootNode 根节点
 @param parentViewElement 父视图元素
 @param parentSCNNode 父视图元素对应的 GroupNode
 @param depth 当前 node 的深度
 @return groupNode
 */
- (SCNNode *)makeGroupNodeWithElement:(PEYViewElement *)viewElement rootNode:(SCNNode *)rootNode parentViewElement:(PEYViewElement *)parentViewElement parentSCNNode:(SCNNode *)parentSCNNode depth:(CGFloat)depth;

/**
 构建 elementNode，作为内容节点，展示 view 视图的截图

 @param viewElement view 元素
 @param groupNode 内容节点所属的 groupNode
 @return 返回 elementNode
 */
- (SCNNode *)makeElementNodeWithElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode;

/**
 构建边框节点

 @param viewElement view 元素
 @param groupNode 所属的 groupNode
 @param highlight 是否高亮
 @return 返回 boardNode
 */
- (SCNNode *)makeBoardWithViewElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode highlight:(BOOL)highlight;

/**
 构建 header 节点

 @param viewElement 所属的视图元素
 @param groupNode 所属的 groupNode
 @return 返回 headerNode
 */
- (SCNNode *)makeTitleWithViewElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode bgColor:(UIColor *)bgColor;

/**
 构建高亮蒙层节点

 @param viewElement 所属的视图元素
 @param groupNode 所属的 groupNode
 @return 返回 highlightNode
 */
- (SCNNode *)makeHighlightNodeWithViewElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode;

@end

NS_ASSUME_NONNULL_END
