#ifndef MD5_H
#define MD5_H

#ifdef _TRACE_INFO_
#define TRACE_INFO printf
#else
#define TRACE_INFO //
#endif

typedef unsigned int uint32;

struct MD5Context {
	uint32 buf[4];
	uint32 bits[2];
	unsigned char in[64];
};

void MD5Init(struct MD5Context *context);
void MD5Update(struct MD5Context *context, unsigned char const *buf,unsigned len);
void MD5Final(unsigned char digest[16], struct MD5Context *context);
void MD5Transform(uint32 buf[4], uint32 const in[16]);
int GetMd5Resulte(unsigned char *outResult, char *input, int inputlen);

//把16字节的MD5数字摘要格式化为32个字符表示
void FormatMD5Digest(unsigned char *md5Digest, char* outMd5Str);
/*
 * This is needed to make RSAREF happy on some MS-DOS compilers.
 */
typedef struct MD5Context MD5_CTX;

#endif /* !MD5_H */
