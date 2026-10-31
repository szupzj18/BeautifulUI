# BeautifulUI 移植报告

日期：2026-10-30。

## 做了什么

- 把 beautifului.dev 的 21 个 Web 组件移植成 SwiftUI 组件库 `BeautifulUI`（iOS 26 起，macOS 26 也能编译），没有第三方依赖。库代码约 8,500 行，58 个单测全部通过。
- 写了 Catalog 演示 App（XcodeGen，Xcode 26.0 编译通过）：首页 Gallery 按原站顺序整页展示全部实时演示，另有列表视图和单组件页，示例数据照搬原站的冰淇淋主题。
- 每个组件都在模拟器上截了图，拼成状态图放在 `compare/`（21 张，每张含深浅色和多个交互状态）。
- 按组件逐个提交。

## 怎么做的

1. **拿到原版的真实实现**。原站页面的 RSC 数据里内嵌了每个组件的 React 源码（这是站点“View code”功能用的），我把 21 份源码提取出来放在本地（`reference/source/`，不入库）。移植时逐行照着原版的数值来：尺寸、间距、时序、缓动曲线、关键帧。
2. **设计 token**。从站点 CSS 里读出深浅两套颜色（oklch 换算成 sRGB）、圆角、阴影、缓动曲线和关键帧，写在 [`docs/tokens.md`](../tokens.md)，再落成 `BUIColors`、`BUIRadii`、`BUIElevation`、`BUICurve`、`BUIKeyframes`。
3. **对照截图**。只读访问原站，按 402pt 宽（iPhone 17 Pro）截图。原站的演示动画只在页面加载时播放一次，所以有时间轴的组件每张截图都重新加载页面，在指定时刻截。站点会弹出订阅框，截图前点遮罩关掉，没有填写或提交任何表单。原站的输入框也没碰：Chat、Search 这类需要打字的状态，只在 iOS 端用启动参数展示。这些原站截图只在本地对照用，不入库。
4. **逐个组件循环**：实现，在模拟器上截图，和原站截图并排对照，按像素找差异再修，补单测，提交。

## 替你做的选择

| 选择 | 理由 | 想改的话 |
|---|---|---|
| 用 SF Pro 和 SF Mono，不打包 Inter 和 JetBrains Mono | 库不带字体资源，也省掉字体许可的问题 | 在 `BUITextStyle` 里换成 `.custom` 字体 |
| 原站 px 一比一换成 pt，字号跟随 Dynamic Type | 默认字号下版式和原站一致 | 宿主想要更大的字，可以给 `BUITheme` 加一个字号缩放系数（见下文） |
| 等宽字默认字距 -0.03em | SF Mono 比 JetBrains Mono 宽 3%；不收紧的话，chip 的换行位置会和原站不一样 | 改 `BUITextStyle` 的默认 tracking |
| 悬停一律改成按下 | iOS 没有悬停；只在悬停时出现的控件改为点按或按下时出现 | — |
| 主题通过环境注入（`.buiTheme(_:)`） | 宿主可以把自己的 token 映射进来，不用改组件代码 | — |
| `Color(light:dark:)` 和 `Color(hex:)` 不公开 | 宿主 App 里可能已有同名同参数的初始化方法，公开后它现有的调用会产生歧义 | — |
| Prompt Bar 的状态放在 `@Observable PromptBarModel` | 宿主（以及 Catalog 重放原站的自动演示）可以驱动草稿、菜单和模型选择 | — |
| Records Table：横向滚动时公司列收窄到 120pt，去掉拖动调列宽 | 270pt 的固定列在手机上会挡住所有其他列 | `RecordsTable.compactCompanyWidth` |
| 原站的视频、桌面截图、图表库、WebGL shader、图标库都没有引入 | 不带第三方代码和素材；分别用占位视图、Canvas、渐变、SF Symbols 代替 | 这些位置都可以传入自己的视图 |
| 对照时只取 402pt 宽的原站 | 和 iPhone 的宽度相同，才能直接比较 | 桌面宽的截图也抓了，只留在本地 |

## 性能

目标是主线程稳定 60 帧。组件按这些原则写：

- 循环动画尽量交给 SwiftUI 的动画系统，不在每帧重新计算 body。文字闪光、转圈指示器、脉冲点都是对单个属性做 repeatForever 动画。
- 必须逐帧计算的地方用 `TimelineView` 加 `Canvas`，并限制刷新频率：像素加载器在 Canvas 里画 9 个格子；耗时计时器每 0.1 秒刷新一次；听写电平表限制在 30fps。
- 列表类组件都用稳定的 id；Gallery 和 Records Table 用 Lazy 容器，屏幕外的内容不布局、不播放动画。
- 流式文本整段只用一个 `Text`，每来一个 token 只更新这一个视图，不会每个词一个视图。

**还没做的**：没有用 Instruments 实测帧率。建议接入宿主 App 时，把 Thinking、Streaming Text、Loading State 放进真实的对话列表里，用 Instruments 录一次。

## 下一步：接进宿主 App

### 1. 先替换哪几处

按“替换收益大、改动面小”排序：

1. **Thinking**（`ThinkingState`）→ 代理推理和步骤的折叠展示。宿主里如果已有 `ThinkingRow`，接入时要用 `BeautifulUI.ThinkingRow` 区分。
2. **Tool Chips**（`ToolChips`）→ 工具调用行加改动文件 chip。宿主如果已有 diff 配色，可以映射进 `BUIColors` 的 green/red。
3. **Loading State**（`LoadingState`）→ 长任务的状态行，带耗时计时器。
4. **Streaming Text**（`StreamingText`）→ 带来源引用和追问建议的流式回答。宿主里如果有同名类型，接入时同样要加模块前缀。
5. **Approval Card**（`ApprovalCard`）→ 需要用户确认的提问。
6. **Code Block**（`CodeBlock`）→ 代码和 diff 展示。同名类型同样要加前缀。
7. **Prompt Bar** 最后再考虑：输入框通常是宿主的核心交互，应该先在一个次要入口试用。

### 2. 和宿主的主题 token 怎么协调

如果宿主有自己的主题（颜色、圆角随风格切换），在根视图上按当前风格注入一次 `BUITheme` 就够了（下面是示意，`HostTheme` 换成宿主自己的类型）：

```swift
extension BUITheme {
    static func host(_ style: HostStyle) -> BUITheme {
        var colors = BUIColors.standard
        colors.page = HostTheme.pageBackground(style)
        colors.surface = HostTheme.card(style)
        colors.canvas = HostTheme.pageBackground(style)
        colors.line = HostTheme.cardStroke
        colors.accent = HostTheme.accent(style)
        colors.green = HostTheme.positive
        colors.red = HostTheme.danger
        colors.orange = HostTheme.caution
        // ink / ink2 / ink3 用 .primary / .secondary / .tertiary，跟着系统走
        return BUITheme(colors: colors, radii: BUIRadii(chip: 6, control: HostTheme.controlRadius, card: HostTheme.cardRadius))
    }
}

RootView().buiTheme(.host(model.style))
```

- 扁平卡片加细线描边的风格最接近原版，直接映射即可。
- 卡片底色用材质（比如 `.glassEffect`）的风格：可以给 `buiSurface` 加一个可选的 `ShapeStyle` 填充。
- 圆角更大、阴影更软的风格：圆角通过 `BUIRadii` 放大；阴影需要给 `BUIElevation` 加一个按主题覆盖的入口（目前阴影是固定的两层）。

### 3. 接入前要补的两处

- **字号**：BeautifulUI 沿用原站偏小的桌面字号（13pt 左右），而手机 App 的正文常用系统 `.body`（17pt）。`BUITheme` 的 `typeScale` 在 `BUIFontModifier` 里乘上去，可以设成 1.15 左右。
- **类型重名**：`CodeBlock`、`ContextCards`、`StreamingText`、`ThinkingRow`、`ToolCall` 这些名字，宿主里可能也有。Swift 会优先用宿主本模块里的定义，所以现有代码不受影响；用到库里的同名类型时写 `BeautifulUI.CodeBlock`，或者在宿主里加 `typealias BUICodeBlock = BeautifulUI.CodeBlock`。

### 4. 接入方式

用本地路径依赖，或者仓库地址依赖，写法见 [README](../../README.md#installation)。

## 产物

- 代码：`BeautifulUI/`、`Catalog/`（含走查 UI 测试）、`tools/`
- 状态图：`compare/01-…jpg` 到 `compare/21-…jpg`；设计 token：`docs/tokens.md`
- 许可：`LICENSE`（本库，MIT，ChrisPan）、`LICENSE-beautifului` 和 `NOTICE`（原项目）
