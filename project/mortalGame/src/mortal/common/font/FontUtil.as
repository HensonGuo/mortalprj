package mortal.common.font
{
	import mortal.common.global.ParamsConst;
	import mortal.common.global.ProxyType;
	
	public class FontUtil
	{
		//普通字体   默认字体  Times New Roman  宋体 华文行楷  stxingkai 隶书
		public static var defaultFont:FontName;
		public static var songtiFont:FontName;
		public static var xingkaiFont:FontName;
		public static var stXingkaiFont:FontName;
		public static var lishuFont:FontName;
		
		//嵌入字体
		public static const EmbedNumberName:String = "number";
		public static const EmbedSkillName:String = "skillName";
		public static const EmbedTitleName:String = "title";
		public static const EmbedBaseName:String = "base";
		
		public function FontUtil()
		{
			
		}
		
		public static function init():void
		{
			switch(ParamsConst.instance.proxyType)
			{
				case ProxyType.Vietnam:
					defaultFont = new SmallSizeFontName("Courier new");
					songtiFont = new SmallSizeFontName("Courier new");
					xingkaiFont = new SmallSizeFontName("Courier new");
					stXingkaiFont = new SmallSizeFontName("Courier new");
					lishuFont = new SmallSizeFontName("Courier new");
					break;
				case ProxyType.TW:
					defaultFont = new FontName("Times New Roman");
					songtiFont = new FontName("宋体");
					xingkaiFont = new FontName("宋体");
					stXingkaiFont = new FontName("STXingkai");
					lishuFont = new FontName("宋体");
					break;
				default:
					defaultFont = new FontName("微软雅黑,Microsoft YaHei,Times New Roman");
					songtiFont = new FontName("宋体");
					xingkaiFont = new FontName("STXingkai");
					stXingkaiFont = new FontName("STXingkai");
					lishuFont = new FontName("隶书");
					break;
				}
			}
					
		/**
		 * 默认 
		 * @return 
		 * 
		 */		
		public static function get defaultName():String
		{
			return defaultFont.fontName;
		}
		
		/**
		 * 宋体 
		 * @return 
		 * 
		 */		
		public static function get songtiName():String
		{
			return songtiFont.fontName;
		}
		
		/**
		 * 华文行楷 
		 * @return 
		 * 
		 */		
		public static function get xingkaiName():String
		{
			return xingkaiFont.fontName;
		}
		
		/**
		 * stXingkai 
		 * @return 
		 * 
		 */		
		public static function get stXingkaiName():String
		{
			return stXingkaiFont.fontName;
		}
		
		/**
		 * 隶书 
		 * @return
		 * 
		 */		
		public static function get lishuName():String
		{
			return lishuFont.fontName;
		}
	}
}