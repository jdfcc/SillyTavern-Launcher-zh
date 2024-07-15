@echo off

:info_vram
title STL [VRAM INFO]
chcp 65001 > nul
cls
echo %blue_fg_strong%/ 主页 / 显存信息%reset%
echo -------------------------------------------------------------
REM Recommendations Based on VRAM Size
if %VRAM% lss 8 (
    echo %cyan_fg_strong%GPU 显存: %VRAM% GB%reset% - 建议使用OpenAI、Claude或Gemini等的API进行LLM使用, 
    echo 本地模型将导致内存错误或输出执行巨勾八慢
) else if %VRAM% lss 12 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - Can run 7B and 8B models. Check info below for BPW
    echo %blue_bg%╔════ BPW - Bits Per Weight ═════════════════════════════════╗%reset%
    echo %blue_bg%║                                                            ║%reset%
    echo %blue_bg%║* EXL2: 5_0                                                 ║%reset%
    echo %blue_bg%║* GGUF: Q5_K_M                                              ║%reset%
    echo %blue_bg%╚════════════════════════════════════════════════════════════╝%reset%
    echo.
) else if %VRAM% lss 22 (
    echo %cyan_fg_strong%GPU 显存: %VRAM% GB%reset% - 可以运行 7B, 8B and 13B参数的模型. 查看下面的BPW信息
    echo %blue_bg%╔════ BPW - Bits Per Weight ═════════════════════════════════╗%reset%
    echo %blue_bg%║                                                            ║%reset%
    echo %blue_bg%║* EXL2: 6_5                                                 ║%reset%
    echo %blue_bg%║* GGUF: Q5_K_M                                              ║%reset%
    echo %blue_bg%╚════════════════════════════════════════════════════════════╝%reset%
    echo.
) else if %VRAM% lss 25 (
    echo %cyan_fg_strong%GPU 显存: %VRAM% GB%reset% - 能很好的运行 7B, 8B, 13B, 30B, 和一些高效的 70B 参数模型. 大参数本地模型将运行良好
    echo.
    echo ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    echo ║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                             ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2 can produce, near        ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ unquantized performance.                                ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ Very similar to 8.0, good tradeoff of size vs           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ performance, recommended.                               ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5, but usable on 8GB cards. ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight, slightly higher        ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ quality.                                                ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.                 ║
    echo ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    echo.
) else if %VRAM% gtr 25 (
    echo %cyan_fg_strong%GPU 显存: %VRAM% GB%reset% - Suitable for most models, including larger LLMs. 
    echo 如果您拥有超过25GB的显存，您可以选择拥有自己的专业模型
) else (
    echo An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.
)
echo.

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
)

echo.
echo %blue_bg%╔════ GPU INFO ═════════════════════════════════╗%reset%
echo %blue_bg%║                                               ║%reset%
echo %blue_bg%║* %gpu_info:~1%                   ║%reset%
echo %blue_bg%║                                               ║%reset%
echo %blue_bg%╚═══════════════════════════════════════════════╝%reset%
echo.

endlocal

echo 您想打开显存计算器网站检查兼容型号吗？
set /p uservram_choice=检查兼容型号? [Y/N] 

REM Check if user input is not empty and is neither "Y" nor "N"
if not "%uservram_choice%"=="" (
    if /i not "%uservram_choice%"=="Y" if /i not "%uservram_choice%"=="N" (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 输入无效。请输入Y表示是，或输入N表示否%reset%
        pause
        goto :info_vram
    )
)

if /i "%uservram_choice%"=="Y" ( start https://sillytavernai.com/llm-model-vram-calculator/?vram=%VRAM%
)
goto :home