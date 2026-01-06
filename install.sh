#!/bin/bash -eu

readonly CMD=terraform-google
readonly DOWNLOAD_URL=https://raw.githubusercontent.com/creal/terraform-google-cli/refs/heads/main/terraform-google
readonly INSTALL_DIR=${HOME}/.local/bin
readonly TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo -e "==> Downloading from ${DOWNLOAD_URL}..."
curl -fL "${DOWNLOAD_URL}" -o "${TMP_DIR}/${CMD}"
chmod +x "${TMP_DIR}/${CMD}"

if [ ! -d "${INSTALL_DIR}" ]; then
    echo "Creating directory ${INSTALL_DIR}..."
    mkdir -p "${INSTALL_DIR}"
fi

echo -e "==> Installing binary to ${INSTALL_DIR}..."
mv "${TMP_DIR}/${CMD}" "${INSTALL_DIR}/${CMD}"

if [[ ":${PATH}:" != *":$INSTALL_DIR:"* ]]; then
  echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.zshrc && source ~/.zshrc
fi

echo "Success! ${CMD} has been installed to ${INSTALL_DIR}/${CMD}"

