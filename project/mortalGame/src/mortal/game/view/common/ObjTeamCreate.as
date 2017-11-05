/**
 * author hexiaoming
 * 创建一些常用组合对象 
 */
package mortal.game.view.common
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.containers.GBox;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.view.common.item.TitleItem;

	public class ObjTeamCreate
	{
		/**
		 * 给一个textField 设定一个键值显示，键和值不同颜色 
		 * @param tf
		 * @param key
		 * @param value
		 * @param colorKey
		 * @param colorValue
		 * 
		 */		
		public static function setTextFieldKeyValue(tf:TextField,key:String,value:String = "",colorKey:String = "",colorValue:String = ""):void
		{
			if(!colorKey)
			{
				colorKey = GlobalStyle.colorPutong;
			}
			if(!colorValue)
			{
				colorValue = GlobalStyle.colorAnjin;
			}
			tf.htmlText = HTMLUtil.addColor(key,colorKey) + HTMLUtil.addColor(value,colorValue);
		}
		
		/**
		 * 创建一个标题列表
		 * @param vcTitleItem
		 * @param textFormat
		 * @return 
		 * 
		 */		
		public static function createTitles(vcTitleItem:Vector.<TitleItem>,textFormat:TextFormat = null):GBox
		{
			if(!textFormat)
			{
				textFormat = new GTextFormat(FontUtil.songtiName,12,GlobalStyle.colorAnjinUint);
				textFormat.align = TextAlign.CENTER;
			}
			var boxTitle:GBox = new GBox();
			for(var i:int = 0;i < vcTitleItem.length;i++)
			{
				UIFactory.textField(vcTitleItem[i].titleName,0,0,vcTitleItem[i].width,20,boxTitle,textFormat);
			}
			return boxTitle;
		}
	}
}