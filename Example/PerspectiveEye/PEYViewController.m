//
//  PEYViewController.m
//  PerspectiveEye
//
//  Created by Yasic on 05/06/2019.
//  Copyright (c) 2019 Yasic. All rights reserved.
//

#import "PEYViewController.h"
#import "PEYDefines.h"
#import "PEYPerspectiveViewController.h"
#import <Masonry/Masonry.h>

@interface PEYViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *brownView;
@property (nonatomic, strong) UILabel *brownLabel;
@property (nonatomic, strong) UIView *purpleView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *yellowView;

@end

@implementation PEYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试首页";
    [self addViews];
    [self setConstraints];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"透视" style:UIBarButtonItemStylePlain target:self action:@selector(enablePerspective)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)enablePerspective
{
    PEYPerspectiveViewController *vc = [[PEYPerspectiveViewController alloc] initWithTargetView:[UIApplication sharedApplication].keyWindow];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)addViews
{
    [self.view addSubview:self.topView];

    [self.topView addSubview:self.redView];
    [self.redView addSubview:self.brownView];
    [self.brownView addSubview:self.brownLabel];
    [self.redView addSubview:self.purpleView];
    [self.topView addSubview:self.blueView];

    [self.view addSubview:self.bottomView];

    [self.bottomView addSubview:self.greenView];
    [self.bottomView addSubview:self.yellowView];
}

- (void)setConstraints
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.5);
    }];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.topView);
        make.width.equalTo(self.topView).multipliedBy(0.5);
    }];
    [self.brownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.redView).inset(20);
        make.right.equalTo(self.redView).inset(-20);
    }];
    [self.brownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.brownView);
    }];
    [self.purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.redView).inset(20);
        make.left.equalTo(self.redView).inset(-20);
    }];
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.topView);
        make.width.equalTo(self.topView).multipliedBy(0.5);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView).multipliedBy(0.5);
    }];
    [self.yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView).multipliedBy(0.5);
    }];
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIView *)redView
{
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (UIView *)brownView
{
    if (!_brownView) {
        _brownView = [UIView new];
        _brownView.backgroundColor = [UIColor brownColor];
    }
    return _brownView;
}

- (UILabel *)brownLabel
{
    if (!_brownLabel) {
        _brownLabel = [UILabel new];
        _brownLabel.text = @"I am brown";
        _brownLabel.textColor = HEXCOLOR(0xffffff);
        _brownLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _brownLabel;
}

- (UIView *)purpleView
{
    if (!_purpleView) {
        _purpleView = [UIView new];
        _purpleView.backgroundColor = [UIColor purpleColor];
    }
    return _purpleView;
}

- (UIView *)blueView
{
    if (!_blueView) {
        _blueView = [UIView new];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor grayColor];
    }
    return _bottomView;
}

- (UIView *)greenView
{
    if (!_greenView) {
        _greenView = [UIView new];
        _greenView.backgroundColor = [UIColor greenColor];
    }
    return _greenView;
}

- (UIView *)yellowView
{
    if (!_yellowView) {
        _yellowView = [UIView new];
        _yellowView.backgroundColor = [UIColor yellowColor];
    }
    return _yellowView;
}

@end
