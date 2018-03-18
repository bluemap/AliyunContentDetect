/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			:
 *
 * Description	: NSData MD5散列
 *
 * Author		: wangqz@ucweb.com
 *
 * History		: Creation, 2014/09/03
 ******************************************************************************
 **/

#import "NSData+MD5.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5Extend)

- (NSData*)md5Data
{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

@end
