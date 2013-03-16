//+------------------------------------------------------------------+
//|                                                   CatchEvent.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#include <ZhuLing_Lib.mqh>


int handle = 0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   handle = FileOpen("Catch Event Log.csv",FILE_CSV|FILE_READ|FILE_WRITE);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   if(handle > 0)
   {
      FileClose(handle);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {

   string CurrentSymbol = Symbol();
   double Lots = 0.2;
   double PriceJump = 0;
   double stoploss = 0;
   double takeprofit = 0;
   //定义事件的时间，注意是北京时间 -  6小时(对IronFX)
   datetime EventTime = StrToTime("2013.3.15 16:20");

    
   if(StringFind(CurrentSymbol,"EURUSD") != -1)
   {
      //为保证能正常开挂单，上限设为6
      PriceJump = 7;
      stoploss = 5;
      takeprofit = 100;
      Lots = 1;
   }
   
   if(StringFind(CurrentSymbol,"GBPUSD") != -1)
   {
      //为保证能正常开挂单，上限设为6
      PriceJump = 7;
      stoploss = 5;
      takeprofit = 100;
      Lots = 1;
   }   
   
   if(StringFind(CurrentSymbol,"USDJPY") != -1)
   {
      //经验证，挂单最小差50
      PriceJump = 50;
      stoploss = 50;
      takeprofit = 200;
      Lots = 1;
   }

   if(StringFind(CurrentSymbol,"AUDUSD") != -1)
   {
      //为保证能正常开单，上限设为6
      PriceJump = 7;
      stoploss = 5;
      takeprofit = 50;
      Lots = 1;
   }
   
   if(StringFind(CurrentSymbol,"USDCHF") != -1)
   {
      //为保证能正常开单，上限设为6
      PriceJump = 50;
      stoploss = 50;
      takeprofit = 500;
      Lots = 1;
   }

   if(StringFind(CurrentSymbol,"EURJPY") != -1)
   {
      //为保证能正常开单，上限设为6
      PriceJump = 7;
      stoploss = 5;
      takeprofit = 100;
      Lots = 1;
   }

   if(StringFind(CurrentSymbol,"USDCAD") != -1)
   {
      //为保证能正常开单，上限设为6
      PriceJump = 7;
      stoploss = 5;
      takeprofit = 50;
      Lots = 1;
   }
   
   if(StringFind(CurrentSymbol,"NZDUSD") != -1)
   {
      //为保证能正常开单，上限设为6
      PriceJump = 50;
      stoploss = 50;
      takeprofit = 200;
      Lots = 1;
   }   
   

   if(PriceJump == 0)
   {
      return (0);
   }


   //事件还有超过120秒才发生，不开单
   if(EventTime - TimeCurrent() > 120)
   {
      return(0);
   }
      
   //时间已经开始，并且在60秒内，不开单。以免挂单已经生效而反复开单
   if(TimeCurrent() - EventTime > 0 && TimeCurrent() - EventTime <= 60)
   {
      return (0);
   }
   
   
   int i = 0;
/*      
   //事件已经发生超过了60秒，将所有挂单删除  
   if(TimeCurrent() - EventTime > 60)
   {
      for(int i=0;i<OrdersTotal();i++)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
            if((OrderType()==OP_BUYSTOP ) || (OrderType()==OP_SELLSTOP))    
            {
               int ticket = OrderTicket();
               OrderDelete(ticket);
            } 
         }
      }
      return(0);
   }
*/   
   
   //此时离时间不到120秒，在价位的上部和下部分别开挂单
   
   //Todo: 如果已经开了挂单，并且上次挂单的价格和这次挂单的价格相差小于5点，则更改挂单价格
   bool BuyStopOpened = false;
   bool SellStopOpened = false;
   
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         //如果不是当前货币对，则退出
         if(StringFind(OrderSymbol(),CurrentSymbol) == -1)
         {
            continue;
         }
         
         if(OrderType() == OP_BUYSTOP)
         {
            BuyStopOpened = true;           
         }
         if(OrderType() == OP_SELLSTOP) 
         {
            SellStopOpened = true;
         }
      }
   }
      
   double price =0;
   
   if(!BuyStopOpened)
   {
      price = Ask + PriceJump*PointScale(CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
      buyStop(CurrentSymbol,Lots,price,stoploss,takeprofit,CurrentSymbol + " Catch Event", 2, handle);
   }

   if(!SellStopOpened)
   {
      price = Bid - PriceJump*PointScale(CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
      sellStop(CurrentSymbol,Lots,price,stoploss,takeprofit,CurrentSymbol + " Catch Event", 2,handle);
   }      


   return(0);
  }
//+------------------------------------------------------------------+