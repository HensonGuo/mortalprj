package mortal.game.view.common.display
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.events.DataEvent;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class TextInputListRenderer extends GCellRenderer
	{
		private var _text:GTextFiled;
		private var _line:ScaleBitmap;
		
		public function TextInputListRenderer()
		{
			super();
			
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_text = UIFactory.gTextField("",5,0,120,20,this);
			_line = UIFactory.bg(0,20,120,1,this,ImagesConst.SplitLine);
			
//			this.configEventListener(MouseEvent.CLICK,clickHanlder);
			var across:Bitmap = ResourceConst.getScaleBitmap(ImagesConst.Menu_overSkin);
			this.setStyle("overSkin", across);
		}
		
//		private function clickHanlder(e:MouseEvent):void
//		{
//			// TODO Auto Generated method stub
//			dispatchEvent(new DataEvent(Event.SELECT,data));
//		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_text.dispose(isReuse);
			_line.dispose(isReuse);
			
			_text = null;
			_line = null;
		}
		
		override public function set data(arg0:Object):void
		{
			super.data = arg0;
			if(arg0!=null)
			{
				_data = arg0 as ItemInfo;
				_text.text = _data.name;
			}
			else
			{
				_text.text = "";
			}
		}
		
		
	}
}