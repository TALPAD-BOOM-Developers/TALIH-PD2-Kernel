#!/usr/bin/env bash
# 本分支（KernelSU-Next）专用 SU 后端集成：KernelSU-Next 内核树 + 内核侧手动挂钩（已 in-tree）。
# 钩子见 fs/{exec,stat,open,read_write}.c、drivers/input/input.c、fs/namespace.c（CONFIG_KSU）。
# defconfig: CONFIG_KSU=y、CONFIG_KPROBES=y、CONFIG_KSU_KPROBE_HOOKS=n（开 kprobe 但不用 kprobe 集成）。
set -euo pipefail

rm -rf KernelSU drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash
