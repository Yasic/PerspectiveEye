//
//  PEYConstraintsView.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/15.
//

#import "PEYConstraintsView.h"

@interface PEYConstraintRelationCell : UITableViewCell

/**
 约束关系展示文案
 */
@property (nonatomic, strong) UILabel *relationLabel;

@end

@implementation PEYConstraintRelationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.relationLabel];
        [self.relationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return self;
}

- (UILabel *)relationLabel
{
    if (!_relationLabel) {
        _relationLabel = [UILabel new];
        _relationLabel.font = Font(14);
        _relationLabel.textColor = HEXCOLOR(0xffffff);
        _relationLabel.textAlignment = NSTextAlignmentLeft;
        _relationLabel.numberOfLines = 0;
        _relationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _relationLabel;
}

@end

@interface PEYConstraintsView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSAttributedString *> *constraintArray;

@end

@implementation PEYConstraintsView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self addViews];
        [self makeConstraints];
    }
    return self;
}

- (void)setTargetView:(UIView *)targetView
{
    if (!targetView) {
        return;
    }
    _targetView = targetView;
    self.constraintArray = [[NSMutableArray alloc] init];
    NSArray<NSLayoutConstraint *> *superConstraints = targetView.superview.constraints;
    [superConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        if (constraint.firstItem == self.targetView || constraint.secondItem == self.targetView) {
            [self.constraintArray addObject:[self makeStringWithConstrant:constraint]];
        }
    }];
    NSArray<NSLayoutConstraint *> *ownConstraints = targetView.constraints;
    [ownConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        if (constraint.firstItem == self.targetView || constraint.secondItem == self.targetView) {
            [self.constraintArray addObject:[self makeStringWithConstrant:constraint]];
        }
    }];
    [self.tableView reloadData];
}

- (NSAttributedString *)makeStringWithConstrant:(NSLayoutConstraint *)constraint
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:[self attributeStrForConstraintItem:constraint.firstItem andAttribute:constraint.firstAttribute]];
    [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", [self constraintRelationToString:constraint.relation]]]];
    if (constraint.secondItem) {
        if (constraint.multiplier < 0.0f) {
            [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"-"]];
        }
        [attrStr appendAttributedString:[self attributeStrForConstraintItem:constraint.secondItem andAttribute:constraint.secondAttribute]];
        if (fabs(constraint.multiplier) != 1.0f) {
            [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" * %.2f", fabs(constraint.multiplier)]]];
        }
    }
    if (constraint.constant > 0 && constraint.secondItem) {
        [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" + "]];
    }
    if (constraint.constant < 0) {
        [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" - "]];
    }
    if (constraint.constant != 0) {
        [attrStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", fabs(constraint.constant)]]];
    }
    return [attrStr copy];
}

- (NSMutableAttributedString *)attributeStrForConstraintItem:(id)item andAttribute:(NSLayoutAttribute)attribute
{
    NSMutableString *res = [[NSMutableString alloc] init];
    UIColor *color = [self.creator colorForHeaderType:PEVNodeGroupHeaderTypeSelf];
    if (item == self.targetView) {
        res = [@"self" mutableCopy];
    } else {
        res = [[NSString stringWithFormat:@"$%@", [self.creator.semanticManager nameForElementIdentifier:[NSString stringWithFormat:@"%p", item]]] mutableCopy];
        if (item == self.targetView.superview) {
            color = [self.creator colorForHeaderType:PEVNodeGroupHeaderTypeParentView];
        } else {
            color = [self.creator colorForHeaderType:PEVNodeGroupHeaderTypeRelativeView];
        }
    }
    [res appendString:[NSString stringWithFormat:@".%@ ", [self attributeEnumToString:attribute]]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:res];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, res.length)];
    return attrStr;
}

- (NSString *)attributeEnumToString:(NSLayoutAttribute)attr
{
    NSArray *indexList = @[@"NSLayoutAttributeNotAnAttribute",
                           @"NSLayoutAttributeLeft",
                           @"NSLayoutAttributeRight",
                           @"NSLayoutAttributeTop",
                           @"NSLayoutAttributeBottom",
                           @"NSLayoutAttributeLeading",
                           @"NSLayoutAttributeTrailing",
                           @"NSLayoutAttributeWidth",
                           @"NSLayoutAttributeHeight",
                           @"NSLayoutAttributeCenterX",
                           @"NSLayoutAttributeCenterY",
                           @"NSLayoutAttributeLastBaseline",
                           @"NSLayoutAttributeBaseline",
                           @"NSLayoutAttributeFirstBaseline",
                           @"NSLayoutAttributeLeftMargin",
                           @"NSLayoutAttributeRightMargin",
                           @"NSLayoutAttributeTopMargin",
                           @"NSLayoutAttributeBottomMargin",
                           @"NSLayoutAttributeLeadingMargin",
                           @"NSLayoutAttributeTrailingMargin",
                           @"NSLayoutAttributeCenterXWithinMargins",
                           @"NSLayoutAttributeCenterYWithinMargins"];
    if (attr >= indexList.count || attr < 0) {
        return @"";
    }
    return [indexList[attr] substringFromIndex:17];
}

- (NSString *)constraintRelationToString:(NSLayoutRelation)relation
{
    NSString *res = @"==";
    switch (relation) {
        case -1: {
            res = @"<=";
            break;
        }
        case 1: {
            res = @">=";
            break;
        }
        default:
            break;
    }
    return res;
}

#pragma mark tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.constraintArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEYConstraintRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PEYConstraintRelationCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.relationLabel.attributedText = self.constraintArray[indexPath.row];
    return cell;
}

#pragma mark UI 懒加载

- (void)addViews
{
    [self addSubview:self.tableView];
}

- (void)makeConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[PEYConstraintRelationCell class] forCellReuseIdentifier:NSStringFromClass([PEYConstraintRelationCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
