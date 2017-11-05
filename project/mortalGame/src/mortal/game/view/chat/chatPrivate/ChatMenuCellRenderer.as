/**
 * @heartspeak
 * 2014-3-20 
 */   	

package mortal.game.view.chat.chatPrivate
{
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class ChatMenuCellRenderer extends GCellRenderer
	{
		private var _text:GTextFiled;
		private var _closeBtn:GLoadedButton;
		private var _chatWindowMsg:ChatWindowMsg;
		private static var _overBmpd:BitmapData;
		
		public function ChatMenuCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_text = UIFactory.gTextField("生命在于折腾吖",12,0,110,20,this,GlobalStyle.textFormatAnjin);
			_closeBtn = UIFactory.gLoadedButton(ImagesConst.CloseBtn2_upSkin,120,2,16,16,this);
			_closeBtn.configEventListener(MouseEvent.CLICK,onClickCloseBtn);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_text.dispose(isReuse);
			_closeBtn.dispose(isReuse);
			_text = null;
			_closeBtn = null;
			
			_chatWindowMsg = null;
		}
		
		override protected function initSkin():void
		{
			super.initSkin();
			if(!_overBmpd)
			{
				_overBmpd = new BitmapData(140,22,true,0X00FFFFFF);
			}
			var across:Bitmap = ResourceConst.getScaleBitmap(ImagesConst.Menu2_overSkin);
			across.width = 120;
			_overBmpd.draw(across,new Matrix(1,0,0,1,10,0));
			this.setStyle("overSkin",new Bitmap(_overBmpd));
		}
		
		/**
		 * 点击关闭按钮 
		 * @param e
		 * 
		 */
		protected function onClickCloseBtn(e:MouseEvent):void
		{
			if(_chatWindowMsg)
			{
				ChatManager.removeChatWindowByMsg(_chatWindowMsg);
				e.stopPropagation();
			}
		}
		
		override public function set data(arg0:Object):void
		{
			var chatWindowMsg:ChatWindowMsg = arg0 as ChatWindowMsg;
			_text.htmlText = chatWindowMsg.getHtml();
			_chatWindowMsg = chatWindowMsg;
		}
		
		override public function set label(arg0:String):void
		{
			
		}
	}
}