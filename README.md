# PerspectiveEye

[![CI Status](https://img.shields.io/travis/Yasic/PerspectiveEye.svg?style=flat)](https://travis-ci.org/Yasic/PerspectiveEye)
[![Version](https://img.shields.io/cocoapods/v/PerspectiveEye.svg?style=flat)](https://cocoapods.org/pods/PerspectiveEye)
[![License](https://img.shields.io/cocoapods/l/PerspectiveEye.svg?style=flat)](https://cocoapods.org/pods/PerspectiveEye)
[![Platform](https://img.shields.io/cocoapods/p/PerspectiveEye.svg?style=flat)](https://cocoapods.org/pods/PerspectiveEye)

## 透视眼

透视眼（PerspectiveEye）是一个在 iOS 端模拟的 “Debug View Hierarchy” 工具，可以通过 3D 效果展示当前 window 下所有 UIView 的层级关系、内容及其约束信息。

### 特性

* 支持查看任意 UIView 对象的全部子 View 的视图层级
* 支持多种手势操作：
  * 单击选中视图
  * 双指缩放
  * 双指移动
* 支持调节视图元素的间距
* 支持隐藏部分视图元素
* 支持仅展示线框模式
* 支持展示约束面板，以及高亮显示约束相关的视图及父视图

### 示例图

* 普通模式

<img src="https://raw.githubusercontent.com/Yasic/PerspectiveEye/master/Screenshot/normal_mode_01.jpg" width="300px" height="500px">

<img src="https://raw.githubusercontent.com/Yasic/PerspectiveEye/master/Screenshot/normal_mode_02.jpg" width="300px" height="500px">

* 仅展示线框

隐藏 UIView 的内容，仅展示 UIView 的线框

<img src="https://raw.githubusercontent.com/Yasic/PerspectiveEye/master/Screenshot/only_wireframe.jpg" width="300px" height="500px">

* 展示约束信息

展示当前 View 的全部约束关系，并以不同颜色高亮展示相关的 View 元素

<img src="https://raw.githubusercontent.com/Yasic/PerspectiveEye/master/Screenshot/show_constraints.jpg" width="300px" height="500px">


## 依赖

PerspectiveEye 支持 iOS8 及以上系统，需要依赖 SceneKit。 

## 接入方式

支持通过 Cocoapod 引入到工程中

```ruby
pod 'PerspectiveEye'
```

## 使用方式

初始化一个 PEYPerspectiveViewController 对象，传入一个希望查看的目标 UIView 对象，然后 present 出来。

```objectivec
PEYPerspectiveViewController *vc = [[PEYPerspectiveViewController alloc] initWithTargetView:[UIApplication sharedApplication].keyWindow];
[self presentViewController:vc animated:YES completion:nil];
```

## Author

Yasic, yuxuan2580@gmail.com

## License

PerspectiveEye is available under the MIT license. See the LICENSE file for more info.
