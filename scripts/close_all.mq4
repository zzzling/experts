//+------------------------------------------------------------------+
//|                                                    close_all.mq4 |
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
   double price;
   int    cmd,error;
   int total=OrdersTotal();

   for(int i=0; i<total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         cmd = OrderType();

         if(cmd==OP_BUY || cmd==OP_SELL)
         {
            while(true)
            {
               if(cmd == OP_BUY) 
                  price=Bid;
               else            
                  price=Ask;
               result = OrderClose(OrderTicket(),OrderLots(),price,5,CLR_NONE);
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
                  continue;
            }
         }
      }
      else 
      { 
         Print( "Error when order select ", GetLastError()); 
         break; 
      }
   }   


   return(0);
  }
//+------------------------------------------------------------------+