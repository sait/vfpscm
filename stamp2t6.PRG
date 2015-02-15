******************************************************************** 
* Program....: STAMP2T6.PRG 
* Version....: 1.0 
* Author.....: Ted Roche 
* Date.......: May 31, 1998 
* Notice.....: Copyright 1998 Ted Roche, All Rights Reserved. 
* Compiler...: Visual FoxPro 06.00.8093.00 for Windows 
* Abstract...: VERSION SIX AND LATER ONLY!!! 
* ...........: Simpler version of Stamp2DT written for HackFox3 and 
* ...........: also published in FoxPro Advisor magazine 
* Changes....: ********************************************************************   
function stamp2t6(tnStamp)
	#DEFINE SecondsMask 15 && 00001111 
	#DEFINE MinutesMask 63 && 00111111 
	#DEFINE HoursMask 31 && 00011111 
	#DEFINE DaysMask 31 && 00011111 
	#DEFINE MonthsMask 15 && 00001111 
	#DEFINE YearsMask 63 && 00111111   
	#DEFINE SecondsOffset 1 && Note this is a LEFT shift, not RIGHT 
	#DEFINE MinutesOffset 5 
	#DEFINE HoursOffset 11 
	#DEFINE DaysOffset 16 
	#DEFINE MonthsOffset 21 
	#DEFINE YearsOffset 25   
	#DEFINE fMonth BITAND(BITRSHIFT(tnStamp,MONTHSOFFSET),MONTHSMASK) 
	#DEFINE fDay BITAND(BITRSHIFT(tnStamp,DAYSOFFSET),DAYSMASK) 
	#DEFINE fYear 1980+BITAND(BITRSHIFT(tnStamp,YEARSOFFSET),YEARSMASK) 
	#DEFINE fHour BITAND(BITRSHIFT(tnStamp,HOURSOFFSET),HOURSMASK) 
	#DEFINE fMinute BITAND(BITRSHIFT(tnStamp,MINUTESOFFSET),MINUTESMASK) 
	#DEFINE fSecond BITAND(BITLSHIFT(tnStamp,SECONDSOFFSET),SECONDSMASK)   
	IF TYPE("VERSION(5)") = "U"  
		MESSAGEBOX("This routine only works with Visual FoxPro 6.x or later.") 
		RETURN {//::}
	ENDIF   
return iif(tnStamp = 0, {//::}, DATETIME(fYear, fMonth, fDay, fHour, fMinute, fSecond)) 
