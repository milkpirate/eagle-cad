#ifndef _SOKOBAN_LEVELS_H_
#define _SOKOBAN_LEVELS_H_

#include <avr/pgmspace.h>
#include "fontchars.h"

#define SOKOBAN_ROOMS_PER_LEVEL 8
#define SOKOBAN_LEVELS_COUNT (SOKOBAN_ROOMS_PER_LEVEL * 10)

// Compressed level data (Microban by David W. Skinner)
/*
 * Compression algorithm:
 * Stream is divided into nibbles (4-bit wide numbers).
 * First nibble defines width of level data (1-16) (width is value+1).
 * Second nibble defines height of level data (1-8) (height is value+1, leftmost bit is always 0)
 * Next nibbles are level data:
 *   - if leftmost bit is 0, next 3 bits defines type of tile to write on screen:
 *     - 000 = floor
 *     - 001 = target
 *     - 010 = box
 *     - 011 = box on target
 *     - 100 = sky (empty = area outside walls - whole game area is at first set to this tile)
 *     - 101 = wall
 *     - 110 = sokoban (player)
 *     - 111 = sokoban on target
 *   - if leftmost bit is 0, next 3 bits defines type of tile, which is written double (two times), except for:
 *     - (1)110 = "enter" - jump to the leftmost position on next line (it is not necessary to use enter, because we know width of level, so it may overlap for better compression)
 *     - (1)111 = "end of level" - marks end of level (if it's on first nibble, second nibble should be 1111 too - to round level data to whole byte; end of level must be specified - isn't implied from width and height)
 *
 * Level is written into viewport of given width and height, which is centered in game area.
 *
 * Example: 0x42,0xdd,0xd6,0x21,0xdd,0xdf
 *   - 0x42: width of level is 4+1=5; height of level is 2+1=3
 *   - tiles are:
 *     - 0xdd: wall, wall; wall, wall
 *     - 0xd6: wall, (implicit new line), wall; sokoban
 *     - 0x21: box; target
 *     - 0xdd: wall, (implicit new line), wall; wall, wall
 *     - 0xdf: wall, wall; (end of level)
 *   - so level is:
 *     #####
 *     #@$.#
 *     #####
 */
const uint8_t sokoban_levels[] PROGMEM = {
		0x56,0xdd,0xe5,0x01,0x5e,0x58,0xdd,0x36,0x8d,0x82,0x0d,0x8d,0xdd,0x5f,
		0x56,0xdd,0xd5,0x88,0xd0,0x56,0x0d,0x02,0x30,0xd0,0x13,0x0d,0x88,0xdd,0xd5,0xff,
		0x85,0xcd,0xde,0xd5,0x8d,0xd5,0x88,0x02,0x0d,0x05,0x85,0x20,0xd0,0x10,0x15,0x60,0xdd,0xdd,0xdf,
		0x75,0xdd,0xdd,0x58,0x88,0xd0,0x1b,0x26,0xd8,0x88,0xdd,0xd8,0x5c,0xcd,0xdf,
		0x76,0x4d,0xdd,0x54,0x58,0x80,0x54,0x50,0x12,0x10,0xd5,0x02,0x62,0x0d,0x81,0x21,0x0d,0x88,0x8d,0xdd,0xd5,0xff,
		0xb5,0xdd,0xd0,0xdd,0xd8,0x8d,0x58,0x0d,0x0a,0x88,0x05,0x6d,0x02,0x05,0x91,0x80,0xd8,0x0d,0xdd,0xdd,0xd5,0xff,
		0x67,0xdd,0xdd,0x88,0x0d,0x01,0x21,0x0d,0x02,0x12,0x0d,0x01,0x21,0x0d,0x02,0x12,0x0d,0x86,0x8d,0xdd,0xdf,
		0x56,0xdd,0x5e,0x51,0x8d,0x56,0xa0,0xd5,0x80,0x54,0xd8,0x5c,0xd1,0x5c,0x4d,0x5f,
		0xa7,0xcc,0xcd,0xd5,0xcc,0xc5,0x18,0x5c,0xcc,0x51,0x50,0xdd,0xdd,0x15,0x0d,0x06,0x02,0x02,0x02,0x0d,0x05,0x05,0x05,0x0d,0xd8,0x88,0x05,0xed,0xdd,0xd5,0xff,
		0x87,0xcd,0xdd,0xec,0x58,0x85,0xec,0x50,0xd6,0xdd,0x50,0x50,0x20,0xd0,0x95,0x02,0x0d,0x88,0x80,0xd8,0xdd,0xdd,0xdf,
		0x87,0xdd,0x5e,0x58,0x0d,0xe5,0x02,0x85,0xed,0x02,0x0d,0xd4,0xd5,0x61,0x85,0xc5,0x81,0x50,0x5c,0x58,0x80,0x5c,0xdd,0xd5,0xff,
		0x65,0xdd,0xdd,0x88,0x0d,0x05,0x05,0x0d,0x10,0x23,0x6d,0x80,0xdd,0xdd,0xff,
		0x86,0xcc,0x4d,0x5e,0xdd,0xd6,0xd5,0x88,0x13,0x0d,0x80,0x58,0x0d,0xdd,0x25,0x05,0xcc,0x58,0x05,0xcc,0xdd,0x5f,
		0x97,0x4d,0xde,0x45,0x8d,0xde,0x45,0x88,0x0d,0xed,0x0d,0x80,0x5e,0x51,0x01,0x50,0x62,0xd5,0x80,0x50,0xa0,0xd8,0x15,0x88,0xdd,0xdd,0xd5,0xff,
		0x56,0xdd,0x5e,0x50,0x60,0x5e,0x59,0x15,0xe5,0xa2,0xd5,0x88,0xd8,0x8d,0xdd,0x5f,
		0x77,0xdd,0xdd,0x58,0x09,0x0d,0x86,0xa0,0xdd,0xd0,0xdc,0x45,0x85,0xec,0x45,0x85,0xec,0x45,0x85,0xec,0x4d,0xdf,
		0x87,0xdd,0xd5,0xe5,0x88,0x0d,0xd8,0x6a,0x9d,0xd5,0x0d,0x05,0xc5,0x88,0x05,0xc5,0x8d,0xdc,0x58,0x5e,0xcd,0xdf,
		0x65,0xdd,0xe5,0x8d,0xd5,0x01,0x01,0x0d,0x0a,0x56,0xd5,0x88,0x54,0xdd,0xdf,
		0x66,0xdd,0xdd,0x83,0x8d,0x88,0x0d,0x50,0x50,0xd4,0x52,0x61,0x5e,0x45,0x80,0x5e,0x4d,0xd5,0xff,
		0x66,0x50,0xdd,0x5c,0x58,0x0d,0xda,0x6d,0x80,0xdd,0x88,0x0d,0x01,0x01,0x0d,0xdd,0xdf,
		0x66,0x4d,0xde,0x45,0x8d,0x54,0x50,0xa0,0xd5,0x91,0x0d,0x86,0x20,0xd8,0x0d,0xdd,0xdf,
		0x57,0x4d,0xd5,0x45,0x06,0x05,0x45,0x80,0xdd,0x20,0xd0,0x91,0xd0,0xa0,0xdd,0x85,0xcd,0xdf,
		0x66,0xdd,0xde,0x58,0x01,0x5e,0x50,0xd0,0xd5,0x8a,0x6d,0x05,0x80,0xd1,0x8d,0xdd,0xdf,
		0x66,0xdd,0x5e,0x58,0x05,0xe5,0x06,0x05,0xe5,0x0a,0xdd,0x51,0x01,0x05,0x45,0x88,0x54,0xdd,0xdf,
		0x56,0xdd,0xe5,0x8d,0xd0,0xa0,0xd9,0x10,0xd0,0x62,0x0d,0x80,0xdd,0xd5,0xff,
		0x66,0xcd,0xde,0x4d,0x85,0xed,0x62,0x1d,0x50,0xa8,0xd0,0x10,0x10,0xdd,0x80,0x5c,0xdd,0x5f,
		0x66,0x4d,0xde,0xd8,0xdd,0x88,0x0d,0x1b,0x26,0xd8,0x0d,0xd5,0x85,0xe4,0xdd,0xff,
		0x66,0xdd,0xdd,0x10,0x58,0xd8,0x28,0xd1,0x02,0x56,0xd8,0x28,0xd1,0x05,0x8d,0xdd,0xdf,
		0x85,0xcd,0xde,0xd5,0x8d,0xd5,0x88,0x80,0xd6,0x2b,0x31,0x0d,0x88,0x80,0xdd,0xdd,0xdf,
		0xe4,0xdd,0xe5,0x8d,0xdd,0xdd,0xd5,0x02,0x02,0x02,0x02,0x02,0x06,0x0d,0x09,0x91,0x88,0x80,0xdd,0xdd,0xdd,0xdd,0xff,
		0x87,0xcc,0xcd,0xdd,0xd0,0x51,0xd8,0x0d,0x51,0xd8,0x02,0x05,0x1d,0x02,0x82,0x8d,0xdd,0x65,0x05,0xcc,0x58,0x05,0xcc,0xdd,0x5f,
		0x96,0xdd,0xdd,0xd5,0x88,0x88,0xd0,0xd1,0xd5,0x0d,0x05,0x0a,0x01,0x0d,0x01,0x06,0x2d,0x0d,0xdd,0x88,0x5c,0xcd,0xdd,0xff,
		0x65,0x4d,0xd5,0xe4,0x58,0x05,0xed,0x80,0xd5,0x0a,0x20,0xd0,0x17,0x10,0xdd,0xdd,0xff,
		0x75,0xdd,0xd5,0xe5,0x88,0x05,0xe5,0x6a,0x20,0xd5,0x85,0x91,0xd5,0x88,0xd4,0xdd,0xdf,
		0x67,0xc4,0xdd,0xc4,0x58,0x5c,0x45,0x60,0xdd,0x52,0x1d,0x80,0x21,0xd0,0x50,0x21,0xd8,0x8d,0xdd,0xdf,
		0x42,0xdd,0xd6,0x21,0xdd,0xdf,
		0x56,0xdd,0xd5,0x91,0x0d,0x82,0x0d,0x05,0x2d,0x58,0x20,0xd8,0x60,0xdd,0xd5,0xff,
		0x67,0x4d,0xdd,0xd8,0x8d,0x8d,0x0d,0x05,0x02,0x0d,0x83,0x01,0xd5,0x05,0x6d,0x45,0x80,0x5e,0x4d,0xd5,0xff,
		0xa6,0xcd,0xdd,0x5e,0xd5,0x88,0x05,0xe5,0x02,0x02,0x80,0x5e,0x50,0xd5,0x0d,0xdd,0x06,0x01,0x01,0x80,0xd8,0x0d,0x58,0x0d,0xdd,0x0d,0xd5,0xff,
		0x77,0xdd,0xde,0x58,0x60,0x5e,0x58,0x50,0xde,0x50,0x15,0x8d,0x50,0x1a,0x20,0xd0,0x15,0x80,0xdd,0x58,0x05,0xc4,0xdd,0x5f,
		0x96,0xcd,0xde,0xd5,0x8d,0xdd,0x82,0x86,0x9d,0x02,0x88,0x50,0xdd,0x0d,0xd0,0x5c,0x58,0x88,0x5c,0xdd,0xdd,0xff,
		0x76,0xdd,0xe5,0x8d,0x5e,0x58,0x8d,0xd8,0x23,0x60,0xdd,0x01,0x50,0x5c,0x58,0x85,0xcd,0xdd,0xff,
		0x57,0xcd,0xdd,0x50,0x6d,0x82,0x0d,0x83,0x1d,0x83,0x1d,0x82,0x0d,0xd8,0x5c,0xdd,0xff,
		0x66,0x4d,0xd5,0xed,0x10,0x1d,0x50,0x30,0x30,0xd8,0x58,0xd0,0x20,0x20,0xd5,0x06,0x0d,0x4d,0xd5,0xff,
		0xb7,0xcc,0xcd,0xdd,0xcc,0xc5,0x88,0x5c,0xdd,0x50,0x18,0xdd,0x8d,0x51,0x8d,0x02,0x82,0x81,0x0d,0x50,0x6a,0x05,0x01,0x05,0xed,0x88,0xdd,0x5e,0x4d,0xdd,0xff,
		0x97,0xdd,0xdd,0xe5,0x06,0x05,0x85,0xe5,0x88,0x85,0xed,0xd5,0x20,0x5e,0xcc,0x58,0xd5,0x4d,0x05,0x20,0x95,0x4d,0x05,0x8d,0x5c,0xcd,0xdf,
		0x65,0xdd,0x5e,0x58,0x0d,0xd8,0x28,0xd5,0x30,0x10,0x54,0x58,0x06,0x54,0xdd,0xdf,
		0x66,0xdd,0xe5,0x8d,0xd5,0x13,0x28,0xd0,0x12,0x50,0xd5,0x06,0x85,0x45,0x80,0xd4,0xdd,0x5f,
		0xc5,0xc4,0xdd,0xdd,0xdd,0xd8,0x8d,0x8d,0x8a,0x29,0x92,0x6d,0x88,0x8d,0x58,0xd8,0x0d,0xd0,0xdd,0xdd,0x5f,
		0x67,0xdd,0x5e,0x58,0x0d,0xe5,0x05,0x85,0xe5,0x62,0x31,0xdd,0x81,0x05,0x45,0x02,0x50,0x54,0xd8,0x05,0xcd,0xd5,0xff,
		0x96,0x4d,0xde,0x45,0x8d,0xdd,0xd8,0x82,0x8d,0x01,0x50,0x28,0x0d,0x01,0x52,0xdd,0xd0,0x16,0x05,0xed,0xdd,0xff,
		0xa7,0xdd,0x8d,0xde,0x58,0xdd,0x85,0xe5,0x85,0x85,0x85,0xe5,0x85,0x88,0x2d,0x58,0x10,0x15,0x28,0xd6,0x0d,0x05,0x02,0x0d,0x80,0x10,0x58,0x0d,0xdd,0xdd,0xdf,
		0xa7,0x4d,0xde,0x45,0x8d,0xdd,0x54,0x52,0x06,0x58,0x01,0xd5,0x05,0xa8,0x01,0xd8,0x28,0xd9,0xd8,0x05,0x0d,0xdd,0xd8,0x05,0xec,0xdd,0x5f,
		0x96,0x4d,0xdd,0x5e,0xd0,0x99,0xde,0x58,0x0d,0xdd,0x58,0x02,0x02,0x06,0xdd,0x82,0x02,0x05,0xcd,0x58,0x85,0xcc,0xdd,0xdf,
		0xa6,0xdd,0xdd,0xde,0x50,0x60,0x99,0x05,0xe5,0x80,0xdd,0x2d,0xd0,0x58,0x20,0x20,0x54,0x50,0x28,0x88,0x54,0x58,0x0d,0xdd,0x4d,0xd5,0xff,
		0xa7,0x4d,0xdd,0x5e,0xd8,0x80,0xde,0x58,0x20,0x28,0x5e,0x50,0x20,0x20,0x20,0x5e,0xd0,0xd5,0x0d,0xd4,0x56,0x89,0x91,0x54,0xd8,0x80,0xd5,0xcd,0xdd,0x5f,
		0x95,0x4d,0xdd,0xd5,0x45,0x88,0x58,0xd5,0x02,0x52,0x58,0xd8,0x12,0x16,0x8d,0x81,0x58,0x8d,0xdd,0xdd,0x5f,
		0x77,0xdd,0x5e,0x58,0x0d,0x5e,0x50,0x18,0x0d,0xd3,0x52,0x8d,0x01,0x50,0x20,0xd0,0x6d,0x0d,0x58,0x80,0x5e,0xdd,0xd5,0xff,
		0x87,0xcc,0xdd,0xec,0xd5,0x8d,0x4d,0x02,0x80,0xd5,0x02,0x85,0x0d,0x06,0x5a,0x8d,0x09,0x8d,0xd0,0x9d,0x5e,0xdd,0x5f,
		0x96,0x4d,0xdd,0xde,0x45,0x86,0x80,0x5e,0x45,0x02,0x82,0x05,0xed,0x50,0xd0,0xdd,0x82,0x92,0x8d,0x80,0x98,0x0d,0xdd,0xdd,0x5f,
		0xa4,0xdd,0xdd,0xdd,0x88,0x1d,0x8d,0x0a,0x69,0xa0,0xd8,0x0d,0x18,0x0d,0xdd,0xdd,0xdf,
		0x87,0xdd,0xdd,0xd0,0x60,0x58,0x0d,0x02,0x02,0x80,0xd5,0x2d,0x50,0xd5,0x89,0x18,0xd8,0x05,0x80,0xdd,0xd5,0x85,0xcc,0x4d,0xdf,
		0x77,0xdd,0xdd,0x56,0x88,0x0d,0x01,0xa1,0x0d,0x02,0x92,0x0d,0x02,0x92,0x0d,0x01,0xa1,0x0d,0x88,0x8d,0xdd,0xd5,0xff,
		0x77,0xdd,0xd5,0xe5,0x06,0x58,0x5e,0x51,0x28,0x05,0xe5,0x10,0x50,0x2d,0x51,0x25,0x80,0xd1,0x05,0x02,0x0d,0x85,0x80,0xdd,0xdd,0x5f,
		0xa7,0xdd,0xdd,0xdd,0x99,0x58,0x8d,0x85,0x80,0xa0,0xd8,0x68,0xd8,0xd8,0x80,0xd2,0x0d,0xdd,0x58,0x20,0x5c,0xc4,0x58,0x85,0xcc,0x4d,0xdd,0xff,
		0x77,0xcd,0xd5,0xec,0x50,0x10,0xdd,0x50,0x28,0xd0,0x10,0x25,0x6d,0x05,0x20,0x10,0xd8,0x20,0xdd,0x50,0x10,0x5e,0x4d,0xd5,0xff,
		0x77,0xdd,0xdd,0x58,0x88,0xd0,0x2b,0x30,0xd0,0x38,0x30,0xd0,0x38,0x30,0xd0,0xb3,0x10,0xd8,0x80,0x6d,0xdd,0xd5,0xff,
		0xe7,0xdd,0x88,0x0d,0xd5,0xe5,0x8d,0x58,0x05,0x80,0xd5,0x88,0x58,0x05,0x20,0x20,0xd9,0x50,0xdd,0x50,0x58,0xd8,0x68,0x85,0x02,0x02,0x0d,0x95,0x88,0x88,0x0d,0xd8,0x0d,0xdd,0xd5,0xe4,0xdd,0x5f,
		0xb7,0xcc,0xdd,0x5e,0xdd,0x58,0x0d,0xd5,0x88,0x05,0x88,0xd8,0x59,0x91,0x8d,0x58,0xd0,0x50,0xd5,0x45,0xa6,0xa2,0x05,0xe4,0x58,0x80,0xd5,0xe4,0xdd,0xd5,0xff,
		0x96,0xcc,0x4d,0xd5,0xc4,0xd5,0x80,0xdd,0x59,0x91,0xd0,0x6a,0xa2,0x0d,0x88,0x05,0x0d,0xdd,0x58,0x05,0xec,0xcd,0xd5,0xff,
		0xc7,0xcc,0xcd,0xd5,0xec,0xcc,0x58,0x0d,0xec,0xcc,0x50,0x28,0x5e,0xdd,0xdd,0x05,0x6d,0x50,0x18,0x50,0x20,0x28,0xd8,0x88,0x82,0x50,0xd9,0x1d,0xd5,0x80,0xdd,0xd8,0x0d,0xd5,0xff,
		0xb6,0x4d,0xdd,0xdd,0xd5,0x99,0x91,0x8d,0x0a,0xaa,0x26,0x0d,0x80,0x50,0x50,0x50,0xd5,0x05,0x05,0x88,0x05,0xe5,0x80,0xdd,0xd5,0xed,0xd5,0xff,
		0xa7,0xcd,0xdd,0xdd,0xd8,0x05,0x80,0xd0,0x30,0x20,0x10,0x10,0xd8,0x02,0x0d,0x0d,0xdd,0x35,0x80,0x5e,0x45,0x86,0x8d,0x5e,0x45,0x80,0xd5,0xe4,0xdd,0x5f,
		0xa7,0xcd,0xdd,0xdd,0xd0,0x60,0x58,0x0d,0x03,0x02,0x03,0x90,0xd8,0x02,0x05,0x80,0xdd,0x53,0x58,0xd5,0x45,0x88,0x0d,0xe4,0x58,0x0d,0x5e,0x4d,0xd5,0xff,
		0xb6,0xdd,0x58,0xdd,0xd8,0x0d,0xd9,0x0d,0x0a,0x28,0x88,0xd8,0x02,0x58,0x90,0xdd,0x06,0x58,0xd0,0x5c,0x58,0xd8,0x85,0xcd,0xdd,0xdd,0xff,
		0x97,0xdd,0xe5,0x06,0xd5,0xe5,0x13,0x8d,0xdd,0x95,0xa0,0x20,0xd5,0x88,0x80,0x54,0x50,0x50,0xd8,0x54,0x58,0x0d,0xd5,0x4d,0xd5,0xff,
		0x97,0x4d,0xdd,0x5e,0x45,0x81,0x01,0xd5,0x45,0x01,0x01,0x01,0x0d,0xd0,0xdd,0x0d,0x86,0x28,0x20,0xd8,0xa8,0x20,0xdd,0x58,0x0d,0x5c,0x4d,0xd5,0xff,
		0xa6,0xdd,0xd5,0xe5,0x88,0x0d,0xdd,0x0a,0x56,0xd9,0xd0,0x58,0x88,0x0d,0x82,0x05,0x05,0x8d,0xd5,0x02,0x89,0x5c,0x4d,0xdd,0xdf,
		0x87,0x4d,0xdd,0x5e,0x45,0x88,0x05,0xed,0x0d,0x52,0xd5,0x12,0x80,0x60,0xd0,0x90,0x52,0x0d,0x1d,0x82,0x0d,0x88,0xdd,0xdd,0xdf,
		0xe6,0xdd,0xdd,0xd5,0xe5,0x81,0x85,0x80,0x5e,0x50,0x51,0x86,0x80,0x5e,0x58,0x59,0x50,0xdd,0xdd,0x58,0xd0,0xa0,0x20,0x20,0x54,0xd8,0x88,0x88,0x05,0xcd,0xdd,0xdd,0xd5,0xff,
};

#endif