/*************************************************************************
 * FILENAME :        glRenderContrastLuminance.h
 *
 * DESCRIPTION :
 *       Implement the Contrast and Luminance Render Class for GLLibrary.
 *
 * NOTES :
 *       This file are a part of the GLLibrary middle ware;
 *
 *       Copyright TenJi Information System Co. All rights reserved.
 *
 * AUTHOR :    Boning Xu    START DATE :    2017/05/21
 *
 * CHANGES :
 * REF NO  VERSION DATE    WHO     DETAIL
 *************************************************************************/

#ifndef __GL_RENDER_CONTRAST_LUMINANCE_H__
#define __GL_RENDER_CONTRAST_LUMINANCE_H__

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
// Render 的 Contrast and Luminance 子类。
//************************************************
class ContrastLumi : public GLRender
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    ContrastLumi();
    ~ContrastLumi();

    // 释放Data。
    void Release();

    //-------------------------
    // OpenGL运行标准API。
    //-------------------------
    int32_t Init();
    int32_t SetInput(float avg_luminance, Image2D * input_image);
    int32_t SetOutput(Image2D * output_image);
    int32_t Draw(float contrast_rate, float target_lumi);
    int32_t ReadOutData();

    // Draw的特殊化接口：
    int32_t Contrast(float rate);          // 只调节对比度。
    int32_t Luminance(float target_lumi);    // 只调节辉度。
    
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
    GLProgram   program_y_;          // Shader Program --> Grey处理版本（只有Y分量数据）.
    GLProgram   program_rgb_;        // Shader Program --> RGB处理版本（输入输出都是RGB分量）.

    GLTexture2D input_tex_;          // 输入纹理.
    GLSingleFBO output_fbo_;         // Output FBO.

    // VAO 和 VBO。 因为VAO根据输入，变化较多，所以不太容易封装成对象。暂时由Render直接处理。
    GLuint      vao_id_;             // 一个Vertex Array Object。
    GLuint      vertex_buffer_id_;   // Vertex数据Buffer。
    GLuint      index_buffer_id_;    // Index数据Buffer。

    // Shader中Uniform的Location。
    GLint       y_sampler_loc_;        // Texture Sampler location
    GLint       y_contrast_rate_loc_;  // Contrast Rate location
    GLint       y_average_lumi_loc_;   // Average Lumination location
    GLint       y_target_lumi_loc_;    // Target Lumination location

    GLint       rgb_sampler_loc_;        // Texture Sampler location
    GLint       rgb_contrast_rate_loc_;  // Contrast Rate location
    GLint       rgb_average_lumi_loc_;   // Average Lumination location
    GLint       rgb_target_lumi_loc_;    // Target Lumination location

    //-------------------------
    // 缓存成员。
    //-------------------------
    Image2D * in_img_;
    Image2D * out_img_;
    
    bool      use_rgb_program_;        // 使用Y版本Shader Program还是RGB版本Shader Program。
    float     in_avg_lumi_;             // 输入图片的平均灰度。
};

}  // namespace gl_lib

#endif  // __GL_RENDER_TRANS_Y_H__
