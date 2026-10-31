# M4 记忆栈（mem0 + Milvus + SeaweedFS + st-embed + DSH 薄插件）
开发验证环境：鲲鹏 VM aarch64。零外部 LLM key（infer=false，提炼归 DSH 主脑）。
## 启动
cp .env.example .env（生成 token）→ modelscope 下 BAAI/bge-m3 到 embed/models/bge-m3
→ docker compose up -d --build → ./test/smoke.sh → python3 seed/seed_cves.py
## 端口（全 127.0.0.1，SSH 隧道访问）：milvus 19530/9091 | embed 8090 | sidecar 8888
## 决策：bge-m3=1024 维 | collection=cve_memory | scope=pkg/<name> | seed 与活记忆按 metadata.type 区分
## 已踩坑（全部已修，勿回退）：
- minio 公开镜像已下架 → openeuler/seaweedfs:4.03-oe2403sp2（meta 里的 sp4 tag 未发布，以 registry tag 列表为准）
- TEI 无 arm64 → 自研 st-embed 容器（torch+sentence-transformers）
- etcd 默认只听 localhost → --listen-client-urls http://0.0.0.0（否则 milvus panic）
- mem0 MilvusDBConfig token=None 必崩 → vector_store.config 显式 "token":""
- mem0 2.x search 拒顶层 user_id → filters={"user_id":...}
## 验收状态：冒烟5/5✅ 重启存活✅ scope隔离✅ seed灌入✅ | DSH插件装载+跨会话召回 = 待做(需DSH/模型key)
## 迁移 ostX86：clone → 重生成 .env token → 下 bge-m3 → up --build → smoke → seed（数据重放不拷卷）
