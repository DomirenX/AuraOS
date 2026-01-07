#
# Copyright © 2026 DomirenX
# Licensed under the AuraOS Non-Commercial License (ANCL)
#

# =================================================
# Toolchain
# =================================================

CC		:= x86_64-elf-gcc
LD		:= x86_64-elf-ld
AS		:= x86_64-elf-as

# =================================================
# Paths
# =================================================

KERNEL_DIR		:= kernel/arch/x86_64
ISO_ROOT		:= iso_root
BUILD_DIR		:= build

KERNEL_ELF		:= $(BUILD_DIR)/kernel.elf
ISO_IMAGE		:= aura_os.iso

# =================================================
# Source files
# =================================================

C_SOURCES		:= $(KERNEL_DIR)/entry.c
C_OBJECTS		:= $(C_SOURCES:%.c=$(BUILD_DIR)/%.o)

# =================================================
# Flags
# =================================================

CFLAGS := \
	-std=gnu11 \
	-ffreestanding \
	-fno-stack-protector \
	-fno-pie -fno-pic \
	-m64 \
	-mno-red-zone \
	-mcmodel=kernel \
	-O2 \
	-Wall -Wextra

LDFLAGS := \
	-T linker.ld \
	-nostdlib \
	-z max-page-size=0x1000

CFLAGS += -I limine

# =================================================
# Rules
# =================================================

all: $(ISO_IMAGE)

# =================================================
# Compile C
# =================================================

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# =================================================
# Link kernel
# =================================================

$(KERNEL_ELF): $(C_OBJECTS)
	@mkdir -p $(BUILD_DIR)
	$(LD) $(LDFLAGS) $^ -o $@

# =================================================
# ISO Image
# =================================================

$(ISO_IMAGE): $(KERNEL_ELF)
	@mkdir -p $(ISO_ROOT)/EFI/BOOT
	cp $(KERNEL_ELF) $(ISO_ROOT)/kernel.elf
	cp limine.conf $(ISO_ROOT)/
	cp limine/limine-bios.sys $(ISO_ROOT)/ && cp limine/limine-uefi-cd.bin $(ISO_ROOT)/ && cp limine/limine-bios-cd.bin $(ISO_ROOT)/
	cp limine/BOOTX64.EFI $(ISO_ROOT)/EFI/BOOT

	xorriso -as mkisofs \
		-b limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-uefi-cd.bin \
		-efi-boot-part --efi-boot-image \
		-o $(ISO_IMAGE) $(ISO_ROOT)

# =================================================
# Run in QEMU
# =================================================

run: $(ISO_IMAGE)
	qemu-system-x86_64 \
		-cdrom $(ISO_IMAGE) \
		-m 512M \
		-serial stdio

# =================================================
# Clean
# =================================================

clean:
	rm -rf $(BUILD_DIR) $(ISO_ROOT)/EFI $(ISO_ROOT)/limine-bios.sys $(ISO_ROOT)/limine-bios-cd.bin $(ISO_ROOT)/limine-uefi-cd.bin $(ISO_ROOT)/kernel.elf $(ISO_ROOT)/limine.conf $(ISO_IMAGE) 

.PHONY: all clean run