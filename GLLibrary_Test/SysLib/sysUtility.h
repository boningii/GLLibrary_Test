/*
 *  globalVariable.h
 *  globalVariable
 *
 */

#ifndef SYSTEM_UTILITY_H
#define SYSTEM_UTILITY_H

//----------------------------------------------
// 系统头文件。
//----------------------------------------------
#include <sys/time.h>
#include <time.h>
#include "glLibrary.h"

//----------------------------------------------
// 通用工具函数。
//----------------------------------------------
class SysUtl
{
public:
	static timeval curSysTime();        // 获取当前的系统时间(微秒级别 0.000001 秒)。
    static void logDeltaTime(const timeval& startTime, const timeval& endTime, const char* pTitle = "");    // 使用毫秒单位打印差值时间。

    // 补丁函数。将一个 1Byte 的灰度图转化为 3Bytes 的RGB图。 因为现在的图片存储函数只支持RGB／RGBA格式，才有这个转化用补丁。
    static void transYtoRGB(gl_lib::Image2D& in, gl_lib::Image2D& out);

};


#endif
