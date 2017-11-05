/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.view.task.view.track
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GButton;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import extend.language.Language;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.common.UIFactory;
	
	public class BtnViewTaskModule extends Sprite implements IToolTipItem
	{
		private var _btn:GButton;
		private var _textFiled:TextField;
		
		private var _downColor:String = "#B1EFFC";
		private var _upColor:String = "#B1EFFC";
		private var _down:Boolean;
		
		private var _width:int;
		private var _height:int;
		
		private var _textLeft:int = -2;
		private var _textTop:int = -2;
		
		public function BtnViewTaskModule()
		{
			super();
		
			mouseEnabled = false;
			initUI();
			
			toolTipData = HTMLUtil.addColor(Language.getString(20140) + HTMLUtil.addColor("（Q）","#00ff00") ,"#ffffff");//查看全部任务
		}
		
		/**
		 * 鼠标按下 
		 * @param event
		 * 
		 */
		private function onBtnMouseDownHandler(event:MouseEvent):void
		{
			_down = true;
			
			updateText();
		}
		
		/**
		 * 鼠标弹起 
		 * @param event
		 * 
		 */
		private function onBtnMouseUPHandler(event:MouseEvent):void
		{
			_down = false;
			
			updateText();
		}
		
		/**
		 * 初始化 
		 * 
		 */
		private function initUI():void
		{
			_btn = UIFactory.gButton("");
			_btn.styleName = "Button";
			_btn.addEventListener(MouseEvent.MOUSE_DOWN,onBtnMouseDownHandler);
			_btn.addEventListener(MouseEvent.MOUSE_UP,onBtnMouseUPHandler);
			addChild(_btn);
		
			_textFiled = new TextField();
			_textFiled.mouseEnabled = false;
			_textFiled.autoSize = TextFieldAutoSize.CENTER;
			_textFiled.width = 30;
			_textFiled.filters = [FilterConst.nameGlowFilter];
			addChild(_textFiled);
		}
		
		/**
		 * 更新按钮文字 
		 * 
		 */
		private function updateText():void
		{
			if(_down)
			{
				_textFiled.htmlText = HTMLUtil.addColor(_textFiled.text,_downColor);
			}
			else
			{
				_textFiled.htmlText = HTMLUtil.addColor(_textFiled.text,_upColor);
			}
			
			_textFiled.x = _textLeft + (_width - _textFiled.textWidth)/2;
			_textFiled.y = _textTop + (_height - _textFiled.textHeight)/2;
		}
		
		public function set label(text:String):void
		{
			_textFiled.text = text;
			
			updateText();
		}
		
		public function setSize(w:int,h:int):void
		{
			_width = w;
			_height = h;
			_btn.setSize(w,h);
			
			updateText();
		}
		
		public function setTextPading(left:int,top:int):void
		{
			_textLeft = left;
			_textTop = top;
		
			updateText();
		}
		
		public function get toolTipData():*
		{
			return _tooltipData;
		}
		
		private var _tooltipData:*;
		
		public function set toolTipData(value:*):void
		{
			if(value == null || value==""){
				ToolTipsManager.unregister(this);
			}else{
				ToolTipsManager.register(this);
			}
			_tooltipData = value;
		}
	}
}