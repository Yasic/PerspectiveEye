//
//  PEYPerspectiveViewController.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "PEYPerspectiveViewController.h"
#import "PEYSettingView.h"

@interface PEYPerspectiveViewController ()

@property (nonatomic, strong) PEYPerspectiveView *persView;

@property (nonatomic, strong) UIView *targetView;

/**
 操作导航栏
 */
@property (nonatomic, strong) UIView *actionBar;

/**
 关闭页面按钮
 */
@property (nonatomic, strong) UIButton *closeButton;

/**
 标题栏
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 设置按钮
 */
@property (nonatomic, strong) UIButton *settingButton;

/**
 设置面板
 */
@property (nonatomic, strong) PEYSettingView *settingView;

@property (nonatomic, strong) MASConstraint *settingViewShowConstraint;
@property (nonatomic, strong) MASConstraint *settingViewHiddenConstraint;

@end

@implementation PEYPerspectiveViewController

- (instancetype)initWithTargetView:(UIView *)targetView
{
    self = [self init];
    if (self){
        self.targetView = targetView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addViews];
    __weak __typeof(&*self) weak_self = self;
    self.settingView.settingUpdateBlock = ^(PEYSettingItem * _Nonnull item) {
        __strong __typeof(&*weak_self) self = weak_self;
        switch (item.option) {
            case PEYSettingOptionsOnlyWireframe: {
                [self.persView onlyWireframe:item.isOn];
                break;
            }
            case PEYSettingOptionsShowConstraints: {
                [self.persView showConstrants:item.isOn];
                break;
            }
            default:
                break;
        }
    };
}

/**
 关闭页面
 */
- (void)closePage
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/**
 设置按钮点击事件
 */
- (void)settingButtonClicked
{
    self.settingButton.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        self.settingButton.enabled = YES;
    });
    [self.view layoutIfNeeded];
    if (self.settingView.isHidden) {
        [self.settingViewHiddenConstraint deactivate];
        [self.settingViewShowConstraint activate];
    } else {
        [self.settingViewHiddenConstraint activate];
        [self.settingViewShowConstraint deactivate];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    if (self.settingView.isHidden) {
        self.settingView.hidden = !self.settingView.hidden;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            self.settingView.hidden = !self.settingView.hidden;
        });
    }
}

- (void)addViews
{
    [self.view addSubview:self.persView];
    [self.view addSubview:self.actionBar];
    [self.actionBar addSubview:self.closeButton];
    [self.actionBar addSubview:self.titleLabel];
    [self.actionBar addSubview:self.settingButton];
    [self.view addSubview:self.settingView];
    [self.persView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.actionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actionBar).offset(15);
        make.bottom.equalTo(self.actionBar).offset(-5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionBar);
        make.centerY.equalTo(self.closeButton);
    }];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.actionBar).offset(-15);
        make.centerY.equalTo(self.closeButton);
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.actionBar.mas_bottom);
        self.settingViewShowConstraint = make.height.mas_equalTo([self.settingView viewHeight]);
        self.settingViewHiddenConstraint = make.height.mas_equalTo(0);
    }];
    [self.settingViewShowConstraint deactivate];
    [self.settingViewHiddenConstraint activate];
}

- (PEYPerspectiveView *)persView
{
    if (!_persView) {
        _persView = [[PEYPerspectiveView alloc] initWithViewElement:[[PEYViewElement alloc] initWithView:self.targetView]];
    }
    return _persView;
}

- (UIView *)actionBar
{
    if (!_actionBar) {
        _actionBar = [UIView new];
        _actionBar.backgroundColor = HEXCOLOR(0x222333);
    }
    return _actionBar;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = Font(14);
        [_closeButton addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Perspective Eye";
        _titleLabel.font = Font(14);
        _titleLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _titleLabel;
}

- (UIButton *)settingButton
{
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _settingButton.titleLabel.font = Font(14);
        [_settingButton addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (PEYSettingView *)settingView
{
    if (!_settingView) {
        _settingView = [PEYSettingView new];
        _settingView.hidden = YES;
    }
    return _settingView;
}

@end
