# dsh-plugin-cve-memory
mem0 sidecar 薄适配层（两工具，零业务逻辑；提炼由 DSH 主脑负责，sidecar 全程 infer=false）：
- memory_recall(scope,query)：triage/repair 前必调；scope=pkg/<name>
- memory_save(scope,memory,type)：CI失败/人审驳回/修复完成后沉淀；type=fix_strategy|ci_error_pattern|review_reject
装载：dsh plugin --profile web add ./plugin（待 DSH 就绪）
配置：baseUrl=http://127.0.0.1:8888 / token=/opt/mem-stack/.env / topK=5
