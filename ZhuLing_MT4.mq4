//+------------------------------------------------------------------+
//|                                                  ZhuLing_MT4.mq4 |
//|                                                         Zhu Ling |
//+------------------------------------------------------------------+
#property copyright "Zhu Ling V20121008_01"
#include <ZhuLing_Lib.mqh>

/*
extern int MACD_Weight = 0;
extern int KDJ_Weight = 0;
extern int Acc_Weight = 0;
extern int Signal_Threashold = 0;
*/

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {   
   string SymbolArray[5] = {"EURUSD", "EURGPB", "GBPUSD", "AUDUSD", "USDCHF"};
   return(0);
  }
  
  
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
  
  
  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  
   string CurrentSymbol;
   int TimeFrame = PERIOD_M15;
 
  
  //check if we should place order
  
   int buySignal = 0;
   int sellSignal = 0;
   
   bool closeBuyFlag = false;
   bool closeSellFlag = false;
   
   
   
   bool MACD_Buy_Signal = false;
   bool MACD_Sell_Signal = false;
   bool MA_Buy_Signal = false;
   bool MA_Sell_Signal = false;

   int MACD_Weight = 2;
   int MA_Weight = 4;
   int KDJ_Weight = 2;
   int Acc_Weight = 0;
   int Alligator_Weight = 2;
   
   int Signal_Open_Threashold = 4;
   int Signal_Close_Threashold = 4;


   double Lots = 0.05;
   double stoploss = 30;
   double takeprofit = 300;


   
   for(int count = 0; count < 1; count++)
   {
//     CurrentSymbol = SymbolArray[count];
       CurrentSymbol = Symbol();
   
   //---------------------------------------------------------------------------
   //check MACD indicator
   //---------------------------------------------------------------------------


   double MACDMain = iMACD(CurrentSymbol,TimeFrame,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double MACDSignal = iMACD(CurrentSymbol,TimeFrame,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);   

   double MACDMainP1 = iMACD(CurrentSymbol,TimeFrame,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double MACDSignalP1 = iMACD(CurrentSymbol,TimeFrame,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);   


   if(MACDMain < 0 && MACDMain > MACDSignal &&  MACDMainP1 < MACDSignalP1 )
   {
      sellSignal = sellSignal + MACD_Weight;
      MACD_Sell_Signal = true;
      DrawSignal(1,Red);
      StopLossBuy(CurrentSymbol);
   }

   
   if(MACDMain > 0 && MACDMain < MACDSignal &&  MACDMainP1 > MACDSignalP1)
   {
      buySignal = buySignal + MACD_Weight;
      MACD_Buy_Signal = true;
      DrawSignal(0,Green);
      StopLossSell(CurrentSymbol);
   }
   
   //check MA indicator
   double Ma5 = iMA(CurrentSymbol,TimeFrame,5,0,MODE_SMMA,PRICE_CLOSE,0);
   double Ma5Pre = iMA(CurrentSymbol,TimeFrame,5,0,MODE_SMMA,PRICE_CLOSE,1);
   double Ma5Pre2 = iMA(CurrentSymbol,TimeFrame,5,0,MODE_SMMA,PRICE_CLOSE,2);
   
   double Ma8 = iMA(CurrentSymbol,TimeFrame,8,0,MODE_SMMA,PRICE_CLOSE,0);
   double Ma8Pre = iMA(CurrentSymbol,TimeFrame,8,0,MODE_SMMA,PRICE_CLOSE,1);
   double Ma8Pre2 = iMA(CurrentSymbol,TimeFrame,8,0,MODE_SMMA,PRICE_CLOSE,2);

   double Ma26 = iMA(CurrentSymbol,TimeFrame,26,0,MODE_SMMA,PRICE_CLOSE,0);
   double Ma26Pre = iMA(CurrentSymbol,TimeFrame,26,0,MODE_SMMA,PRICE_CLOSE,1);
   double Ma26Pre2 = iMA(CurrentSymbol,TimeFrame,26,0,MODE_SMMA,PRICE_CLOSE,2);
   
   static datetime LastMABuyCrossTime = 0;
   static datetime LastMASellCrossTime = 0;
   if(Ma5 > Ma8 && Ma8 > Ma26 && ((Ma5Pre <= Ma8Pre) || (Ma8Pre <= Ma26Pre)))
   {
      LastMABuyCrossTime = TimeCurrent();
   }
   
   if(Ma5 < Ma8 && Ma8 < Ma26 && ((Ma5Pre >= Ma8Pre) || (Ma8Pre >= Ma26Pre)))
   {
       LastMASellCrossTime = TimeCurrent();
   }
   
   if(Ma5 - Ma8 > 1*PointScale(CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT)  && TimeCurrent() - LastMABuyCrossTime < 60*15 )
   {
      //如果均线在15分钟内就扩大1点，准备开单
      buySignal = buySignal + MA_Weight;
      DrawSignal(8,Green);   
      MA_Buy_Signal = true;
      StopLossSell(CurrentSymbol);
   }
   
   if(Ma8 - Ma5 > 1*PointScale(CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT)  && TimeCurrent() - LastMASellCrossTime < 60*15)
   {
      //如果均线在15分钟内就扩大1点，准备开单
      sellSignal = sellSignal + MA_Weight;
      DrawSignal(9,Red);
      MA_Sell_Signal = true;
      StopLossBuy(CurrentSymbol);
   }
   
   if(MathAbs(LastMASellCrossTime - LastMABuyCrossTime) <  60*15)
   {
      //如果两次均线交叉的时间小于15分钟，即均线在来回纠缠，则15分钟内不开单
      if((TimeCurrent()-LastMABuyCrossTime < 60*15)||(TimeCurrent()-LastMASellCrossTime < 60*15))
      {
         //no sell or buy order
         sellSignal = sellSignal - MA_Weight;
         buySignal = buySignal - MA_Weight;
      }   
   }
   
   

   


   //-------------------------------------------------------------------------------------
   //check Accelerator indicator
   //-------------------------------------------------------------------------------------
//   
   
   int    limit;
   double     ExtBuffer1[4];
   double     ExtBuffer2[4];
   double     ExtBuffer3[4];
   double     ExtBuffer4[4];
   double prev,current;


   limit = 4;
   //---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
   {
      double smallMA = iMA(CurrentSymbol,TimeFrame,5,0,MODE_SMA,PRICE_MEDIAN,i);
      double bigMA = iMA(CurrentSymbol,TimeFrame,34,0,MODE_SMA,PRICE_MEDIAN,i);
      ExtBuffer3[i]= smallMA - bigMA;      
   }
   //---- signal line counted in the 2-nd additional buffer
   for(i=0; i<limit; i++)
      ExtBuffer4[i]=iMAOnArray(ExtBuffer3,limit,5,0,MODE_SMA,i);
   //---- dispatch values between 2 buffers
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=ExtBuffer3[i]-ExtBuffer4[i];
      prev=ExtBuffer3[i+1]-ExtBuffer4[i+1];
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         ExtBuffer2[i]=current;
         ExtBuffer1[i]=0.0;
        }
      else
        {
         ExtBuffer1[i]=current;
         ExtBuffer2[i]=0.0;
        }
     }


      if(MathAbs(ExtBuffer1[1]) > 0 && MathAbs(ExtBuffer1[1]) <= 0.0002)
      {
         //不开单
         buySignal = buySignal - Acc_Weight;
         sellSignal = sellSignal - Acc_Weight;
      }      
      else if(MathAbs(ExtBuffer1[1]) > 0.0002 && MathAbs(ExtBuffer1[1]) <= 0.005)
      {
         buySignal = buySignal + Acc_Weight;
//         DrawSignal(4,Green);         
      }
      else if( MathAbs(ExtBuffer1[1]) > 0.005)
      {
         buySignal = buySignal + Acc_Weight;
         DrawSignal(4,Yellow);
         StopLossSell(CurrentSymbol);                  
      }
      
      
      
      if(MathAbs(ExtBuffer2[1]) > 0 && MathAbs(ExtBuffer2[1]) <= 0.0002)
      {
         //No orders placed;
         sellSignal = sellSignal - Acc_Weight;
         buySignal = buySignal - Acc_Weight;
       }
       else if(MathAbs(ExtBuffer2[1]) > 0.0002 && MathAbs(ExtBuffer2[1]) <= 0.005)
       {
         sellSignal = sellSignal + Acc_Weight;
//         DrawSignal(5,Red);       
       }
       else if(MathAbs(ExtBuffer2[1]) > 0.005)
      {
         sellSignal = sellSignal + Acc_Weight;
         DrawSignal(5,Yellow);
         StopLossBuy(CurrentSymbol);       
      }
      


   
   //---------------------------------------------------------------------------------
   //check KDJ indicator;
   //---------------------------------------------------------------------------------
   double K = iStochastic(CurrentSymbol,TimeFrame,5,3,3,MODE_SMA,0,MODE_MAIN,0);
   double D = iStochastic(CurrentSymbol,TimeFrame,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);
   double Kp1 = iStochastic(CurrentSymbol,TimeFrame,5,3,3,MODE_SMA,0,MODE_MAIN,1);
   double Kp2 = iStochastic(CurrentSymbol,TimeFrame,5,3,3,MODE_SMA,0,MODE_MAIN,2);
   double Dp1 = iStochastic(CurrentSymbol,TimeFrame,5,3,3,MODE_SMA,0,MODE_SIGNAL,1);
   double Dp2 = iStochastic(CurrentSymbol,TimeFrame,5,3,3,MODE_SMA,0,MODE_SIGNAL,2);
   //check buy
   //check K>D
   if((K > D) && (Kp1 < Dp1))
   {
      //K & D are rising
      if((K > Kp1) && (Kp1> Kp2) && (D > Dp1) && (Dp1 > Dp2))
      {
         if(K > 50 && K <= 80)
         {
            //if K > 50, be careful, buy with lower conficence
            buySignal = buySignal + KDJ_Weight/2;
            Lots = Lots/2;
            DrawSignal(2,Green);
         }
         else if (K > 20 && K <=50)
         {
            //safe, buy with higher confidence
            DrawSignal(2,Green);
            buySignal = buySignal + KDJ_Weight;

         }
         else
         {
            //K <= 20 or K > 80, no action
         }
      }
   }
   
   //check sell
   if((K < D) && (Kp1 > Dp1))
   {
      //K & D are falling
      if((K < Kp1) && (Kp1< Kp2) && (D < Dp1) && (Dp1 < Dp2))
      {
         if(K > 20 && K <= 50)
         {
            //if K > 50, be careful, buy with lower conficence
            sellSignal = sellSignal + KDJ_Weight/2;
            Lots = Lots/2;
            DrawSignal(3,Red);
         }
         else if (K > 50 && K <=80)
         {
            //safe, buy with higher confidence
            sellSignal = sellSignal + KDJ_Weight;
            DrawSignal(3,Red);
         }
         else
         {
            //K <= 20 or K > 80, no action
         }
      }
   }

   //-------------------------------------------------------------------------------------
   //check Alligator indicator
   //-------------------------------------------------------------------------------------
   double ExtBlueBuffer[];
   double ExtRedBuffer[];
   double ExtLimeBuffer[];
   int JawsPeriod=13;
   int JawsShift=8;
   int TeethPeriod=8;
   int TeethShift=5;
   int LipsPeriod=5;
   int LipsShift=3;

   limit = 4;
   for(i=0; i<limit; i++)
   {
      //---- ma_shift set to 0 because SetIndexShift called abowe
      ExtBlueBuffer[i]=iMA(NULL,0,JawsPeriod,0,MODE_SMMA,PRICE_MEDIAN,i);
      ExtRedBuffer[i]=iMA(NULL,0,TeethPeriod,0,MODE_SMMA,PRICE_MEDIAN,i);
      ExtLimeBuffer[i]=iMA(NULL,0,LipsPeriod,0,MODE_SMMA,PRICE_MEDIAN,i);
   }
   
   if(ExtBlueBuffer[1] < ExtRedBuffer[1] && ExtRedBuffer[1] < ExtLimeBuffer[1])
   {
      buySignal = buySignal + Alligator_Weight;
      DrawSignal(6,Green);
   }
   
   if(ExtBlueBuffer[1] > ExtRedBuffer[1] && ExtRedBuffer[1] > ExtLimeBuffer[1])
   {
      sellSignal = sellSignal + Alligator_Weight;
      DrawSignal(7,Red);
   }




   //check close order
   if(sellSignal >= Signal_Close_Threashold || closeBuyFlag)
   {
      closeBuy(CurrentSymbol);
      closeBuyFlag = true;
   }
   
   if(buySignal >= Signal_Close_Threashold || closeSellFlag)
   {
      closeSell(CurrentSymbol);
      closeSellFlag = true;
   }

   if(CheckNoTradeSignal(CurrentSymbol,TimeFrame))
   {
      return;
   }
   
   
   //Open order
   if(buySignal >= Signal_Open_Threashold && !closeBuyFlag)
   {
      buy(CurrentSymbol, Lots, stoploss, takeprofit, CurrentSymbol + " Zhuling Buy Test", 1);
   }
   else
   {
/*      if(MACD_Buy_Signal)
      {
         Print("MACD Buy signal triggered, but not buy");
       Print("Buy Signal = " + buySignal);
       Print("Close Buy Flag = " + closeBuyFlag);

      }
      if(MA_Buy_Signal)
      {
         Print("MA Buy signal triggered, but not buy ");
       Print("Buy Signal = " + buySignal);
       Print("Close Buy Flag = " + closeBuyFlag);
      }  
*/       
   }
   
   if(sellSignal >= Signal_Open_Threashold && !closeSellFlag)
   {
      sell(CurrentSymbol, Lots, stoploss, takeprofit, CurrentSymbol + " Zhuling Sell Test", 1);
   }
   else
   {
/*      if(MACD_Sell_Signal)
      {
         Print("MACD Sell signal triggered, but not buy");
       Print("Sell Signal = " + sellSignal);
       Print("Close Sell Flag = " + closeSellFlag);
      }
      if(MA_Sell_Signal)
      {
         Print("MA Sell signal triggered, but not buy ");
       Print("Sell Signal = " + sellSignal);
       Print("Close Sell Flag = " + closeSellFlag);
      }
*/   }
   
   
 
 
 
   
   //check if existing order's gain threshold should be changed
   MoveTakeProfit(23);
   
   //force stop loss
   ForceStopLoss(CurrentSymbol,stoploss);
   
//   CheckAddon(30);
   
//   StopLoss(12);
   
   
   
   
   
   //check if we should close order to take gain, or stop loss
   
   
   
   
   }
   
   
   return(0);
  }
//+------------------------------------------------------------------+




//Check whether we should not trade
bool CheckNoTradeSignal(string CurrentSymbol, int TimeFrame)
{
   return (CheckGap(CurrentSymbol,TimeFrame)|| CheckTiming(CurrentSymbol,TimeFrame) || CheckHugePriceChange(CurrentSymbol,TimeFrame));
}

//如果是每个月第一个周五的晚上8点到11点，非农数据公布的时候，不开单
bool CheckTiming(string CurrentSymbol, int TimeFrame)
{
   //周五晚上7点以后不交易
   if(DayOfWeek() == 5)
   {
      if(TimeHour(TimeCurrent()) + 8 >= 19)
      {
         return (true);
      }
   }
   return (false);
}

//如果出现了跳空:30分钟内，一根K线和上一根K线 差别大于50点
bool CheckGap(string CurrentSymbol, int TimeFrame)
{
   static datetime LastGapTime = 0;

   double PriceThresold = 50*PointScale( CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);

   if( MathMax(iOpen(CurrentSymbol,TimeFrame,1),iClose(CurrentSymbol,TimeFrame,1)) < MathMin(iOpen(CurrentSymbol,TimeFrame,0),iClose(CurrentSymbol,TimeFrame,0)) - PriceThresold
      ||
      MathMin(iOpen(CurrentSymbol,TimeFrame,1),iClose(CurrentSymbol,TimeFrame,1)) > MathMax(iOpen(CurrentSymbol,TimeFrame,0),iClose(CurrentSymbol,TimeFrame,0)) + PriceThresold)
   {   
      return (true);
   }
   else
   { 
      return (false);
   }      
}

//如果均线交差前的30分钟内，单根K线价格出现大幅震荡(大于50个点)，说明均线交差是由单次震荡引起的，不开单
bool CheckHugePriceChange(string CurrentSymbol, int TimeFrame)
{
   static datetime LastOcilationTime = 0;
   
   double PriceDifference = MathAbs(iOpen(CurrentSymbol,TimeFrame,0) - iClose(CurrentSymbol,TimeFrame,0));
   double PriceThresold = 50*PointScale( CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
   if(PriceDifference > PriceThresold)
   {
      LastOcilationTime = TimeCurrent();
/*      
      static datetime LastDrawArrowTime = 0;
      if(TimeCurrent() - LastDrawArrowTime > 60*30)
      {
         LastDrawArrowTime = TimeCurrent();
         DrawArrow("价格巨幅震荡，30分钟内不开单",SYMBOL_STOPSIGN,OrangeRed);   
      }         
*/      
   }
   if(TimeCurrent() - LastOcilationTime < 60*30)
   {
      return (true);
   }
   else
   {
      return (false);
   }
}


