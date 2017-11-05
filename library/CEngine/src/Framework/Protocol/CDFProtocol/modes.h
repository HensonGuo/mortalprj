/* ====================================================================
 * Copyright (c) 2008 The OpenSSL Project. All rights reserved.
 *
 * Rights for redistribution and usage in source and binary
 * forms are granted according to the OpenSSL license.
 */
#ifndef HEADER_CDL_MODES_H
#define HEADER_CDL_MODES_H
#include <stddef.h>

typedef void (*block128_f)(const unsigned char in[16],
			unsigned char out[16],
			const void *key);

typedef void (*cbc128_f)(const unsigned char *in, unsigned char *out,
			size_t len, const void *key,
			unsigned char ivec[16], int enc);

void crypto_cbc128_encrypt(const unsigned char *in, unsigned char *out,
			size_t len, const void *key,
			unsigned char ivec[16], block128_f block);
void crypto_cbc128_decrypt(const unsigned char *in, unsigned char *out,
			size_t len, const void *key,
			unsigned char ivec[16], block128_f block);
#endif
