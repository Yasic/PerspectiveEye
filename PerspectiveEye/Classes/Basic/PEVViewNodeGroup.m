//
//  PEVViewNodeGroup.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/13.
//

#import "PEVViewNodeGroup.h"

@implementation PEVViewNodeGroup

- (instancetype)initWithViewElement:(PEYViewElement *)viewElement
{
    self = [super init];
    if (self){
        self.viewElement = viewElement;
    }
    return self;
}

- (instancetype)initWithViewElement:(PEYViewElement *)viewElement creator:(PEYSCNNodeCreator *)creator
{
    self = [self initWithViewElement:viewElement];
    if (self) {
        self.creator = creator;
    }
    return self;
}

- (NSString *)elementIdentifier
{
    return self.viewElement.elementIdentifier ?: @"";
}

- (void)setIsHighlight:(BOOL)isHighlight
{
    _isHighlight = isHighlight;
    if (!self.creator) {
        return;
    }
    [self.boardNode removeFromParentNode];
    self.boardNode = [self.creator makeBoardWithViewElement:self.viewElement groupNode:self.groupNode highlight:isHighlight];
    if (!isHighlight) {
        [self.highlightNode removeFromParentNode];
    } else {
        self.highlightNode = [self.creator makeHighlightNodeWithViewElement:self.viewElement groupNode:self.groupNode];
    }
}

- (void)setOnlyWireframe:(BOOL)onlyWireframe
{
    _onlyWireframe = onlyWireframe;
    self.elementNode.hidden = onlyWireframe;
}

- (void)setShowHeaderInfo:(BOOL)showHeaderInfo
{
    _showHeaderInfo = showHeaderInfo;
    self.headerNode.hidden = !showHeaderInfo;
}

- (CGFloat)renderToScene:(SCNScene *)scene parentNode:(PEYViewElement *)parentViewElement nodeGroupMap:(NSMutableDictionary *)nodeGroupMap depth:(CGFloat)depth
{
    if (!self.creator) {
        return 0.0f;
    }
    SCNNode *parentSCNNode = nil;
    if ([nodeGroupMap[parentViewElement.elementIdentifier] isKindOfClass:[PEVViewNodeGroup class]]) {
        parentSCNNode = ((PEVViewNodeGroup *)nodeGroupMap[parentViewElement.elementIdentifier]).groupNode;
    }
    __block CGFloat maxDepth = depth;
    __block CGFloat currentDeepestDepth = depth;
    NSMutableArray *frameCache = [NSMutableArray array];
    
    self.groupNode = [self.creator makeGroupNodeWithElement:self.viewElement rootNode:scene.rootNode parentViewElement:parentViewElement parentSCNNode:parentSCNNode depth:depth];
    self.nodeDepth = depth;
    self.elementNode = [self.creator makeElementNodeWithElement:self.viewElement groupNode:self.groupNode];
    self.boardNode = [self.creator makeBoardWithViewElement:self.viewElement groupNode:self.groupNode highlight:self.isHighlight];
    self.headerNode = [self.creator makeTitleWithViewElement:self.viewElement groupNode:self.groupNode];
    // header 默认关闭
    self.headerNode.hidden = YES;
    [nodeGroupMap setObject:self forKey:self.viewElement.elementIdentifier];
    
    [self.viewElement.subElements enumerateObjectsUsingBlock:^(PEYViewElement * _Nonnull subElement, NSUInteger idx, BOOL * _Nonnull stop) {
        PEVViewNodeGroup *group = [[PEVViewNodeGroup alloc] initWithViewElement:subElement creator:self.creator];
        if ([frameCache pey_filter:^BOOL(NSValue *frameValue, NSUInteger frameIdx) {
            return CGRectIntersectsRect(subElement.frame, frameValue.CGRectValue);
        }].count > 0) { // 当前 node 与其他 node 有重叠，需要错开深度
            currentDeepestDepth = [group renderToScene:scene parentNode:self.viewElement nodeGroupMap:nodeGroupMap depth:maxDepth + 1];
        } else { // 各个 node 无重叠，可以在同一级展示
            currentDeepestDepth = [group renderToScene:scene parentNode:self.viewElement nodeGroupMap:nodeGroupMap depth:depth + 1];
        };
        maxDepth = MAX(maxDepth, currentDeepestDepth);
        [frameCache addObject:[NSValue valueWithCGRect:subElement.frame]];
    }];
    return maxDepth;
}

@end
