/**
 * 2014-1-22
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.render
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapLeftTipsItem extends GSprite
	{
		public function SmallMapLeftTipsItem()
		{
			super();
		}
		
		private var _icon:GBitmap;
		private var _txt:GTextFiled;
		
		public function updateData(obj:Object):void
		{
			var url:String = obj["icon"];
			var name:String = obj["name"];
			_icon.bitmapData = GlobalClass.getBitmapData(url);
			_txt.text = name;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_icon = UIFactory.gBitmap("", 0, 0, this);
			_txt = UIFactory.gTextField("", 22, 0, 160, 20, this);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_icon.dispose(isReuse);
			_txt.dispose(isReuse);
			
			_icon = null;
			_txt = null;
		}
	}
}