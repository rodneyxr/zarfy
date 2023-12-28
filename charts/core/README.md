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

# Import Keycloak Realm Config

Create a realm export file from the Keycloak admin console and save it as `realm-export.json` in this directory.

Create the configmap (add `--dry-run=client -o yaml | less` to see the preview before creating it):

```sh
kubectl -n core create configmap keycloak-config-cli-configmap --from-file=realm-export.json
```

Run the import job:

```sh
kubectl -n core apply -f config-cli.yaml
```