/*************************************************************************
 * FILENAME :        glShaderProgram.h
 *
 * DESCRIPTION :
 *       Implement the Shader Program Class for GLLibrary.
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

#ifndef __GL_SHADER_PROGRAM_H__
#define __GL_SHADER_PROGRAM_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// OpenGL Program Interface。
//************************************************
class GLProgram
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    GLProgram();
    ~GLProgram();

    void Release();

    bool IsInitialized();
    GLuint GetProgramObject();

    //-------------------------
    // OpenGL功能API。
    //-------------------------
    // Shader相关。
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint LoadProgram(const char *vertShaderSrc, const char *fragShaderSrc);

 private:
    //-------------------------
    // 数据。
    //-------------------------
    GLuint program_object_;    // Handle to a program object
};

}  // namespace gl_lib

#endif  // __GL_SHADER_PROGRAM_H__
