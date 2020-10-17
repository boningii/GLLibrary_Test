/*************************************************************************
 * FILENAME :        glRender.h
 *
 * DESCRIPTION :
 *       Implement the Render Base Classfor GLLibrary.
 *
 * NOTES :
 *       This file are a part of the GLLibrary middle ware;
 *
 *       Copyright TenJi Information System Co. All rights reserved.
 *
 * AUTHOR :    Boning Xu    START DATE :    2017/05/01
 *
 * CHANGES :
 * REF NO  VERSION DATE    WHO     DETAIL
 *************************************************************************/

#ifndef __GL_RENDER_H__
#define __GL_RENDER_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#include "glStructure.h"
#include "glShaderProgram.h"
#include "glTexture.h"
#include "glFrameBufferObject.h"

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// OpenGL Render Interface : 基类。
// 进行具体的描画。
// 管理对应的 Shader Program, 输入用数据(texture) 等
//************************************************
class GLRender
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    GLRender();
    virtual ~GLRender();

    // 判断是否已经进行了初始化。
    bool IsInitialized();

 protected:
    //-------------------------
    // 内部工具函数。 只有子类能够使用。
    //-------------------------
    void SetInitialized(bool mark);

 private:
    //-------------------------
    // 数据。
    //-------------------------
    bool initialized_;
};

}  // namespace gl_lib

#endif  // __GL_RENDER_H__
