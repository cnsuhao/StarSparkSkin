` 喵大斯微信订阅号已开通：请在微信>通讯录>公众号>搜索“喵大斯AS3教程”以获取最及时的AS3经验知识。`
![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/wx-100x100.jpg?dir=0&filepath=_assets%2Fwx-100x100.jpg&oid=54df34f62326259a98df71256f83949d961d4a56&sha=1652abcf24111cbd8bfe9fd8b28c9c65f0f215a2)

StarSparkSkin v1.5
=====
-----
` StarSparkSkin 更新版本到 v1.5`

  * 1、设计实现 DatePicker 代替原生 DateChooser，完成日期选择功能，支持 “年、月、日” 三种状态切换选择，而不是生硬的通过按钮控制
  * 2、重新设计实现 DateField，利用 DatePicker 来完成日期表单控件
  * 3、DateField 和 DatePicker 都支持皮肤主题，可以自定义外观

##相关配图：
  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/date1.png?dir=0&filepath=_assets%2Fdate1.png&oid=eabc5837ea6c9b1789a373b9efb558870afe74b3&sha=78379048a6b4f36d71957651a2af70d3212c4725)
  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/date2.png?dir=0&filepath=_assets%2Fdate2.png&oid=a7815699eccc3956910b86edb36cb514d1be927c&sha=78379048a6b4f36d71957651a2af70d3212c4725)


StarSparkSkin v1.4
=====
-----
` StarSparkSkin 更新版本到 v1.4`

  * 1、重新设计实现 HtmlText，主要用于快速渲染 HTML 富文本内容，并支持选择和复制
  * 2、优化 GridHtmlItemRenderer 细节和性能
  * 3、增加 LinkButton 组件，支持 url、target、title 和默认支持点击打开网页功能，支持皮肤控制



StarSparkSkin v1.3
=====
-----
` StarSparkSkin 更新版本到 v1.3`

  * 1、增加表单自动验证器 FormValidator
  * 说明：一般表单验证会存在多个验证器，比如“字符串验证、电话号码验证、邮箱验证...”等等，而需要进行下一步操作，就得逐个检测这些检测器是否都正确通过。
  * 这势必有些麻烦，而 FormValidator 可以方便的对多个验证器进行统一管理，只要所有验证器结果都通过了，则会统一派发一个 VALID 事件，来提醒进行下一步的逻辑处理。
  
##相关配图：
  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/form.png?dir=0&filepath=_assets%2Fform.png&oid=6b879dd3f3c4e5b2805234a7057902223f889e69&sha=78379048a6b4f36d71957651a2af70d3212c4725)



StarSparkSkin v1.2
=====
-----
` StarSparkSkin 更新版本到 v1.2`

  * 1、增加 Form 相关样式支持，统一风格
  * 2、增加 errorTip 样式支持，优化绘制逻辑
  * 3、重新设计 ToolTipBorder，支持4个方向的指示符号，优化大量绘制细节，美化外观
  
##相关配图：
  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/tip.png?dir=0&filepath=_assets%2Ftip.png&oid=4b17f1af7ca465561cd9e8ec5c49836a9db998e8&sha=78379048a6b4f36d71957651a2af70d3212c4725)


StarSparkSkin v1.1
=====
-----
` StarSparkSkin 更新版本到 v1.1`

  * 1、去除 HtmlLabel、HtmlTextBase　组件
  * 2、继承 UIComponent 重新实现 IGridItemRenderer 接口设计 starskin.itemRenderers.GridHtmlItemRenderer
  * 3、GridHtmlItemRenderer 在 DataGrid 中显示 HTML 速度达到极致。在企业开发中推荐使用，所有文本内容的 ItemRenderer 都可以通过此组件来表现。并且支持 color、fontSize、fontFamily 等多种文本样式。
  * 4、优化 GridActualHeightLayout，现在可以真实的体现 DataGrid 的实际高度，而不必出现滚动条
  * 5、优化 starskin.comps.UITextField 细节，提升效率

StarSparkSkin v1.0
=====
-----

` StarSparkSkin 扁平化蓝色主题 Spark 皮肤`

##这是一个应用于一套 OA 系统的主题皮肤，包含：
  * 1、优化 DataGrid，利用 TextField 大大提升其显示 HTML 的速度
  * 2、重写 TabBar，利用它完成 TabViewer 代替 mx:TabNavigator ，并且支持皮肤、支持关闭按钮，主要用于页面导航。
  * 3、制作页面模板，继承 Panel，支持皮肤
  * 5、制作页码导航控件，支持皮肤。用以支持分页控制，支持 “首页、尾页、上一页、下一页、页码范围、页码跳转”
  * 6、覆盖常用的大部分组件皮肤

##相关配图：
  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/0.png?dir=0&filepath=_assets%2F0.png&oid=208ed44decdf142ebb8d07aa03e86e1b69071e7c&sha=78379048a6b4f36d71957651a2af70d3212c4725)

  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/1.jpg?dir=0&filepath=_assets%2F1.jpg&oid=c7e5599a69b5edcd2740208e2569837daedfee6f&sha=78379048a6b4f36d71957651a2af70d3212c4725)
  
  * ![image](https://git.oschina.net/starfire/StarSparkSkin/raw/master/_assets/2.jpg?dir=0&filepath=_assets%2F2.jpg&oid=2287838d626ae9884da38cb11764dc213c08266b&sha=78379048a6b4f36d71957651a2af70d3212c4725)