@echo off

set rootpath=%userprofile%\.svm
set /p version=<%rootpath%\version
%rootpath%\versions\%version%\scriptcs.exe %*