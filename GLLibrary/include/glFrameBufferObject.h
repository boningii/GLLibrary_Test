/*************************************************************************
 * FILENAME :        glFrameBufferObject.h
 *
 * DESCRIPTION :
 *       Implement the Frame Buffer Object function for GLLibrary.
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
#ifndef __GL_FRAME_BUFFER_OBJECT_H__
#define __GL_FRAME_BUFFER_OBJECT_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#else
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#endif

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// 单一Render Target的FrameBuffer对象。
//************************************************
class GLSingleFBO
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    GLSingleFBO();
    ~GLSingleFBO();

    void Release();

    bool IsInitialized();

    GLuint GetFrameBufferObject();
    GLuint GetTextureObject();
    GLuint GetFboWidth();
    GLuint GetFboHeight();

    //-------------------------
    // OpenGL功能API。
    //-------------------------
    bool Create(GLuint width, GLuint height, GLenum inter_format, GLenum format, GLenum type, GLuint min, GLuint mag);

 private:
    //-------------------------
    // 数据。
    //-------------------------
    // Frame Object对象。
    GLuint  frame_buffer_object_;   // Handle to the FBO.
    GLuint  texture_object_;        // Handle to the ColorTexture.

    // Frame Object的尺寸。（所有的Buffer必须保持一样的大小）。
    GLint   fbo_width_;             // FBO 的 width
    GLint   fbo_height_;            // FBO 的 height
};

}  // namespace gl_lib

#endif  // __GL_FRAME_BUFFER_OBJECT_H__
