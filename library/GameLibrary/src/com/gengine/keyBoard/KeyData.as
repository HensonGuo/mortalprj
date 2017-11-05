package com.gengine.keyBoard
{
	
	
	public class KeyData
	{
		public var key:int;
		//是否按下
		public var isKeyDown:Boolean = false;
		//按键对应的数值
		public var keyCode:uint;		
		private var _keyMap:IKeyMap;
		private var _isShift:Boolean;
		private var _isCtrl:Boolean;
		private var _shortcutsName:String;
		
		public function KeyData($keyCode:uint=0,$isShift:Boolean=false,$isCtrl:Boolean=false)
		{
			this.keyCode = $keyCode;
			_isShift = $isShift;
			_isCtrl = $isCtrl;
			updateKey($keyCode,_isShift,_isCtrl);
		}
		
		public function get keyMap():IKeyMap
		{
			return _keyMap;
		}

		public function set keyMap(value:IKeyMap):void
		{
			_keyMap = value;
		}

		public function get isShift():Boolean
		{
			return _isShift;
		}

		public function set isShift(value:Boolean):void
		{
			_isShift = value;
		}

		public function get isCtrl():Boolean
		{
			return _isCtrl;
		}
		
		public function set isCtrl(value:Boolean):void
		{
			_isCtrl = value;
		}
		
		public function get shortcutsName():String
		{
			return _shortcutsName;
		}

		private function updateKey($keyCode:int,$isShift:Boolean,$isCtrl:Boolean):void
		{
			keyCode = $keyCode;
			_isShift = $isShift;
			_isCtrl = $isCtrl;
			
			if( _isShift )
			{
				key = $keyCode+KeyCode.SHIFT_NUM;
			}
			else if(_isCtrl)
			{
				key = $keyCode+KeyCode.CTRL
			}
			else
			{
				key = $keyCode;
			}

			
			if( _isShift )
			{
				_shortcutsName = "sht+"+KeyCode.getKeyName(keyCode);
			} 
			else if(_isCtrl)
			{
				_shortcutsName = "ctr+"+KeyCode.getKeyName(keyCode);
			}
			else
			{
				_shortcutsName = KeyCode.getKeyName(keyCode);
				if( _shortcutsName == null )
				{
					_shortcutsName = "";
				}
			}
		}
		
//		private function copy( keyData:KeyData ):void
//		{
//			if( keyData )
//			{
//				updateKey( keyData.keyCode ,keyData.isShift);
//				this.keyMap = keyData.keyMap;
//			}
//			else
//			{
//				updateKey( 0 ,false);
//				this.keyMap = null;
//			}
//		}
	}
}