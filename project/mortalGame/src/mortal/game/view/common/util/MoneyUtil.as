/**
 * @date 2011-6-23 下午03:44:08
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.common.util
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	
	import extend.language.Language;
	
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.info.ColorInfo;

	public class MoneyUtil
	{
		public function MoneyUtil()
		{
		}
		
		/**
		 * 获取一个数字的字符串显示,每隔3位添加一个逗号 
		 * @param num
		 * @return 
		 * 
		 */	
		public static function getFormatInt(num:int):String
		{
			var str:String = num.toString();
			var formatStr:String = "";
			while(str.length > 3)
			{
				var strLastTree:String = str.slice(str.length - 3);
				str = str.slice(0,str.length - 3);
				formatStr = "," + strLastTree + formatStr;
			}
			if(str.length > 0)
			{
				formatStr = str + formatStr;
			}
			return formatStr;
		}
		
		public static function getCoinColor(num:int):ColorInfo
		{
			var colorInfo:ColorInfo = new ColorInfo();
			if(num < 1000)
			{
				colorInfo = ColorConfig.instance.getCoinColor(1);
			}
			else
			if(num < 10000)
			{
				colorInfo = ColorConfig.instance.getCoinColor(2);
			}
			else
			if(num < 1000000)
			{
				colorInfo = ColorConfig.instance.getCoinColor(3);
			}
			else
			{
				colorInfo = ColorConfig.instance.getCoinColor(4);
			}
			return colorInfo;
		}
		
		public static function getGoldColor(num:int):ColorInfo
		{
			var colorInfo:ColorInfo = new ColorInfo();
			if(num < 100)
			{
				colorInfo = ColorConfig.instance.getGoldColor(1);
			}
			else
			if(num < 1000)
			{
				colorInfo = ColorConfig.instance.getGoldColor(2);
			}
			else
			if(num < 10000)
			{
				colorInfo = ColorConfig.instance.getGoldColor(3);
			}
			else
			{
				colorInfo = ColorConfig.instance.getGoldColor(4);
			}
			return colorInfo;
		}
		
		public static function getGoldHtml(num:int):String
		{
			return "<font face='宋体' color='" + getGoldColor(num).color + "'>" + getFormatInt(num) + "</font>";
		}
		
		public static function getCoinHtml(num:int):String
		{
			return "<font face='宋体' color='" + getCoinColor(num).color + "'>" + getFormatInt(num) + "</font>";
		}
		
		public static function getMoneyName(priceUint:int):String
		{
			var moneyName:String = "";
			switch(priceUint)
			{
				case EPrictUnit._EPriceUnitCoin:
					moneyName = Language.getString(69906);
					break;
				case EPrictUnit._EPriceUnitGold:
					moneyName = Language.getString(69905);
					break;
				case EPrictUnit._EPriceUnitCoinBind:
					moneyName = Language.getString(69908);
					break;
				case EPrictUnit._EPriceUnitGoldBind:
					moneyName = Language.getString(69907);
					break;
			}
			return moneyName;
		}
	}
}