@echo off

if "%1" == "-f" goto yes
if "%1" == "-F" goto yes

set /P ANSWER="ボリュームマウントで作成されたファイルを削除します (Y/N)？"

if /i {%ANSWER%}=={y} (goto :yes)
if /i {%ANSWER%}=={yes} (goto :yes)

goto :end

:yes

set TARGET=redmine\*

del /S /Q %TARGET%
for /D %%1 in (%TARGET%) do echo 削除したディレクトリ - %%1 & rmdir /S /Q %%1

:end
