package editor.ui.common
{
	import com.gengine.keyBoard.KeyCode;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.common.UIFactory;
	
	public class TextFieldInput extends GSprite
	{
		private var _textField:GTextFiled;
		private var _textInput:GTextInput;
		
		public function TextFieldInput()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_textField = UIFactory.gTextField("",0,0,100,20,this,GlobalStyle.textFormatChen);
			_textField.mouseEnabled = true;
			_textField.doubleClickEnabled = true;
			_textField.selectable = false;
			_textField.configEventListener(MouseEvent.DOUBLE_CLICK,onClickTextField);
			
			_textInput = UIFactory.gTextInput(0,0,100,20,this);
			_textInput.visible = false;
			_textInput.configEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,9999);
			_textInput.configEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_textField.dispose(isReuse);
			_textInput.dispose(isReuse);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == KeyCode.ENTER)
			{
				updateText();
			}
		}
		
		private function onFocusOut(e:Event):void
		{
			updateText();
		}
		
		private function updateText():void
		{
			_textField.visible = true;
			_textInput.visible = false;
			_textField.text = _textInput.text;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onClickTextField(e:MouseEvent):void
		{
			_textField.visible = false;
			_textInput.visible = true;
			_textInput.text = _textField.text;
			_textInput.setFocus();
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set text(value:String):void
		{
			_textField.text = value;
		}
		
		public override function setSize(width:Number,height:Number):void
		{
			super.setSize(width,height);
			_textField.width = width;
			_textField.height = height;
			
			_textInput.width = width;
			_textInput.height = height;
		}
	}
}