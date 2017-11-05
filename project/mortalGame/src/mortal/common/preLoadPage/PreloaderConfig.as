/**
 * @date	2011-4-11 下午08:00:35
 * @author  cjx
 * 
 */	

package mortal.common.preLoadPage
{
	import extend.language.PreLanguage;

	public class PreloaderConfig
	{
		/**
		 * 需要预加载的资源 
		 */
		private static var _preResUrl:Array;
		private static var _preResName:Array;
		
		public static const LOGIN_GAME:int = 0;
		public static const LOAD_CREATE_ROLE:int = 1;
		public static const LOAD_MAIN_GAME:int = 2;
		public static const LOAD_CONFIG:int = 3;
		public static const LOAD_RESCOUSE:int = 4;
		
		//value必须从0开始，从小到大，且在0到100之间。
		public static var config:Array = 
			[
				{baseValue:0,length:5,text:PreLanguage.getString(102)},
				{baseValue:5,length:10,text:PreLanguage.getString(103)},
				{baseValue:15, length:45,text:PreLanguage.getString(104)},
				{baseValue:60,length:20,text:PreLanguage.getString(105)},
				{baseValue:80,length:20,text:PreLanguage.getString(106)}
			];
		
		/**
		 * 设置预加载的资源 
		 * @param value
		 * 
		 */
		public static function set preResUrl(value:Array):void
		{
			_preResUrl = value;
			
			if(!_preResName)
			{
				_preResName = [];
			}
			else
			{
				_preResName.splice(0);
			}
			
			var resUrl:String;
			var resName:String;
			for(var i:int = 0; i< _preResUrl.length; i++)
			{
				resUrl = _preResUrl[i];
				resName = resUrl.substr(resUrl.lastIndexOf("/") + 1);
				_preResName.push(resName);
			}
		}
		
		public static function get preResUrl():Array
		{
			return _preResUrl;
		}
		
		public static function get preResName():Array
		{
			return _preResName;
		}
		
		public function PreloaderConfig()
		{
		}
	}
}