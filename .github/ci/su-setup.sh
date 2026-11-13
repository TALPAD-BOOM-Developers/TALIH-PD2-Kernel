#!/usr/bin/env bash
# 本分支（KernelSU-Next）专用 SU 后端集成：KernelSU-Next 内核树 + 内核侧手动挂钩（已 in-tree）。
# 钩子见 fs/{exec,stat,open,read_write}.c、drivers/input/input.c、fs/namespace.c（CONFIG_KSU）。
# defconfig: CONFIG_KSU=y、CONFIG_KSU_MANUAL_HOOK=y、CONFIG_KPROBES=y（仅 LKM 用），SU 不走 kprobe。
set -euo pipefail

rm -rf KernelSU KernelSU-Next drivers/kernelsu
git checkout -- drivers/Makefile drivers/Kconfig
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s -- origin/next || true

# 必须落在带 4.19 版本守卫的分支上：最新 tag（v3.4.2）的 feature/sucompat.c 会无保护地
# include <linux/pgtable.h>（4.19 无此头）。这里显式确认，不满足就强制切到 origin/next。
if ! grep -q 'LINUX_VERSION_CODE >= KERNEL_VERSION(5, 10, 0)' KernelSU-Next/kernel/feature/sucompat.c 2>/dev/null; then
  echo "[fix] 未落在 next 分支，强制 fetch + checkout origin/next"
  git -C KernelSU-Next fetch --depth 1 origin next
  git -C KernelSU-Next checkout --detach FETCH_HEAD
fi
grep -q 'LINUX_VERSION_CODE >= KERNEL_VERSION(5, 10, 0)' KernelSU-Next/kernel/feature/sucompat.c
echo "[ok] KernelSU-Next @ $(git -C KernelSU-Next rev-parse --short HEAD) $(git -C KernelSU-Next describe --tags --always 2>/dev/null || true)"
