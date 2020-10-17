/*************************************************************************
 * FILENAME :        glDefination.h
 *
 * DESCRIPTION :
 *       Implement the Struct Defination for GLLibrary.
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


#ifndef __GL_DEFINATION_H__
#define __GL_DEFINATION_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#include <stdint.h>
#include <limits>
#include <math.h>

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// 常数定义。
//************************************************
static const float   kFloatEpsilon           = std::numeric_limits<float>::epsilon();
static const double  kDoubleEpsilon          = std::numeric_limits<double>::epsilon();

static const double  kPI                     = M_PI;          // PI, 3.14。
static const double  kPISqr                  = M_PI * M_PI;   // PI的平方。

static const int32_t kVertexArrayDefaultID   = 0;
static const int32_t kBufferDefaultID        = 0;
static const int32_t kFrameBufferDefaultID   = 0;
static const int32_t kTextureDefaultID       = 0;
static const int32_t kProgramDefaultID       = 0;
static const int32_t kShaderDefaultID        = 0;

static const int32_t kSamplerLocationDefaultValue  = 0;
static const int32_t kUniformLocationDefaultValue  = 0;
static const int32_t kErrorProgramLinkCode   = 0;
static const int32_t kDefaultLanczosA        = 2;
    
static const int32_t kDefaultWidth           = 0;
static const int32_t kDefaultHeight          = 0;
static const int32_t kDefaultDepth           = 0;
static const int32_t kDefaultBitPerPixel     = 0;
static const int32_t kDefaultByteNumber      = 0;

static const float   kDefaultValueX          = 0.0f;
static const float   kDefaultValueY          = 0.0f;
static const float   kDefaultValueZ          = 0.0f;
static const float   kDefaultSize            = 0.0f;
static const float   kDefaultOffset          = 0.0f;

static const uint8_t kDefaultValueR          = 0;
static const uint8_t kDefaultValueG          = 0;
static const uint8_t kDefaultValueB          = 0;
static const uint8_t kDefaultValueA          = 255;
static const uint8_t kMinValueUINT8          = 0;
static const uint8_t kMaxValueUINT8          = 255;

static const int32_t kPBufferWidth           = 320;
static const int32_t kPBufferHeight          = 240;

static const int32_t kImageStartX            = 0;
static const int32_t kImageStartY            = 0;

//************************************************
// Error Code定义。
//************************************************
typedef int32_t ErrorCode;

static const ErrorCode NO_ERROR                      = 0;       // 无错误。

static const ErrorCode ERROR_NOT_INITIALIZED         = 1;       // 没有进行初始化。
static const ErrorCode ERROR_CREATE_VAO_FAILED       = 1001;    // VAO创建失败。
static const ErrorCode ERROR_CREATE_PROGRAM_FAILED   = 1002;    // Shader Program创建失败。
static const ErrorCode ERROR_CREATE_TEXTURE_FAILED   = 1003;    // Texture创建失败。
static const ErrorCode ERROR_SETUP_TEXTURE_FAILED    = 1004;    // Texture设置数据失败。
static const ErrorCode ERROR_CREATE_FBO_FAILED       = 1005;    // FBO创建失败。
static const ErrorCode ERROR_DRAW_FAILED             = 1006;    // 描画失败。
static const ErrorCode ERROR_READ_OUT_DATA_FAILED    = 1007;    // 读取数据失败。
static const ErrorCode ERROR_INPUT_INVALID           = 2001;    // 输入数据非法。


}  // namespace gl_lib

#endif  // __GL_DEFINATION_H__
