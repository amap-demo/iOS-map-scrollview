本工程为基于高德地图iOS SDK进行封装，将地图view作为UIScrollView子view，响应滑动手势。
## 前述 ##
- [高德官网申请Key](http://lbs.amap.com/dev/#/).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 3D地图SDK实现

## 功能描述 ##
将地图view作为UIScrollView子view，响应滑动手势。

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| UIPanGestureRecognizer |  | 系统手势 | |

## 核心难点 ##

`Objective-C`

```
//实现手势处理
- (void)panHandler:(UIPanGestureRecognizer *)gesture
{
    // NSLog(@"vvv %f, %f", [gesture velocityInView:_scrollView].x, [gesture velocityInView:_scrollView].y);
    // 设置触发条件
    if (gesture.state != UIGestureRecognizerStateEnded)
    {
        return;
    }

    if (fabs([gesture velocityInView:_scrollView].x) > 1200)
    {
        // -1 向左，1 向右
        int direction = fabs([gesture velocityInView:_scrollView].x) / [gesture velocityInView:_scrollView].x;
        int validIdx = 1;

        if (_currentIndex == validIdx && !_scrollView.isDecelerating)
        {
            CGFloat width = _scrollView.frame.size.width * (1 - direction);
            [_scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
        }
    }
}

//设置允许和scrollview上pan手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
```

`Swift`

```

//实现手势处理
func panHandle(gesture : UIPanGestureRecognizer) {

    if gesture.state != UIGestureRecognizerState.ended {
        return
    }

    if fabs(gesture.velocity(in: self.scrollView).x) > 1400 {

        // -1 向左，1 向右
        let direction = fabs(gesture.velocity(in: self.scrollView).x) / gesture.velocity(in: self.scrollView).x
        let validIdx = 1

        if self.currentIndex == validIdx && !self.scrollView.isDecelerating {
            let width: CGFloat = self.scrollView.frame.size.width * CGFloat(1 - direction)
            scrollView.setContentOffset(CGPoint(x: width, y: CGFloat(0)), animated: true)
        }
    }
}

//设置允许和scrollview上pan手势并发
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
}

```
