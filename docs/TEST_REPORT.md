# 验证记录

验证日期：2026-11-03。工程以 Android 模拟器为本次运行验收平台。

## 环境

| 项目 | 版本/配置 |
| --- | --- |
| Flutter | 3.41.6 stable |
| Dart | 3.11.4 |
| 设备 | Android SDK built for arm64，emulator-5554 |
| 系统 | Android 14，API 34 |
| 模拟器显示 | 1080 × 2340，密度 440 |
| 布局测试 | 414 × 896、320 × 700 逻辑像素 |

## 自动检查

| 检查 | 结果 | 覆盖内容 |
| --- | --- | --- |
| flutter analyze | 通过，无问题 | 导入、类型、空安全与项目 lint |
| flutter test | 40 项通过 | 19 页 × 2 种尺寸布局，状态操作、队列循环、登录校验与跳转 |
| Android 集成测试：逐页截图 | 通过 | 19 个路由实际运行、图片解码完成后截图、无布局异常 |
| Android 集成测试：交互与音频 | 通过 | 原生音频播放、30 秒时长、拖动进度、暂停、切歌、收藏、本地恢复、卡片选择与演示确认 |
| Android 调试构建 | 通过 | lib/main.dart 正常启动入口构建 APK |
| Android ARM64 优化构建 | 通过，24.9 MB | release 模式，按 ARM64 架构输出体验包 |

集成测试日志中还会出现框架自身的 teardown 计数；本项目包含 2 个集成测试用例。

## 界面复核

检查了实际截图总览及首页、分类、注册、播放器等主要单页。修复了窄屏文字/卡片溢出、注册表单底部显示空间、播放器控制区布局，以及懒加载网格图片尚未解码导致的截图缺图。Android PixelCopy 短暂取帧失败时，截图流程会等待下一帧重试，不重放页面操作。截图以 PNG 的 Base64 格式回传，避免将大量字节展开成整数列表导致连接关闭；最终 19 张截图已成功写入本机。

- 全部实际截图：`docs/screenshots/*.png`，共 19 张。
- 总览：`docs/screenshots/overview.jpg`。
- 设计原图：`docs/design_reference/*.png`，共 19 张。
- 截图不包含真实账户、验证码邮件或支付数据；本项目仅使用演示数据。

## 复现

在项目根目录执行：

```sh
flutter pub get
flutter analyze
flutter test
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d emulator-5554
flutter build apk --debug -t lib/main.dart
flutter build apk --release --split-per-abi --target-platform android-arm64 -t lib/main.dart
```

`flutter drive` 会临时使用测试入口构建应用，因此交付普通安装包时需最后重新执行 `flutter build apk --debug -t lib/main.dart`。本项目交付的安装包使用正常应用入口。

## 验证范围

iOS 和 Web 工程已生成，但本次未进行对应设备运行测试。在线鉴权、第三方登录、邮件发送、真实支付、完整歌曲和系统推送不属于当前本地演示实现；详见项目 README 的演示边界。
