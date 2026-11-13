#!/usr/bin/env bash
set -euo pipefail

KSU_BRANCH=builtin
KSU_REPO=https://github.com/SukiSU-Ultra/SukiSU-Ultra

rm -rf KernelSU drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig

git clone --depth 1 --branch "$KSU_BRANCH" "$KSU_REPO" KernelSU

ln -sf "$(realpath --relative-to=drivers KernelSU/kernel)" drivers/kernelsu
grep -q kernelsu drivers/Makefile || printf '\nobj-$(CONFIG_KSU) += kernelsu/\n' >> drivers/Makefile
grep -q 'drivers/kernelsu/Kconfig' drivers/Kconfig || sed -i '/^endmenu/i\source "drivers/kernelsu/Kconfig"' drivers/Kconfig

grep -q 'int ksu_handle_execveat' KernelSU/kernel/feature/sucompat.h
grep -q 'int ksu_handle_sys_reboot' KernelSU/kernel/supercall/supercall.c
echo "[ok] SukiSU-Ultra@${KSU_BRANCH} $(git -C KernelSU rev-parse --short HEAD)"
