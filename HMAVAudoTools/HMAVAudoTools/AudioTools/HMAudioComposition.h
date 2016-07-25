//
//  HMAudioComposition.h
//  HMAVAudoTools
//
//  Created by 传智.小飞燕 on 16/7/25.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMAudioComposition : NSObject

/// 合并音频文件
/// @param sourceURLs 需要合并的多个音频文件
/// @param toURL      合并后音频文件的存放地址
/// 注意:导出的文件是:m4a格式的.
+ (void) sourceURLs:(NSArray *) sourceURLs composeToURL:(NSURL *) toURL completed:(void (^)(NSError *error)) completed;

@end
