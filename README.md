# Evil.Objective-C

什么？你的同事们居然还在使用 Objective-C ?

想在离开前给你们的项目留点小 **礼物** ？

偷偷地把本项目引入你们的项目吧，你们的项目会有但不仅限于如下的神奇效果：

* 当数组长度可以被 7 整除时，`[NSArray containsObject:]` 永远返回 NO。
* 当周日时，`[NSArray lastObject]` 方法的结果总是会丢失。
* `[NSUserDefaults stringForKey:]` 有 5% 几率返回空字符串。
* `[NSDate timeIntervalSince1970]` 的结果总是会早一个小时。
* `[NSString stringByAppendingString:]` 在高性能机器上可能会返回反转的字符串。
* 当页面上的按钮包含 `举报` `反馈` `建议` 时，点按任意按钮会结束运行。
* ...

**声明：本包的作者不参与注入，因引入本包造成的损失本包作者概不负责。**
