package mortal.game.view.market.buyAndQiugou
{
	import Message.DB.Tables.TMarket;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MktCatogeryRenderer extends GCellRenderer
	{
		private var _txtName:GTextFiled;
		private var _txtStatus:GTextFiled;
		private var _line:ScaleBitmap;
		
		public function MktCatogeryRenderer()
		{
			super();
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:Bitmap = new Bitmap();
			this.setStyle("downSkin", ResourceConst.getScaleBitmap(ImagesConst.taskItemSelected));
			this.setStyle("overSkin", ResourceConst.getScaleBitmap(ImagesConst.taskItemSelected));
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin", ResourceConst.getScaleBitmap(ImagesConst.taskItemSelected));
			this.setStyle("selectedOverSkin", ResourceConst.getScaleBitmap(ImagesConst.taskItemSelected));
			this.setStyle("selectedUpSkin", ResourceConst.getScaleBitmap(ImagesConst.taskItemSelected));
		}
		
		public override function set data(value:Object):void
		{
			super.data = value;
			///_taskInfo = value as TaskInfo;
			_txtName.text = value.label;
			//_txtStatus.htmlText = tmarket.name2;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			_txtName = UIFactory.gTextField("", 12, 1, 160, 20, this,tf);
			tf.align = TextFormatAlign.RIGHT;
			_txtStatus = UIFactory.gTextField("", 12, 1, 165, 20, this, tf);
			_line = UIFactory.bg(0, 20, 180, 1, this, ImagesConst.SplitLine); 
			
			this.configEventListener(MouseEvent.CLICK, clickMeHandler);
		}
		
		private function clickMeHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketClickType, data));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txtName.dispose(isReuse);
			_txtName = null;
			_line.dispose(isReuse);
			_line = null;
			_txtStatus.dispose(isReuse);
			_txtStatus = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}