ZARF_VERSION=v0.31.4
ZARF_ARCH=$(shell [ $(shell uname -m) = "x86_64" ] && echo "amd64" || echo "arm64";)
INSTALL_LOCATION=/usr/bin/zarf

check:
	@echo "ZARF_VERSION: ${ZARF_VERSION}"
	@echo "ZARF_ARCH: ${ZARF_ARCH}"
	@echo "INSTALL_LOCATION: ${INSTALL_LOCATION}"

install: install-cluster install-plugins

install-cluster: .zarf-install .zarf-init .kubeconfig
	@kubectl get pods -A

uninstall: destroy
	@sudo rm -f ${INSTALL_LOCATION} || true

# `make destroy CONFIRM=y` to skip confirmation
destroy:
	@if [ -z "$(CONFIRM)" ]; then \
		printf "Are you sure you want to destroy? [y/N]: "; read confirm; \
		if [ "$$confirm" != "y" ] && [ "$$confirm" != "Y" ]; then \
			echo "Aborting"; \
			exit 1; \
		fi; \
	else \
		if [ "$(CONFIRM)" != "y" ] && [ "$(CONFIRM)" != "Y" ]; then \
			echo "Aborting"; \
			exit 1; \
		fi; \
	fi
	@echo "Destroying Zarf"
	@sudo zarf destroy --confirm --remove-components || true

.zarf-install:
	@if [ "$$(zarf version)" != "${ZARF_VERSION}" ]; then \
		echo "Downloading Zarf ${ZARF_VERSION} for ${ZARF_ARCH}..."; \
		wget https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_Linux_${ZARF_ARCH} -O zarf; \
		chmod +x zarf; \
		sudo mv zarf ${INSTALL_LOCATION} && echo "Installed ${INSTALL_LOCATION}"; \
	else \
		echo "Zarf ${ZARF_VERSION} is already installed."; \
	fi

# init package: https://github.com/defenseunicorns/zarf/releases/download/v0.31.4/zarf-init-amd64-v0.31.4.tar.zst
.zarf-init:
	@if [ ! -f "zarf-init-${ZARF_ARCH}-${ZARF_VERSION}.tar.zst" ]; then \
		echo "Downloading zarf init package"; \
		wget https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf-init-${ZARF_ARCH}-${ZARF_VERSION}.tar.zst; \
	else \
		echo "using existing zarf init package"; \
	fi
	@sudo su -c "zarf init --components=k3s --confirm"

.kubeconfig:
	@mkdir -p ~/.kube
	@sudo cp /root/.kube/config ~/.kube/config
	@sudo chown -R $(id -u):$(id -g) ~/.kube

#######################################
# PLUGINS
#######################################
install-plugins: install-istio install-cert-manager install-ca install-httpd
build-plugins: build-istio build-cert-manager
clean-plugins: clean-istio clean-cert-manager

#######################################
# Istio
#######################################
ISTIO_PACKAGE=istio/zarf-package-istio-${ZARF_ARCH}.tar.zst

install-istio: build-istio
	@echo "Installing Istio package"
	@zarf package deploy ${ISTIO_PACKAGE} --confirm

build-istio: ${ISTIO_PACKAGE}

${ISTIO_PACKAGE}: istio/*.yaml
	@echo "Building Istio package"
	@cd istio && zarf package create --confirm

clean-istio:
	@rm -f ${ISTIO_PACKAGE} || true

#######################################
# Cert Manager
#######################################
CERT_MANAGER_PACKAGE=cert-manager/zarf-package-cert-manager-${ZARF_ARCH}.tar.zst

install-cert-manager: build-cert-manager
	@echo "Installing Cert Manager package"
	@zarf package deploy ${CERT_MANAGER_PACKAGE} --confirm

build-cert-manager: ${CERT_MANAGER_PACKAGE}

${CERT_MANAGER_PACKAGE}: cert-manager/*.yaml
	@echo "Building Cert Manager package"
	@cd cert-manager && zarf package create --confirm

clean-cert-manager:
	@rm -f ${CERT_MANAGER_PACKAGE} || true

#######################################
# Certificate Authority
#######################################
CA_PACKAGE=ca/zarf-package-ca-${ZARF_ARCH}.tar.zst

install-ca: build-ca
	@echo "Installing CA package"
	@zarf package deploy ${CA_PACKAGE} --confirm

build-ca: ${CA_PACKAGE}

${CA_PACKAGE}: ca/*.yaml
	@echo "Building CA package"
	@cd ca && zarf package create --confirm

clean-ca:
	@rm -f ${CA_PACKAGE} || true

#######################################
# HTTPD
#######################################
HTTPD_PACKAGE=httpd/zarf-package-httpd-${ZARF_ARCH}.tar.zst

install-httpd: build-httpd
	@echo "Installing HTTPD package"
	@zarf package deploy ${HTTPD_PACKAGE} --confirm

build-httpd: ${HTTPD_PACKAGE}

${HTTPD_PACKAGE}: httpd/*.yaml
	@echo "Building HTTPD package"
	@cd httpd && zarf package create --confirm

clean-httpd:
	@rm -f ${HTTPD_PACKAGE} || true