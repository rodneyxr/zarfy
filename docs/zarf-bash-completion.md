# Bash Completion

Run the following commands to enable bash completion for your zarf.

```bash
sudo dnf install bash-completion
zarf completion bash | sudo tee /etc/bash_completion.d/zarf > /dev/null
```

Restart your shell.