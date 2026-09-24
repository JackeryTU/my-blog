@echo off
chcp 65001 >nul
setlocal

echo 开始同步到 Netlify（推送源码）...
git add .
if errorlevel 1 goto :error

git diff --cached --quiet
if errorlevel 1 (
  git commit -m "update"
  if errorlevel 1 goto :error
) else (
  echo 没有新的源码变更需要提交。
)

git push
if errorlevel 1 goto :error

echo 开始构建并推送到 GitHub Pages（使用独立配置）...
call npx hexo clean
if errorlevel 1 goto :error

call npx hexo generate --config _config.yml,_config.github.yml
if errorlevel 1 goto :error

call npx hexo deploy --config _config.yml,_config.github.yml
if errorlevel 1 goto :error

echo 全部完成！
pause
exit /b 0

:error
echo 部署失败，请查看上方的具体错误信息。
pause
exit /b 1
