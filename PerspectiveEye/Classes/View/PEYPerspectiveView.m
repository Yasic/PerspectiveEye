//
//  PEYPerspectiveView.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "PEYPerspectiveView.h"
#import "PEYSCNNodeCreator.h"
#import "PEVViewNodeGroup.h"
#import "PEYRangeSlider.h"
#import "PEYConstraintsView.h"

@interface PEYPerspectiveView() <SCNSceneRendererDelegate>

/**
 SCNScene 对象
 */
@property (nonatomic, strong) SCNScene *scnScene;

/**
 SCNView 对象
 */
@property (nonatomic, strong) SCNView *scnView;

@property (nonatomic, strong) PEYSCNNodeCreator *creator;

/**
 缓存 group 与其 identifier 的字典
 */
@property (nonatomic, strong) NSMutableDictionary *nodeGroupMap;

/**
 高亮节点组
 */
@property (nonatomic, strong) PEVViewNodeGroup *highlightGroup;

/**
 元素描述文案 label
 */
@property (nonatomic, strong) UILabel *elementDescLabel;

/**
 间距调节器
 */
@property (nonatomic, strong) UISlider *spacingSlider;

/**
 深度调节器
 */
@property (nonatomic, strong) PEYRangeSlider *depthSlider;

/**
 仅展示边框文案
 */
@property (nonatomic, strong) UILabel *wireframeLabel;

/**
 仅展示边框开关
 */
@property (nonatomic, strong) UISwitch *wireframeSwitch;

/**
 开启展示 header 的文案
 */
@property (nonatomic, strong) UILabel *showHeaderLabel;

/**
 展示header开关
 */
@property (nonatomic, strong) UISwitch *headerSwitch;

/**
 展示约束开关文案
 */
@property (nonatomic, strong) UILabel *constraintsShowLabel;

/**
 展示约束开关
 */
@property (nonatomic, strong) UISwitch *constraintsShowSwitch;

/**
 约束关系展示列表
 */
@property (nonatomic, strong) PEYConstraintsView *constraintsView;

@property (nonatomic, strong) MASConstraint *constrainsShowConstraint;
@property (nonatomic, strong) MASConstraint *constrainsHiddenConstraint;

@end

@implementation PEYPerspectiveView

- (instancetype)initWithViewElement:(PEYViewElement *)viewElement
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.nodeGroupMap = [NSMutableDictionary dictionary];
        self.rootElement = viewElement;
        self.creator = [[PEYSCNNodeCreator alloc] init];
        [self addViews];
        
        PEVViewNodeGroup *group = [[PEVViewNodeGroup alloc] initWithViewElement:viewElement creator:self.creator];
        group.creator = self.creator;
        CGFloat maxDepth = [group renderToScene:self.scnScene parentNode:nil nodeGroupMap:self.nodeGroupMap depth:0.0f];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.scnView addGestureRecognizer:tap];
        
        __weak __typeof(&*self) weak_self = self;
        self.depthSlider.rangeSliderValueChanged = ^(CGFloat location, CGFloat length) {
            __strong __typeof(&*weak_self) self = weak_self;
            // 深度不在当前范围的 node 需要隐藏
            [self.nodeGroupMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PEVViewNodeGroup *group, BOOL * _Nonnull stop) {
                if (group.nodeDepth/maxDepth < location - 0.1 || group.nodeDepth/maxDepth > location + length + 0.1) {
                    group.groupNode.hidden = YES;
                } else {
                    group.groupNode.hidden = NO;
                }
            }];
        };
    }
    return self;
}

/**
 点击事件处理，需要高亮对应的element

 @param sender 点击处理者
 */
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point = [sender locationOfTouch:0 inView:self.scnView];
    SCNNode *node = [self scnNodeAtPoint:point];
    if (node && self.nodeGroupMap[node.name]) {
        if (self.highlightGroup) {
            self.highlightGroup.isHighlight = NO;
        }
        PEVViewNodeGroup *group = self.nodeGroupMap[node.name];
        group.isHighlight = YES;
        self.highlightGroup = group;
        self.elementDescLabel.text = group.viewElement.elementDescrption;
        self.constraintsView.targetView = group.viewElement.targetView;
    }
}

/**
 间距滑动条值更新事件
 */
- (void)spacingSliderChanged
{
    [self.nodeGroupMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PEVViewNodeGroup  *group, BOOL * _Nonnull stop) {
        group.groupNode.position = SCNVector3Make(group.groupNode.position.x, group.groupNode.position.y, group.nodeDepth * self.spacingSlider.value);
    }];
}

/**
 边框开关
 */
- (void)wireframeSwitchClicked
{
    [self.nodeGroupMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PEVViewNodeGroup *group, BOOL * _Nonnull stop) {
        group.onlyWireframe = self.wireframeSwitch.isOn;
    }];
}

/**
 header开关
 */
- (void)headerSwitchClicked
{
    [self.nodeGroupMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, PEVViewNodeGroup *group, BOOL * _Nonnull stop) {
        group.showHeaderInfo = self.headerSwitch.isOn;
    }];
}

- (void)constraintsShowSwitchClicked
{
    [self layoutIfNeeded];
    if (self.constraintsShowSwitch.isOn) {
        [self.constrainsHiddenConstraint deactivate];
        [self.constrainsShowConstraint activate];
    } else {
        [self.constrainsHiddenConstraint activate];
        [self.constrainsShowConstraint deactivate];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

/**
 定位当前 point 所对应的 GroupNode

 @param point 指定点
 @return 返回当前点对应的 GroupNode，可能为 nil
 */
- (SCNNode *)scnNodeAtPoint:(CGPoint)point
{
    NSArray<SCNHitTestResult *> *hitTestRes = [self.scnView hitTest:point options:nil];
    for (SCNHitTestResult *res in hitTestRes) {
        SCNNode *node = [self findNearestAncestorSCNNode:res.node];
        if (node) {
            return node;
        }
    }
    return nil;
}

/**
 当前 node 所属的 groupNode

 @param node 指定 node
 @return 返回 groupNode，可能为 nil
 */
- (SCNNode *)findNearestAncestorSCNNode:(SCNNode *)node
{
    if (!node) {
        return nil;
    }
    if (node.name != nil) { // name 不为 0 的是 group 对应的 node
        return node;
    }
    return [self findNearestAncestorSCNNode:node.parentNode];
}

#pragma mark UI 懒加载

- (void)addViews
{
    [self addSubview:self.scnView];
    [self addSubview:self.elementDescLabel];
    [self addSubview:self.spacingSlider];
    [self addSubview:self.depthSlider];
    [self addSubview:self.wireframeLabel];
    [self addSubview:self.wireframeSwitch];
    [self addSubview:self.showHeaderLabel];
    [self addSubview:self.headerSwitch];
    [self addSubview:self.constraintsShowLabel];
    [self addSubview:self.constraintsShowSwitch];
    [self addSubview:self.constraintsView];
    [self.scnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.depthSlider.mas_top);
    }];
    [self.spacingSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(24);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH/2 - 24 - 12);
        make.height.mas_equalTo(20);
    }];
    [self.depthSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(24);
        make.bottom.equalTo(self.spacingSlider);
        make.height.mas_equalTo(24);
        make.left.equalTo(self.spacingSlider.mas_right).offset(24);
    }];
    [self.elementDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(10);
        make.bottom.equalTo(self.depthSlider.mas_top).offset(-10);
    }];
    
    [self.wireframeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).inset(15);
    }];
    [self.wireframeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wireframeLabel.mas_right).offset(15);
        make.centerY.equalTo(self.wireframeLabel);
    }];
    [self.showHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.wireframeSwitch.mas_bottom).offset(15);
    }];
    [self.headerSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wireframeSwitch);
        make.centerY.equalTo(self.showHeaderLabel);
    }];
    [self.constraintsShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.showHeaderLabel.mas_bottom).offset(15);
    }];
    [self.constraintsShowSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wireframeSwitch);
        make.centerY.equalTo(self.constraintsShowLabel);
    }];
    [self.constraintsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wireframeSwitch.mas_right).offset(10);
        make.right.equalTo(self);
        make.top.equalTo(self);
        self.constrainsShowConstraint = make.height.equalTo(self).multipliedBy(0.3);
        self.constrainsHiddenConstraint = make.height.equalTo(self).multipliedBy(0);
    }];
    [self.constrainsShowConstraint deactivate];
    [self.constrainsHiddenConstraint deactivate];
}

- (SCNView *)scnView
{
    if (!_scnView) {
        _scnView = [SCNView new];
        _scnView.scene = self.scnScene;
        _scnView.allowsCameraControl = YES;
        _scnView.autoenablesDefaultLighting = YES;
        _scnView.delegate = self;
        _scnView.playing = YES;
    }
    return _scnView;
}

- (SCNScene *)scnScene
{
    if (!_scnScene) {
        _scnScene = [SCNScene new];
        _scnScene.background.contents = HEXCOLOR(0xffffff);
    }
    return _scnScene;
}

- (UILabel *)elementDescLabel
{
    if (!_elementDescLabel) {
        _elementDescLabel = [UILabel new];
        _elementDescLabel.textColor = HEXCOLOR(0x222333);
        _elementDescLabel.textAlignment = NSTextAlignmentCenter;
        _elementDescLabel.font = Font(14);
        _elementDescLabel.numberOfLines = 0;
    }
    return _elementDescLabel;
}

- (UISlider *)spacingSlider
{
    if (!_spacingSlider) {
        _spacingSlider = [UISlider new];
        _spacingSlider.minimumValue = 0.5;
        _spacingSlider.maximumValue = 100;
        _spacingSlider.value = self.creator.spacing;
        [_spacingSlider addTarget:self action:@selector(spacingSliderChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _spacingSlider;
}

- (PEYRangeSlider *)depthSlider
{
    if (!_depthSlider) {
        _depthSlider = [PEYRangeSlider new];
    }
    return _depthSlider;
}

- (UILabel *)wireframeLabel
{
    if (!_wireframeLabel) {
        _wireframeLabel = [UILabel new];
        _wireframeLabel.text = @"仅展示边框";
        _wireframeLabel.font = Font(14);
        _wireframeLabel.textColor = HEXCOLOR(0x222333);
    }
    return _wireframeLabel;
}

- (UISwitch *)wireframeSwitch
{
    if (!_wireframeSwitch) {
        _wireframeSwitch = [UISwitch new];
        [_wireframeSwitch addTarget:self action:@selector(wireframeSwitchClicked) forControlEvents:UIControlEventValueChanged];
    }
    return _wireframeSwitch;
}

- (UILabel *)showHeaderLabel
{
    if (!_showHeaderLabel) {
        _showHeaderLabel = [UILabel new];
        _showHeaderLabel.text = @"展示header";
        _showHeaderLabel.font = Font(14);
        _showHeaderLabel.textColor = HEXCOLOR(0x222333);
    }
    return _showHeaderLabel;
}

- (UISwitch *)headerSwitch
{
    if (!_headerSwitch) {
        _headerSwitch = [UISwitch new];
        [_headerSwitch addTarget:self action:@selector(headerSwitchClicked) forControlEvents:UIControlEventValueChanged];
    }
    return _headerSwitch;
}

- (UILabel *)constraintsShowLabel
{
    if (!_constraintsShowLabel) {
        _constraintsShowLabel = [UILabel new];
        _constraintsShowLabel.text = @"展示约束";
        _constraintsShowLabel.font = Font(14);
        _constraintsShowLabel.textColor = HEXCOLOR(0x222333);
    }
    return _constraintsShowLabel;
}

- (UISwitch *)constraintsShowSwitch
{
    if (!_constraintsShowSwitch) {
        _constraintsShowSwitch = [UISwitch new];
        [_constraintsShowSwitch addTarget:self action:@selector(constraintsShowSwitchClicked) forControlEvents:UIControlEventValueChanged];
    }
    return _constraintsShowSwitch;
}

- (PEYConstraintsView *)constraintsView
{
    if (!_constraintsView) {
        _constraintsView = [PEYConstraintsView new];
        _constraintsView.clipsToBounds = YES;
        _constraintsView.backgroundColor = HEXACOLOR(0x222333, 0.5);
    }
    return _constraintsView;
}

#pragma mark SceneKit 回调函数

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time
{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didApplyAnimationsAtTime:(NSTimeInterval)time
{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didSimulatePhysicsAtTime:(NSTimeInterval)time
{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didApplyConstraintsAtTime:(NSTimeInterval)time
{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time
{
    
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time
{
    
}

@end
