# AliyunContentDetect
运用阿里云做图片、视频等内容审查
# 设计概要
该demo模块及类设计如下图所示：
![](https://github.com/bluemap/AliyunContentDetect/blob/master/Example/screenshots/class.jpg?raw=true)
主要分应用模块及服务模块。
AliyunContentDetectService为阿里云服务service，提供统一的图片及视频检测接口。
AliyunContentDetectTask为封装阿里云服务的具体task。
BMViewController为服务入口界面。
BMImageAndVideoDetectViewController为内容检测界面。
应用模块及服务模块共同依赖AFNetworking等第三方库。

# 使用说明
### 修改配置
下载本项目代码，用Xcode打开Example中的AliyunContentDetect.xcworkspace工程，并修改如下所示配置
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#pragma mark 这里设置阿里云的accesskey及secret(需要去阿里云注册账号及开通相关服务)
[AliyunContentDetectService setAccessKey:@"set accessKey" secretKey:@"set secret"];
return YES;
}
```
### 编译执行
编译运行，如果提示pod相关错误，可以执行pod install尝试修复
正常情况下界面效果如下

![](https://github.com/bluemap/AliyunContentDetect/blob/master/Example/screenshots/main.png?raw=true)

点击相应选项能够进入检测详情页面
图片鉴黄界面如下图所示，顶部输入栏允许输入图片地址，点完成后将在图片展示区添加一张图片
点击图片，开始检测，检测结果将在底部文本框显示

![](https://github.com/bluemap/AliyunContentDetect/blob/master/Example/screenshots/imageporn.png?raw=true)

图片涉政检测

![](https://github.com/bluemap/AliyunContentDetect/blob/master/Example/screenshots/imageface.png?raw=true)

视频涉黄检测如下图所示，与图片鉴黄类似，但是视频鉴黄不能马上显示结果，需要30s轮询一次检测结果

![](https://github.com/bluemap/AliyunContentDetect/blob/master/Example/screenshots/videoporn.png?raw=true)

### 打包测试
修改bundle identifier并设置相关证书，打包ipa后上传[蒲公英](https://www.pgyer.com/)或相关平台生成内部测试包供下载使用
打包可借鉴:[https://github.com/hades0918/ipapy](https://github.com/hades0918/ipapy)

### 接口调用分析
在阿里云的管理控制台我们可以看到接口调用情况及内容检测结果。
![](https://github.com/bluemap/AliyunContentDetect/blob/master/Example/screenshots/ananyze.png?raw=true)
### 备注
相关默认数据只用来测试使用，请务随意传播


