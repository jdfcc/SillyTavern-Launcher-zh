@echo off

:exit
echo %red_bg%[%time%]%reset% %red_fg_strong%��ֹ�����������Ľ���...%reset%
for /f %%a in ('type "%log_dir%\pids.txt"') do (
    taskkill /F /PID %%a
)
del "%log_dir%\pids.txt"
exit

