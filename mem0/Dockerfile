FROM openeuler/openeuler:24.03-lts-sp4
RUN dnf install -y python3 python3-pip && dnf clean all
RUN pip3 install --no-cache-dir mem0ai pymilvus fastapi "uvicorn[standard]" requests
COPY app.py /app/app.py
EXPOSE 8888
CMD ["uvicorn","app:app","--host","0.0.0.0","--port","8888","--app-dir","/app"]
