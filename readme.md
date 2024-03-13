# SRTLA Server

```bash
docker build -t srtla_server .
docker run -d -p 5000:5000/udp -p 5001:5001/udp srtla_server
```
