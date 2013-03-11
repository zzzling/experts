//+------------------------------------------------------------------+
//|                                             ZhuLing_Lib_Draw.mq4 |
//|                                                         Zhu Ling |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Zhu Ling"




void DrawSignal(int nSignalType, int Color)
{
   static datetime last_MACD_Buy_DrawTime = 0;
   static datetime last_MACD_Sell_DrawTime = 0;
   static datetime last_MA_Buy_DrawTime = 0;
   static datetime last_MA_Sell_DrawTime = 0;
   static datetime last_KDJ_Buy_DrawTime = 0;
   static datetime last_KDJ_Sell_DrawTime = 0;
   static datetime last_Acc_Buy_DrawTime = 0;
   static datetime last_Acc_Sell_DrawTime = 0;
   static datetime last_Alligator_Buy_DrawTime = 0;
   static datetime last_Alligator_Sell_DrawTime = 0;


   string name;
   int ArrowType;
   datetime CurrentTime =  TimeCurrent();
   
   switch(nSignalType)
   {
      case 0: 
         return;
         name = "MACD buy";
         ArrowType = SYMBOL_ARROWUP;
         if(CurrentTime - last_MACD_Buy_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_MACD_Buy_DrawTime = CurrentTime;
         }
         break;
      case 1: 
         return;
         name = "MACD sell";
         ArrowType = SYMBOL_ARROWDOWN;
         if(CurrentTime - last_MACD_Sell_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_MACD_Sell_DrawTime = CurrentTime;
         }
         break;
      case 2:
         name = "KDJ buy";
         ArrowType = SYMBOL_ARROWUP;
         if(CurrentTime - last_KDJ_Buy_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_KDJ_Buy_DrawTime = CurrentTime;
         }
         break;
      case 3:
         name = "KDJ sell";
         ArrowType = SYMBOL_ARROWDOWN;
         if(CurrentTime - last_KDJ_Sell_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_KDJ_Sell_DrawTime = CurrentTime;
         }
         break;
      case 4:
         return;
         name = "Acc buy";
         ArrowType = SYMBOL_ARROWUP;
         if(CurrentTime - last_Acc_Buy_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_Acc_Buy_DrawTime = CurrentTime;
         }
         break;
      case 5:
         return;
         name = "Acc sell";
         ArrowType = SYMBOL_ARROWDOWN;
         if(CurrentTime - last_Acc_Sell_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_Acc_Sell_DrawTime = CurrentTime;
         }
          break;
      case 6:
         name = "Alligator buy";
         ArrowType = SYMBOL_ARROWUP;
         if(CurrentTime - last_Alligator_Buy_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_Alligator_Buy_DrawTime = CurrentTime;
         }
         break;
      case 7:
         name = "Alligator sell";
         ArrowType = SYMBOL_ARROWDOWN;
         if(CurrentTime - last_Alligator_Sell_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_Alligator_Sell_DrawTime = CurrentTime;
         }
          break;
      case 8:
         return;
         name = "MA buy";
         ArrowType = SYMBOL_ARROWUP;
         if(CurrentTime - last_MA_Buy_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_MA_Buy_DrawTime = CurrentTime;
         }
         break;
      case 9:
         return;
         name = "MA sell";
         ArrowType = SYMBOL_ARROWDOWN;
         if(CurrentTime - last_MA_Buy_DrawTime  < 1200)
         {
            return;
         }
         else
         {
            last_MA_Buy_DrawTime = CurrentTime;
         }
          break;
        default:
         name = "Wrong Signal Type";
         ArrowType = SYMBOL_STOPSIGN;
   }     
               
   
   DrawArrow(name,ArrowType,Color);
   
}



void DrawArrow(string name, int ArrowType, int Color)
{
   
   datetime CurrentTime =  TimeCurrent();
   string obName = name + TimeToStr(CurrentTime,TIME_DATE|TIME_SECONDS);
   int nOffset = MathRand()%20;
   if(ArrowType == SYMBOL_ARROWUP)
   {
      ObjectCreate(obName, OBJ_ARROW, 0, TimeCurrent(), Low[0]-(10+nOffset)*Point); //draw an up arrow
      ObjectCreate(obName + "Text", OBJ_TEXT, 0, TimeCurrent(), Low[0]-(40+nOffset)*Point); 
   }
   else
   {
      ObjectCreate(obName, OBJ_ARROW, 0, TimeCurrent(), High[0]+(10+nOffset)*Point); //draw an up arrow      
      ObjectCreate(obName + "Text", OBJ_TEXT, 0, TimeCurrent(), High[0]+(40+nOffset)*Point); //draw an up arrow
   }
   ObjectSetText(obName + "Text",name,9, "Times New Roman",Color);
   ObjectSet(obName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(obName, OBJPROP_ARROWCODE, ArrowType);
   ObjectSet(obName, OBJPROP_COLOR,Color); 
}

