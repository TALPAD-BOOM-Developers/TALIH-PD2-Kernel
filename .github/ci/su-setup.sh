#!/usr/bin/env bash
# 本分支（KernelSU-Next）专用 SU 后端集成。
# 内核侧手动挂钩已 in-tree（fs/{exec,stat,open,read_write,namespace}.c、drivers/input/input.c，CONFIG_KSU）。
# defconfig: CONFIG_KSU=y、CONFIG_KSU_MANUAL_HOOK=y、CONFIG_KPROBES=y（仅 LKM 用），SU 不走 kprobe。
#
# 注意：KernelSU-Next 无 next 分支（archive/refs/heads/next 实际回退到 legacy），
# 而官方 setup.sh 不带参数会 checkout 最新 tag（v3.4.2 的 feature/sucompat.c 无保护地
# include <linux/pgtable.h>，4.19 无此头）。故这里直接克隆 legacy 分支并自行接线，
# 不调用 setup.sh。
set -euo pipefail

KSU_REF=legacy
KSU_REPO=https://github.com/KernelSU-Next/KernelSU-Next

rm -rf KernelSU KernelSU-Next drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig

git clone --depth 1 --branch "$KSU_REF" "$KSU_REPO" KernelSU-Next

ln -sf "$(realpath --relative-to=drivers KernelSU-Next/kernel)" drivers/kernelsu
grep -q kernelsu drivers/Makefile || printf '\nobj-$(CONFIG_KSU) += kernelsu/\n' >> drivers/Makefile
grep -q 'drivers/kernelsu/Kconfig' drivers/Kconfig || sed -i '/^endmenu/i\source "drivers/kernelsu/Kconfig"' drivers/Kconfig

# 硬校验：拿到的源码必须带 4.19 版本守卫
grep -q 'LINUX_VERSION_CODE >= KERNEL_VERSION(5, 10, 0)' KernelSU-Next/kernel/feature/sucompat.c
echo "[ok] KernelSU-Next@${KSU_REF} $(git -C KernelSU-Next rev-parse --short HEAD)"
