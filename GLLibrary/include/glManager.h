/*************************************************************************
 * FILENAME :        glFrameBufferObject.h
 *
 * DESCRIPTION :
 *       Implement the Manager Object function for GLLibrary.
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
#ifndef __GL_MANAGER_H__
#define __GL_MANAGER_H__

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
#include "glRenderColorTransY.h"
#include "glRenderColorContrastLumi.h"
#include "glRenderColorSaturation.h"
#include "glRenderScaleNearest.h"
#include "glRenderScaleBilinear.h"
#include "glRenderScaleBicubic.h"
#include "glRenderScaleBox.h"
#include "glRenderScaleLanczos.h"

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// OpenGL Manager Interface
//************************************************
class GLManager
{
 public:
    //-------------------------
    // 构造&析构函数。
    //-------------------------
    GLManager();
    ~GLManager();

    //-------------------------
    // 基础功能API。
    //-------------------------
    bool IsInitialized();       // 是否完成了初始化.

    //-------------------------
    // OpenGL功能API。
    //-------------------------
    void Init(GLint buf_width, GLint buf_height);    // 初始化OpenGL Es 3.0 Context.
    void Close();                                    // 关闭OpenGL Es 3.0 Context.

    //-------------------------
    // 颜色处理功能。
    //-------------------------
    // Y变换处理。
    int32_t TransY(Image2D * in_img, Image2D * out_img);
    // 调节对比度和辉度。
    int32_t ContrastLuminance(float contrast_rate, float avg_luminance, float target_lumi, Image2D * in_img, Image2D * out_img);
    int32_t Contrast(float contrast_rate, float avg_luminance, Image2D * in_img, Image2D * out_img);    // 只调节对比度。
    int32_t Luminance(float avg_luminance, float target_lumi, Image2D * in_img, Image2D * out_img);     // 只调节辉度。
    // 调节饱和度。
    int32_t Saturation(float saturation_rate, Image2D * in_img, Image2D * out_img);

    //-------------------------
    // 缩放功能。
    //-------------------------
    // 使用Nearest算法进行缩放。
    int32_t NearestScale(Image2D * in_img, Image2D * out_img);
    // 使用Bilinear算法进行缩放。
    int32_t BilinearScale(Image2D * in_img, Image2D * out_img);
    // 使用Bicubic算法进行缩放。
    int32_t BicubicScale(Image2D * in_img, Image2D * out_img);
    // 使用Box算法进行缩放。
    int32_t BoxScale(Image2D * in_img, Image2D * out_img);
    // 使用Lanczos算法进行缩放。
    int32_t LanczosScale(Image2D * in_img, Image2D * out_img, int a = kDefaultLanczosA);

 protected:
    //-------------------------
    // 内部工具函数。
    //-------------------------
    void CreateContextWithEGL();    // 使用EGL创建Context。iOS系统以外使用。

 private:
    //-------------------------
    // 基础数据。
    //-------------------------
    bool         initialized_;

    GLint        width_;         // Window width
    GLint        height_;        // Window height

    //-------------------------
    // Render数据。
    //-------------------------
    // 颜色处理功能。
    class TransY         render_trans_y_;
    class ContrastLumi   render_contrast_lumi_;
    class Saturation     render_saturation_;
    class NearestScale   render_nearest_scale_;
    class BilinearScale  render_bilinear_scale_;
    class BicubicScale   render_bicubic_scale_;
    class BoxScale       render_box_scale_;
    class LanczosScale   render_lanczos_scale_;

#ifndef __APPLE__
    EGLNativeDisplayType egl_native_display_;   // Display handle
    EGLNativeWindowType  egl_native_window_;    // Window handle
    EGLDisplay           egl_display_;          // EGL display
    EGLContext           egl_context_;          // EGL context
    EGLSurface           egl_surface_;          // EGL surface
#endif
};

}  // namespace gl_lib

#endif  // __GL_MANAGER_H__
