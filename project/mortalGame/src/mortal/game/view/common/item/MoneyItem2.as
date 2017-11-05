/**
 * @date 2012-7-17 下午04:12:33
 * @author cjx
 */
package mortal.game.view.common.item
{
	import com.mui.core.GlobalClass;
	
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;

	public class MoneyItem2 extends MoneyItem
	{
		public function MoneyItem2()
		{
			UIFactory.bg(26,0,105,20,this,ImagesConst.DisabledBg);
			
			super();
			
			_bmpType.x = 0;
			_tfNum.x = 26;
			_tfNum.width = 105;
			_tfNum.defaultTextFormat = new GTextFormat(FontUtil.songtiName,12,0xF1FFB1,null,null,null,null,null,TextFormatAlign.LEFT);
		}
		
	}
}