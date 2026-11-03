# 全部界面截图

以下 19 张 PNG 均由 Android 模拟器运行本项目后通过 Flutter 集成测试截取，保留原始输出尺寸。图片展示初始视口；列表、表单和隐私内容可继续滚动。

[返回项目说明](../README.md) · [项目架构](ARCHITECTURE.md)

## 界面总览

![全部 19 个界面](screenshots/overview.jpg)

## 单页截图

| 界面 | 实际应用截图 | Pixso 参考 |
| --- | --- | --- |
| 引导 · `onboarding` | <a href="screenshots/onboarding.png"><img src="screenshots/onboarding.png" width="200" alt="引导"></a> | [原始参考](design_reference/onboarding.png) |
| 登录 · `login` | <a href="screenshots/login.png"><img src="screenshots/login.png" width="200" alt="登录"></a> | [原始参考](design_reference/login.png) |
| 注册 · `register` | <a href="screenshots/register.png"><img src="screenshots/register.png" width="200" alt="注册"></a> | [原始参考](design_reference/register.png) |
| 验证码 · `otp` | <a href="screenshots/otp.png"><img src="screenshots/otp.png" width="200" alt="验证码"></a> | [原始参考](design_reference/otp.png) |
| 找回密码 · `forgot_password` | <a href="screenshots/forgot_password.png"><img src="screenshots/forgot_password.png" width="200" alt="找回密码"></a> | [原始参考](design_reference/forgot_password.png) |
| 重设密码 · `reset_password` | <a href="screenshots/reset_password.png"><img src="screenshots/reset_password.png" width="200" alt="重设密码"></a> | [原始参考](design_reference/reset_password.png) |
| 首页 · `home` | <a href="screenshots/home.png"><img src="screenshots/home.png" width="200" alt="首页"></a> | [原始参考](design_reference/home.png) |
| 即将上线与最近播放 · `upcoming` | <a href="screenshots/upcoming.png"><img src="screenshots/upcoming.png" width="200" alt="即将上线与最近播放"></a> | [原始参考](design_reference/upcoming.png) |
| 音乐库 · `music` | <a href="screenshots/music.png"><img src="screenshots/music.png" width="200" alt="音乐库"></a> | [原始参考](design_reference/music.png) |
| 播放列表与筛选 · `music_list` | <a href="screenshots/music_list.png"><img src="screenshots/music_list.png" width="200" alt="播放列表与筛选"></a> | [原始参考](design_reference/music_list.png) |
| 歌手详情 · `artist` | <a href="screenshots/artist.png"><img src="screenshots/artist.png" width="200" alt="歌手详情"></a> | [原始参考](design_reference/artist.png) |
| 正在播放 · `now_playing` | <a href="screenshots/now_playing.png"><img src="screenshots/now_playing.png" width="200" alt="正在播放"></a> | [原始参考](design_reference/now_playing.png) |
| 音乐分类 · `categories` | <a href="screenshots/categories.png"><img src="screenshots/categories.png" width="200" alt="音乐分类"></a> | [原始参考](design_reference/categories.png) |
| 个人中心 · `profile` | <a href="screenshots/profile.png"><img src="screenshots/profile.png" width="200" alt="个人中心"></a> | [原始参考](design_reference/profile.png) |
| 关注歌手 · `following` | <a href="screenshots/following.png"><img src="screenshots/following.png" width="200" alt="关注歌手"></a> | [原始参考](design_reference/following.png) |
| 设置 · `settings` | <a href="screenshots/settings.png"><img src="screenshots/settings.png" width="200" alt="设置"></a> | [原始参考](design_reference/settings.png) |
| 语言偏好 · `language` | <a href="screenshots/language.png"><img src="screenshots/language.png" width="200" alt="语言偏好"></a> | [原始参考](design_reference/language.png) |
| 卡片 · `cards` | <a href="screenshots/cards.png"><img src="screenshots/cards.png" width="200" alt="卡片"></a> | [原始参考](design_reference/cards.png) |
| 隐私说明 · `privacy` | <a href="screenshots/privacy.png"><img src="screenshots/privacy.png" width="200" alt="隐私说明"></a> | [原始参考](design_reference/privacy.png) |

## 重新生成

```sh
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d emulator-5554
```

截图脚本会预先解码本地图片后再取帧，避免快速切换到懒加载网格时截到尚未显示的封面。截图保持演示初始状态，未播放音频，也未输入真实账户或支付信息。
