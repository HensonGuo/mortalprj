/**
 * @heartspeak
 * 2014-4-24 
 */   	
package mortal.game.view.systemSetting.view
{
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.keyBoard.KeyCode;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	
	import extend.language.Language;
	
	import fl.controls.TextInput;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import mortal.common.global.GlobalStyle;
	import mortal.common.shortcutsKey.KeyMapData;
	import mortal.common.shortcutsKey.ShortcutsKey;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class ShortcutItemRenderer extends GCellRenderer
	{
		private static var NoDefaultStr:String = "未设置";//"未设置";
		//view
		private var _nameTxt:GTextFiled;
		private var _btn:GButton;
		private var _inputTxt:GTextInput;
		//data
		private var _keyMapData:KeyMapData;
		
		public function ShortcutItemRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_nameTxt = UIFactory.textField("",20,4,100,29,this,GlobalStyle.textFormatPutong);
			_btn = UIFactory.gButton("",120,4,65,22,this,"GroupButton");
			_btn.configEventListener(MouseEvent.CLICK, onBtnClickHandler);
			_btn.doubleClickEnabled = false;
			_btn.focusEnabled = false;
			_btn.mouseEnabled = true;
			_btn.mouseChildren = false;
			_inputTxt = UIFactory.gTextInput(120,4,65,22,this);
			setInputVisible(false);
			_inputTxt.textField.addEventListener(FocusEvent.FOCUS_OUT, onInputFocusOutHandler);
			_inputTxt.textField.addEventListener(FocusEvent.FOCUS_IN,onInputfocusInHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_keyMapData = null;
			setInputVisible(false);
			_nameTxt.dispose(isReuse);
			_btn.dispose(isReuse);
			_btn.mouseChildren = true;
			_btn.doubleClickEnabled = true;
			_inputTxt.dispose(isReuse);
			_inputTxt.textField.removeEventListener(FocusEvent.FOCUS_OUT, onInputFocusOutHandler);
			_inputTxt.textField.removeEventListener(FocusEvent.FOCUS_IN,onInputfocusInHandler);
		}
		
		override public function set data(arg0:Object):void
		{
			super.data = arg0;
			_keyMapData = arg0 as KeyMapData;
			if(_keyMapData)
			{
				_nameTxt.text = _keyMapData.keyMapName;
				if( _keyMapData.keyData )
				{
					setButtonLabel(_keyMapData.tempName);
				}
				else
				{
					setButtonLabel();
				}
				_btn.enabled = _keyMapData.isCanEdit;
				_btn.drawNow();
			}
			else
			{
				_nameTxt.text = "";
				setButtonLabel();
				_keyMapData.tempName = "";
				_btn.enabled = true;
			}
		}
		
		private var _clickNum:Number = 0
		private function onBtnClickHandler(e:MouseEvent):void
		{
			if( _clickNum < 1  )
			{
				setTimeout(setShortcutData,200);
			}
			_clickNum++;
		}
		
		private function setShortcutData():void
		{
			if( _clickNum <= 1  )
			{
				setInputVisible(true);
			}
			else
			{
				if( _keyMapData.keyData )
				{
					_keyMapData.tempName = _keyMapData.keyData.shortcutsName;
				}
				data = _keyMapData;
			}
			_clickNum = 0;
		}
		
		private function onInputFocusOutHandler(e:FocusEvent):void
		{
			setInputVisible(false);
		}
		
		private function onInputfocusInHandler(e:FocusEvent):void
		{
			KeyBoardManager.instance.changeImeEnable(false);
		}
		
		private function setInputVisible( value:Boolean ):void
		{
			_inputTxt.visible = value;
			_btn.visible = !value;
			if( value )
			{
				this.stage.focus = _inputTxt.textField;
				_inputTxt.textField.text = _btn.label;
				this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
				this.addEventListener(KeyboardEvent.KEY_UP,onKeyDownHandler);
				_inputTxt.textField.addEventListener(TextEvent.TEXT_INPUT,onTextInputHandler);
			}
			else
			{
				if(_inputTxt.text != "")
				{
					setButtonLabel(_inputTxt.text);
				}
				else
				{
					setButtonLabel();
				}
				this.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
				this.removeEventListener(KeyboardEvent.KEY_UP,onKeyDownHandler);
				_inputTxt.textField.removeEventListener(TextEvent.TEXT_INPUT,onTextInputHandler);
			}
		}
		
		private function onTextInputHandler(e:TextEvent):void
		{
			e.preventDefault();
			e.stopImmediatePropagation();
		}
		
		private var _tempKeyCode:int = 0;
		private function onKeyDownHandler(event:KeyboardEvent):void
		{
			if( event.type == KeyboardEvent.KEY_DOWN )
			{
				if( _tempKeyCode == event.keyCode) return;
				
				_tempKeyCode = event.keyCode;
				if( event.keyCode == KeyCode.BackSpace )
				{
					setInputTextTxt("");
					if( _keyMapData )
					{
						_keyMapData.displayKeyData.keyCode = 0;
						_keyMapData.displayKeyData.isShift = false;
					}
				}
				else if( ShortcutsKey.instance.hasKeyCode(event.keyCode) )
				{
					if( KeyBoardManager.ShiftKey )
					{
						setInputTextTxt("sht+" + KeyCode.getKeyName(event.keyCode) ); 
						setInputVisible(false);
					}
					else
					{
						setInputTextTxt( KeyCode.getKeyName(event.keyCode) );
						setInputVisible(false);
					}
					var mapdata:KeyMapData = ShortcutsKey.instance.getKeyMapData(event.keyCode, KeyBoardManager.ShiftKey);
					if(mapdata &&  mapdata != _keyMapData )
					{
						mapdata.tempName = NoDefaultStr;
						mapdata.displayKeyData.keyCode = 0;
						mapdata.displayKeyData.isShift = false;
						//SelectableList(this.listData.owner).invalidateItem(mapdata);
						Dispatcher.dispatchEvent(new DataEvent( EventName.ShortcutsUpdate,mapdata));
						MsgManager.showRollTipsMsg(mapdata.keyMapName + "快捷键清除");//"快捷键清除"
					}
					if( _keyMapData )
					{
						_keyMapData.displayKeyData.isShift = KeyBoardManager.ShiftKey;
						_keyMapData.displayKeyData.keyCode = event.keyCode;
					}
				}
				else
				{
					if( event.keyCode != KeyCode.SHIFT )
					{
						MsgManager.showRollTipsMsg("不能使用的快捷键");//"不能使用的快捷键"
					}
				}
			}
			else
			{
				_tempKeyCode = 0;
			}
		}
		
		private function setInputTextTxt( value:String ):void
		{
			_inputTxt.textField.text = value;
			_inputTxt.textField.setSelection(0,value.length-1);
		}
		
		private function setButtonLabel(value:String = ""):void
		{
			if( value == null || value == "" )
			{
				value = NoDefaultStr;
			}
			_btn.label = value;
			_btn.drawNow();
			if( _keyMapData )
			{
				_keyMapData.tempName = value;
			}
		}
	}
}