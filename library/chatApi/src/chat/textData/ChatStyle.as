/**
 * @date 2011-3-14 上午11:21:10
 * @author  hexiaoming
 * 
 */ 
package chat.textData
{
	import flash.text.TextFormat;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontMetrics;
	import flash.text.engine.FontWeight;
	import flash.text.engine.TextBaseline;
	
	public class ChatStyle
	{
		
		private static function createElementFormat():ElementFormat
		{
			var elementFormat:ElementFormat = new ElementFormat();
			elementFormat.fontSize = 12;
			return elementFormat;
			
		}
		
		/**
		 * 聊天类型样式 例如 世界 场景 国家
		 * @return 
		 * 
		 */	
		public static function getTitleFormat():ElementFormat
		{
			var titleFontDescription:FontDescription = new FontDescription();
			titleFontDescription.fontName = "宋体";
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.color = getTitleColor();
			elementFormat.baselineShift = 0;
			elementFormat.fontDescription = titleFontDescription;
			elementFormat.trackingRight = 1;
			return elementFormat;
		}
		
		/**
		 * 玩家名称样式 
		 * @return 
		 * 
		 */
		public static function getPlayerNameFormat(nameColor:int = 0x7cfdff):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = "宋体";
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.baselineShift = 0;
			elementFormat.color = nameColor;
			elementFormat.trackingLeft = 1;
			return elementFormat;
		}
		
		
		/**
		 * 聊天内容样式 
		 * @return 
		 * 
		 */
		public static function getContentFormat(contentColor:int = 0x82fbff):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = "宋体";
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.color = contentColor;
			elementFormat.trackingLeft = 2;

			return elementFormat;
		}
		
		public static function getTitleColor():int
		{
			return 0xf54a4a;
		}
		
		public static function getChatContentColor():int
		{
			return 0x7cfdff;
		}
	}
}