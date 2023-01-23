<h1 align="center">
    <b>
        <a href="https://godolphinx.org"><img src="https://godolphinx.org/images/dolphin-platform-logo.svg" /></a><br>
    </b>
</h1>

<p align="center"> 一个快速开发软件的平台 </p>

<p align="center">
    <a href="https://godolphinx.org/"><b>Website</b></a> •
    <a href="https://godolphinx.org/ios/description.html"><b>Documentation</b></a>
</p>

<div align="center">
  <a href="https://github.com/wangxiang4/dolphin-ios/blob/master/LICENSE">
    <img src="https://img.shields.io/npm/l/vue.svg?sanitize=true">
  </a>
  <a href="https://gitpod.io/#https://github.com/wangxiang4/dolphin-ios">
    <img src="https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod&style=flat-square">
  </a>
  <a href="https://discord.gg/DREuQWrRYQ">
    <img src="https://img.shields.io/badge/chat-on%20discord-7289da.svg?sanitize=true"/>
  </a>
</div>

## 🐬 介绍
海豚生态计划-打造一个web端,安卓端,ios端的一个海豚开发平台生态圈,不接收任何商业化,并且完全免费开源(包含高级功能)。

## 💪 愿景
让人人都可以快速高效的开发软件

## ✨ 特性
- MVVM开发模式
- RXSwift订阅发布异步执行
- RXTheme实现主题响应式切换
- 采用Moya网络请求
- 集成大量RX扩展库让编写RX也可以很甜
- 集成浮动面板让场景切换变得很生动
- 集成KafkaRefresh刷新让表格分页刷新变得简单
- 集成RAMAnimatedTabBarController让标签栏变的很漂亮
- 集成DZNEmptyDataSet让表个没有数据也有动画图片
- 封装大量RX组件可以很方便的开发界面
- 采用苹果官方推荐语言 Swift5 编写
- 整体框架采用最新的SwiftUi编写ui视图,避免采用设计器带来代码版本管理问题

## <img width="28" style="vertical-align:middle" src="https://godolphinx.org/images/hacktoberfest-logo.svg"> 黑客节
加入[Github HackToberFest](https://hacktoberfest.com/) 开始为此项目做出贡献.

## 🍀 基础准备
- 了解 **Swift5**
- 了解 **Object-c**
- 了解 **SwiftUi**
- 了解 **xib/storyboard**
- 了解 **RxSwift**

## 🔨 开发目录

```
├─ dolphin-ios -- IOS海豚APP
│  ├─ Dolphin -- APP
│  │  ├─Application -- 应用程序初始化代理
│  │  ├─Configs -- 全局配置
│  │  ├─Common -- 通用组件基于SwiftUI进行扩展
│  │  ├─Managers -- 应用控制管理
│  │  ├─Entity -- 数据映射实体
│  │  ├─Modules -- 场景模块
│  │  │  ├─Login  --  登录场景
│  │  │  ├─Home -- 首页场景
│  │  │  ├─Main -- APP启动入口场景
│  │  │  ├─Workbench -- 工作台场景
│  │  │  ├─Messages -- 消息场景
│  │  │  ├─Settings -- 应用设置场景
│  │  │  ├─Settings Language -- 语言切换设置场景
│  │  │  ├─Theme -- 主题颜色切换场景
│  │  ├─DependencyInjection -- IOC依赖注入
│  │  ├─Extensions -- 功能扩展
│  │  │  ├─CATransform3D -- 核心动画3D视图变形扩展
│  │  │  ├─object-c Foundation -- 基础库扩展
│  │  │  ├─RxSwift -- 可观测响应式扩展
│  │  │  ├─UIColor -- UI颜色组件扩展
│  │  │  ├─UIFont -- UI字体组件扩展
│  │  │  ├─UIImage -- UI图片组件扩展
│  │  │  ├─UIView -- UI基础视图扩展
│  │  ├─Utils -- 工具类
│  │  │  ├─CommonUtil -- 通用工具
│  │  │  ├─Networking -- Moya网络请求封装
│  │  │  ├─RxActivityIndicator -- 监听可观测活动对象序列
│  │  ├─Resources -- 资源管理
│  ├─ DolphinTests -- APP单元测试
│  │  ├─Models -- 数据映射实体测试
│  │  ├─Modules -- 场景模块测试
│  ├─ DolphinUITests -- APP单元自动化UI界面交互测试
```


## 🤔 一起讨论
加入我们的 [Discord](https://discord.gg/DREuQWrRYQ) 开始与大家交流。

## 🤗 我想成为开发团队的一员！
欢迎😀！我们正在寻找有才华的开发者加入我们，让海豚开发平台变得更好！如果您想加入开发团队，请联系我们，非常欢迎您加入我们！💖

## 在线一键设置
您可以使用 Gitpod，一个在线 IDE（开源免费）来在线贡献或运行示例。

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/wangxiang4/dolphin-ios)

## 📄 执照
[Dolphin Development Platform 是获得MIT许可](https://github.com/wangxiang4/dolphin-ios/blob/master/LICENSE) 的开源软件 。

