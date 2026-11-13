#!/usr/bin/env bash
# 本分支（susfs+resukisu）专用 SU 后端集成：BakaSU 驱动 + 内核侧手动挂钩（已 in-tree）。
# 内核侧钩子见 fs/{exec,stat,open,read_write}.c、drivers/input/input.c（CONFIG_KSU_MANUAL_HOOK），
# defconfig 已开 CONFIG_KSU_MANUAL_HOOK=y；CONFIG_KPROBES=y 仅供 LKM 使用，SU 不走 kprobe。
set -euo pipefail

rm -rf KernelSU drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig
curl -LSs "https://raw.githubusercontent.com/Baka-SU/BakaSU/main/kernel/setup.sh" | bash
