@echo off
git add .
set /P commit=Enter the commit description: 
git commit -m "%commit%"
git push -u origin master
echo [92mSuccesfully pushed to master![0m