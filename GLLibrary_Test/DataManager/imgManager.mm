
#include "imgManager.h"
#include "glManager.h"
#include "FileUtils.h"
#include "Image.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

//----------------------------------------------
// 静态成员初始化。
//----------------------------------------------
ImageManager* ImageManager::mSelf = NULL;

//----------------------------------------------
// OpenGL Render Control Interface
//----------------------------------------------
ImageManager::ImageManager()
{
}

ImageManager::~ImageManager()
{
}

//-------------------------
// 全局对象的取得与释放。
//-------------------------
ImageManager* ImageManager::singleton()
{
    if(NULL == mSelf)
    {
        mSelf = new ImageManager();
    }
    
    return mSelf;
}

void ImageManager::releaseSingleton()
{
    if(NULL != mSelf)
    {
        delete mSelf;
        mSelf = NULL;
    }
}

//-------------------------
// 功能函数。
//-------------------------
// 读写图像文件。
gl_lib::Image2D* ImageManager::readImage(const char* pName)
{
    gl_lib::Image2D* ret = new gl_lib::Image2D();
    
    CCImage tmpImg;
    tmpImg.initWithImageFile(pName, CCImage::kFmtJpg);
    
    int width  = tmpImg.getWidth();
    int height = tmpImg.getHeight();
    int bpp    = 24;
    if(true == tmpImg.hasAlpha())
        bpp = 32;
    unsigned char * pData = tmpImg.getData();
    
    //int byteNumPerPixel = bpp/8;
    
    ret->SetupData(width, height, bpp, pData);
    
printf("readImage:  %d, %d, %d. \n", width, height, bpp);
    
    return ret;
}
void ImageManager::writeImage(gl_lib::Image2D* pTex, const char* pName)
{
    // 存在内存泄漏。 需要调查。
    int width   = pTex->GetWidth();
    int height  = pTex->GetHeight();
    int bytespp = pTex->GetBpp()/8;
    
    CCImage tmpImg;
    tmpImg.initWithImageData(pTex->GetBuffer(), width * height * bytespp, CCImage::kFmtRawData, width, height);
    
    std::string writePath = CCFileUtils::getWritablePath();
    printf("%s\n", writePath.c_str());
    
    writePath = writePath + pName;
    tmpImg.saveToFile(writePath.c_str());
}





