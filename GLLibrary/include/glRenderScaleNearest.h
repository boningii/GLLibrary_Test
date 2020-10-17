/*************************************************************************
 * FILENAME :        glRenderBoxScale.h
 *
 * DESCRIPTION :
 *       Implement the Nearest Scale Render Class for GLLibrary.
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

#ifndef __GL_RENDER_NEAREST_SCALE_H__
#define __GL_RENDER_NEAREST_SCALE_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#include "glRender.h"
#include "glShaderProgram.h"
#include "glTexture.h"
#include "glFrameBufferObject.h"

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// Render 的 Nearest Scale 子类。
//
// Nearest-neighbor interpolation
//************************************************
class NearestScale : public GLRender
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    NearestScale();
    ~NearestScale();

    // 释放Data。
    void Release();

    //-------------------------
    // OpenGL运行标准API。
    //-------------------------
    int32_t Init();
    int32_t SetInput(Image2D * input_image);
    int32_t SetOutput(Image2D * output_image);
    int32_t Draw();
    int32_t ReadOutData();

 protected:
    //-------------------------
    // 内部功能函数。
    //-------------------------
    // 创建VAO和VBO。
    bool CreateVAO();

 private:
    //-------------------------
    // 内部成员。
    //-------------------------
    // OpenGL 对象。
    GLProgram   program_;                // Shader Program.
    GLTexture2D input_tex_;              // 输入纹理.
    GLSingleFBO output_fbo_;             // Output FBO.

    // VAO 和 VBO。 因为VAO根据输入，变化较多，所以不太容易封装成对象。暂时由Render直接处理。
    GLuint      vao_id_;                 // 一个Vertex Array Object。
    GLuint      vertex_buffer_id_;       // Vertex数据Buffer。
    GLuint      index_buffer_id_;        // Index数据Buffer。

    // Shader中Uniform的Location。
    GLint       sampler_loc_;            // Texture Sampler location

    //-------------------------
    // 缓存成员。
    //-------------------------
    Image2D * in_img_;
    Image2D * out_img_;
};

}  // namespace gl_lib

#endif  // __GL_RENDER_TRANS_Y_H__
