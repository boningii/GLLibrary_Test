
#ifndef GL_PROCESSOR_H
#define GL_PROCESSOR_H

#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#include <pthread.h>
#include "glLibrary.h"

#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//----------------------------------------------
// 处理功能定义.
//----------------------------------------------
enum GL_FUNC_DEF
{
    GLF_NONE              = 0,    // 没有处理.

    GLF_Y_TRANS              ,    // Y变换.
    GLF_CONTRAST             ,    // 调节对比度.
    GLF_LUMINATION           ,    // 调节亮度.
    GLF_CONTRAST_LUMINATION  ,    // 同时调节对比度和亮度.
    GLF_SATURATION_RATE      ,    // 根据变化比率调节饱和度.

    //GLF_SCALE_NEAREST        ,    // Nearest scale算法.
    GLF_SCALE_BILINEAR       ,    // Bilinear scale算法.
    GLF_SCALE_BICUBIC        ,    // Bicubic scale算法.
    GLF_SCALE_BOX            ,    // Box scale算法.
    CLF_SCALE_LANCZOS        ,    // Lanczos scale算法.

};

#if 0
enum PROCESS_STATUS
{
    PS_STANDY     = 0,
    PS_PROCESSING    ,
    PS_PROCESS_DONE  ,
};
#endif

//----------------------------------------------
// OpenGL Processor Interface
// Start new thread to do OpenGL Operation.
//----------------------------------------------
class GLProcessor
{
protected:
    //-------------------------
    // 自身的指针。
    //-------------------------
    static GLProcessor* mProcessor;
    static gl_lib::GLManager*   mGLMgr;
    
    //-------------------------
	// 基础数据。
	//-------------------------
    pthread_t      mThread;
    GL_FUNC_DEF    mFuncToDo;           // 准备执行的处理。
    float          mContrastPara;       // 对比度调节参数。
    int32_t        mDeltaLumination;
    int32_t        mTargetLumination;
    float          mSaturationRate;     // 饱和度变化比率。
    float          mSaturationValue;    // 饱和度变化值。
    
    gl_lib::Vec2   mScaleSize;
    int            mLanczosPara;
    
    //-------------------------
    // 内部数据。
    //-------------------------
    gl_lib::Image2D*  mInTex;
    
protected:
    //-------------------------
    // Sub thread function。
    //-------------------------
    static void* processThread(void* pData);
    
    //-------------------------
    // 内部功能函数
    //-------------------------
    void createGLManager();
    
    // Y变换功能。
    void funcTranY();
    void funcTranY_GPU_Time();
    
    // 对比度调节功能。
    void funcContrast();
    void funcContrast_GPU_Time();
    
    // 亮度调节功能。
    void funcLumination();
    void funcLumination_GPU_Time();
    
    // 对比度&亮度调节功能。
    void funcContrastLumination();
    void funcContrastLumination_GPU_Time();
    
    // 饱和度调节功能。
    void funcSaturationRate();
    void funcSaturationRate_GPU_Time();
    
#if 0
    // Nearest算法进行缩放功能。  因为基本无使用场景， 取消。
    void funcNearestScale();
    void funcNearestScale_GPU_Time();
#endif

    // Bilinear算法进行缩放功能。
    void funcBilinearScale();
    void funcBilinearScale_GPU_Time();
    
    // Bicubic算法进行缩放功能。
    void funcBicubicScale();
    void funcBicubicScale_GPU_Time();

    // Box算法进行缩放功能。
    void funcBoxScale();
    void funcBoxScale_GPU_Time();

    // Lanczos算法进行缩放功能。
    void funcLanczosScale();
    void funcLanczosScale_GPU_Time();

    // 释放GL Manager。
    void releaseGLManager();
    
    //-------------------------
    // 内部功能函数
    //-------------------------
    GLProcessor();       // 不公开的构造函数。
    
public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    ~GLProcessor();

    //-------------------------
	// 全局对象的取得与释放。
	//-------------------------
    static GLProcessor* singleton();
    static void releaseSingleton();

    //-------------------------
    // 功能函数。
    //-------------------------
    // Misc。
    void startSubThread();   // 启动子线程。
    GL_FUNC_DEF getFuncToDo();
    std::string getOutputPath(GL_FUNC_DEF func, bool gpu);
    
    // 基本图像处理。
    void doTransY();         // 执行Y变换。
    void doContrast(float rate);    // 调节对比度.  输入参数应大于等于 -1
    void doLumination(int32_t delta);    // 调节亮度.
    void doContrastLumination(float rate, int32_t delta);    // 调节对比度, 亮度.
    void doSaturationRate(float rate);    // 输入比率，调节Saturation.

    // 各种缩放算法。
    //void doNearestScale(const gl_lib::Vec2& scale_size);  // 输入缩放比率，进行缩放.
    void doBilinearScale(const gl_lib::Vec2& scale_size);  // 输入缩放比率，进行缩放.
    void doBicubicScale(const gl_lib::Vec2& scale_size);  // 输入缩放比率，进行缩放.
    void doBoxScale(const gl_lib::Vec2& scale_size);      // 输入缩放比率，进行缩放.
    void doLanczosScale(const gl_lib::Vec2& scale_size, int a);      // 输入缩放比率，进行缩放.
    
	//-------------------------
	// 数据处理功能。
	//-------------------------
//	void check3DTexture();    // 无输入, 内部使用标准3D纹理, 并自行进行检查。
//	void check3DTexture(Texture3D * pInTex, Texture2D * pOutTex);    // 使用外部输入。

    
};

#endif
