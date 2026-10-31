#!/bin/bash
cd /opt/mem-stack
export $(grep MEM0_TOKEN .env | xargs)
pass=0; fail=0
ck(){ if eval "$2" >/dev/null 2>&1; then echo "✅ $1"; ((pass++)); else echo "❌ $1"; ((fail++)); fi; }
ck "milvus healthz"  "curl -s -m5 http://127.0.0.1:9091/healthz"
ck "embed ready"     "curl -s -m60 http://127.0.0.1:8090/v1/embeddings -H 'Content-Type: application/json' -d '{\"model\":\"bge-m3\",\"input\":\"x\"}' | grep -q data"
ck "sidecar healthz" "curl -s -m5 http://127.0.0.1:8888/healthz | grep -q '\"ok\"'"
ck "写入(infer=false)" "curl -s -m60 -X POST http://127.0.0.1:8888/memories -H 'Content-Type: application/json' -H \"Authorization: Bearer $MEM0_TOKEN\" -d '{\"messages\":[{\"role\":\"user\",\"content\":\"nginx 的 CVE-2025-1234 上游在 1.27.4 修复，backport 时 mod_http2 补丁需重打\"}],\"scope\":\"pkg/nginx\",\"metadata\":{\"type\":\"backport_note\"},\"infer\":false}'"
ck "召回含关键词"     "curl -s -m30 -X POST http://127.0.0.1:8888/search -H 'Content-Type: application/json' -H \"Authorization: Bearer $MEM0_TOKEN\" -d '{\"query\":\"nginx backport 坑\",\"scope\":\"pkg/nginx\"}' | grep -q mod_http2"
echo "== $pass 过 / $fail 挂 =="
[ $fail -eq 0 ]
