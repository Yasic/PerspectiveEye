//
//  PEYPerspectiveViewController.m
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "PEYPerspectiveViewController.h"

@interface PEYPerspectiveViewController ()

@property (nonatomic, strong) PEYPerspectiveView *persView;

@property (nonatomic, strong) UIView *targetView;

@property (nonatomic, strong) UIView *actionBar;

@property (nonatomic, strong) UIButton *closeButton;

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
}

/**
 关闭页面
 */
- (void)closePage
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addViews
{
    [self.view addSubview:self.persView];
    [self.view addSubview:self.actionBar];
    [self.actionBar addSubview:self.closeButton];
    [self.persView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-36);
    }];
    [self.actionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(36);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.actionBar);
    }];
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
        _actionBar.backgroundColor = HEXCOLOR(0x3399ff);
    }
    return _actionBar;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
