//
//  PEVViewNodeGroup.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/13.
//

#import <Foundation/Foundation.h>
#import "PEYViewElement.h"
#import "PEYSCNNodeCreator.h"

NS_ASSUME_NONNULL_BEGIN

@interface PEVViewNodeGroup : NSObject

/**
 节点对应的 viewElement
 */
@property (nonatomic, strong) PEYViewElement *viewElement;


/**
 整个 element 组的 SCNNode
 */
@property (nonatomic, strong) SCNNode *groupNode;

/**
 viewElement 对应的 SCNNode
 */
@property (nonatomic, strong) SCNNode *elementNode;

/**
 viewElement 的边框 node
 */
@property (nonatomic, strong) SCNNode *boardNode;

/**
 viewElement 的 header node
 */
@property (nonatomic, strong) SCNNode *headerNode;

/**
 viewElement 唯一标识
 */
@property (nonatomic, strong) NSString *elementIdentifier;

/**
 是否高亮选中
 */
@property (nonatomic, assign) BOOL isHighlight;

/**
 仅展示边框
 */
@property (nonatomic, assign) BOOL onlyWireframe;

/**
 是否展示header
 */
@property (nonatomic, assign) BOOL showHeaderInfo;

/**
 构造器
 */
@property (nonatomic, strong) PEYSCNNodeCreator *creator;

/**
 节点深度
 */
@property (nonatomic, assign) CGFloat nodeDepth;

/**
 高亮蒙层节点
 */
@property (nonatomic, strong) SCNNode *highlightNode;

- (instancetype)initWithViewElement:(PEYViewElement *)viewElement creator:(PEYSCNNodeCreator *)creator;

- (CGFloat)renderToScene:(SCNScene *)scene parentNode:(nullable PEYViewElement *)parentViewElement nodeGroupMap:(NSMutableDictionary *)nodeGroupMap depth:(CGFloat)depth;

- (void)showHeaderWithType:(PEVNodeGroupHeaderType)headerType;

@end

NS_ASSUME_NONNULL_END
