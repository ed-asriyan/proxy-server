# Prometheus
Helps to detect traffic abuse.

Request sample:
```
(sum(increase(shadowsocks_data_bytes{dir=~"p>t|p<t"}[3600s])) by (access_key)) / 1024 / 1024
```
