/**
 * @heartspeak
 * 2014-4-17 
 */   	

package mortal.game.view.chat.chatPanel
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.global.GlobalStyle;
	import mortal.common.tools.DateParser;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;

	public class HistoryMsg extends GSprite
	{
		protected var _bg:ScaleBitmap;
		protected var _titleTextField:GTextFiled;
		protected var _contentTextField:GTextFiled;
		
		public function HistoryMsg()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.bg(5,2,40,16,this,ImagesConst.ChatNotesBg);
			_titleTextField = UIFactory.gTextField("",10,0,40,18,this);
			_contentTextField = UIFactory.gTextField("",46,0,250,-1,this,GlobalStyle.textFormatPutong.setLeading(2));
			_contentTextField.wordWrap = true;
			_contentTextField.multiline = true;
			_contentTextField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_titleTextField.dispose(isReuse);
			_contentTextField.dispose(isReuse);
			_bg.dispose(isReuse);
			super.disposeImpl(isReuse);
		}
		
		public function updateValue(str:String,historyMsg:MsgTypeImpl):void
		{
			_titleTextField.htmlText = HTMLUtil.addColor(historyMsg.name,historyMsg.color);
			var dateStr:String = HTMLUtil.addColor("[" + DateParser.parse(ClockManager.instance.nowDate,"hh：mm：ss") + "]","#ffff00");
			_contentTextField.htmlText = dateStr + str;
		}
		
		override public function get height():Number
		{
			return _contentTextField.textHeight;
		}
	}
}