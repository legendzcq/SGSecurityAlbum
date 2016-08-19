//
//  NSData+Md5.m
//  LKFMDB_Demo
//
//  Created by 张传奇 on 16/8/19.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "NSData+Md5.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSData (Md5)
- (NSString *)md5String
{
    const char *str = [self bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)self.length, result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

-(NSString *)imageIDString
{
   NSString * tempmd5 =  [self md5String];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString * temp = [NSString stringWithFormat:@"%@%@",tempmd5,locationString];
    return [temp MD5];
}
@end
