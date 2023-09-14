# Outline shadowsocks server
Generate secret:
```commandline
openssl rand -base64 15
```

How cloud URI is generated:
```python
"ss://" + btoa(encryption_method + ":" + secret) + "@" + host + ":" + port
```
