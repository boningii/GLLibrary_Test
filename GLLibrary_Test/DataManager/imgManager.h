
#ifndef IMAGE_MANAGER_H
#define IMAGE_MANAGER_H

#include "glLibrary.h"

//----------------------------------------------
// Read & Write image files.
//----------------------------------------------
class ImageManager
{
protected:
    //-------------------------
    // 自身的指针。
    //-------------------------
    static ImageManager* mSelf;


protected:
    //-------------------------
    // 内部功能函数
    //-------------------------
    ImageManager();       // 不公开的构造函数。
    
public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    ~ImageManager();

    //-------------------------
	// 全局对象的取得与释放。
	//-------------------------
    static ImageManager* singleton();
    static void releaseSingleton();

    //-------------------------
    // 功能函数。
    //-------------------------
    gl_lib::Image2D* readImage(const char* pName);
    void writeImage(gl_lib::Image2D* pTex, const char* pName);
    
    
};

#endif
