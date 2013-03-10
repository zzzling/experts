//+------------------------------------------------------------------+
//|                                                  ZhuLing_Lib.mq4 |
//|                                                        Zhu Ling. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Zhu Ling V20121008_01"

#include <ZhuLing_Lib_Utl.mqh>
#include <ZhuLing_Lib_Draw.mqh>


int buy(string CurrentSymbol, double Lots,double loss,double gain,string comment,int magic)
{
   static datetime LastBuyTime;
   if(TimeCurrent() - LastBuyTime < 60*60*0.5)
      return (0);

   int nRepeated = 0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if((OrderComment()==comment)&&(OrderMagicNumber()==magic))    
         {
            if(OrderProfit() < 0)
               return (0);
            nRepeated++;
            
         } 
      }
   }
/*
   if(nRepeated >= 1)
   {
      Lots = Lots*2;
      loss = loss/2;   
   }
*/
   
   double price = Ask;
   int ticket=OrderSend(CurrentSymbol ,OP_BUY,Lots,price,5*PointScale(CurrentSymbol),0,0,comment,magic,0,Purple);
   if(ticket>0)
   {
      LastBuyTime = TimeCurrent();
      if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
      {
         loss = loss * PointScale(CurrentSymbol);
         gain = gain * PointScale(CurrentSymbol);
         if((loss!=0)&&(gain!=0))
         {
           OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-loss*MarketInfo(CurrentSymbol,MODE_POINT),OrderOpenPrice()+gain*MarketInfo(CurrentSymbol,MODE_POINT),0,Purple); 
         }
         if((loss==0)&&(gain!=0))
         {
           OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()+gain*MarketInfo(CurrentSymbol,MODE_POINT),0,Purple); 
         }
         if((loss!=0)&&(gain==0))
         {
           OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-loss*MarketInfo(CurrentSymbol,MODE_POINT),0,0,Purple); 
         }
      }
      return(ticket);
   }
   else
   {
      int errorCode = GetLastError();
      Print("Buy error code " + errorCode + " , " + ErrorDescription(errorCode));
      return(0);
   }
}



int sell(string CurrentSymbol, double Lots,double loss,double gain,string comment,int magic)
{
   static datetime LastSellTime;
   
   if(TimeCurrent() - LastSellTime < 60*60*0.5)
      return (0);
      
      
   int nRepeated = 0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if((OrderComment()==comment)&&(OrderMagicNumber()==magic))    
         {
            if(OrderProfit() < 1)
               return (0);
            nRepeated++;
         } 
      }
   }
/*
   if(nRepeated >= 1)
   {
      Lots = Lots*2;
      loss = loss/2;   
   }
*/   
   
   double price = Bid;
   int ticket=OrderSend(CurrentSymbol ,OP_SELL,Lots,price,5*PointScale(CurrentSymbol),0,0,comment,magic,0,Red);
   if(ticket>0)
   {
      LastSellTime = TimeCurrent();
      if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
      {
         loss = loss * PointScale(CurrentSymbol);
         gain = gain * PointScale(CurrentSymbol);
         if((loss!=0)&&(gain!=0))
         {
           OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+loss*MarketInfo(CurrentSymbol,MODE_POINT),OrderOpenPrice()-gain*MarketInfo(CurrentSymbol,MODE_POINT),0,Red); 
         }
         if((loss==0)&&(gain!=0))
         {
           OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderOpenPrice()-gain*MarketInfo(CurrentSymbol,MODE_POINT),0,Red); 
         }
         if((loss!=0)&&(gain==0))
         {
           OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+loss*MarketInfo(CurrentSymbol,MODE_POINT),0,0,Red); 
         }
      }
      return(ticket);
   }
   else
   {
      int errorCode = GetLastError();
      Print("Buy error code " + errorCode + " , " + ErrorDescription(errorCode));
      return(0);
   }
}

int closeBuy(string CurrentSymbol)
{
   int error;
   bool result;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)&& OrderType() == OP_BUY)
      {
         if(OrderSymbol() == CurrentSymbol)    
         {
            while(true)
            {
                  result = OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue);
                  if(result!=TRUE) 
                  { 
                     error=GetLastError(); 
                     Print("LastError = ",error); 
                     if(error==135)    
                        RefreshRates();
                     else 
                        break;
                  }
                  else
                  { 
                     error=0;
                     break;
                  }
                     
              }
         } 
      }
   }
}

int closeSell(string CurrentSymbol)
{
   int error;
   bool result;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderType() == OP_SELL)
      {
         if(OrderSymbol() == CurrentSymbol)   
         {
            while(true)
            {
                  result = OrderClose(OrderTicket(),OrderLots(),Ask,3,Blue);
                  if(result!=TRUE) 
                  { 
                     error=GetLastError(); 
                     Print("LastError = ",error); 
                     if(error==135)    
                        RefreshRates();
                     else 
                        break;
                  }
                  else
                  { 
                     error=0;
                     break;
                  }
              }
         } 
      }
   }
}

int StopLossSell(string CurrentSymbol)
{
   int error;
   bool result;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderType() == OP_SELL)
      {
         if(OrderSymbol() == CurrentSymbol)   
         {
            if(OrderProfit() < 0)
            {
               while(true)
               {
                     result = OrderClose(OrderTicket(),OrderLots(),Ask,3,Blue);
                     if(result!=TRUE) 
                     { 
                        error=GetLastError(); 
                        Print("LastError = ",error); 
                     }
                     else 
                        error=0;
                     
                     if(error==135)    
                        RefreshRates();
                     else 
                        break;
                 }
              }
         } 
      }
   }
}

int StopLossBuy(string CurrentSymbol)
{
   int error;
   bool result;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)&& OrderType() == OP_BUY)
      {
         if(OrderSymbol() == CurrentSymbol)    
         {
            if(OrderProfit() < 0)
            {
               while(true)
               {
                     result = OrderClose(OrderTicket(),OrderLots(),Bid,3,Blue);
                     if(result!=TRUE) 
                     { 
                        error=GetLastError(); 
                        Print("LastError = ",error); 
                     }
                     else 
                        error=0;
                     
                     if(error==135)    
                        RefreshRates();
                     else 
                        break;
                 }
              }
         } 
      }
   }
}




//在盈利的时候，移动止损止盈
void MoveTakeProfit(double Delta)
{
   int ErrorCode = 0;
   int OrderCount = OrdersTotal();
   int nRepeated = 0;

   for(int i = 0; i < OrderCount;i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) 
         continue;
      
      string CurrentSymbol = OrderSymbol();
      static double LastHighestProfit = 0;
      static double LastHighestLoss = 0;
      double ProfitThresold = 100000*OrderLots()*Delta* PointScale( CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
      double LossThresold = ProfitThresold;
      
      nRepeated++;
      if(OrderProfit() > 0 && OrderProfit() > LastHighestProfit)
      {
         LastHighestProfit = OrderProfit();
         return;
      }
      
      if(OrderProfit() < 0 && OrderProfit() < LastHighestLoss)
      {
         LastHighestLoss = OrderProfit();
      }
      
      if(LastHighestLoss >=  -1*ProfitThresold)
      {
         ProfitThresold = ProfitThresold*2;
      }
      

      double CurrentBidPrice = MarketInfo(CurrentSymbol,MODE_BID);
      double CurrentAskPrice = MarketInfo(CurrentSymbol,MODE_ASK);
      double OrderTakeProfitPrice = OrderTakeProfit();
      double OrderStopLossPrice = OrderStopLoss();
      double CurrentOrderOpenPrice = OrderOpenPrice();
      
      if(nRepeated >= 2)
      {
         ProfitThresold = ProfitThresold/2;
      }
      
      
      //如果还在盈利，并且盈利水平比曾经有的最高盈利值下降了一定的Thresold，则平仓
      if((OrderProfit() > 0) && (LastHighestProfit - OrderProfit() > ProfitThresold))
      {
         if(OrderType() == OP_BUY)
            closeBuy(CurrentSymbol);
         if(OrderType() == OP_SELL)
            closeSell(CurrentSymbol);           
         LastHighestProfit = 0;
         LastHighestLoss = 0;
         DrawArrow("Take Profit",SYMBOL_ARROWDOWN,Yellow);
      }
      
      
      //如果开盘后一直亏损，切当前亏损额大于Thresold，平仓
      if( LastHighestProfit<=0.4*LossThresold && OrderProfit() < -0.8*LossThresold)
      {
         if(OrderType() == OP_BUY)
            closeBuy(CurrentSymbol);
         if(OrderType() == OP_SELL)
            closeSell(CurrentSymbol);           
         LastHighestProfit = 0;
         LastHighestLoss = 0;
         DrawArrow("Stop Loss",SYMBOL_STOPSIGN,Yellow);
      }
      
      
      
   }
}

void ForceStopLoss(string CurrentSymbol,double StopLoss)
{
   double LossThresold = 100000*OrderLots()*StopLoss* PointScale( CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
   if(OrderProfit()< -1*LossThresold)
   {
      if(OrderType() == OP_SELL)
      {
         closeSell(CurrentSymbol);
      }
      else if(OrderType() == OP_BUY)
      {
         closeBuy(CurrentSymbol);
      }
   }
}


//止损
void StopLoss(double Delta)
{
   int ErrorCode = 0;
   int OrderCount = OrdersTotal();
   int nRepeated = 0;

   for(int i = 0; i < OrderCount;i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) 
         continue;
      string CurrentSymbol = OrderSymbol();
      static double LastHighestProfit = 0;
      double DeltaThresold = Delta* PointScale( CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
      
      double CurrentBidPrice = MarketInfo(CurrentSymbol,MODE_BID);
      double CurrentAskPrice = MarketInfo(CurrentSymbol,MODE_ASK);
      double OrderTakeProfitPrice = OrderTakeProfit();
      double OrderStopLossPrice = OrderStopLoss();
      double CurrentOrderOpenPrice = OrderOpenPrice();
      
      
      
      if((OrderProfit() < 0) && MathAbs(CurrentBidPrice - CurrentOrderOpenPrice) > DeltaThresold)
      {
         if(OrderType() == OP_BUY)
            closeBuy(CurrentSymbol);
         if(OrderType() == OP_SELL)
            closeSell(CurrentSymbol);           
         DrawArrow("Stop Loss",SYMBOL_STOPSIGN,OrangeRed);
      }
   }
}

//当盈利时，追加下单
void CheckAddon(double Delta)
{
   int ErrorCode = 0;
   int OrderCount = OrdersTotal();
   if(OrderCount <1) return;
   
   string CurrentSymbol;


   int nRepeated = 0;
   datetime LastOrderTime = 0;
   for(int i = 0; i < OrderCount;i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) 
         continue;
         
      CurrentSymbol = OrderSymbol();
      
      double ProfitThresold = 100000*OrderLots()*Delta* PointScale( CurrentSymbol)*MarketInfo(CurrentSymbol,MODE_POINT);
      
      if(OrderProfit() < ProfitThresold)
         return;
      
      if(LastOrderTime < OrderOpenTime())
         LastOrderTime = OrderOpenTime();
      
      nRepeated = nRepeated + 1;
   }
   
   if( TimeCurrent() -  LastOrderTime > 60*60*2)
   {
      double CurrentBidPrice = MarketInfo(CurrentSymbol,MODE_BID);
      double CurrentAskPrice = MarketInfo(CurrentSymbol,MODE_ASK);
      
      if(nRepeated > 4) nRepeated = 4;
      double Lots = AccountFreeMargin()*0.1*OrderCount*0.001;
      
      if(OrderType() == OP_BUY)
      {
         buy(CurrentSymbol, Lots, 20, 50, CurrentSymbol + " Zhuling Add on Buy Test", 2);
      }
      else if(OrderType() == OP_SELL)
      {
         sell(CurrentSymbol, Lots, 20, 50, CurrentSymbol + " Zhuling Add on Sell Test", 2);
      }

   }
}






