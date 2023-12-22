# Test LoadBalancer

```bash
kubectl create deploy nginx --image=nginx
kubectl expose deploy nginx --type=LoadBalancer --port=8080 --target-port=80
curl -vL http://localhost:8080
kubectl delete svc/nginx
kubectl delete deploy/nginx
```