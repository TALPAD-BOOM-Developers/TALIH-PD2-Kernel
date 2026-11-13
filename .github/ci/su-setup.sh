#!/usr/bin/env bash
set -euo pipefail

KSU_BRANCH=builtin-new
KSU_REPO=https://github.com/SukiSU-Ultra/SukiSU-Ultra

rm -rf KernelSU drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig

git clone --depth 1 --branch "$KSU_BRANCH" "$KSU_REPO" KernelSU

ln -sf "$(realpath --relative-to=drivers KernelSU/kernel)" drivers/kernelsu
grep -q kernelsu drivers/Makefile || printf '\nobj-$(CONFIG_KSU) += kernelsu/\n' >> drivers/Makefile
grep -q 'drivers/kernelsu/Kconfig' drivers/Kconfig || sed -i '/^endmenu/i\source "drivers/kernelsu/Kconfig"' drivers/Kconfig

test -f KernelSU/kernel/hook/lsm_hooks_ultralegacy.c
grep -q 'KERNEL_VERSION(4, 19, 0)' KernelSU/kernel/hook/syscall_table_hook_arm64.c
echo "[ok] SukiSU-Ultra@${KSU_BRANCH} $(git -C KernelSU rev-parse --short HEAD)"
