# Quickstart

Just run the following command:

```bash
make install
```

This will do the following:

1. Become `root` (NOT `sudo`)
2. Install the `zarf` binary to `/usr/local/bin/zarf`
3. Install `k3s` (a lightweight kubernetes distribution)
4. Initialize a zarf cluster
5. Setup your user's kubeconfig to use the zarf cluster

# Install Istio

```bash
make install-istio
```

## Bash Completion

Run the following commands to enable bash completion for your zarf.

```bash
sudo dnf install bash-completion
zarf completion bash | sudo tee /etc/bash_completion.d/zarf > /dev/null
```

Restart your shell.

## Test LoadBalancer

```bash
kubectl create deploy nginx --image=nginx
kubectl expose deploy nginx --type=LoadBalancer --port=8080 --target-port=80
curl -vL http://localhost:8080
kubectl delete svc/nginx
kubectl delete deploy/nginx
```