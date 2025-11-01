//媒体查询常量
export  class  breakPiontConstants{
  //设置当前的屏幕尺寸，用于存储检测到的屏幕尺寸
  static readonly CURRENT_BREAKPOINT = "currentBreakPoint"

  //手表
  static readonly BREAKPOINT_XS = "xs"
  //手机
  static readonly BREAKPOINT_SM = "sm"
  //折叠屏
  static readonly BREAKPOINT_MD = "md"
  //pad
  static readonly BREAKPOINT_LG = "lg"
  //智慧屏
  static readonly BREAKPOINT_XL = "xl"

  //手表字体
  static readonly FONTSIZE_XS = "10VP"
  //手机字体
  static readonly FONTSIZE_SM = "14VP"
  //折叠屏字体
  static readonly FONTSIZE_DM = "16VP"
  //pad字体
  static readonly FONTSIZE_LG = "18VP"
  //智慧屏字体
  static readonly FONTSIZE_XL = "20VP"

  //手表
  static readonly RANGE_XS:string = '(0vp<width<320vp)'
  //手机
  static readonly RANGE_SM:string = '(320vp<width<640vp)'
  //折叠屏
  static readonly RANGE_MD:string = '(640vp<=width<=1080vp)'
  //pad
  static readonly RANGE_LG:string = '(1080vp<=width<=1560vp)'
  //智慧屏
  static readonly RANGE_XL:string = '(1560vp<=width<=3000vp)'
  //其他





}