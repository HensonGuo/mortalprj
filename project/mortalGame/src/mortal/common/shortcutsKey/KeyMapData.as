package mortal.common.shortcutsKey
{
	import com.gengine.keyBoard.IKeyMap;
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.keyBoard.KeyData;

	/**
	 * 快捷键映射的数据 
	 * @author jianglang
	 * 
	 */	
	public class KeyMapData implements IKeyMap
	{
		private var _keyData:KeyData;
		private var _keyMapName:String;  //映射名称
		private var _key:Object;
		private var _isCanEdit:Boolean;//是否可以编辑
		
		private var _tempName:String;
		
		public var displayKeyData:KeyData; //显示数据
		
		private var _defaultKeyData:KeyData;
		
		public function KeyMapData( $key:Object,$keyMapName:String,$isCanEdit:Boolean = true )
		{
			_key = $key;
			_keyMapName = $keyMapName;
			_isCanEdit = $isCanEdit;
			displayKeyData = new KeyData();
		}

		public function get defaultKeyData():KeyData
		{
			if( _defaultKeyData == null )
			{
				_defaultKeyData  = ShortcutsKey.instance.getDefaultKeyData(key);
			}
			return _defaultKeyData;
		}

		public function set tempName(value:String):void
		{
			_tempName = value;
		}

		public function get tempName():String
		{
			if( _tempName == null )
			{
				if( _keyData )
				{
					_tempName = _keyData.shortcutsName;
				}
				
				if( _tempName == null )
				{
					_tempName = "";
				}
			}
			return _tempName;
		}
		
		

		public function get isCanEdit():Boolean
		{
			return _isCanEdit;
		}

		public function get keyMapName():String
		{
			return _keyMapName;
		}

		public function get key():Object
		{
			return _key;
		}

		public function get keyData():KeyData
		{
			return _keyData;
		}

		public function set keyData(value:KeyData):void
		{
			_keyData = value;
			if( _keyData )
			{
				displayKeyData.isShift = _keyData.isShift;
				displayKeyData.keyCode = _keyData.keyCode;
			}
			else
			{
				displayKeyData.isShift = false;
				displayKeyData.keyCode = 0;
			}
		}
		
		/**
		 * 获取服务器对象 
		 * @return 
		 * 
		 */		
		public function getServerObject():Object
		{
			if( _keyData )
			{
				return {c:_keyData.keyCode,s:_keyData.isShift==true?1:0 };
			}
			return null;
		}
		
		/**
		 * 默认数据数据显示 
		 * 
		 */		
		public function setDefault():void
		{
			if(this.keyData)
			{
				this.keyData.keyMap = null;
			}
			this.keyData = defaultKeyData;
			if( this.keyData )
			{
				this.keyData.keyMap = this;
				tempName = this.keyData.shortcutsName;
			}
			else
			{
				tempName = "";
			}
		}
		/**
		 * 临时数据更新到设置数据
		 * 
		 */
		public function updateKeyData():void
		{
			if( this.keyData )
			{
				//相互连接确认是自己 就清除连接 不是自己 说明他已经和其他对象确认连接 不需要清除
				if( this.keyData.keyMap == this ) 
				{
					this.keyData.keyMap = null;
				}
			}
			this.keyData = KeyBoardManager.createKeyData(displayKeyData.keyCode,displayKeyData.isShift);
			this.keyData.keyMap = this;
		}
		
		/**
		 * 恢复设置
		 * 
		 */		
		public function recoveryKeyData():void
		{
			if( this.keyData )
			{
				displayKeyData.keyCode = this.keyData.keyCode;
				displayKeyData.isShift = this.keyData.isShift;
				tempName = this.keyData.shortcutsName;
			}
			else
			{
				displayKeyData.keyCode = 0;
				displayKeyData.isShift = false;
				tempName = "未设置";
			}
		}
		
		public function clear():void
		{
			if( this.keyData )
			{
				this.keyData.keyMap = null;
				this.keyData = null;
			}
			tempName = "未设置";
		}
		
	}
}