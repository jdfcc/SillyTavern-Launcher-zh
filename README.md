<a name="readme-top"></a>

<div align="center">

<img height="160" src="st-launcher.ico">

<h1 align="center">SillyTavern Launcher汉化版 - (STL)</h1>

<p align="center">

  
[![GitHub Stars](https://img.shields.io/github/stars/vircus/SillyTavern-Launcher-zh.svg)](https://github.com/vircus/SillyTavern-Launcher-zh/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/vircus/SillyTavern-Launcher-zh.svg)](https://github.com/vircus/SillyTavern-Launcher-zh/network)
[![GitHub Issues](https://img.shields.io/github/issues/vircus/SillyTavern-Launcher-zh.svg)](https://github.com/vircus/SillyTavern-Launcher-zh/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/vircus/SillyTavern-Launcher-zh.svg)](https://github.com/vircus/SillyTavern-Launcher-zh/pulls)
</div>

🔧 # 安装
### 🖥️ window

##方法一： 

1.安装git（安装过git可以跳过），在键盘上：按“WINDOWS + R”打开“运行”对话框。然后，运行以下命令安装 git：
```shell
cmd /c winget install -e --id Git.Git
```
2. 在键盘上：按“WINDOWS + E”** 打开文件资源管理器，然后导航到要安装启动器的文件夹。进入所需文件夹后，在地址栏中键入“cmd”，然后按回车键。然后，运行以下命令：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher && start installer.bat
```
以后点击laucher.bat运行，退出ST前最好按下ctrl+c。

##方法二： 

直接下载zip，复制以下链接在浏览器打开
```shell
https://github.com/vircus/SillyTavern-Launcher-zh/archive/refs/heads/main.zip
```
解压后双击打开 install.bat安装，以后点击laucher.bat运行，退出ST前最好按下ctrl+c。

### 🐧 Linux
1. 打开你喜欢的终端并安装 git
2. Git 克隆 Sillytavern-Launcher：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```

3. 以以下方式开始 installer.sh：
```shell
chmod +x install.sh && ./install.sh
```
4. 安装后，通过以下方式启动 launcher.sh：
```shell
chmod +x launcher.sh && ./launcher.sh
```


### 🍎 Mac
1. 打开终端并安装 brew：
```shell
/bin/bash -c “$（curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh）”
```
2. 使用以下命令安装 git：
```shell
brew install git
```
3. Git 克隆 Sillytavern-Launcher：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
4. 以以下方式开始 installer.sh：
```shell
chmod +x install.sh && ./install.sh
```
5. 安装后，通过以下方式启动 launcher.sh：
```shell
chmod +x launcher.sh && ./launcher.sh
```

✨ # 特性
* 能够自动安装带有可选应用的核心app：
  * SillyTavern,
  * Extras,
  * XTTS,
  * 7-Zip,
  * FFmpeg,
  * Node.js,
  * yq,
  * Visual Studio BuildTools,
  * CUDA Toolkit

* 能够自动安装文本完成应用程序：
  * Text generation web UI oobabooga
  * koboldcpp
  * TabbyAPI

* 能够自动安装图像生成应用程序：
  * Stable Diffusion web UI
  * Stable Diffusion web UI Forge
  * ComfyUI
  * Fooocus

*自动更新所有应用程序
*备份和恢复SillyTavern
* 开关分支
* 模块编辑器
* 应用程序安装程序和卸载程序来管理应用程序
* 故障排除菜单可解决最常见的问题

#问题或建议？

|[![][discord-shield-badge]][discord-link] |[加入我们的 Discord 社区！](https://discord.gg/sillytavern)获得支持，分享角色和提示。|
|:---------------------------------------- |:------------------------------------------------------------------------------------------------------- |

# 屏幕截图


<div align="right">

[![][back-to-top]](#readme-top)
    
</div>


<!-- LINK GROUP -->
[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square
[discord-link]: https://discord.gg/sillytavern
[discord-shield]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square
[discord-shield-badge]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=for-the-badge
