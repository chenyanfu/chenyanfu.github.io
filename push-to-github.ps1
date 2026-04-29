# GitHub 自动推送脚本
# 使用方法：右键以 PowerShell 运行，按提示输入 GitHub Token

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GitHub Pages 自动推送工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Git
$gitPath = "$env:TEMP\MinGit\cmd\git.exe"
if (-not (Test-Path $gitPath)) {
    $gitPath = "git"
}

# 配置信息
$githubUser = "xfchen"
$repoName = "xfchen.github.io"
$email = "1541952740@qq.com"

Write-Host "GitHub 用户名: $githubUser" -ForegroundColor Green
Write-Host "仓库名: $repoName" -ForegroundColor Green
Write-Host "邮箱: $email" -ForegroundColor Green
Write-Host ""

# 获取 Token
$token = Read-Host -Prompt "请输入你的 GitHub Personal Access Token (输入时不会显示)" -AsSecureString
$tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

if ([string]::IsNullOrWhiteSpace($tokenPlain)) {
    Write-Host "错误: Token 不能为空！" -ForegroundColor Red
    exit 1
}

# 验证 Token
Write-Host ""
Write-Host "正在验证 Token..." -ForegroundColor Yellow

try {
    $headers = @{
        Authorization = "token $tokenPlain"
        Accept = "application/vnd.github.v3+json"
    }
    $userInfo = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method GET
    Write-Host "Token 验证成功！用户: $($userInfo.login)" -ForegroundColor Green
} catch {
    Write-Host "Token 验证失败！请检查 Token 是否正确。" -ForegroundColor Red
    Write-Host "错误: $_" -ForegroundColor Red
    exit 1
}

# 检查仓库是否存在
Write-Host ""
Write-Host "正在检查仓库是否存在..." -ForegroundColor Yellow

try {
    $repoInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$githubUser/$repoName" -Headers $headers -Method GET
    Write-Host "仓库已存在: $repoName" -ForegroundColor Green
} catch {
    # 仓库不存在，创建它
    Write-Host "仓库不存在，正在创建..." -ForegroundColor Yellow
    
    $body = @{
        name = $repoName
        description = "xfchen (chenyanfu) 的个人主页 - GitHub Pages"
        private = $false
        auto_init = $false
    } | ConvertTo-Json
    
    try {
        $newRepo = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers -Method POST -Body $body -ContentType "application/json"
        Write-Host "仓库创建成功！" -ForegroundColor Green
    } catch {
        Write-Host "仓库创建失败！" -ForegroundColor Red
        Write-Host "错误: $_" -ForegroundColor Red
        exit 1
    }
}

# 设置 git 凭证（使用 credential.helper store 临时存储）
Write-Host ""
Write-Host "正在配置 Git 凭证..." -ForegroundColor Yellow

$repoUrl = "https://$tokenPlain@github.com/$githubUser/$repoName.git"

# 设置远程 URL 为带 token 的版本
& $gitPath remote set-url origin $repoUrl

# 配置用户信息
& $gitPath config user.name "$githubUser"
& $gitPath config user.email "$email"

# 推送
Write-Host ""
Write-Host "正在推送到 GitHub..." -ForegroundColor Yellow
Write-Host ""

Push-Location d:\git_prj

try {
    # 先拉取（如果仓库有初始提交）
    $pullOutput = & $gitPath pull origin master --allow-unrelated-histories 2>&1
    if ($LASTEXITCODE -ne 0) {
        # 可能是一个空仓库，忽略错误
    }
    
    # 推送
    $pushOutput = & $gitPath push -u origin master 2>&1
    if ($LASTEXITCODE -ne 0) {
        # 尝试 main 分支
        $pushOutput = & $gitPath push -u origin main 2>&1
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "  🎉 推送成功！" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "你的个人主页将在 1-2 分钟后上线：" -ForegroundColor Cyan
        Write-Host "  https://$githubUser.github.io" -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host ""
        Write-Host "GitHub 仓库地址：" -ForegroundColor Cyan
        Write-Host "  https://github.com/$githubUser/$repoName" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "推送可能遇到问题，输出如下：" -ForegroundColor Yellow
        Write-Host $pushOutput
    }
} catch {
    Write-Host "推送出错: $_" -ForegroundColor Red
} finally {
    Pop-Location
    
    # 恢复远程 URL（移除 token）
    & $gitPath remote set-url origin "https://github.com/$githubUser/$repoName.git"
    Write-Host "已清理临时凭证。" -ForegroundColor Gray
}

Write-Host ""
Write-Host "按 Enter 键退出..."
Read-Host
