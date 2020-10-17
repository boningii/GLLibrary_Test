/*************************************************************************
 * FILENAME :        glCPUFunction.h
 *
 * DESCRIPTION :
 *       Implement the CPU Functions for GLLibrary.
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

#ifndef __GL_CPU_FUNCTION_H__
#define __GL_CPU_FUNCTION_H__

#include <math.h>
#include "glConfig.h"
#include "glStructure.h"

// The top level name space: gl_lib.
namespace gl_lib {

//************************************************
// CPU侧功能函数。
// 与GPU侧功能是对应关系。
//************************************************
namespace CPUFunc
{
//-------------------------
// Group 0: 工具函数。
//-------------------------
// 输入只有Y（Luminance）分量的Grey图， 或 输入RGB图 计算这幅图片的平均辉度。
int32_t CalculateAverageLuminance(Image2D * in_img);

// Bilinear计算公式。 采样[0, 0] -> [1, 1]的四个顶点。
float BilinearFormula(float p00, float p10, float p01, float p11, const Vec2 pos);

// Bicubic计算需要的公式。计算单一方向（x或y）的指定坐标的值。
float CubicFormula(float p0, float p1, float p2, float p3, float x);
Vec3 CubicFormulaRGB(const ColorValue& p0, const ColorValue& p1, const ColorValue& p2, const ColorValue& p3, float x);

// Lanczos Kernel。
float Lanc(float x, int32_t a);

//-------------------------
// Group 1: 颜色转换。
//-------------------------
// 根据RGB值计算亮度Y。
void TransY(Image2D * in_img, Image2D * out_img);

// 调节对比度。
void Contrast(float rate, int32_t avg_luminance, Image2D * in_img, Image2D * out_img);
// 调节辉度。
void Luminance(int32_t avg_luminance, int32_t target_luminance, Image2D * in_img, Image2D * out_img);
// 同时调节对比度和辉度。 （对比度和辉度调节同属于灰度图调节，可整合在一起）。
void ContrastAndLuminance(float contrast_rate, int32_t avg_luminance, int32_t target_luminance, Image2D * in_img, Image2D * out_img);

// 调节饱和度（Saturation）
void SaturationByRate(float delta_rate, Image2D * in_img, Image2D * out_img);      // 输入变化比率: new_s = old_s * (1.0 + delta_rate);
// 按照绝对数值调整饱和度会导致图像呈现奇怪的显示效果。没有实际应用价值。取消这个功能。
//void SaturationByValue(float delta_val, Image2D * in_img, Image2D * out_img);      // 输入变化值  : new_s = old_s + delta_val;

//-------------------------
// Group 2: 几何变换 （缩放及切割）。
//-------------------------
void ScaleNearest(Image2D * in_img, Image2D * out_img);               // 使用Nearest算法对图像进行缩放。
void ScaleBilinear(Image2D * in_img, Image2D * out_img);              // 使用Bilinear算法对图像进行缩放。
void ScaleBicubic(Image2D * in_img, Image2D * out_img);               // 使用Bicubic算法对图像进行缩放。
void ScaleBox(Image2D * in_img, Image2D * out_img);                   // 使用Box算法对图像进行缩放。
void ScaleLanczos(Image2D * in_img, Image2D * out_img, int a = 2);    // 使用Lanczos算法对图像进行缩放。 同时可以指定Lanczos Kernel的参数a。

}  // namespace CPUFunc

}  // namespace gl_lib

#endif  // __GL_CPU_FUNCTION_H__
