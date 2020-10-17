
#include "LogOutputer.h"
#include <stdio.h>
#include <stdlib.h>

//----------------------------------------------
// 静态成员初始化。
//----------------------------------------------
LogManager* LogManager::mSharedPtr = NULL;

//----------------------------------------------
// OpenGL Render Control Interface
//----------------------------------------------
LogManager::LogManager()
{
}

LogManager::~LogManager()
{
}

//-------------------------
// 全局对象的取得与释放。
//-------------------------
LogManager* LogManager::singleton()
{
    if (NULL == mSharedPtr) {
        mSharedPtr = new LogManager();
    }
    
    return mSharedPtr;
}

void LogManager::releaseSingleton()
{
    if (NULL != mSharedPtr) {
        delete mSharedPtr;
        mSharedPtr = NULL;
    }
}

void LogManager::printStr(const char* str, bool clearPool)
{
    //-----------------
    // Terminal Log.
    //-----------------
    NSLog(@"%@", [NSString stringWithUTF8String:str]);
    
    //-----------------
    // UI Log.
    //-----------------
    if (clearPool == true) {
        mLogPool.clear();
    }
    
    // Output Log.
    std::string newStr = str;
    mLogPool.push_back(newStr);
}

//void LogManager::printImgSize(const std::string& str, int imgWidth, int imgHeight, int imgBpp)
//{
//    char tmp[512];
//    sprintf(tmp, "%s width: %d, height: %d. bpp: %d. \n", str.c_str(), imgWidth, imgHeight, imgBpp);
//    this->printStr(tmp);
//}

// 使用毫秒单位打印差值时间。
void LogManager::logDeltaTime(const timeval& startTime, const timeval& endTime, const char* pTitle)
{
    timeval dt;
    dt.tv_sec  = endTime.tv_sec  - startTime.tv_sec;
    dt.tv_usec = endTime.tv_usec - startTime.tv_usec;
    
    float deltaMS = dt.tv_sec * 1000.0f + static_cast<float>(dt.tv_usec)/1000.0f;
    
    //printf("%s Delta millisecond time is:%f. \n", pTitle, deltaMS);
    
    char tmp[512];
    sprintf(tmp, "%s Delta millisecond time is:%f. ", pTitle, deltaMS);
    this->printStr(tmp);
}

// 取得输出用字符串。
std::string LogManager::GetOutputString()
{
    std::string outStr;
    for (auto&strLine : mLogPool) {
        outStr += strLine;
        outStr += "\n";
    }
    
    //mViewCtl.mTxtLogOutput.text = [NSString stringWithUTF8String:outStr.c_str()];
    return outStr;
}

