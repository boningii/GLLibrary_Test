
#ifndef LOG_OUTPUTER_H
#define LOG_OUTPUTER_H

#include <string>
#include <vector>
#include <sys/time.h>
#include <time.h>

#include "ViewController.h"

//----------------------------------------------
// Log Manager.
//----------------------------------------------
class LogManager
{
protected:
    //-------------------------
    // 自身的数据。
	//-------------------------
    // Log Data Pool
    std::vector<std::string> mLogPool;
    
    // Shared Pointer.
    static LogManager* mSharedPtr;
    
public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    LogManager();
    ~LogManager();

    //-------------------------
    // 全局对象的取得与释放。
    //-------------------------
    static LogManager* singleton();
    static void releaseSingleton();
    
    //-------------------------
    // 功能函数。
    //-------------------------
    void printStr(const char* str, bool clearPool=false);
    //void printImgSize(const std::string& str, int imgWidth, int imgHeight, int imgBpp);
    
    // 使用毫秒单位打印差值时间。
    void logDeltaTime(const timeval& startTime, const timeval& endTime, const char* pTitle = "");
    
    // 取得输出用字符串。
    std::string GetOutputString();
};

#endif
