/*
 *  smoke3D.cpp
 *  smoke3D
 *
 */

#include "sysUtility.h"

#include <stdio.h>

//--------------------------------------------------------------
// Output a log message.
//--------------------------------------------------------------
timeval SysUtl::curSysTime()
{
    struct timeval tv;
    struct timezone tz;
    
    int ret = gettimeofday(&tv, &tz);
    
//    if(ret == 0) {
//        printf("Succeed in get system time. %ld: %d \n", tv.tv_sec, tv.tv_usec);
//    }
//    else {
//        printf("Failed in get system time. \n");
//    }
    
    return tv;
}

// 使用毫秒单位打印差值时间。
void SysUtl::logDeltaTime(const timeval& startTime, const timeval& endTime, const char* pTitle)
{
    timeval dt;
    dt.tv_sec  = endTime.tv_sec  - startTime.tv_sec;
    dt.tv_usec = endTime.tv_usec - startTime.tv_usec;
    
    float deltaMS = dt.tv_sec * 1000.0f + static_cast<float>(dt.tv_usec)/1000.0f;
    
//    printf("Delta time is: %ld: %d. \n", dt.tv_sec, dt.tv_usec);
    printf("%s Delta millisecond time is:%f. \n", pTitle, deltaMS);

}

// 补丁函数。将一个 1Byte 的灰度图转化为 3Bytes 的RGB图。 因为现在的图片存储函数只支持RGB／RGBA格式，才有这个转化用补丁。
void SysUtl::transYtoRGB(gl_lib::Image2D& in, gl_lib::Image2D& out)
{
    int width  = in.GetWidth();
    int height = in.GetHeight();
    int bpp    = in.GetBpp();
    
    uint8_t * pIn  = in.GetBuffer();
    uint8_t * pOut = out.GetBuffer();
 
//    printf("transYtoRGB In image. width: %d, height: %d, bpp: %d. \n", width, height, bpp);
//    printf("transYtoRGB out image. width: %d, height: %d, bpp: %d. \n", out.GetWidth(), out.GetHeight(), out.GetBpp());

    int outOffset = 0;
    int inOffset  = 0;
    int pixelNum = width * height;
    for(int i=0; i<pixelNum; ++i)
    {
        pOut[(outOffset) ]    = pIn[inOffset];
        pOut[(outOffset) + 1] = pIn[inOffset];
        pOut[(outOffset) + 2] = pIn[inOffset];
        pOut[(outOffset) + 3] = 255;
        inOffset++;
        outOffset += 4;
    }
}
