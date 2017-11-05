/**
 * 日期工具类
 * @date   2012-7-17 下午4:16:21
 * @author shiyong
 * 
 */
package mortal.common.tools
{
	import mortal.game.manager.ClockManager;

	public class DateUtil
	{
		private static var localTimeZone:int = -8; 
		
		public function DateUtil()
		{
		}
		
		/**
		 *获取经过的总天数。距离 1970 年 1 月 1 日 
		 * @param date
		 * @return 
		 * 
		 */		
		public static function getTotalDays(date:Date):int
		{
			if (date == null) 
			{
				return 0;
			}
			return int(( date.time - localTimeZone * 60 * 60 * 1000 ) / (24 * 60 * 60 * 1000));
		}
		
		/**
		 * 是否同一天 
		 * @param day1
		 * @param day2
		 * 
		 */		
		public static function isSameDay(date1:Date,date2:Date):Boolean
		{
			return date1.fullYear == date2.fullYear 
				&& date1.month == date2.month
				&& date1.day == date2.day
		}
		
		/**
		 * 获取日期差 
		 * @param date1
		 * @param date2
		 * 
		 */		
		public static function getDayDis(dateFrom:Date,dateTo:Date):int
		{
			var fromDay:int = getTotalDays(dateFrom);
			var toDay:int = getTotalDays(dateTo);
			return toDay - fromDay;
		}
		
		/**
		 *当前日期是否在给定时间内 
		 * @param startDt
		 * @param endDt
		 * @return 
		 * 
		 */		
		public static function isInDate(startDt:Date,endDt:Date):Boolean
		{
			if(startDt && endDt && startDt.time <= ClockManager.instance.nowDate.time && endDt.time > ClockManager.instance.nowDate.time)
			{
				return true; 
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获取相差多少秒， date2 - date1 
		 * @param date1
		 * @param date2
		 * @param isChangeToZero
		 * @return 
		 * 
		 */		
		public static function getSecondsDis(date1:Date, date2:Date, isChangeToZero:Boolean=false):int
		{
			var res:int = (date2.time - date1.time)/1000;
			if(isChangeToZero && res < 0)
			{
				res = 0;
			}
			return res;
		}
	}
}