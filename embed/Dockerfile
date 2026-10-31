FROM openeuler/openeuler:24.03-lts-sp4
RUN dnf install -y python3 python3-pip && dnf clean all
RUN pip3 install --no-cache-dir torch sentence-transformers fastapi "uvicorn[standard]"
COPY server.py /app/server.py
EXPOSE 80
CMD ["uvicorn","server:app","--host","0.0.0.0","--port","80","--app-dir","/app"]
