#ifndef __CRC_H
#define __CRC_H


#include <types.h>

// polynomical value to XOR when 1 pops out.
#define POLYNOM_CRC7  (0x9)       


// CRC7
unsigned char crc7( unsigned char Seed, unsigned char Input , unsigned char Depth);
uint8_t CRC7(const uint8_t* data, uint8_t n);


// CRC16
uint16_t CRC_CCITT(const uint8_t *data, size_t n);

#endif