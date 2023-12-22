# Install the core chart

```sh
helm dep update
helm dep build
helm install core . -n core --create-namespace
```

# Uninstall the core chart

```sh
helm uninstall core -n core
kubectl delete pvc -l app.kubernetes.io/instance=core -n core
kubectl delete ns core
```