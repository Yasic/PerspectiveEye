//
//  PEYSettingView.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/16.
//

#import "PEYSettingView.h"

@implementation PEYSettingItem

@end

@interface PEYSettingItemCell : UITableViewCell

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 开关
 */
@property (nonatomic, strong) UISwitch *settingSwitch;

/**
 选项实体
 */
@property (nonatomic, strong) PEYSettingItem *item;

/**
 用户设置操作回调
 */
@property (nonatomic, copy) void (^settingUpdateBlock)(PEYSettingItem *item);

@end

@implementation PEYSettingItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self addViews];
        [self makeConstraints];
    }
    return self;
}

- (void)setItem:(PEYSettingItem *)item
{
    _item = item;
    self.titleLabel.text = item.itemTitle ?: @"";
    self.settingSwitch.on = item.isOn;
}

- (void)settingSwitchClicked
{
    self.item.isOn = self.settingSwitch.isOn;
    if (self.settingUpdateBlock) {
        self.settingUpdateBlock(self.item);
    }
}

- (void)addViews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.settingSwitch];
}

- (void)makeConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [self.settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = Font(14);
        _titleLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _titleLabel;
}

- (UISwitch *)settingSwitch
{
    if (!_settingSwitch) {
        _settingSwitch = [UISwitch new];
        [_settingSwitch addTarget:self action:@selector(settingSwitchClicked) forControlEvents:UIControlEventValueChanged];
    }
    return _settingSwitch;
}

@end

@interface PEYSettingView()<UITableViewDataSource, UITableViewDelegate>

/**
 设置项列表
 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<PEYSettingItem *> *settingItems;

@end

@implementation PEYSettingView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.clipsToBounds = YES;
        self.backgroundColor = HEXACOLOR(0x222333, 0.5);
        self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.layer.borderColor = HEXCOLOR(0x222333).CGColor;
        [self addViews];
        [self makeConstraints];
        NSArray<NSString *> *settingTitles = @[@"仅展示线框",
                                               @"展示约束面板"];
        self.settingItems = [settingTitles pey_map:^id _Nonnull(NSString *title, NSUInteger idx) {
            PEYSettingItem *item = [PEYSettingItem new];
            item.itemTitle = title;
            item.option = idx;
            return item;
        }];
    }
    return self;
}

- (CGFloat)viewHeight
{
    return self.settingItems.count * 44;
}

#pragma mark tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEYSettingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PEYSettingItemCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = self.settingItems[indexPath.row];
    __weak __typeof(&*self) weak_self = self;
    cell.settingUpdateBlock = ^(PEYSettingItem *item) {
        __strong __typeof(&*weak_self) self = weak_self;
        [self.tableView reloadData];
        if (self.settingUpdateBlock) {
            self.settingUpdateBlock(item);
        }
    };
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
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PEYSettingItemCell class] forCellReuseIdentifier:NSStringFromClass([PEYSettingItemCell class])];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
    }
    return _tableView;
}

@end
