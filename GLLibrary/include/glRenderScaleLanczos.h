/*************************************************************************
 * FILENAME :        glRenderLanczosScale.h
 *
 * DESCRIPTION :
 *       Implement the Lanczos Scale Render Class for GLLibrary.
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

#ifndef __GL_RENDER_LANCZOS_SCALE_H__
#define __GL_RENDER_LANCZOS_SCALE_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#include "glDefination.h"
#include "glRender.h"
#include "glShaderProgram.h"
#include "glTexture.h"
#include "glFrameBufferObject.h"

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// Render 的 Lanczos Scale 子类。
//
// Lanczos interpolation interpolation
//************************************************
class LanczosScale : public GLRender
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    LanczosScale();
    ~LanczosScale();

    // 释放Data。
    void Release();

    //-------------------------
    // OpenGL运行标准API。
    //-------------------------
    int32_t Init();
    int32_t SetInput(Image2D * input_image);
    int32_t SetOutput(Image2D * output_image);
    int32_t Draw(int a = kDefaultLanczosA);
    int32_t ReadOutData();

 protected:
    //-------------------------
    // 内部功能函数。
    //-------------------------
    // 创建VAO和VBO。
    bool CreateVAO();

    // 计算内部使用的Parameter。
    void CalculateLocalParameter();

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
    GLint       lan_a_loc_;              // Location for u_lancA.
    GLint       pre_tex_size_loc_;       // Location for u_preTexSize.
    GLint       post_tex_size_loc_;      // Location for u_postTexSize.
    GLint       new_pixel_size_loc_;     // Location for u_newTexSize.
    GLint       tex_step_offset_loc_;    // Location for u_texStepOffset.

    //-------------------------
    // 计算数据。
    //-------------------------
    int         lanczos_a_;
    Vec2        pre_tex_size_;
    Vec2        post_tex_size_;
    Vec2        new_pixel_size_;
    Vec2        tex_step_offset_;

    //-------------------------
    // 缓存成员。
    //-------------------------
    Image2D * in_img_;
    Image2D * out_img_;
};

}  // namespace gl_lib

#endif  // __GL_RENDER_BICUBIC_SCALE_H__
