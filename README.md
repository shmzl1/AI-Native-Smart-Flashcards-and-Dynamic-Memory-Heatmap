# AI-Native-Smart-Flashcards-and-Dynamic-Memory-Heatmap


# AI 原生智能闪卡与动态记忆热力图

本仓库用于开发一个小型全栈项目，包含：

- 闪卡管理（增删改查）
- 复习事件（rating 0~5）
- 用于可视化的图谱数据（nodes + edges）
- （可扩展）基于 VLM 的 DAG 抽取（以接口契约为准）

当前仓库主要沉淀**规范与环境**：

- API 契约：`spec/api.md`
- VLM DAG Schema：`spec/vlm-dag-schema.json`
- 数据库建表：`db/schema.sql`
- 本地数据库运行：`docker-compose.yml`

---

## 本地快速启动（Local）

### 1）环境要求

- Docker + Docker Compose

### 2）配置环境变量

从示例文件复制一份本地环境变量（按需修改）：

```bash
cp .env.example .env
```

> 注意：`.env` 仅用于本地，不应提交到仓库。

### 3）启动数据库

在仓库根目录执行：

```bash
docker compose up -d
```

停止数据库：

```bash
docker compose down
```

---

## 规范 / 契约（Specs / Contracts）

### API 契约

见：`spec/api.md`

- Base path：`/api/v1`
- 响应包裹约定（Response wrapper）：
  - 成功：`{ "code": 0, "message": "", "data": ... }`
  - 失败：`{ "code": 400/401/500, "message": "reason", "data": null }`

### VLM DAG Schema

`POST /vlm/extractDag` 的返回 `data` 必须符合：

- `spec/vlm-dag-schema.json`

---

## 数据库（Database）

- 建表文件：`db/schema.sql`
- 数据库由 `docker-compose.yml` 启动

如果修改了数据库结构，通常需要同步更新：

- `db/schema.sql`
- `spec/api.md`（如果接口字段/行为也跟着变了）

---

## 开发约定（Development Notes）

### 复习评分（Review rating）

`POST /reviewEvents` 的 `rating` 范围固定为：**0 ~ 5**。

### 推荐实现顺序（按联调完成顺序）

1. Cards 增删改查（CRUD）
2. ReviewEvents 录入 + 同步更新卡片统计字段（如 reviewCount、easeFactor）
3. Graph 数据接口
4. VLM 抽取 DAG 接口

---

## 仓库结构（Repo Structure）

```text
.
├── .env.example
├── .gitignore
├── docker-compose.yml
├── README.md
├── db
│   └── schema.sql
└── spec
    ├── api.md
    └── vlm-dag-schema.json
```
