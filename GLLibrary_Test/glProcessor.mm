
#include "glProcessor.h"
#include "LogOutputer.h"
#include "imgManager.h"
#include "sysUtility.h"
#include "glLibrary.h"

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#include <OpenGLES/ES3/gl.h>


//----------------------------------------------
// 静态成员初始化。
//----------------------------------------------
GLProcessor* GLProcessor::mProcessor = NULL;
gl_lib::GLManager*   GLProcessor::mGLMgr     = NULL;

//----------------------------------------------
// OpenGL Render Control Interface
//----------------------------------------------
GLProcessor::GLProcessor()
: mThread(0)
, mFuncToDo(GLF_NONE)
, mInTex(NULL)
{
}

GLProcessor::~GLProcessor()
{
}

//-------------------------
// Sub thread function。
//-------------------------
void* GLProcessor::processThread(void* pData)
{
    NSLog(@"Enter sub thread.");
    
    //---------------------
    // 1.0 初始化。
    //---------------------
    // 1.1 创建这个线程使用的OpenGL Context。
    //    EAGLContext* _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    EAGLContext* _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Init failed.");
    }
    
    // 1.2 创建OpenGLManager。
    mGLMgr = new gl_lib::GLManager();
    mGLMgr->Init(0, 0);
    
    // 1.3 将输入指针转换为制定类型。
    GLProcessor* pProcessor = static_cast<GLProcessor*>(pData);
    
    //---------------------
    // 2.0 无限循环， 处理发生的命令。
    //---------------------
    while(true) {
        if (pProcessor->mFuncToDo == GLF_Y_TRANS) {
            pProcessor->funcTranY();        // 执行Y变换。
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcTranY_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == GLF_CONTRAST) {
            pProcessor->funcContrast();    // 对比度调节功能。
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcContrast_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == GLF_LUMINATION) {
            pProcessor->funcLumination();    // 亮度调节功能。
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcLumination_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == GLF_CONTRAST_LUMINATION) {
            pProcessor->funcContrastLumination();    // 对比度, 亮度调节功能。
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcContrastLumination_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == GLF_SATURATION_RATE) {
            pProcessor->funcSaturationRate();    // 根据变化比率调节饱和度.
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcSaturationRate_GPU_Time();
        }
#if 0
        else if (pProcessor->mFuncToDo == GLF_SCALE_NEAREST) {
            pProcessor->funcNearestScale();    // Nearest算法进行缩放功能.
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcNearestScale_GPU_Time();
        }
#endif
        else if (pProcessor->mFuncToDo == GLF_SCALE_BILINEAR) {
            pProcessor->funcBilinearScale();    // Bilinear算法进行缩放功能.
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcBilinearScale_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == GLF_SCALE_BICUBIC) {
            pProcessor->funcBicubicScale();    // Bicubic算法进行缩放功能.
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcBicubicScale_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == GLF_SCALE_BOX) {
            pProcessor->funcBoxScale();    // Box算法进行缩放功能.
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcBoxScale_GPU_Time();
        }
        else if (pProcessor->mFuncToDo == CLF_SCALE_LANCZOS) {
            pProcessor->funcLanczosScale();    // Lanczos算法进行缩放功能.
            LogManager::singleton()->printStr("---------------- GPU Time Details ----------------");
            pProcessor->funcLanczosScale_GPU_Time();
        }
    }
    
    //---------------------
    // 3.0 结束。删除OpenGL Context。
    //---------------------
    delete mGLMgr;
    mGLMgr = NULL;
    
    return NULL;
}

//-------------------------
// 取得当前处理算法。
//-------------------------
GL_FUNC_DEF GLProcessor::getFuncToDo()
{
    return mFuncToDo;
}

//-------------------------
// 取得输出路径。
//-------------------------
std::string GLProcessor::getOutputPath(GL_FUNC_DEF func, bool gpu)
{
    std::string ret;
    
    switch (func) {
        case GLF_Y_TRANS:
            ret = "Y_Trans_";
            break;
        case GLF_CONTRAST:
            ret = "Contrast_";
            break;
        case GLF_LUMINATION:
            ret = "Lumination_";
            break;
        case GLF_CONTRAST_LUMINATION:
            ret = "Contrast_Lumination_";
            break;
        case GLF_SATURATION_RATE:
            ret = "Saturation_Rate_";
            break;
#if 0
        case GLF_SCALE_NEAREST:
            ret = "Nearest_Scale_";
            break;
#endif
        case GLF_SCALE_BILINEAR:
            ret = "Bilinear_Scale_";
            break;
        case GLF_SCALE_BICUBIC:
            ret = "Bicubic_Scale_";
            break;
        case GLF_SCALE_BOX:
            ret = "Box_Scale_";
            break;
        case CLF_SCALE_LANCZOS:
            ret = "Lanczos_3_Scale_";
            break;
    }
    
    if (gpu == true) {
        ret += "GPU.png";
    }
    else {
        ret += "CPU.png";
    }
    
    return ret;
}

//-------------------------
// 内部功能函数
//-------------------------
// Y变换功能。
void GLProcessor::funcTranY()
{
#if 0
    int maxSize;
    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxSize);
    printf("Max Tex size: %d. \n", maxSize);
#endif
    
    LogManager::singleton()->printStr("Start to do Y transition. ");
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    //pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[500];
    sprintf(tmp, "In texture width: %d, height: %d. ", mInTex->GetWidth(), mInTex->GetHeight());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Trans.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。

timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::TransY(mInTex, pCpuOutTex);
timeval cpuEndTime = SysUtl::curSysTime();      // 测量系统时间。
LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Trans Y.   ->  ");
    
    // 写入结果文件。
    gl_lib::Image2D* pCpuOutTexRGB= new gl_lib::Image2D();
    pCpuOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    SysUtl::transYtoRGB(*pCpuOutTex, *pCpuOutTexRGB);
    pImgMgr->writeImage(pCpuOutTexRGB, getOutputPath(mFuncToDo, false).c_str());  //"Y_Trans_CPU.png");
   
    //-----------------------------
    // GPU Y变换处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), mInTex->GetBpp(), NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // init.
    class gl_lib::TransY gl_render;
    gl_render.Init();
    glFinish();
    
    // Input and process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->TransY(mInTex, pOutTex);
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    gl_render.Draw();
    glFinish();
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Trans Y.   ->  ");
    
    // Read out and 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());    //"Y_Trans_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    delete pOutTex;
    delete pCpuOutTex;
    delete pCpuOutTexRGB;

    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// Y变换功能 --> 输出详细GPU动作时间。
void GLProcessor::funcTranY_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::TransY gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    glFinish();
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Trans Y  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Trans Y  ->  Draw. ");

    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    //glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Trans Y  ->  Read out data. ");

    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}


// 对比度调节功能。
void GLProcessor::funcContrast()
{
    LogManager::singleton()->printStr("Start to do contrast. ");
    
    mContrastPara = 0.5f;
    mDeltaLumination = 0;
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    // 转化为灰度图。
    gl_lib::Image2D* pGreyTex= new gl_lib::Image2D();
    pGreyTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    gl_lib::CPUFunc::TransY(mInTex, pGreyTex);
    
    int32_t avg_lumination = gl_lib::CPUFunc::CalculateAverageLuminance(pGreyTex);
    float avg_lumination_F = static_cast<float>(avg_lumination) / 255.0f;
    char tmp[512];
    sprintf(tmp, "Average lumination: %d . %f. ", avg_lumination, avg_lumination_F);
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Function.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::Contrast(mContrastPara, avg_lumination, pGreyTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Contrast Y.   ->  ");
    
    // 写入结果文件。
    gl_lib::Image2D* pCpuOutTexWrite= new gl_lib::Image2D();
    pCpuOutTexWrite->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);
    SysUtl::transYtoRGB(*pCpuOutTex, *pCpuOutTexWrite);
    pImgMgr->writeImage(pCpuOutTexWrite, getOutputPath(mFuncToDo, false).c_str());  //"Contrast_Y_CPU.png");
    
    //-----------------------------
    // GPU Grey image contrast处理。
    //-----------------------------
    gl_lib::Image2D* pOutTexY = new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTexY->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
 
    // Create GPU render.
    class gl_lib::ContrastLumi gl_render;
    gl_render.Init();
    glFinish();
    
    // Start process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->Contrast(mContrastPara, avg_lumination_F, pGreyTex, pOutTexY);
    gl_render.SetInput(avg_lumination_F, pGreyTex);
    gl_render.SetOutput(pOutTexY);
    gl_render.Contrast(mContrastPara);
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast Y.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTexY, getOutputPath(mFuncToDo, true).c_str());  //"Contrast_Y_GPU.png");

    //-----------------------------
    // CPU Function RGB.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTexRGB = new gl_lib::Image2D();
    pCpuOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::Contrast(mContrastPara, avg_lumination, mInTex, pCpuOutTexRGB);
    timeval cpuEndTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTimeRGB, cpuEndTimeRGB, "CPU Contrast RGB.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTexRGB, "Contrast_RGB_CPU.png");
    
    //-----------------------------
    // GPU RGB image contrast处理。
    //-----------------------------
    gl_lib::Image2D* pOutTexRGB = new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval startTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->Contrast(mContrastPara, avg_lumination_F, mInTex, pOutTexRGB);
    gl_render.SetInput(avg_lumination_F, mInTex);
    gl_render.SetOutput(pOutTexRGB);
    gl_render.Contrast(mContrastPara);
    timeval endTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTimeRGB, endTimeRGB, "GPU Contrast RGB.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTexRGB, "Contrast_RGB_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    delete pGreyTex;
    delete pOutTexY;
    delete pCpuOutTex;
    delete pOutTexRGB;
    delete pCpuOutTexRGB;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// RGB对比度调节功能 --> 输出详细GPU动作时间。
void GLProcessor::funcContrast_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    int32_t avg_lumination = gl_lib::CPUFunc::CalculateAverageLuminance(mInTex);
    float avg_lumination_F = static_cast<float>(avg_lumination) / 255.0f;
    //printf("Average lumination: %d . %f. ", avg_lumination, avg_lumination_F);
    char tmp[512];
    sprintf(tmp, "Average lumination: %d . %f. ", avg_lumination, avg_lumination_F);
    LogManager::singleton()->printStr(tmp);
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::ContrastLumi gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(avg_lumination_F, mInTex);
    gl_render.SetOutput(pOutTex);
    glFinish();
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Contrast(mContrastPara);
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// 对比度调节功能。
void GLProcessor::funcLumination()
{
    //printf("Start to do lumination. ");
    LogManager::singleton()->printStr("Start to do lumination. ");
    
    mContrastPara = 0.0f;
    mDeltaLumination = 60;
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    // 转化为灰度图。
    gl_lib::Image2D* pGreyTex= new gl_lib::Image2D();
    pGreyTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    gl_lib::CPUFunc::TransY(mInTex, pGreyTex);
    
    int32_t avg_lumination = gl_lib::CPUFunc::CalculateAverageLuminance(mInTex);
    mTargetLumination = avg_lumination + mDeltaLumination;
    char tmp[512];
    sprintf(tmp, "Average lumination: %d. Target lumination: %d. ", avg_lumination, mTargetLumination);
    LogManager::singleton()->printStr(tmp);
    
    float avg_lumination_F = static_cast<float>(avg_lumination) / 255.0f;
    float tar_lumination_F = static_cast<float>(mTargetLumination)/255.0f;
    
    //-----------------------------
    // CPU Function.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::Luminance(avg_lumination, mTargetLumination, pGreyTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Lumination Y.   ->  ");
    
    // 写入结果文件。
    gl_lib::Image2D* pCpuOutTexWrite = new gl_lib::Image2D();
    pCpuOutTexWrite->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);
    SysUtl::transYtoRGB(*pCpuOutTex, *pCpuOutTexWrite);
    pImgMgr->writeImage(pCpuOutTexWrite, getOutputPath(mFuncToDo, false).c_str());  //"Lumination_Y_CPU.png");
    
    //-----------------------------
    // GPU Grey image 处理。
    //-----------------------------
    gl_lib::Image2D* pOutTexY = new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTexY->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Init Render.
    class gl_lib::ContrastLumi gl_render;
    gl_render.Init();
    glFinish();
    
    // Start Process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->Luminance(avg_lumination_F, tar_lumination_F, pGreyTex, pOutTexY);
    gl_render.SetInput(avg_lumination_F, pGreyTex);
    gl_render.SetOutput(pOutTexY);
    gl_render.Luminance(tar_lumination_F);
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Lumination Y.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTexY, getOutputPath(mFuncToDo, true).c_str());  //"Lumination_Y_GPU.png");

    //-----------------------------
    // CPU Function RGB.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTexRGB = new gl_lib::Image2D();
    pCpuOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::Luminance(avg_lumination, mTargetLumination, mInTex, pCpuOutTexRGB);
    timeval cpuEndTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTimeRGB, cpuEndTimeRGB, "CPU Lumination RGB.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTexRGB, "Lumination_RGB_CPU.png");    // 文件读写中存在内存泄漏。 暂时没有进行对应。

    //-----------------------------
    // GPU RGB image contrast处理。
    //-----------------------------
    gl_lib::Image2D* pOutTexRGB = new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval startTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->Luminance(avg_lumination_F, tar_lumination_F, mInTex, pOutTexRGB);
    gl_render.SetInput(avg_lumination_F, mInTex);
    gl_render.SetOutput(pOutTexRGB);
    gl_render.Luminance(tar_lumination_F);
    timeval endTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTimeRGB, endTimeRGB, "GPU Lumination RGB.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTexRGB, "Lumination_RGB_GPU.png");    // 文件读写中存在内存泄漏。 暂时没有进行对应。
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    delete pGreyTex;
    delete pOutTexY;
    delete pCpuOutTex;
    delete pOutTexRGB;
    delete pCpuOutTexRGB;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// RGB亮度调节功能 --> 输出详细GPU动作时间。
void GLProcessor::funcLumination_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    int32_t avg_lumination = gl_lib::CPUFunc::CalculateAverageLuminance(mInTex);
    mTargetLumination = avg_lumination + mDeltaLumination;
    char tmp[512];
    sprintf(tmp, "Average lumination: %d. Target lumination: %d. ", avg_lumination, mTargetLumination);
    LogManager::singleton()->printStr(tmp);
    
    float avg_lumination_F = static_cast<float>(avg_lumination) / 255.0f;
    float tar_lumination_F = static_cast<float>(mTargetLumination)/255.0f;
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::ContrastLumi gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(avg_lumination_F, mInTex);
    gl_render.SetOutput(pOutTex);
    glFinish();
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Lumination  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Luminance(tar_lumination_F);
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Lumination  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Lumination  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// 调节对比度和亮度.
void GLProcessor::funcContrastLumination()
{
    LogManager::singleton()->printStr("Start to do contrast and lumination. ");
    
    mContrastPara = 0.5f;
    mDeltaLumination = 60;
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    // 转化为灰度图。
    gl_lib::Image2D* pGreyTex= new gl_lib::Image2D();
    pGreyTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    gl_lib::CPUFunc::TransY(mInTex, pGreyTex);
    
    int32_t avg_lumination = gl_lib::CPUFunc::CalculateAverageLuminance(mInTex);
    mTargetLumination = avg_lumination + mDeltaLumination;
    char tmp[512];
    sprintf(tmp, "Average lumination: %d. Target lumination: %d. ", avg_lumination, mTargetLumination);
    LogManager::singleton()->printStr(tmp);
    
    float avg_lumination_F = static_cast<float>(avg_lumination) / 255.0f;
    float tar_lumination_F = static_cast<float>(mTargetLumination)/255.0f;
    
    //-----------------------------
    // CPU Function.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 8, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ContrastAndLuminance(mContrastPara, avg_lumination, mTargetLumination, pGreyTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Contrast & Lumination Y.   ->  ");
    
    // 写入结果文件。
    gl_lib::Image2D* pCpuOutTexWrite = new gl_lib::Image2D();
    pCpuOutTexWrite->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);
    SysUtl::transYtoRGB(*pCpuOutTex, *pCpuOutTexWrite);
    pImgMgr->writeImage(pCpuOutTexWrite, getOutputPath(mFuncToDo, false).c_str());  //"ContrastLumination_Y_CPU.png");
    
    //-----------------------------
    // GPU Grey image contrast处理。
    //-----------------------------
    gl_lib::Image2D* pOutTexY = new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTexY->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Create Render.
    class gl_lib::ContrastLumi gl_render;
    gl_render.Init();
    glFinish();
    
    // Start to Process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->ContrastLuminance(mContrastPara, avg_lumination_F, tar_lumination_F, pGreyTex, pOutTexY);
    gl_render.SetInput(avg_lumination_F, pGreyTex);
    gl_render.SetOutput(pOutTexY);
    gl_render.Draw(mContrastPara, tar_lumination_F);
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast & Lumination Y.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTexY, getOutputPath(mFuncToDo, true).c_str());  //"ContrastLumination_Y_GPU.png");
    
    //-----------------------------
    // CPU Function RGB.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTexRGB = new gl_lib::Image2D();
    pCpuOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ContrastAndLuminance(mContrastPara, avg_lumination, mTargetLumination, mInTex, pCpuOutTexRGB);
    timeval cpuEndTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTimeRGB, cpuEndTimeRGB, "CPU Contrast & Lumination RGB.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTexRGB, "ContrastLumination_RGB_CPU.png");
    
    //-----------------------------
    // GPU RGB image contrast处理。
    //-----------------------------
    gl_lib::Image2D* pOutTexRGB = new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTexRGB->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Start to Process.
    timeval startTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->ContrastLuminance(mContrastPara, avg_lumination_F, tar_lumination_F, mInTex, pOutTexRGB);
    gl_render.SetInput(avg_lumination_F, mInTex);
    gl_render.SetOutput(pOutTexRGB);
    gl_render.Draw(mContrastPara, tar_lumination_F);
    timeval endTimeRGB = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTimeRGB, endTimeRGB, "GPU Contrast & Lumination RGB.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTexRGB, "ContrastLumination_RGB_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    delete pGreyTex;
    delete pCpuOutTex;
    delete pCpuOutTexWrite;
    delete pCpuOutTexRGB;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// RGB对比度&亮度调节功能 --> 输出详细GPU动作时间。
void GLProcessor::funcContrastLumination_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    int32_t avg_lumination = gl_lib::CPUFunc::CalculateAverageLuminance(mInTex);
    mTargetLumination = avg_lumination + mDeltaLumination;
    char tmp[512];
    sprintf(tmp, "Average lumination: %d. Target lumination: %d. ", avg_lumination, mTargetLumination);
    LogManager::singleton()->printStr(tmp);
    
    float avg_lumination_F = static_cast<float>(avg_lumination) / 255.0f;
    float tar_lumination_F = static_cast<float>(mTargetLumination)/255.0f;
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::ContrastLumi gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(avg_lumination_F, mInTex);
    gl_render.SetOutput(pOutTex);
    glFinish();
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast Lumination  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw(mContrastPara, tar_lumination_F);
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast Lumination  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Contrast Lumination  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// 调节饱和度
void GLProcessor::funcSaturationRate()
{
    LogManager::singleton()->printStr("Start to do saturation rate. ");
    
    mSaturationRate = 2.0f;

    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
//    pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[512];
    sprintf(tmp, "In texture width: %d, height: %d. bpp: %d. ", mInTex->GetWidth(), mInTex->GetHeight(), mInTex->GetBpp());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Trans.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::SaturationByRate(mSaturationRate, mInTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Saturation.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTex, getOutputPath(mFuncToDo, false).c_str());  //"Saturation_Rate_CPU.png");
    
    //-----------------------------
    // GPU Y变换处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), mInTex->GetBpp(), NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Create Render.
    class gl_lib::Saturation gl_render;
    gl_render.Init();
    glFinish();
    
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->Saturation(mSaturationRate, mInTex, pOutTex);
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    gl_render.Draw(mSaturationRate);
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Saturation.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());  //"Saturation_Rate_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    //delete pTex;
    delete pOutTex;
    delete pCpuOutTex;

    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

void GLProcessor::funcSaturationRate_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::Saturation gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    glFinish();
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Saturation  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw(mSaturationRate);
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Saturation  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Saturation  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

#if 0
// Nearest算法进行缩放功能。
void GLProcessor::funcNearestScale()
{
    LogManager::singleton()->printStr("Start to do nearest scale. ");
    
    // mScaleSize = gl_lib::Vec2(1920 * 2.1, 1080 * 2.1);    // 放大时需要考虑GPU支持的最大Texture尺寸。 iPad是4096*4096.
    mScaleSize = gl_lib::Vec2(600, 337);
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    //    pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[512];
    sprintf(tmp, "In texture width: %d, height: %d. ", mInTex->GetWidth(), mInTex->GetHeight());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Box Scale.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ScaleNearest(mInTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU nearest scale.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTex, getOutputPath(mFuncToDo, false).c_str());  //"Nearest_Scale_CPU.png");

    //-----------------------------
    // GPU 算法进行缩放处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    mGLMgr->NearestScale(mInTex, pOutTex);
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Nearest Scale.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());  //"Nearest_Scale_GPU.png");

    //-----------------------------
    // 释放内存。
    //-----------------------------
    //delete pTex;
    delete pOutTex;
    delete pCpuOutTex;
    
    // 处理结束。
    mFuncToDo = GLF_NONE;
}

void GLProcessor::funcNearestScale_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::NearestScale gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Nearest Scale  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Nearest Scale  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Nearest Scale  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    gl_render.Release();
    
    // 处理结束。
    mFuncToDo = GLF_NONE;
}
#endif

// Bilinear算法进行缩放功能。
void GLProcessor::funcBilinearScale()
{
    LogManager::singleton()->printStr("Start to do Bilinear scale. ");
    
    // mScaleSize = gl_lib::Vec2(1920 * 2.1, 1080 * 2.1);    // 放大时需要考虑GPU支持的最大Texture尺寸。 iPad是4096*4096.
    mScaleSize = gl_lib::Vec2(600, 337);
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    //    pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[512];
    sprintf(tmp, "In texture width: %d, height: %d. ", mInTex->GetWidth(), mInTex->GetHeight());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Bilinear Scale.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ScaleBilinear(mInTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Bilinear scale.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTex, getOutputPath(mFuncToDo, false).c_str());  //"Bilinear_Scale_CPU.png");
    
    //-----------------------------
    // GPU Bilinear算法进行缩放处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Create Render.
    class gl_lib::BilinearScale gl_render;
    gl_render.Init();
    glFinish();
    
    // Start to Process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->BilinearScale(mInTex, pOutTex);
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    gl_render.Draw();
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bilinear Scale.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());  //"Bilinear_Scale_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    //delete pTex;
    delete pOutTex;
    delete pCpuOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

void GLProcessor::funcBilinearScale_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::BilinearScale gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bilinear Scale  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bilinear Scale  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bilinear Scale  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// Bicubic算法进行缩放功能。
void GLProcessor::funcBicubicScale()
{
    LogManager::singleton()->printStr("Start to do Bicubic scale. ");
    
    // mScaleSize = gl_lib::Vec2(1920 * 2.1, 1080 * 2.1);    // 放大时需要考虑GPU支持的最大Texture尺寸。 iPad是4096*4096.
    mScaleSize = gl_lib::Vec2(600, 337);
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    //    pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[512];
    sprintf(tmp, "In texture width: %d, height: %d. ", mInTex->GetWidth(), mInTex->GetHeight());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Bicubic Scale.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ScaleBicubic(mInTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU Bicubic scale.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTex, getOutputPath(mFuncToDo, false).c_str());  //"Bicubic_Scale_CPU.png");
    
    //-----------------------------
    // GPU Bilinear算法进行缩放处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Create Render.
    class gl_lib::BicubicScale gl_render;
    gl_render.Init();
    glFinish();
    
    // Start to Process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->BicubicScale(mInTex, pOutTex);
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    gl_render.Draw();
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bicubic Scale.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());  //"Bicubic_Scale_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    //delete pTex;
    delete pOutTex;
    delete pCpuOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

void GLProcessor::funcBicubicScale_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。

    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::BicubicScale gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bicubic Scale  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bicubic Scale  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Bicubic Scale  ->  Read out data. ");

    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// Box算法进行缩放功能。
void GLProcessor::funcBoxScale()
{
    //printf("Start to do box scale. \n");
    LogManager::singleton()->printStr("Start to do box scale. ");
    
    // mScaleSize = gl_lib::Vec2(1920 * 2.1, 1080 * 2.1);    // 放大时需要考虑GPU支持的最大Texture尺寸。 iPad是4096*4096.
    mScaleSize = gl_lib::Vec2(600, 337);
    
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    //    pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[512];
    sprintf(tmp, "In texture width: %d, height: %d. ", mInTex->GetWidth(), mInTex->GetHeight());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Box Scale.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ScaleBox(mInTex, pCpuOutTex);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU box scale.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTex, getOutputPath(mFuncToDo, false).c_str());  //"Box_Scale_CPU.png");

    //-----------------------------
    // GPU Box算法进行缩放处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Create Render.
    class gl_lib::BoxScale gl_render;
    gl_render.Init();
    glFinish();
    
    // Start to Process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->BoxScale(mInTex, pOutTex);
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    gl_render.Draw();
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Box Scale.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());  //"Box_Scale_GPU.png");
    
    //-----------------------------
    // 释放内存。
    //-----------------------------
    //delete pTex;
    delete pOutTex;
    delete pCpuOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

void GLProcessor::funcBoxScale_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::BoxScale gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Box Scale  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw();
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Box Scale  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU Box Scale  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

// Lanczos算法进行缩放功能。
void GLProcessor::funcLanczosScale()
{
    LogManager::singleton()->printStr("Start to do lanczos scale. ");
    
    // mScaleSize = gl_lib::Vec2(1920 * 2.1, 1080 * 2.1);    // 放大时需要考虑GPU支持的最大Texture尺寸。 iPad是4096*4096.
    //mScaleSize = gl_lib::Vec2(1920 * 1.4, 1080 * 1.4);
    //mScaleSize = gl_lib::Vec2(1920 * 1.3, 1080 * 1.3);
    mScaleSize = gl_lib::Vec2(1920 * 1.2, 1080 * 1.2);
  
    mLanczosPara = 1;
//    mLanczosPara = 2;
//    mLanczosPara = 3;

    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    //    pImgMgr->writeImage(mInTex, "ori.png");
    char tmp[512];
    sprintf(tmp, "In texture width: %d, height: %d. ", mInTex->GetWidth(), mInTex->GetHeight());
    LogManager::singleton()->printStr(tmp);
    
    //-----------------------------
    // CPU Box Scale.
    //-----------------------------
    gl_lib::Image2D* pCpuOutTex= new gl_lib::Image2D();
    pCpuOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    timeval cpuStartTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_lib::CPUFunc::ScaleLanczos(mInTex, pCpuOutTex, mLanczosPara);
    timeval cpuEndTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(cpuStartTime, cpuEndTime, "CPU lanczos Scale, Para = 3.   ->  ");
    
    // 写入结果文件。
    pImgMgr->writeImage(pCpuOutTex, getOutputPath(mFuncToDo, false).c_str());  //"Lanczos_3_Scale_CPU.png");
    
    //-----------------------------
    // GPU Box算法进行缩放处理。
    //-----------------------------
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mScaleSize.x, mScaleSize.y, 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // Create Render.
    class gl_lib::LanczosScale gl_render;
    gl_render.Init();
    glFinish();
    
    // Start to Process.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    //mGLMgr->LanczosScale(mInTex, pOutTex, mLanczosPara);
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    gl_render.Draw(mLanczosPara);
    timeval endTime = SysUtl::curSysTime();    // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU lanczos Scale, Para = 3.   ->  ");
    
    // 写入结果文件。
    gl_render.ReadOutData();
    pImgMgr->writeImage(pOutTex, getOutputPath(mFuncToDo, true).c_str());  //"Lanczos_3_Scale_GPU.png");

    //-----------------------------
    // 释放内存。
    //-----------------------------
    //delete pTex;
    delete pOutTex;
    delete pCpuOutTex;
    
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

void GLProcessor::funcLanczosScale_GPU_Time()
{
    // 读取文件。
    ImageManager* pImgMgr = ImageManager::singleton();
    if(NULL == mInTex) {
        mInTex = pImgMgr->readImage("1.jpeg");
    }
    
    gl_lib::Image2D* pOutTex= new gl_lib::Image2D();
    
    // 因为glReadPixels的限制。 输出Buffer暂时只支持 GRBA 格式。 暂时未能发现其他有效的输出格式。
    pOutTex->SetupData(mInTex->GetWidth(), mInTex->GetHeight(), 32, NULL);    // 数据指针为NULL， 内部只生成Buffer。
    
    // 打开 mGLMgr->TransY(mInTex, pOutTex); 的处理。
    class gl_lib::LanczosScale gl_render;
    gl_render.Init();
    glFinish();
    
    // 1.0 Input data and setup up output FBO.
    timeval startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.SetInput(mInTex);
    gl_render.SetOutput(pOutTex);
    timeval endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU lanczos Scale, Para = 3  ->  Initialize input data and setup output FBO. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.Draw(mLanczosPara);
    glFinish();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU lanczos Scale, Para = 3  ->  Draw. ");
    
    startTime = SysUtl::curSysTime();    // 测量系统时间。
    gl_render.ReadOutData();
    endTime = SysUtl::curSysTime();      // 测量系统时间。
    LogManager::singleton()->logDeltaTime(startTime, endTime, "GPU lanczos Scale, Para = 3  ->  Read out data. ");
    
    // 释放内存。
    delete pOutTex;
        
    // 处理结束。
    gl_render.Release();
    mFuncToDo = GLF_NONE;
}

//-------------------------
// 全局对象的取得与释放。
//-------------------------
GLProcessor* GLProcessor::singleton()
{
    if (NULL == mProcessor){
        mProcessor = new GLProcessor();
    }
    
    return mProcessor;
}

void GLProcessor::releaseSingleton()
{
    if (NULL != mProcessor){
        delete mProcessor;
        mProcessor = NULL;
    }
}

//-------------------------
// 功能函数。
//-------------------------
// 启动子线程。
void GLProcessor::startSubThread()
{
    // 启动子线程。
    if (mThread == 0){
        pthread_create(&mThread, NULL, GLProcessor::processThread, this);
    }
}

// 执行Y变换。
void GLProcessor::doTransY()
{
    LogManager::singleton()->printStr("Enter doTransY(). ", true);
    
    mFuncToDo = GLF_Y_TRANS;
}

// 调节对比度.  输入参数应大于等于 -1
void GLProcessor::doContrast(float rate)
{
    char tmp[512];
    sprintf(tmp, "Enter doContrast(). rate is %f. ", rate);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo = GLF_CONTRAST;
    mContrastPara = rate;
}

// 调节亮度变化值.
void GLProcessor::doLumination(int32_t delta)
{
    char tmp[512];
    sprintf(tmp, "Enter doLumination(). delta lumination is %d. ", delta);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo = GLF_LUMINATION;
    mDeltaLumination = delta;
}

// 调节对比度, 亮度.
void GLProcessor::doContrastLumination(float rate, int32_t delta)
{
    char tmp[512];
    sprintf(tmp, "Enter doContrastLumination(). rate is %f. delta lumination is %d. ", rate, delta);
    LogManager::singleton()->printStr(tmp, true);

    mFuncToDo = GLF_CONTRAST_LUMINATION;
    mContrastPara = rate;
    mDeltaLumination = delta;
}

// 输入比率，调节Saturation.
void GLProcessor::doSaturationRate(float rate)
{
    char tmp[512];
    sprintf(tmp, "Enter doSaturationRate(). rate is %f. ", rate);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo = GLF_SATURATION_RATE;
    mSaturationRate = rate;
}

#if 0
// 输入缩放比率，进行缩放.
void GLProcessor::doNearestScale(const gl_lib::Vec2& scale_size)
{
    char tmp[512];
    sprintf(tmp, "Enter doNearestScale(). scale rate is [%f, %f]. ", scale_size.x, scale_size.y);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo  = GLF_SCALE_NEAREST;
    mScaleSize = scale_size;
}
#endif

// 输入缩放比率，进行缩放.
void GLProcessor::doBilinearScale(const gl_lib::Vec2& scale_size)
{
    char tmp[512];
    sprintf(tmp, "Enter doBilinearScale(). scale rate is [%f, %f]. ", scale_size.x, scale_size.y);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo  = GLF_SCALE_BILINEAR;
    mScaleSize = scale_size;
}

// 输入缩放比率，进行缩放.
void GLProcessor::doBicubicScale(const gl_lib::Vec2& scale_size)
{
    char tmp[512];
    sprintf(tmp, "Enter doBicubicScale(). scale rate is [%f, %f]. ", scale_size.x, scale_size.y);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo  = GLF_SCALE_BICUBIC;
    mScaleSize = scale_size;
}

// 输入缩放比率，进行缩放.
void GLProcessor::doBoxScale(const gl_lib::Vec2& scale_size)
{
    char tmp[512];
    sprintf(tmp, "Enter doBoxScale(). scale rate is [%f, %f]. ", scale_size.x, scale_size.y);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo  = GLF_SCALE_BOX;
    mScaleSize = scale_size;
}

// 输入缩放比率，进行缩放.
void GLProcessor::doLanczosScale(const gl_lib::Vec2& scale_size, int a)
{
    char tmp[512];
    sprintf(tmp, "Enter doLanczosScale(). scale rate is [%f, %f]. ", scale_size.x, scale_size.y);
    LogManager::singleton()->printStr(tmp, true);
    
    mFuncToDo    = CLF_SCALE_LANCZOS;
    mScaleSize   = scale_size;
    mLanczosPara = a;
}
