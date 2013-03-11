//+------------------------------------------------------------------+
//|                                                   CatchEvent.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#include <ZhuLing_Lib.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {

   int handle = FileOpen("EALog.csv",FILE_CSV|FILE_READ|FILE_WRITE);
   string CurrentSymbol = Symbol();
   double Lots = 0.1;
   double PriceJump = 50;
   double stoploss = 50;
   double takeprofit = 300;

   //定义事件的时间，注意是北京时间 - 6小时(对IronFX)
   datetime EventTime = StrToTime("2013.3.11 10:01");


   //事件还有超过60秒才发生，不开单
   if(EventTime - TimeCurrent() > 60)
      return(0);
      
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
   
   
   //此时离时间不到60秒，在价位的上部和下部分别开挂单
   
   //如果已经开了挂单，并且上次挂单的价格和这次挂单的价格相差小于5点，则更改挂单价格
   
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderType()==OP_BUYSTOP  ||    OrderType()==OP_SELLSTOP)
         {
            return (0);           
         } 
      }
   }
      
   double price = Ask + PriceJump*PointScale(CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
   buyStop(CurrentSymbol,Lots,price,stoploss,takeprofit,CurrentSymbol + " Catch Event", 2, handle);


   price = Bid - PriceJump*PointScale(CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
   sellStop(CurrentSymbol,Lots,price,stoploss,takeprofit,CurrentSymbol + " Catch Event", 2,handle);

   return(0);
  }
//+------------------------------------------------------------------+