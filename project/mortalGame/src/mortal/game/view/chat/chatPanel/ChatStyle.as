/**
 * @date 2011-3-14 上午11:21:10
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatPanel
{
	import Message.Game.SPet;
	
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.ColorInfo;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.chat.chatViewData.ChatType;

	public class ChatStyle
	{
		
		private static function createElementFormat():ElementFormat
		{
			var elementFormat:ElementFormat = new ElementFormat();
//			elementFormat.alignmentBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
//			elementFormat.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
			return elementFormat;
			
		}
		
		/**
		 * 聊天类型样式 例如 世界 场景 国家
		 * @return 
		 * 
		 */	
		public static function getTitleFormat(type:String):ElementFormat
		{
			var titleFontDescription:FontDescription = new FontDescription();
//			titleFontDescription.fontWeight = FontWeight.BOLD;
			titleFontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.color = getTitleColor(type);
			elementFormat.baselineShift = 0;
			elementFormat.fontDescription = titleFontDescription;
			elementFormat.trackingRight = 1;
//			elementFormat.trackingLeft = 1;
			return elementFormat;
		}
		
		/**
		 * 阵容样式 
		 * @return 
		 * 
		 */		
		public static function getCampFormat(type:int,fontSize:int = 12):ElementFormat
		{
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.color = getCampColor(type);
			var titleFontDescription:FontDescription = new FontDescription();
			titleFontDescription.fontName = FontUtil.defaultName;
			elementFormat.baselineShift = 0;
			elementFormat.fontDescription = titleFontDescription;
			elementFormat.trackingLeft = 1;	
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		/**
		 * 玩家名称样式 
		 * @return 
		 * 
		 */
		public static function getPlayerNameFormat(nameColor:int = 0x7cfdff,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.baselineShift = 0;
			elementFormat.color = nameColor;
			elementFormat.trackingLeft = 1;	
			elementFormat.fontSize = fontSize;
//			fontMetrics.underlineThickness = 10;
			return elementFormat;
		}
		
		/**
		 * 玩家名称样式 
		 * @return 
		 * 
		 */
		public static function getRumorPlayerNameFormat(nameColor:int = 0x7cfdff,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.baselineShift = 5;
			elementFormat.color = nameColor;
			elementFormat.trackingLeft = 1;
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		/**
		 * 表情样式 
		 * @return 
		 * 
		 */
		public static function getFaceFormat(fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 7;
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		/**
		 * VIP表情样式 
		 * @return 
		 * 
		 */
		public static function getVIPFaceFormat(fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 2;
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		/**
		 * 链接样式 
		 * @return 
		 * 
		 */
		public static function getLinkFormat(fontSize:int=12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.fontDescription = fontDescription;
			elementFormat.color = 0xff0000;
			elementFormat.baselineShift = 5;
			elementFormat.trackingLeft = 1;	
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		public static function getRumorLink(fontSize:int=12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.fontDescription = fontDescription;
			elementFormat.color = ColorConfig.instance.getRumorColor(2).intColor;
			elementFormat.baselineShift = 5;
			elementFormat.trackingLeft = 1;
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		public static function getImageFormat(baselineShift:int = 2,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = baselineShift;
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		/**
		 * 装备样式
		 * @return 
		 * 
		 */		
		public static function getRumorEquipmentFormat(itemData:ItemData,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 5;
			elementFormat.fontSize = fontSize;
			if(itemData.itemInfo)
			{
				var colorInfo:ColorInfo = ColorConfig.instance.getItemColor(itemData.itemInfo.color);
				if(colorInfo)
				{
					elementFormat.color = colorInfo.intColor;
				}
			}
			
			elementFormat.trackingLeft = 1;
			return elementFormat;
		}
		
		/**
		 * 传说装备样式
		 * @return 
		 * 
		 */		
		public static function getEquipmentFormat(itemData:ItemData,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.color = ColorConfig.instance.getItemColor(itemData.itemInfo.color).intColor;
			elementFormat.trackingLeft = 1;		
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		/**
		 * 宠物样式
		 * @return 
		 * 
		 */		
		public static function getPetFormat(petInfo:SPet,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.color = PetUtil.getTalentColor(petInfo.publicPet.talent).intColor;
			elementFormat.trackingLeft = 1;			
			elementFormat.fontSize = fontSize;
			return elementFormat;
		}
		
		
		/**
		 * GM样式 
		 * @return 
		 * 
		 */
		public static function getGMFormat(fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.color = GlobalStyle.colorChenUint;
			elementFormat.trackingLeft = 2;
			elementFormat.fontSize = fontSize;
			
			return elementFormat;
		}
		
		/**
		 * 新手指导员样式 
		 * @return 
		 * 
		 */
		public static function getGuideFormat():ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.color = GlobalStyle.colorChenUint;
			elementFormat.trackingLeft = 2;
			
			return elementFormat;
		}
		
		/**
		 * 聊天内容样式 
		 * @return 
		 * 
		 */
		public static function getContentFormat(contentColor:int = 0x82fbff,fontSize:int = 12):ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ANY;
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.fontSize = fontSize;
			elementFormat.color = contentColor;
			elementFormat.trackingLeft = 2;

			return elementFormat;
		}
		
		/**
		 * 聊天内容换行 
		 * @return 
		 * 
		 */
		public static function getBRFormat():ElementFormat
		{
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontName = FontUtil.defaultName;
			var elementFormat:ElementFormat = createElementFormat();
			elementFormat.breakOpportunity = BreakOpportunity.ALL;
			elementFormat.fontDescription = fontDescription;
			elementFormat.baselineShift = 0;
			elementFormat.trackingLeft = 2;
			
			return elementFormat;
		}
		
		public static function getDiceColor():int
		{
			return ColorConfig.instance.getChatColor("System").intColor;
		}
		
		public static function getTitleImageName(type:String):String
		{
			switch(type)
			{
				case ChatType.System:
					return ImagesConst.ChatSystem;
					break;
				case ChatType.Tips:
					return ImagesConst.ChatTips;
					break;
				case ChatType.Legent:
					return ImagesConst.ChatRumor;
					break;
				case ChatType.Battlefield:
					return ImagesConst.ChatWorld;
					break;
				case ChatType.World:
					return ImagesConst.ChatWorld;
					break;
				case ChatType.Scene:
					return ImagesConst.ChatScene;
					break;
				case ChatType.State:
					return ImagesConst.ChatCamp;
					break;
				case ChatType.Union:
					return ImagesConst.ChatGuild;
					break;
				case ChatType.Team:
				case ChatType.CrossGroup:
					return ImagesConst.ChatGroup;
					break;
				case ChatType.Speaker:
					return ImagesConst.ChatSpeaker;
					break;
				case ChatType.Force:
					return ImagesConst.ChatWorld;
					break;
				case ChatType.CrossServer:
					return ImagesConst.ChatWorld;
					break;
				case ChatType.GuildUnion:
					return ImagesConst.ChatGuild;
					break;
				case ChatType.Market:
					return ImagesConst.ChatMarket;
					break;
				case ChatType.Copy:
					return ImagesConst.ChatCopy;
					break;
			}
			return ImagesConst.ChatWorld
		}
		
		public static function getTitleColor(type:String):int
		{
			var color:int =  0xf54a4a;
			var colorInfo:ColorInfo;
			switch(type)
			{
				case ChatType.System:
					colorInfo = ColorConfig.instance.getChatColor("System");
					break;
				case ChatType.Tips:
					colorInfo = ColorConfig.instance.getChatColor("Tips");
					break;
				case ChatType.Legent:
					colorInfo = ColorConfig.instance.getChatColor("Legent");
					break;
				case ChatType.Battlefield:
					colorInfo = ColorConfig.instance.getChatColor("Battlefield");
					break;
				case ChatType.World:
					colorInfo = ColorConfig.instance.getChatColor("World");
					break;
				case ChatType.Scene:
					colorInfo = ColorConfig.instance.getChatColor("Scene");
					break;
				case ChatType.State:
					colorInfo = ColorConfig.instance.getChatColor("State");
					break;
				case ChatType.Union:
					colorInfo = ColorConfig.instance.getChatColor("Union");
					break;
				case ChatType.Team:
				case ChatType.CrossGroup:
					colorInfo = ColorConfig.instance.getChatColor("Team");
					break;
				case ChatType.Speaker:
					colorInfo = ColorConfig.instance.getChatColor("Speaker");
					break;
				case ChatType.Force:
					colorInfo = ColorConfig.instance.getChatColor("Force");
					break;
				case ChatType.CrossServer:
					colorInfo = ColorConfig.instance.getChatColor("CrossServer");
					break;
				case ChatType.GuildUnion:
					colorInfo = ColorConfig.instance.getChatColor("GuildUnion");
					break;
			}
			if(colorInfo)
			{
				color = colorInfo.intColor;
			}
			return color;
		}
		
		public static function getChatContentColor():int
		{
			var color:int = 0x7cfdff;
			var colorInfo:ColorInfo;
			colorInfo = ColorConfig.instance.getChatColor("ChatContent");
			if(colorInfo)
			{
				color = colorInfo.intColor;
			}
			return color;
		}
		
		public static function getCampColor(type:int):int
		{
			return ColorConfig.instance.getCountryColor(type).intColor;
		}
	}
}