package extend.language
{
	import com.gengine.utils.StringHelper;
	import com.mui.serialization.json.JSON;

	/**
	 * 支持四中格式：
	 * 1、纯字符串
	 * 2、正则替换 格式 你好{0},{1}晚安
	 * 3、数组：name:xxxxx,name:yyyyyy
	 * 4、JSON:\[\{name:"xxxx",value:"xxxx"\}\] 
	 * @author jianglang
	 * 
	 */
	public class Language
	{
		
		public function Language()
		{
			
		}
		/**
		 * 根据code 获取 字符串 
		 * @param code
		 * @return 
		 * 
		 */		
		public static function getString( code:int ):String
		{
			return LanguageConfig.instance.getString(code);
		}
		
		/**
		 * 根据 code 编号 获取数组
		 * {name:"",value:""}
		 * @param code
		 * @return 
		 * 
		 */		
		public static function getArray( code:int ,value:String="label"):Array
		{
			var str:String = LanguageConfig.instance.getString( code );
			var ary:Array = str.split(",");
			var temAry:Array;
			var retAry:Array = [];
			var o:Object;
			for( var i:int=0 ; i < ary.length; i++ )
			{
				temAry = String(ary[i]).split("|");	
				o = { "name":temAry[0] };
				o[value] = temAry[1];
				retAry.push(o);
			}
			return retAry;
		}
		
		/**
		 * 支持JSON格式 
		 * @param code
		 * @return 
		 * 
		 */		
		public static function getJSON( code:int ):Object
		{
			var str:String = LanguageConfig.instance.getString( code );
			return com.mui.serialization.json.JSON.deserialize(str);
		}
		
		/**
		 * 根据{1}替换字符串参数 
		 * @param code
		 * @param rest
		 * 
		 */		
		public static function getStringByParam( code:int , ... rest ):String
		{
			var str:String = LanguageConfig.instance.getString( code );			
			return StringHelper.substitute( str , rest);
		}
		
		public static function getArrayByStr( code:int ):Array
		{
			var str:String = LanguageConfig.instance.getString( code );
			return str.split(",");
		}
	}
}