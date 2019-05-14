//
//  PEYSCNNodeCreator.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/7.
//

#import "PEYSCNNodeCreator.h"

@interface PEYSCNNodeCreator()

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat smallZOffset;
@property (nonatomic, strong) UIColor *boardNormalColor;
@property (nonatomic, strong) UIColor *boardHighlightColor;
@property (nonatomic, assign) CGFloat headerMargin;

@end

@implementation PEYSCNNodeCreator

- (instancetype)init
{
    self = [super init];
    if (self){
        self.spacing = 25;
        self.smallZOffset = 1;
        self.boardNormalColor = HEXCOLOR(0x3399ff);
        self.boardHighlightColor = HEXACOLOR(0xff0000, 0.5);
        self.headerMargin = 10.0;
    }
    return self;
}

- (SCNNode *)makeGroupNodeWithElement:(PEYViewElement *)viewElement rootNode:(SCNNode *)rootNode parentViewElement:(PEYViewElement *)parentViewElement parentSCNNode:(SCNNode *)parentSCNNode depth:(CGFloat)depth
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewElement.frame.size.width, viewElement.frame.size.height)];
    SCNShape *shape = [SCNShape shapeWithPath:path extrusionDepth:0.0];
    SCNMaterial *material = [[SCNMaterial alloc] init];
    material.doubleSided = YES;
    material.diffuse.contents = [UIColor clearColor];
    [shape insertMaterial:material atIndex:0];
    SCNNode *node = [SCNNode nodeWithGeometry:shape];
    CGFloat y = 0.0;
    SCNVector3 position = SCNVector3Make(viewElement.frame.origin.x, y, 0.0);
    if (parentViewElement && parentSCNNode) {
        // sceneKit 的坐标体系是左下角为原点
        y = parentViewElement.frame.size.height - CGRectGetMaxY(viewElement.frame);
        SCNVector3 relativePosition = SCNVector3Make(viewElement.frame.origin.x, y, 0.0);
        position = [rootNode convertPosition:relativePosition fromNode:parentSCNNode];
    }
    position.z = self.spacing * depth;
    [node setPosition:position];
    node.name = viewElement.elementIdentifier ?: @"";
    [rootNode addChildNode:node];
    return node;
}

- (SCNNode *)makeElementNodeWithElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewElement.frame.size.width, viewElement.frame.size.height)];
    SCNShape *shape = [SCNShape shapeWithPath:path extrusionDepth:0.0];
    SCNMaterial *material = [[SCNMaterial alloc] init];
    material.doubleSided = YES;
    material.diffuse.contents = [UIImage imageWithCGImage:viewElement.snapShotImage];
    [shape insertMaterial:material atIndex:0];
    SCNNode *node = [SCNNode nodeWithGeometry:shape];
    SCNVector3 position = SCNVector3Make(0, 0, 0);
    [node setPosition:position];
    [groupNode addChildNode:node];
    return node;
}

- (SCNNode *)makeBoardWithViewElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode highlight:(BOOL)highlight
{
    SCNVector3 min, max;
    [groupNode getBoundingBoxMin:&min max:&max];
    SCNVector3 topLeft = SCNVector3Make(min.x, max.y, self.smallZOffset);
    SCNVector3 bottomLeft = SCNVector3Make(min.x, min.y, self.smallZOffset);
    SCNVector3 topRight = SCNVector3Make(max.x, max.y, self.smallZOffset);
    SCNVector3 bottomRight = SCNVector3Make(max.x, min.y, self.smallZOffset);
    SCNNode *bottomLine = [self makeLineFrom:bottomLeft to:bottomRight color:highlight ? self.boardHighlightColor : self.boardNormalColor];
    SCNNode *topLine = [self makeLineFrom:topLeft to:topRight color:highlight ? self.boardHighlightColor : self.boardNormalColor];
    SCNNode *leftLine = [self makeLineFrom:topLeft to:bottomLeft color:highlight ? self.boardHighlightColor : self.boardNormalColor];
    SCNNode *rightLine = [self makeLineFrom:topRight to:bottomRight color:highlight ? self.boardHighlightColor : self.boardNormalColor];
    SCNNode *boardNode = [SCNNode node];
    [boardNode addChildNode:bottomLine];
    [boardNode addChildNode:topLine];
    [boardNode addChildNode:leftLine];
    [boardNode addChildNode:rightLine];
    [groupNode addChildNode:boardNode];
    return boardNode;
}

- (SCNNode *)makeLineFrom:(SCNVector3)from to:(SCNVector3)to color:(UIColor *)lineColor
{
    SCNVector3 vertices[] = {from, to};
    SCNGeometrySource *source = [SCNGeometrySource geometrySourceWithVertices:vertices count:2];
    int indices[] = {0, 1};
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:[NSData dataWithBytes:&indices length:sizeof(indices)] primitiveType:SCNGeometryPrimitiveTypeLine primitiveCount:1 bytesPerIndex:sizeof(int)];
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[source] elements:@[element]];
    SCNMaterial *material = [[SCNMaterial alloc] init];
    material.diffuse.contents = lineColor;
    // important!!
    material.lightingModelName = SCNLightingModelConstant;
    material.doubleSided = YES;
    geometry.firstMaterial = material;
    SCNNode *line = [SCNNode nodeWithGeometry:geometry];
    return line;
}

- (SCNNode *)makeTitleWithViewElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode
{
    SCNText *nodeNameText = [[SCNText alloc] init];
    nodeNameText.string = viewElement.nodeName;
    nodeNameText.font = Font(14);
    nodeNameText.alignmentMode = kCAAlignmentCenter;
    nodeNameText.truncationMode = kCATruncationEnd;
    SCNNode *textNode = [SCNNode nodeWithGeometry:nodeNameText];
    SCNVector3 textMin, textMax;
    [textNode getBoundingBoxMin:&textMin max:&textMax];
    CGFloat textWidth = textMax.x - textMin.x;
    CGFloat textHeight = textMax.y - textMin.y;
    CGFloat headerWidth = MAX(self.headerMargin * 2 + textWidth, viewElement.frame.size.width);
    CGFloat headerHeight = textHeight + self.headerMargin * 2;
    CGRect frame = CGRectMake(0, 0, headerWidth, headerHeight);
    SCNNode *headerNode = [self makeHeaderNodeWithFrame:frame];
    textNode.position = SCNVector3Make((frame.size.width - textWidth)/2, (frame.size.height - textHeight)/2, self.smallZOffset);
    [headerNode addChildNode:textNode];
    headerNode.position = SCNVector3Make((viewElement.frame.size.width - headerWidth)/2, viewElement.frame.size.height, self.smallZOffset);
    [groupNode addChildNode:headerNode];
    return headerNode;
}

- (SCNNode *)makeHeaderNodeWithFrame:(CGRect)frame
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    SCNShape *shape = [SCNShape shapeWithPath:path extrusionDepth:0.0];
    SCNMaterial *material = [[SCNMaterial alloc] init];
    material.doubleSided = YES;
    material.diffuse.contents = HEXCOLOR(0x3399ff);
    [shape insertMaterial:material atIndex:0];
    SCNNode *header = [SCNNode nodeWithGeometry:shape];
    return header;
}

- (SCNNode *)makeHighlightNodeWithViewElement:(PEYViewElement *)viewElement groupNode:(SCNNode *)groupNode
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewElement.frame.size.width, viewElement.frame.size.height)];
    SCNShape *shape = [SCNShape shapeWithPath:path extrusionDepth:0.0];
    SCNMaterial *material = [[SCNMaterial alloc] init];
    material.doubleSided = YES;
    material.diffuse.contents = self.boardHighlightColor;
    [shape insertMaterial:material atIndex:0];
    SCNNode *highlightNode = [SCNNode nodeWithGeometry:shape];
    highlightNode.position = SCNVector3Make(0, 0, self.smallZOffset/2.0);
    [groupNode addChildNode:highlightNode];
    return highlightNode;
}

@end
