/**
 * 2014-2-17
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.render
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.resource.info.SWFInfo;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.LoaderHelp;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapWorldRegionData;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapWorldRegionItem extends GSprite
	{
		public function SmallMapWorldRegionItem()
		{
			super();
			
			this.mouseChildren = true;
			this.mouseEnabled = true;
			this.buttonMode = true;
		}
		
		private var _sp:GSprite;
		private var _bm:GBitmap;
		private var _data:SmallMapWorldRegionData;
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bm = UIFactory.gBitmap("", 0, 0, this);
			
			this.configEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.configEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.configEventListener(MouseEvent.CLICK, clickMeHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			if(_sp != null)
			{
				_sp.dispose(isReuse);
				_sp = null;
			}
		}
		
		public function update(data:SmallMapWorldRegionData):void
		{
			_data = data;
			LoaderManager.instance.load(data.value + ".swf", resGotHandler);
//			LoaderHelp.addResCallBack(data.value + ".swf", resGotHandler);
			this.x = data.x;
			this.y = data.y;
		}
		
		private function resGotHandler(info:SWFInfo):void
		{
			DisplayUtil.removeMe(_sp);
			_sp = DisplayUtil.getNoneTransparentSprite(info.bitmapData);
			this.addChild(_sp);
			
//			_bm.bitmapData = info.bitmapData;
		}
		
		private function mouseOverHandler(evt:MouseEvent):void
		{
			if(_sp)
			{
				_sp.filters = [FilterConst.colorGlowFilter(0xffff00)];
			}
		}
		
		private function mouseOutHandler(evt:MouseEvent):void
		{
			if(_sp)
			{
				_sp.filters = [];
			}
		}
		
		private function clickMeHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapClickWorldRegion, _data));
		}
	}
}