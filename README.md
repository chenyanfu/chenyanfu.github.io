# 个人主页 Portfolio

一个简约现代风格的个人作品集网页，支持 GitHub Pages 免费部署。

## 🚀 快速开始

### 1. 自定义内容

打开 `index.html`，修改以下占位符为你自己的信息：

| 占位符 | 位置 | 说明 |
|--------|------|------|
| `xfchen` | 标题、多处文字 | 你的显示名称 |
| `1541952740@qq.com` | 联系邮箱 | 你的邮箱地址 |
| `chenyanfu` | GitHub 链接 | 你的 GitHub 用户名 |
| `项目一名称` | 项目卡片 | 你的实际项目 |
| `项目二名称` | 项目卡片 | 你的实际项目 |
| `项目三名称` | 项目卡片 | 你的实际项目 |

> 💡 搜索 `xfchen` 可以一键找到所有需要修改的地方。

### 2. 更换头像

`index.html` 中头像使用的是 DiceBear API 生成的随机头像：
```html
<img src="https://api.dicebear.com/7.x/avataaars/svg?seed=yourname" alt="头像">
```

将 `xfchen` 改成你的名字，会生成一个独特的头像；
或者直接替换为本地图片路径，如 `images/avatar.jpg`。

### 3. 部署到 GitHub Pages

```bash
# 1. 在 GitHub 上创建一个仓库，例如：username.github.io
#    （将 username 替换为你的 GitHub 用户名）

# 2. 初始化本地仓库并提交
git init
git add .
git commit -m "Initial commit"

# 3. 关联远程仓库
git remote add origin https://github.com/username/username.github.io.git

# 4. 推送代码
git push -u origin main
# 如果你的默认分支是 master，使用：
# git push -u origin master
```

推送后，访问 `https://username.github.io` 即可看到你的网页！🎉

## 🎨 自定义样式

所有样式都在 `style.css` 中，你可以轻松修改：

- **主题色**：修改 `:root` 中的 `--primary` 和 `--secondary`
- **深色/浅色模式**：默认深色主题，修改 `--bg`、`--text` 等变量可切换为浅色

## 📁 文件结构

```
.
├── index.html      # 主页面
├── style.css       # 样式文件
└── README.md       # 本文件
```

## 📝 License

MIT License
