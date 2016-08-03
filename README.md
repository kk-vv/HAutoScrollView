# HAutoScrollView

[![CI Status](http://img.shields.io/travis/LiangJun.Hu/HAutoScrollView.svg?style=flat)](https://travis-ci.org/LiangJun.Hu/HAutoScrollView)
[![Version](https://img.shields.io/cocoapods/v/HAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/HAutoScrollView)
[![License](https://img.shields.io/cocoapods/l/HAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/HAutoScrollView)
[![Platform](https://img.shields.io/cocoapods/p/HAutoScrollView.svg?style=flat)](http://cocoapods.org/pods/HAutoScrollView)

>
循环ScrollView,支持自动滚动、支持点击事件代理回调，已处理NSTimer 销毁，处理AutoLayout 适配。

##### `启动自动滚动`

- `[autoScroll setAutoFlip:true];`

##### `设置滚动时间`

- `[autoScroll setFlipInterval:3.0];`

##### `Delegate&DataSource`

- `[autoScroll setDelegate:self];`
- `[autoScroll setDataSource:self];`

##### `点击事件`
 
- `-(void)autoScrollView:(HAutoScrollView *)asView
 didSelectAtPageIndex:(NSInteger)pIndex;`
 
#####  `数据源`

- `-(NSInteger)numberOfPagesInHAutoScrollView:(HAutoScrollView *)asView;`
- `-(UIView *)pageAtIndex:(NSInteger)index
        autoScrollView:(HAutoScrollView *)asView;`


## Installation

HAutoScrollView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HAutoScrollView"
```

## License

HAutoScrollView is available under the MIT license. See the LICENSE file for more info.

===

##### `效果图`
>
![image](https://github.com/iFallen/HAutoScrollView/raw/master/img/1.png)
>
![image](https://github.com/iFallen/HAutoScrollView/raw/master/img/2.png)
>
![image](https://github.com/iFallen/HAutoScrollView/raw/master/img/3.png)
>
![image](https://github.com/iFallen/HAutoScrollView/raw/master/img/4.png)



