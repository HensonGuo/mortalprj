package com.gengine.keyBoard
{
	import com.gengine.global.Global;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import fl.controls.BaseButton;
	import fl.controls.TextInput;
	
	[Event(name="key_down", type="com.mgame.common.keyboard.KeyEvent")]
	[Event(name="key_up", type="com.mgame.common.keyboard.KeyEvent")]
	/**
	 *  键盘按键管理
	 * @author kbq
	 * 
	 */	
	public class KeyBoardManager extends EventDispatcher
	{
		private static var _keyMap:Object = {};
		
		private static var _instance:KeyBoardManager;
		
		private static var _stage:Stage;
		
		public static var ctrlKey:Boolean;
		
		public static var ShiftKey:Boolean;
		
		public function KeyBoardManager()
		{
			if(_instance != null) throw new Error("KeyBoardManager 不能实例化");
			_instance = this;
		}

		public static function get instance():KeyBoardManager
		{
			if(_instance == null)
			{
				_instance = new KeyBoardManager();
			}
			return _instance;
		}
		
		public function start():void
		{
			_stage = Global.stage;
			if( _stage )
			{
				addListener();
			}
		}
		
		public static function addkeys(value:Array):void
		{
			if(value == null || value.length ==0) return;
			if(value[0] as KeyData == null)
			{
				throw new Error("addkeys(value:Array) value中不是KeyData类型");
			}
			
			var len:int = value.length;
			var itemData:KeyData;
			for(var i:int=0;i<len;i++)
			{
				itemData = value[i] as KeyData;
				_keyMap[itemData.keyCode] = itemData;
			}
		}
		
		public static function createKeyData(value:uint,isShift:Boolean = false,isCtrlKey:Boolean=false):KeyData
		{
			var keyData:KeyData = getKeyData(value,isShift,isCtrlKey);
			if(keyData == null)
			{
				keyData = new KeyData(value,isShift,isCtrlKey);
				keyData.isKeyDown = false;
				_keyMap[keyData.key] = keyData;
			}
			return keyData;
		}
		
		public static function getKeyData( value:uint,isShift:Boolean = false,isCtrl:Boolean=false ):KeyData
		{
			if( isShift )
			{
				value += KeyCode.SHIFT_NUM;
			}else if(isCtrl)
			{
				value += KeyCode.CTRL;
			}
			return _keyMap[value];
		}
		
		public function cancelListener():void
		{
			if(_stage)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
				_stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler);
				_stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onMouseFocusChangeHandler);
			}
		}
		public function addListener():void
		{
			if(_stage)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler,false,9999,false);
				_stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUpHandler,false,9999,false);
				_stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,onMouseFocusChangeHandler,false,9999,false);
//				_stage.addEventListener(Event.MOUSE_LEAVE,onMouseLeaveHandler,false,9999,false);
				_stage.addEventListener(Event.ACTIVATE,onActivateHandler,false,9999,false);
			}
		}
		
		private function onActivateHandler(e:Event):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler,true,9999,false);
		}
		
		private function onMouseLeaveHandler( e:Event ):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler,true,9999,false);
		}
		
		private function onMouseFocusChangeHandler( event:FocusEvent ):void
		{
			if( event.relatedObject is TextField)
			{
				if( (event.relatedObject as TextField).type == TextFieldType.INPUT  )
				{
					changeImeEnable(true);
				}
			}
			else if( event.relatedObject is TextInput )
			{
				changeImeEnable(true);
			}
			else if( event.relatedObject is BaseButton )
			{
				_stage.focus = _stage;
				changeImeEnable(false);
			}
			else
			{
				ctrlKey == event.keyCode == KeyCode.CONTROL;
				ShiftKey == event.shiftKey;
				_stage.focus = _stage;
				changeImeEnable(false);
			}
		}
		
		public function changeImeEnable( enbled:Boolean ):void
		{
			if( enbled == IME.enabled ) return;
			if(Capabilities.hasIME)
			{
				try
				{
					IME.enabled = enbled;
				}
				catch(e:Error){};
			}
		}
		
		private function onMouseDownHandler(event:MouseEvent):void
		{
			//Log.system("onMouseDownHandler");
			if( ctrlKey != event.ctrlKey)
			{
				ctrlKey = event.ctrlKey;
				if( event.ctrlKey )
				{
					dispatchKeyDownEvent(KeyCode.CONTROL,getKeyboardEvent( KeyboardEvent.KEY_UP,KeyCode.CONTROL ));
				}
				else
				{
					dispatchKeyUpEvent(KeyCode.CONTROL,getKeyboardEvent( KeyboardEvent.KEY_DOWN,KeyCode.CONTROL ));
				}
			}
			
			if( ShiftKey != event.shiftKey )
			{
				ShiftKey = event.shiftKey;
				if( event.shiftKey )
				{
					dispatchKeyDownEvent(KeyCode.SHIFT,getKeyboardEvent( KeyboardEvent.KEY_UP,KeyCode.SHIFT ));
				}
				else
				{
					dispatchKeyUpEvent(KeyCode.SHIFT,getKeyboardEvent( KeyboardEvent.KEY_DOWN,KeyCode.SHIFT ));
				}
			}
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}
		
		private var _tempKeyCode:uint = 0;
		private var _isDispatchEvent:Boolean = false;
		private function onKeyDownHandler(event:KeyboardEvent):void
		{	
			ctrlKey = event.ctrlKey;
			ShiftKey = event.shiftKey;
			if( _tempKeyCode ==  event.keyCode)
			{
				return;
			}
			_tempKeyCode = event.keyCode;
			if( event.keyCode == KeyCode.CONTROL )
			{
				ctrlKey = true;
				dispatchKeyDownEvent(KeyCode.CONTROL,event);
			}
			else if( event.keyCode == KeyCode.SHIFT )
			{
				ShiftKey = true;
				dispatchKeyDownEvent(KeyCode.SHIFT,event);
			}
			else
			{
				dispatchKeyDownEvent( event.keyCode,event,ShiftKey,ctrlKey );
			}
//			Log.system( event.keyCode );
			event.stopImmediatePropagation();
		}
		
		private function onKeyUpHandler(event:KeyboardEvent):void
		{
			if( _tempKeyCode == event.keyCode )
			{
				_tempKeyCode = 0;
			}
			if( event.keyCode == KeyCode.CONTROL )
			{
				ctrlKey = false;
				dispatchKeyUpEvent(KeyCode.CONTROL,event);
			}
			else if( event.keyCode == KeyCode.SHIFT )
			{
				ShiftKey = false;
				dispatchKeyUpEvent(KeyCode.SHIFT,event);
			}
			else
			{
				dispatchKeyUpEvent( event.keyCode,event,ShiftKey );
			}
			event.stopImmediatePropagation();
		}
		
		private function dispatchKeyUpEvent( keyCode:int,event:KeyboardEvent = null,isShiftKey:Boolean = false ):void
		{
			var keyData:KeyData = createKeyData(keyCode,isShiftKey);
			var evt:KeyEvent = new KeyEvent(KeyEvent.KEY_UP,keyData);
			evt.keyEvent = event;
			dispatchEvent(evt);
		}
		private function dispatchKeyDownEvent( keyCode:int,event:KeyboardEvent = null,isShiftKey:Boolean = false ,isCtrlKey:Boolean=false):void
		{
			var keyData:KeyData = createKeyData(keyCode,isShiftKey,isCtrlKey);
			var evt:KeyEvent = new KeyEvent(KeyEvent.KEY_DOWN,keyData);
			evt.keyEvent = event;
			dispatchEvent(evt);
		}
		
		private function getKeyboardEvent( type:String, keyCode:uint):KeyboardEvent
		{
			return new KeyboardEvent(type,true,false,0,keyCode,0,ctrlKey,false,ShiftKey);
		}
	}
}