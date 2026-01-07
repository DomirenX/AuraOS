# AuraOS

AuraOS is a hobby, experimental operating system written from scratch for the x86_64 architecture.  
The project focuses on low-level system development, clean bootstrapping, and gradual evolution from a minimal kernel into a full operating system.

> ⚠️ AuraOS is work in progress and currently intended for educational and experimental purposes only.

## Features (Current State)

- x86_64 architecture support
- Booting via Limine bootloader
- Freestanding C kernel
- Custom linker script
- Minimal VGA text output (early debug)
- Runs in QEMU

## Toolchain & Requirements

To build and run AuraOS, you need:

- x86_64-elf-gcc cross-compiler
- make
- limine
- qemu-system-x86_64
- Unix-like environment (Linux recommended)

> ⚠️ A system compiler will not work. A proper cross-compiler is required.

## Building the Project

```bash
make all
```

## Running in QEMU

```bash
make run
```

## Goals & Roadmap

Planed future milestones:

- Proper memory management
- Framebuffer output
- Interrupt handling
- Paging
- Basic scheduler
- Userspace & syscalls
- Custom UI / shell

## Attention! The project is under development and at the moment may not work, have problems, bugs, imperfections and so far it is not very similar to the idea, but the development is in full swing as far as possible. Thank you for your understanding!