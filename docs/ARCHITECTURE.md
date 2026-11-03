# 架构与设计实现说明

## 设计读取范围

通过 Pixso 工具读取页面分类、19 个顶层 Frame、节点树、文字信息、图片填充与主要字体；逐个导出参考截图，并导出可复用的局部图片。当前连接文件只有 `Page 1`（`1:1`），参考尺寸为 **414 × 896**。

Pixso 首次 Flutter 导出以整页 PNG 为主体，不适合作为可操作应用。最终工程使用原生 Flutter 重建界面，局部图片仅用于封面、照片、国旗和推广背景，原始整页 PNG 不参与应用运行。

## 页面映射

| 功能分组 | Pixso Frame | 节点 ID | Flutter 路由 | 实现文件 |
| --- | --- | --- | --- | --- |
| 账户引导 | Onboarding | 1:686 | /onboarding | auth_screens.dart |
| 账户引导 | Login Page 3 | 1:737 | /login | auth_screens.dart |
| 账户引导 | Login Page 4 | 1:826 | /register | auth_screens.dart |
| 账户引导 | OTP Verification | 1:914 | /otp | auth_screens.dart |
| 账户引导 | Forget Password | 1:971 | /forgot_password | auth_screens.dart |
| 账户引导 | Reset Password | 1:1019 | /reset_password | auth_screens.dart |
| 音乐探索 | Home Page | 1:558 | /home | browse_screens.dart |
| 音乐探索 | Upcomming | 1:423 | /upcoming | browse_screens.dart |
| 音乐探索 | Music | 1:241 | /music | browse_screens.dart |
| 音乐探索 | Music 2 | 1:1155 | /music_list | browse_screens.dart |
| 音乐探索 | Artist | 1:120 | /artist | browse_screens.dart |
| 音乐探索 | Catagory | 1:1269 | /categories | browse_screens.dart |
| 播放 | Now Playing | 1:352 | /now_playing | player_screen.dart |
| 账户设置 | Profile | 1:2 | /profile | account_screens.dart |
| 账户设置 | Following | 1:1344 | /following | account_screens.dart |
| 账户设置 | Settings | 1:1467 | /settings | account_screens.dart |
| 账户设置 | Language | 1:1081 | /language | account_screens.dart |
| 账户设置 | Card | 1:1654 | /cards | account_screens.dart |
| 账户设置 | Privacy Policy | 1:1753 | /privacy | account_screens.dart |

## 分层职责

`MusicApp` 统一生成路由；启动时只创建目标初始路由，避免引导/登录页下方出现多余首页。底部导航以替换路由的方式切换顶层界面；详情、设置和表单流程使用入栈跳转。

`MusicStore` 作为应用级 `ChangeNotifier`，由 `MusicScope` 注入控件树。收藏、关注、当前歌曲和偏好更新后通知界面；播放进度和播放器状态订阅原生音频事件，而非通过定时器模拟音频。

`catalog.dart` 提供不可变的 `Song`、`Artist` 模型与示例目录。搜索根据歌名及歌手匹配并按 ID 去重；歌手详情优先展示匹配歌手的示例歌曲。

`LocalSettings` 封装 `SharedPreferencesAsync`。启动时恢复显示名、演示邮箱、登录偏好、收藏、关注、试听标记、语言和通知开关。本地反馈单独保存；不保存密码、OTP 或完整卡号。未选择 Remember me 时，本次会话仍可使用应用，下次启动重新进入引导。

音频通过 `audioplayers` 播放 `assets/audio/preview.wav`。播放状态、时长、进度和结束事件由插件提供。页面退出不会销毁播放器，以便小播放器与详情页共享状态；退出账户会暂停音频。状态对象释放时取消订阅并释放播放器。

## 控件复用与布局

- `AppPage`：统一安全区、标题栏、返回操作、底部按钮和可选底部导航。
- `GradientButton`：统一渐变、圆角和点击语义，支持主按钮和小尺寸标签按钮。
- `Artwork`：统一局部图片路径、圆角与裁切。
- `SongTile` / `SongGrid` / `ArtistTile`：共享歌曲和歌手展示。
- `CatalogSearch` / `TrackSearch`：首页实时搜索和全局搜索。
- `FormFieldBlock`：统一字段标签、校验和密码显隐。
- `MiniPlayer`：复用全局歌曲、播放状态与进度。

页面使用流式布局、列表与网格；列表可滚动，表单在键盘弹出后也可滚动。播放器会根据可用高度调整封面，短屏允许继续滚动。内容最大宽度为 560，重点验收手机场景；320 和 414 逻辑像素宽度均有布局测试。系统状态栏采用真实设备状态，不绘制参考稿的虚拟状态栏。

主色为黑色、`#FF8D57`、`#FF2464`；正文次要色为 `#90959B`，输入区域为 `#303030`。Roboto Regular / Bold 随包分发，许可证位于 `assets/fonts/LICENSE.txt`。

## 为运行体验补充的行为

参考稿中的静态 UI 补充了表单校验、密码确认、验证码倒计时/重发、搜索空状态、播放错误提示、收藏/下载筛选、跟随状态变化、支付确认和注销确认。个人中心的关注与收藏数量由实际演示状态计算；部分原稿拼写在界面中修正。

语言服务、在线账户、真实支付、完整音乐目录和系统推送未实现；界面明确说明相应流程是演示。隐私页面使用与本地演示一致的说明，未照搬参考稿中不适用的网站条款。

## 后续扩展位置

若接入真实服务，可在数据层增加目录、鉴权和支付接口，保留页面控件与状态订阅方式；将 `Song` 扩展音频地址与真实时长，替换 `playSong` 中的本地音源。国际化可在保留语言选择状态的基础上引入 Flutter 的 ARB / l10n 资源。

素材来自用户提供的设计参考，保留用于项目还原；如需公开发行，应由项目方确认相应素材使用范围。
