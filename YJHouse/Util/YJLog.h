//
//  YJLog.h
//  YJHouse
//
//  Created by 刘金凯 on 2017/2/18.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#ifndef YJLog_h
#define YJLog_h

#import <Foundation/Foundation.h>
#include <sys/time.h>

#ifdef DEBUG
#define YJLog(args...) _DebugLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define YJLog(args...)
#endif

#define ProdLog NSLog

static inline void _DebugLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    va_list ap;
    
    va_start (ap, format);
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body =  [[NSString alloc] initWithFormat: format arguments: ap];
    va_end (ap);
    const char *threadName = [[[NSThread currentThread] name] UTF8String];
    NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
    
    char            fmt[64] = {'\0'}, timebuf[64] = {'\0'};
    struct timeval  tv;
    struct tm       *tm;
    
    gettimeofday(&tv, NULL);
    if((tm = localtime(&tv.tv_sec)) != NULL)
    {
        strftime(fmt, sizeof fmt, "%Y-%m-%d %H:%M:%S.%%06u", tm);
        snprintf(timebuf, sizeof timebuf, fmt, tv.tv_usec);
    }
    
    if (threadName && strlen(threadName) > 0) {
        fprintf(stderr,"%s %s/%s (%s:%d) %s", timebuf, threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
    } else {
        fprintf(stderr,"%s %p/%s (%s:%d) %s", timebuf, [NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
    }
}

//  Debug Log - Rect
#ifdef DEBUG
#define YJLogRect(rect) YJLog(@"%@", NSStringFromCGRect(rect));
#else
#define YJLogRect(rect)
#endif

//  Debug Log - Size
#ifdef DEBUG
#define YJLogSize(size) YJLog(@"%@", NSStringFromCGSize(size));
#else
#define YJLogSize(size)
#endif

//  Debug Log - Point
#ifdef DEBUG
#define YJLogPoint(point) YJLog(@"%@", NSStringFromCGPoint(point));
#else
#define YJLogPoint(point)
#endif

//  Debug Log - BOOL
#ifdef DEBUG
#define YJLogBOOL(b) YJLog(@"%@", [NSString stringWithFormat:@"%@", b ? @"YES" : @"NO"]);
#else
#define YJLogBOOL(b)
#endif

//  Debug Log - BOOL
#ifdef DEBUG
#define YJLogBOOLM(b, s) YJLog(@"%@ - %@", [NSString stringWithFormat:@"%@", s], [NSString stringWithFormat:@"%@", b ? @"YES" : @"NO"]);
#else
#define YJLogBOOLM(b, s)
#endif


#define DEBUG_LINE()    YJLog(@"-----------------------")

#endif /* YJLog_h */
