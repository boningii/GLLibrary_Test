/*************************************************************************
 * FILENAME :        glTexture.h
 *
 * DESCRIPTION :
 *       Implement the Texture Class for GLLibrary.
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

#ifndef __GL_TEXTURE_H__
#define __GL_TEXTURE_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#include "glStructure.h"

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// OpenGL Texture2D Interface。
//************************************************
class GLTexture2D
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    GLTexture2D();
    ~GLTexture2D();

    void Release();

    bool IsInitialized();
    GLuint GetTextureObject();    // Handle to a program object
    GLuint GetWidth();
    GLuint GetHeight();

    //-------------------------
    // OpenGL功能API。
    //-------------------------
    bool Create(Image2D * src, GLenum inter_format, GLenum format, GLenum type, GLuint min, GLuint mag);    // 创建Texture对象。

    void Create();    // 创建Texture对象。
    void SetZoomFilter(GLuint min, GLuint mag);
    void SetWrapType(GLuint wrap_s, GLuint wrap_t);
    bool Setup(Image2D * src, GLenum inter_format, GLenum format, GLenum type);      // 设置Texture的尺寸和数据。
    void GenMipmap();

 private:
    //-------------------------
    // 数据。
    //-------------------------
    GLuint texture_object_;    // Handle to a program object
    GLuint width_;
    GLuint height_;
};

//************************************************
// OpenGL Texture3D Interface。
//************************************************
class GLTexture3D
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    GLTexture3D();
    ~GLTexture3D();

    void Release();

    bool IsInitialized();
    GLuint GetTextureObject();    // Handle to the texture object
    GLuint GetWidth();
    GLuint GetHeight();
    GLuint GetDepth();

    //-------------------------
    // OpenGL功能API。
    //-------------------------
    bool Create(Image3D * src, GLenum inter_format, GLenum format, GLenum type, GLuint min, GLuint mag);    // 创建Texture对象。

    void Create();                                                 // 创建Texture对象。
    void SetZoomFilter(GLuint min, GLuint mag);
    void SetWrapType(GLuint wrap_s, GLuint wrap_t, GLuint wrap_r);
    bool Setup(Image3D * pSrc, GLenum inter_format, GLenum format, GLenum type);      // 设置Texture的尺寸和数据。
    void GenMipmap();

 protected:
    //-------------------------
    // 数据。
    //-------------------------
    GLuint texture_object_;    // Handle to a program object
    GLuint width_;
    GLuint height_;
    GLuint depth_;
};

}  // namespace gl_lib

#endif  // __GL_TEXTURE_H__
