# Quickstart

Configure your `/etc/hosts` to point `zarf.local` to your IP address or localhost.

```bash
# /etc/hosts
127.0.0.1   zarf.local
```

Just run the following command to deploy the cluster and all services.

```bash
make install
```

Deploy the demo application.

```bash
make install-httpd
```

Go to https://zarf.local/ to see the demo application.

or use curl:

```bash
curl -Lk https://zarf.local/
``` 

## Notes

The above `make install` will do the following:

1. Become `root` (NOT `sudo`)
2. Install the `zarf` binary to `/usr/local/bin/zarf`
3. Install `k3s` (a lightweight kubernetes distribution)
4. Initialize a zarf cluster
5. Setup your user's kubeconfig to use the zarf cluster
