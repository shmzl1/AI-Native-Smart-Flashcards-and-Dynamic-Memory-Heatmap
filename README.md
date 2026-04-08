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

## 这份 README 是给谁看的？（按角色快速定位）

> 这份 README 的定位是：**联调地基 / 新人上手指南**。
> 目前仓库主要是“规范与环境”，代码会在此基础上逐步补齐。

### 前端同学（图谱/页面）

你需要重点看：

- 「规范 / 契约（Specs / Contracts）」：接口返回的统一包裹（Response wrapper）
- `spec/api.md`：Graph 相关接口（nodes/edges 字段）、Cards/Review 的字段含义
- 「推荐实现顺序」：先用 mock 数据做页面，再接入后端接口联调

你最终要做的页面/能力：

- 卡片列表/详情（最简版）
- 图谱展示（nodes + edges）+ 搜索定位（可后续加）
- 根据后端提供的 heat/熟练度字段做热力映射（透明度/光晕等）

### 后端同学（FastAPI + 业务 + AI Pipeline）

你需要重点看：

- `spec/api.md`：按约定实现接口（尤其是统一 Response wrapper）
- 「开发约定」：rating 必须校验 0~5
- `spec/vlm-dag-schema.json`：VLM/DAG 抽取接口的输出校验（Schema）

你最终要交付的：

- Cards CRUD
- ReviewEvents 写入（并更新卡片统计字段：reviewCount、easeFactor 等）
- Graph 数据接口（给前端渲染 nodes/edges）
- VLM 抽取 DAG：先保证返回符合 schema，再谈效果

### 数据库同学（PostgreSQL + 迁移/索引 + 数据契约）

你需要重点看：

- `db/schema.sql`：建表与字段设计（JSONB 拓扑 + 时间序列字段）
- 「数据库」章节：改表结构要同步更新 `spec/api.md`（接口字段会跟着变）

你最终要交付的：

- 可一键初始化的表结构（schema.sql）
- 必要索引（按 user_id / created_at / next_review 等）
- 建议有示例数据，方便前后端联调，验证

---

## 本周（Week 6）要做什么？（项目选题 + 计划阶段）

本周目标：**把“能联调的地基”搭好**，避免后期因为字段/接口反复修改而返工。

- [ ] 全员：`docker compose up -d` 能在本机启动数据库
- [ ] DB：确认 `db/schema.sql` 字段满足 Cards / ReviewEvents / Graph 的最小需求
- [ ] 后端：按 `spec/api.md` 完成最小可用接口（先跑通 Cards CRUD）
- [ ] 前端：用 mock 数据做出最小图谱页面（能渲染 nodes + edges），等待后端接口接入

> 每次接口/字段发生变化时：同步更新 `spec/api.md` 和 `db/schema.sql`，避免只口头约定。

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
