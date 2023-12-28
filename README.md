# Quickstart

Configure your `/etc/hosts` to point `zarf.local` to your IP address or localhost.

```bash
# /etc/hosts
127.0.0.1   zarf.local keycloak.zarf.local
```

Just run the following command to deploy the cluster and all services.

```bash
make install
```

## Import Keycloak Realm Config

Create a configmap with the realm export file from the Keycloak admin console.

```bash
kubectl -n core create configmap keycloak-config-cli-configmap --from-file=./charts/core/import-example/realm-export.json
```

Run the import job:

```bash
kubectl -n core apply -f ./charts/core/config-cli.yaml
```

Go to https://keycloak.zarf.local/ to see the demo application.

## Notes

The above `make install` will do the following:

1. Become `root` (NOT `sudo`)
2. Install the `zarf` binary to `/usr/local/bin/zarf`
3. Install `k3s` (a lightweight kubernetes distribution)
4. Initialize a zarf cluster
5. Setup your user's kubeconfig to use the zarf cluster
