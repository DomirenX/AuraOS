//
// Copyright © 2026 DomirenX
//

#include <stdint.h>
#include <stddef.h>
#include <limine.h>

__attribute__((used, section(".limine_requests")))
static volatile LIMINE_BASE_REVISION(4);

static void limine_main(void);

__attribute__((used, section(".limine_requests")))
static volatile struct limine_entry_point_request entry_point_request = 
{
    .revision = 0,
    .entry = limine_main
};

__attribute__((used, section(".limine_requests_start_marker")))
static volatile LIMINE_REQUESTS_START_MARKER;

__attribute__((used, section(".limine_requests_end_marker")))
static volatile LIMINE_REQUESTS_END_MARKER;

static void vga_write_char(char c, uint8_t color, size_t x, size_t y)
{
    volatile uint16_t *vga = (volatile uint16_t *)0xB8000;
    vga[y * 80 + x] = (uint16_t)c | ((uint16_t)color << 8);
}

static void vga_clear(uint8_t color)
{
    volatile uint16_t *vga = (volatile uint16_t *)0xB8000;
    for (size_t i = 0; i < 80 * 25; i++)
    {
        vga[i] = ' ' | ((uint16_t)color << 8);
    }
}

static void print_str(const char *str, uint8_t color)
{
    static size_t x = 0, y = 0;
    if (x == 0 && y == 0)
    {
        vga_clear(0x00);
    }

    while (*str)
    {
        if (*str == '\n')
        {
            x = 0;
            if (++y >= 25) y = 24;
        } else
        {
            vga_write_char(*str, color, x, y);
            if (++x >= 80)
            {
                x = 0;
                if (++y >= 25) y = 24;
            }
        }
        str++;
    }
}

static void limine_main(void)
{
    print_str("AuraKernel is alive!\n", 0x0F);
    print_str("Welcome to AuraOS with custom kernel.\n", 0x0A);

    for (;;) { __asm__ volatile ("hlt"); }
}