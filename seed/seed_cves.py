import json, requests
BASE="http://127.0.0.1:8888"
TOKEN=[l.split("=",1)[1].strip() for l in open("/opt/mem-stack/.env") if l.startswith("MEM0_TOKEN=")][0]
H={"Authorization":f"Bearer {TOKEN}","Content-Type":"application/json"}
for line in open("/opt/mem-stack/seed/seeds.jsonl"):
    s=json.loads(line)
    hit=requests.post(BASE+"/search",headers=H,json={"query":s["memory"],"scope":s["scope"],"top_k":1}).json()
    if hit.get("results") and hit["results"][0].get("score",0)>0.9:
        print("skip(已存在):",s["scope"]); continue
    r=requests.post(BASE+"/memories",headers=H,
        json={"messages":[{"role":"user","content":s["memory"]}],
              "scope":s["scope"],
              "metadata":{k:v for k,v in s.items() if k in ("cve","type")},
              "infer":False})
    print(s["scope"], r.status_code, str(r.json())[:80])
