//+------------------------------------------------------------------+
//|                                              ZhuLing_Lib_Utl.mq4 |
//|                                                         Zhu Ling |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Zhu Ling"



bool checkPoint5(string symbol)
{
   if(MarketInfo(symbol, MODE_ASK)/MarketInfo(symbol, MODE_POINT) < 100000)
      return (true);
   else
      return (false);
}

int PointScale(string symbol)
{
   if(checkPoint5(symbol))
   {
      return (1);
   }
   else
   {
      return (10);
   }
}

string ErrorDescription(int error_code)
{
   string error_string;
//----
   switch(error_code)//switch 多分支语句
     {
      //---- codes returned from trade serverc
      //case:在case全部变量和相应表达式值检测的操作符之内比较常数表达式值。
      //每一个case变量会在整数或常数表达式内标注。常数表达式不包含函数变量调用。
      //switch表达式操作符必须是整数类型(int )。
      
      //braek语句：一个嵌入 操作符终止最近外部操作符 switch, while或 for 的执行。
      //在终止操作符之后给出检测操作符。这个操作符的目的之一：当中心值指定为变量时，操作符完成循环执行。
      
      
      case 0:
      case 1:   error_string="n没有错误返回";                                      break;
      case 2:   error_string="一般错误。";                                         break;
      case 3:   error_string="无效交易参量 ";                                      break;
      case 4:   error_string="交易服务器繁忙";                                     break;
      case 5:   error_string="客户终端旧版本";                                     break;
      case 6:   error_string="没有连接服务器";                                     break;
      case 7:   error_string="没有权限";                                           break;
      case 8:   error_string="请求过于频繁";                                       break;
      case 9:   error_string="交易运行故障";                                       break;
      case 64:  error_string="账户禁止";                                           break;
      case 65:  error_string="无效账户";                                           break;
      case 128: error_string="交易超时";                                           break;
      case 129: error_string="无效价格";                                           break;
      case 130: error_string="无效停止";                                           break;
      case 131: error_string="无效交易量";                                         break;
      case 132: error_string="市场关闭";                                           break;
      case 133: error_string="交易被禁止";                                         break;
      case 134: error_string="资金不足";                                           break;
      case 135: error_string="价格改变";                                           break;
      case 136: error_string="开价";                                               break;
      case 137: error_string="经纪繁忙";                                           break;
      case 138: error_string="重新开价";                                           break;
      case 139: error_string="定单被锁定";                                         break;
      case 140: error_string="只允许看涨仓位";                                     break;
      case 141: error_string="过多请求";                                           break;
      case 145: error_string="因为过于接近市场，修改否定";                         break;
      case 146: error_string=" 交易文本已满 ";                                     break;
      //---- mql4 errors  MQL4 运行错误代码
      case 4000: error_string="没有错误";                                         break;
      case 4001: error_string="错误函数指示";                                     break;
      case 4002: error_string="数组索引超出范围";                                 break;
      case 4003: error_string="对于调用堆栈储存器函数没有足够内存";               break;
      case 4004: error_string="循环堆栈储存器溢出";                               break;
      case 4005: error_string="对于堆栈储存器参量没有内存";                       break;
      case 4006: error_string="对于字行参量没有足够内存";                         break;
      case 4007: error_string="对于字行没有足够内存";                             break;
      case 4008: error_string="没有初始字行";                                     break;
      case 4009: error_string="在数组中没有初始字串符";                           break;
      case 4010: error_string="对于数组没有内存";                                 break;
      case 4011: error_string="字行过长";                                         break;
      case 4012: error_string="余数划分为零";                                     break;
      case 4013: error_string="零划分";                                           break;
      case 4014: error_string="不明命令";                                         break;
      case 4015: error_string="错误转换(没有常规错误)";                           break;
      case 4016: error_string="没有初始数组";                                     break;
      case 4017: error_string="禁止调用DLL";                                      break;
      case 4018: error_string="数据库不能下载";                                   break;
      case 4019: error_string="不能调用函数";                                     break;
      case 4020: error_string="禁止调用智能交易函数";                             break;
      case 4021: error_string="对于来自函数的字行没有足够内存";                   break;
      case 4022: error_string="系统繁忙 (没有常规错误)";                          break;
      case 4050: error_string="无效计数参量函数";                                 break;
      case 4051: error_string="无效参量值函数";                                   break;
      case 4052: error_string="字行函数内部错误";                                 break;
      case 4053: error_string="一些数组错误";                                     break;
      case 4054: error_string="应用不正确数组";                                   break;
      case 4055: error_string="自定义指标错误";                                   break;
      case 4056: error_string="不协调数组";                                       break;
      case 4057: error_string="整体变量过程错误";                                 break;
      case 4058: error_string="整体变量未找到";                                   break;
      case 4059: error_string="测试模式函数禁止";                                 break;
      case 4060: error_string="没有确认函数";                                     break;
      case 4061: error_string="发送邮件错误";                                     break;
      case 4062: error_string="字行预计参量";                                     break;
      case 4063: error_string="整数预计参量";                                     break;
      case 4064: error_string="双预计参量";                                       break;
      case 4065: error_string="数组作为预计参量";                                 break;
      case 4066: error_string="刷新状态请求历史数据";                             break;
      case 4099: error_string="文件结束";                                         break;
      case 4100: error_string="一些文件错误";                                     break;
      case 4101: error_string="错误文件名称";                                     break;
      case 4102: error_string="打开文件过多";                                     break;
      case 4103: error_string="不能打开文件";                                     break;
      case 4104: error_string="不协调文件";                                       break;
      case 4105: error_string="没有选择定单";                                     break;
      case 4106: error_string="不明货币对";                                       break;
      case 4107: error_string="无效价格";                                         break;
      case 4108: error_string="无效定单编码";                                     break;
      case 4109: error_string="不允许交易";                                       break;
      case 4110: error_string="不允许长期";                                       break;
      case 4111: error_string="不允许短期";                                       break;
      case 4200: error_string="定单已经存在";                                     break;
      case 4201: error_string="不明定单属性";                                     break;
      case 4202: error_string="定单不存在";                                       break;
      case 4203: error_string="不明定单类型";                                     break;
      case 4204: error_string="没有定单名称";                                     break;
      case 4205: error_string="定单坐标错误";                                     break;
      case 4206: error_string="没有指定子窗口";                                   break;
      default:   error_string="不知道的错误";
     }
//----
   return(error_string);
} 