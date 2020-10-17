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
#ifndef __GL_STRUCTURE_H__
#define __GL_STRUCTURE_H__

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#include <stdint.h>

// The top level name space: gl_lib.
namespace gl_lib {
//************************************************
// 2D向量 结构体定义。
//************************************************
struct Vec2
{
    //-------------------------
    // Members.
    //-------------------------
    float x;
    float y;

    //-------------------------
    // Methods.
    //-------------------------
    Vec2();
    Vec2(const Vec2& val);
    Vec2(float in_x, float in_y);
};

//************************************************
// 3D向量 结构体定义。
//************************************************
struct Vec3
{
    //-------------------------
    // Members.
    //-------------------------
    float x;
    float y;
    float z;

    //-------------------------
    // Methods.
    //-------------------------
    Vec3();
    Vec3(const Vec3& val);
    Vec3(float in_x, float in_y, float in_z);
};

//************************************************
// RGBA 8 bit 整数型颜色数据。
//************************************************
struct ColorValue
{
    //-------------------------
    // Members.
    //-------------------------
    uint8_t r;
    uint8_t g;
    uint8_t b;
    uint8_t a;

    //-------------------------
    // Methods.
    //-------------------------
    ColorValue();
    ColorValue(const ColorValue& val);
    ColorValue(float in_r, float in_g, float in_b, float in_a);
};

//************************************************
// 裁剪区域。
//************************************************
struct CropArea
{
    //-------------------------
    // Members.
    //-------------------------
    float ori_x;
    float ori_y;
    float width;
    float height;
    
    //-------------------------
    // Methods.
    //-------------------------
    CropArea();
    CropArea(const CropArea& val);
    CropArea(float in_x, float in_y, float in_width, float in_height);
};


//************************************************
// CPU侧 RGBA 8bit 整数型2D图像。
//************************************************
class Image2D
{
 public:
    //-------------------------
    // Methods.
    //-------------------------
    Image2D();
    ~Image2D();

    // 释放数据。
    void Release();

    // 设置Texture。
    void SetupData(int32_t width, int32_t height, int32_t bpp, uint8_t* data_buffer);
    // 根据坐标取得数据。
    ColorValue ReadData(int32_t pos_x, int32_t pos_y);
    // 根据坐标取得数据。 超出范围的坐标使用Edge方式纠正坐标值。
    ColorValue ReadDataEdge(int32_t pos_x, int32_t pos_y);
    // 写入数据。
    void WriteData(int32_t pos_x, int32_t pos_y, const ColorValue& val);

    // accessors.
    int32_t GetWidth();
    int32_t GetHeight();
    int32_t GetBpp();
    int32_t GetByteNum();
    uint8_t* GetBuffer();
    
 private:
    //-------------------------
    // Members.
    //-------------------------
    int32_t width_;
    int32_t height_;
    int32_t bpp_;         // 24Bpp, 3Bytes; 32Bpp, 4Bytes.
    int32_t byte_num_;    // Calculate by the bpp_.

    uint8_t *buffer_;
};

//************************************************
// CPU侧 RGBA 8bit 整数型3D图像。
//************************************************
class Image3D
{
 public:
    //-------------------------
    // Methods.
    //-------------------------
    Image3D();
    ~Image3D();

    // 释放数据。
    void Release();

    // 设置Texture。
    void SetupData(int32_t width, int32_t height, int32_t depth, int32_t bpp, uint8_t* data_buffer);
    // 根据坐标取得数据。
    ColorValue ReadData(int32_t pos_x, int32_t pos_y, int32_t pos_z);
    // 根据坐标取得数据。 超出范围的坐标使用Edge方式纠正坐标值。
    ColorValue ReadDataEdge(int32_t pos_x, int32_t pos_y, int32_t pos_z);
    // 写入数据。
    void WriteData(int32_t pos_x, int32_t pos_y, int32_t pos_z, const ColorValue& val);

    // accessors.
    int32_t  GetWidth();
    int32_t  GetHeight();
    int32_t  GetDepth();
    int32_t  GetBpp();
    int32_t GetByteNum();
    uint8_t* GetBuffer();

 private:
    //-------------------------
    // Members.
    //-------------------------
    int32_t  width_;
    int32_t  height_;
    int32_t  depth_;
    int32_t  bpp_;         // 8Bpp, 1Byte; 24Bpp, 3Bytes; 32Bpp, 4Bytes.
    int32_t  byte_num_;    // Calculate by the bpp_.

    uint8_t* buffer_;
};

}  // namespace gl_lib

#endif  // __GL_DEFINATION_H__
