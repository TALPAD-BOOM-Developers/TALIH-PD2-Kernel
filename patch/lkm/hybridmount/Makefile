# SPDX-License-Identifier: GPL-2.0-only
#
# Hybrid Mount VFS kernel module (`hybridmount`).
# Built via the kernel top-level Makefile: make O=out ... M=<this dir> modules

MODULE_NAME := hybridmount
obj-m += $(MODULE_NAME).o

# Kernels before 5.18 default to gnu89, which rejects the C99 declarations used
# throughout the sources; the upstream build always set -std=gnu11.
ccflags-y += -std=gnu11 -Wno-declaration-after-statement
