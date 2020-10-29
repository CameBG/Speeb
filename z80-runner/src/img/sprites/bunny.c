#include "bunny.h"
// Data created with Img2CPC - (c) Retroworks - 2007-2017
// Palette uses hardware values.
const u8 PALETTE[16] = { 0x4f, 0x54, 0x5d, 0x45, 0x4d, 0x56, 0x57, 0x5e, 0x5f, 0x47, 0x42, 0x53, 0x5a, 0x59, 0x5b, 0x4b };

// Tile bunny_0: 16x16 pixels, 8x16 bytes.
const u8 bunny_0[8 * 16] = {
	0x00, 0x00, 0x00, 0x00, 0x40, 0x80, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0x80, 0xc0, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0xc0, 0xea, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0xc0, 0xea, 0x00,
	0x40, 0x80, 0xc0, 0xc0, 0xd5, 0xc0, 0xea, 0x00,
	0xd5, 0xea, 0xff, 0xff, 0xff, 0xea, 0xea, 0x00,
	0xd5, 0xd5, 0xff, 0xff, 0xff, 0xff, 0xea, 0x00,
	0xc0, 0xff, 0xff, 0xff, 0xff, 0xd5, 0xea, 0x00,
	0x40, 0xff, 0xff, 0xff, 0xff, 0xc0, 0xff, 0x80,
	0x40, 0xff, 0xff, 0xff, 0xff, 0xc0, 0xff, 0xc2,
	0x40, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc2,
	0x40, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80,
	0x40, 0xff, 0xff, 0xff, 0xff, 0xff, 0xea, 0x00,
	0x00, 0xd5, 0xff, 0xff, 0xff, 0xff, 0xea, 0x00,
	0x00, 0x40, 0xd5, 0xff, 0xff, 0xea, 0x80, 0x00,
	0x00, 0x00, 0x40, 0xc0, 0xc0, 0x80, 0x00, 0x00
};

// Tile bunny_1: 16x16 pixels, 8x16 bytes.
const u8 bunny_1[8 * 16] = {
	0x00, 0x00, 0x00, 0x00, 0x40, 0x80, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0x80, 0xc0, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0xc0, 0xea, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0xc0, 0xea, 0x00,
	0x40, 0x80, 0xc0, 0xc0, 0xd5, 0xc0, 0xea, 0x00,
	0xd5, 0xea, 0xff, 0xff, 0xff, 0xea, 0xea, 0x00,
	0xd5, 0xd5, 0xff, 0xff, 0xff, 0xff, 0xea, 0x00,
	0xc0, 0xff, 0xff, 0xff, 0xff, 0xd5, 0xea, 0x00,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xc0, 0xff, 0x80,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xc0, 0xff, 0xc2,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc2,
	0xd5, 0xea, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80,
	0xd5, 0xff, 0xd5, 0xff, 0xff, 0xff, 0xea, 0x00,
	0x40, 0xff, 0xc0, 0xc0, 0xc0, 0xd5, 0xea, 0x00,
	0x40, 0xff, 0xea, 0x00, 0x00, 0x40, 0xff, 0x80,
	0x40, 0xc0, 0xc0, 0x00, 0x00, 0x40, 0xc0, 0x80
};

// Tile bunny_2: 16x16 pixels, 8x16 bytes.
const u8 bunny_2[8 * 16] = {
	0x00, 0x00, 0x00, 0x00, 0x40, 0x80, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0x80, 0xc0, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0xc0, 0xea, 0x00,
	0x00, 0x00, 0x00, 0x00, 0xd5, 0xc0, 0xea, 0x00,
	0x40, 0x80, 0xc0, 0xc0, 0xd5, 0xc0, 0xea, 0x00,
	0xd5, 0xea, 0xff, 0xff, 0xff, 0xea, 0xea, 0x00,
	0xd5, 0xd5, 0xff, 0xff, 0xff, 0xff, 0xea, 0x00,
	0xc0, 0xff, 0xff, 0xff, 0xff, 0xd5, 0xea, 0x00,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xc0, 0xff, 0x80,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xc0, 0xff, 0xc2,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc2,
	0xd5, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80,
	0xd5, 0xff, 0xff, 0xd5, 0xff, 0xff, 0xea, 0x00,
	0x40, 0xff, 0xff, 0xd5, 0xff, 0xd5, 0xea, 0x00,
	0x00, 0xc0, 0xff, 0xea, 0xff, 0xc0, 0x80, 0x00,
	0x00, 0x40, 0xc0, 0xc0, 0xc0, 0x80, 0x00, 0x00
};
