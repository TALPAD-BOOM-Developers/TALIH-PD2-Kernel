#!/usr/bin/env bash
# 本分支（KernelSU-Next）专用 SU 后端集成：KernelSU-Next 内核树 + 内核侧手动挂钩（已 in-tree）。
# 钩子见 fs/{exec,stat,open,read_write}.c、drivers/input/input.c、fs/namespace.c（CONFIG_KSU）。
# defconfig: CONFIG_KSU=y、CONFIG_KSU_MANUAL_HOOK=y、CONFIG_KPROBES=y（供 LKM），KSU 不走 kprobe。
# 注意：setup.sh 不带参数会 checkout 最新 tag（v3.4.2 无 4.19 守卫，会拉进 linux/pgtable.h），
# 必须显式指定 next 分支。
set -euo pipefail

rm -rf KernelSU drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s -- next
