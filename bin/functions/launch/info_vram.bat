@echo off

:info_vram
title STL [VRAM INFO]
chcp 65001 > nul
cls
echo %blue_fg_strong%/ ��ҳ / �Դ���Ϣ%reset%
echo -------------------------------------------------------------
REM Recommendations Based on VRAM Size
if %VRAM% lss 8 (
    echo %cyan_fg_strong%GPU �Դ�: %VRAM% GB%reset% - ����ʹ��OpenAI��Claude��Gemini�ȵ�API����LLMʹ��, 
    echo ����ģ�ͽ������ڴ��������ִ�о޹�����
) else if %VRAM% lss 12 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - Can run 7B and 8B models. Check info below for BPW
    echo %blue_bg%�X�T�T�T�T BPW - Bits Per Weight �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[%reset%
    echo %blue_bg%�U                                                            �U%reset%
    echo %blue_bg%�U* EXL2: 5_0                                                 �U%reset%
    echo %blue_bg%�U* GGUF: Q5_K_M                                              �U%reset%
    echo %blue_bg%�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a%reset%
    echo.
) else if %VRAM% lss 22 (
    echo %cyan_fg_strong%GPU �Դ�: %VRAM% GB%reset% - �������� 7B, 8B and 13B������ģ��. �鿴�����BPW��Ϣ
    echo %blue_bg%�X�T�T�T�T BPW - Bits Per Weight �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[%reset%
    echo %blue_bg%�U                                                            �U%reset%
    echo %blue_bg%�U* EXL2: 6_5                                                 �U%reset%
    echo %blue_bg%�U* GGUF: Q5_K_M                                              �U%reset%
    echo %blue_bg%�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a%reset%
    echo.
) else if %VRAM% lss 25 (
    echo %cyan_fg_strong%GPU �Դ�: %VRAM% GB%reset% - �ܺܺõ����� 7B, 8B, 13B, 30B, ��һЩ��Ч�� 70B ����ģ��. ���������ģ�ͽ���������
    echo.
    echo �X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
    echo �U Branch �U Bits �U lm_head bits �U VRAM - 4k �U VRAM - 8k �U VRAM - 16k �U VRAM - 32k �U Description                                             �U
    echo �U�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�U
    echo �U 8.0    �U 8.0  �U 8.0          �U 10.1 GB   �U 10.5 GB   �U 11.5 GB    �U 13.6 GB    �U Maximum quality that ExLlamaV2 can produce, near        �U
    echo �U        �U      �U              �U           �U           �U            �U            �U unquantized performance.                                �U
    echo �U�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�U
    echo �U 6.5    �U 6.5  �U 8.0          �U 8.9 GB    �U 9.3 GB    �U 10.3 GB    �U 12.4 GB    �U Very similar to 8.0, good tradeoff of size vs           �U
    echo �U        �U      �U              �U           �U           �U            �U            �U performance, recommended.                               �U
    echo �U�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�U
    echo �U 5.0    �U 5.0  �U 6.0          �U 7.7 GB    �U 8.1 GB    �U 9.1 GB     �U 11.2 GB    �U Slightly lower quality vs 6.5, but usable on 8GB cards. �U
    echo �U�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�U
    echo �U 4.25   �U 4.25 �U 6.0          �U 7.0 GB    �U 7.4 GB    �U 8.4 GB     �U 10.5 GB    �U GPTQ equivalent bits per weight, slightly higher        �U
    echo �U        �U      �U              �U           �U           �U            �U            �U quality.                                                �U
    echo �U�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�U
    echo �U 3.5    �U 3.5  �U 6.0          �U 6.4 GB    �U 6.8 GB    �U 7.8 GB     �U 9.9 GB     �U Lower quality, only use if you have to.                 �U
    echo �^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a
    echo.
) else if %VRAM% gtr 25 (
    echo %cyan_fg_strong%GPU �Դ�: %VRAM% GB%reset% - Suitable for most models, including larger LLMs. 
    echo �����ӵ�г���25GB���Դ棬������ѡ��ӵ���Լ���רҵģ��
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
echo %blue_bg%�X�T�T�T�T GPU INFO �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[%reset%
echo %blue_bg%�U                                               �U%reset%
echo %blue_bg%�U* %gpu_info:~1%                   �U%reset%
echo %blue_bg%�U                                               �U%reset%
echo %blue_bg%�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a%reset%
echo.

endlocal

echo ������Դ��������վ�������ͺ���
set /p uservram_choice=�������ͺ�? [Y/N] 

REM Check if user input is not empty and is neither "Y" nor "N"
if not "%uservram_choice%"=="" (
    if /i not "%uservram_choice%"=="Y" if /i not "%uservram_choice%"=="N" (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[����] ������Ч��������Y��ʾ�ǣ�������N��ʾ��%reset%
        pause
        goto :info_vram
    )
)

if /i "%uservram_choice%"=="Y" ( start https://sillytavernai.com/llm-model-vram-calculator/?vram=%VRAM%
)
goto :home