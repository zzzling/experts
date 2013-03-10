extern double lots = 1; // lots to use per trade
extern string name = "ms";
extern int magic_shift = -61;

int magic;

void onOpen(){
   double historic_move = iAC(NULL, 0, MathAbs(magic_shift));
   
   if (magic_shift<0){
      if (historic_move < 0){
         closeShortGoLong();
      }else{
         closeLongGoShort();
      }
   }else{
      if (historic_move > 0){
         closeShortGoLong();
      }else{
         closeLongGoShort();
      }
   }
}

void closeShortGoLong(){
   closeOpenOrders(OP_SELL, magic);
   if (getNumOpenOrders(OP_BUY, magic) == 0){
      buy(lots, 0, 0, magic, comment);
   }
}

void closeLongGoShort(){
   closeOpenOrders(OP_BUY, magic);
   if (getNumOpenOrders(OP_SELL, magic) == 0){
      sell(lots, 0, 0, magic, comment);
   }
}

int start(){
   static int numbars;
   if (Bars == numbars){
      return(0);
   }
   numbars = Bars;
   onOpen();
   return(0);
}

void closeOpenOrders(int type, int magic){
   int total, cnt;
   double price;
   
   
   while (getNumOpenOrders(type, magic) > 0){
      while (IsTradeContextBusy()){
         Print("Waiting for trade context... (OrderClose)");
         Sleep(MathRand()/10);
      }
      total=OrdersTotal();
      Print("Trying to close trades");
      RefreshRates();
      if (type == OP_BUY){
         price = Bid;
      }else{
         price = Ask;
      }
      for(cnt=total;cnt>=0;cnt--){
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderSymbol()==Symbol() && (type==-1 || OrderType()==type) && OrderMagicNumber() == magic){
            if(IsTradeContextBusy()){
               break; // something else is trading too, back to the while loop.
            }
            if (type == OP_BUYSTOP || type == OP_SELLSTOP || type == OP_BUYLIMIT || type == OP_SELLLIMIT){
               OrderDelete(OrderTicket());
            }else{
               OrderClose(OrderTicket(),OrderLots(),price,999,Yellow);
            }
            Print("last error: " + GetLastError());
         } 
      }
      Sleep(MathRand()/100);
   }
}

int getNumOpenOrders(int type, int magic){
   int cnt;
   int num = 0;
   int total=OrdersTotal();
   for(cnt=total;cnt>=0;cnt--){
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber() == magic && (type==-1 || OrderType() == type)){
         num++;
      }
   }
   return (num);
}

int buy(double lots, double sl, double tp, int magic=42, string comment=""){
   int err;
   int ticket;
   while(True){
      RefreshRates();
      Print("Trying to buy (" + lots + "," + Ask + "," + sl + "," + tp + ")");
      ticket = OrderSendN(Symbol(), OP_BUY, lots, Ask, 100, sl, tp, comment, magic, 0, Blue);
      err = GetLastError();
      Print("last Error: " + err);
      if (err != 0){
         if (err==130){
            return(-1);
         }
         Sleep(1000);
      }else{
         return(ticket);
      }
   }   
}

int sell(double lots, double sl, double tp, int magic=42, string comment=""){
   int err;
   int ticket;
   while(True){
      RefreshRates();
      Print("Trying to sell (" + lots + "," + Bid + "," + sl + "," + tp + ")");
      ticket = OrderSendN(Symbol(), OP_SELL, lots, Bid, 100, sl, tp, comment, magic, 0, Red);
      err = GetLastError();
      Print("last Error: " + err);
      if (err != 0){
         if (err==130){
            return(-1);
         }
         Sleep(1000);
      }else{
         return(ticket);
      }
   }   
}


int OrderSendN(
   string symbol, 
   int cmd, 
   double volume, 
   double price, 
   int slippage, 
   double stoploss,
   double takeprofit,
   string comment="",
   int magic=0,
   datetime expiration=0,
   color arrow_color=CLR_NONE
){
   return(OrderSend(
      symbol,
      cmd, 
      volume, 
      NormalizeDouble(price, Digits), 
      slippage, 
      NormalizeDouble(stoploss, Digits), 
      NormalizeDouble(takeprofit, Digits),
      comment, 
      magic, 
      expiration, 
      arrow_color
   ));
}