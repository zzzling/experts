//+------------------------------------------------------------------+
//|                                           delete_all_pending.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   bool   result;
   int    cmd,total;
//----
   total=OrdersTotal();
//----
   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         cmd = OrderType();
         //---- pending orders only are considered
         if(cmd != OP_BUY && cmd != OP_SELL)
         {
            result=OrderDelete(OrderTicket());
            if(result != TRUE) 
               Print("LastError = ", GetLastError());
         }
      }
      else 
      { 
         Print( "Error when order select ", GetLastError()); 
         break; 
      }
   }   
//----
   return(0);
  }
//+------------------------------------------------------------------+