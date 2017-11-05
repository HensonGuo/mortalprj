package mortal.common.shortcutsKey
{
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.keyBoard.KeyCode;
	import com.gengine.keyBoard.KeyData;
	import com.mui.serialization.json.JSON;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.ModuleType;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 快捷键 
	 * @author jianglang
	 * 
	 */	
	public class ShortcutsKey
	{
		private var _keyMap:Dictionary;
		
		private var _defaultKeyMap:Dictionary = new Dictionary();
		
		private static var _instance:ShortcutsKey;
		
		public var moduleAry:Array = [];
		public var skillsAry:Array = [];
		
		public function ShortcutsKey()
		{
			if( _instance  )
			{
				throw new Error("ShortcutsKey singleton ");
			}
			_instance = this;
			
			initKeyMap();
			initDefaultShortcutsKey();
		}
		
		private function initKeyMap():void
		{
			if( _keyMap == null )
			{
				_keyMap = new Dictionary();
				
				addKeyMap(ModuleType.Pack,Language.getString(20021))//"背包"
				addKeyMap(ModuleType.Players,Language.getString(20022))//"人物"
				addKeyMap(ModuleType.Skills, Language.getString(20052))//"技能"
				addKeyMap(ModuleType.SmallMap, Language.getString(20023))//"地图"
				addKeyMap(ModuleType.PickBox, Language.getString(10021))//"拾取物品"
				addKeyMap(ModuleType.SwitchTarget,Language.getString(20024));//"切换目标"
				addKeyMap(ModuleType.Group,Language.getString(30201));//"组队"
				addKeyMap(ModuleType.Tasks, Language.getString(20120))//"任务"
				addKeyMap(ModuleType.Pets, Language.getString(70023))//"宠物"
				addKeyMap(ModuleType.Friend,Language.getString(40001))//"好友"
				addKeyMap(ModuleType.ShopMall,Language.getString(30059))//"商城"
				addKeyMap(ModuleType.Mail,Language.getString(50001))//"邮件"
				addKeyMap(ModuleType.Build,Language.getString(30006))//"锻造"
				addKeyMap(ModuleType.Mounts,Language.getString(30300))//"坐骑"
				addKeyMap(ModuleType.Guild, Language.getString(60001));//"仙盟"
				addKeyMap(ModuleType.Wizard, Language.getString(30400));//精灵
				
				addKeyMap(ModuleType.AutoFight, "自动挂机");//自动挂机
				addKeyMap(ModuleType.PetsRest, "收放宠物");//收放宠物
				addKeyMap(ModuleType.DownUpMounts, "上下坐骑");//上下坐骑
				addKeyMap(ModuleType.Rest, "打坐修炼");//打坐修炼
				addKeyMap(ModuleType.XP, "XP技能");//XP技能
				
				for( var i:int = 1; i <= 20; i++ )
				{
					if(i<=10)
					{
						addKeyMap(i, Language.getString(20049) + i);//"基础栏"
					}
					else
					{
						addKeyMap(i, Language.getString(20050) + i);//"扩展栏"
					}
				}
			}
		}
		
		private function initDefaultShortcutsKey():void
		{
			//快捷栏
			registerDefaultKeyMap(KeyCode.N1,ModuleType.Shortcuts1); //
			registerDefaultKeyMap(KeyCode.N2,ModuleType.Shortcuts2); //
			registerDefaultKeyMap(KeyCode.N3,ModuleType.Shortcuts3); //
			registerDefaultKeyMap(KeyCode.N4,ModuleType.Shortcuts4); //
			registerDefaultKeyMap(KeyCode.N5,ModuleType.Shortcuts5); //
			registerDefaultKeyMap(KeyCode.N6,ModuleType.Shortcuts6); //
			registerDefaultKeyMap(KeyCode.N7,ModuleType.Shortcuts7); //
			registerDefaultKeyMap(KeyCode.N8,ModuleType.Shortcuts8); //
			registerDefaultKeyMap(KeyCode.N9,ModuleType.Shortcuts9); //
			registerDefaultKeyMap(KeyCode.N0,ModuleType.Shortcuts10); //
			
			registerDefaultKeyMap(KeyCode.N1,ModuleType.Shortcuts11,true); //
			registerDefaultKeyMap(KeyCode.N2,ModuleType.Shortcuts12,true); //
			registerDefaultKeyMap(KeyCode.N3,ModuleType.Shortcuts13,true); //
			registerDefaultKeyMap(KeyCode.N4,ModuleType.Shortcuts14,true); //
			registerDefaultKeyMap(KeyCode.N5,ModuleType.Shortcuts15,true); //
			registerDefaultKeyMap(KeyCode.N6,ModuleType.Shortcuts16,true); //
			registerDefaultKeyMap(KeyCode.N7,ModuleType.Shortcuts17,true); //
			registerDefaultKeyMap(KeyCode.N8,ModuleType.Shortcuts18,true); //
			registerDefaultKeyMap(KeyCode.N9,ModuleType.Shortcuts19,true); //
			registerDefaultKeyMap(KeyCode.N0,ModuleType.Shortcuts20,true); //
			
			// 键盘26个字母对应
			registerDefaultKeyMap(KeyCode.B,ModuleType.Pack, false); // 背包
			registerDefaultKeyMap(KeyCode.C, ModuleType.Players, false); // 人物
			registerDefaultKeyMap(KeyCode.V, ModuleType.Skills, false)//"技能"
			registerDefaultKeyMap(KeyCode.M, ModuleType.SmallMap, false)//"小地图"
			registerDefaultKeyMap(KeyCode.Z, ModuleType.PickBox, false)//"小地图"
			registerDefaultKeyMap(KeyCode.TAB,ModuleType.SwitchTarget,false);//切换目标
			registerDefaultKeyMap(KeyCode.T,ModuleType.Group,false);//组队
			registerDefaultKeyMap(KeyCode.Q, ModuleType.Tasks,false); // 任务
			registerDefaultKeyMap(KeyCode.W, ModuleType.Pets,false); // 任务
			registerDefaultKeyMap(KeyCode.F,ModuleType.Friend,false);//好友
			registerDefaultKeyMap(KeyCode.S,ModuleType.ShopMall,false);//商城
			registerDefaultKeyMap(KeyCode.E,ModuleType.Mail,false);//邮件
			registerDefaultKeyMap(KeyCode.K,ModuleType.Build,false);//锻造
			registerDefaultKeyMap(KeyCode.J,ModuleType.Mounts,false);//坐骑
			registerDefaultKeyMap(KeyCode.G, ModuleType.Guild, false);//公会
			registerDefaultKeyMap(KeyCode.P, ModuleType.Wizard, false);//精灵
			registerDefaultKeyMap(KeyCode.A, ModuleType.AutoFight, false);//自动挂机
			registerDefaultKeyMap(KeyCode.R, ModuleType.PetsRest, false);//收放宠物
			registerDefaultKeyMap(KeyCode.H, ModuleType.DownUpMounts, false);//收放宠物
			registerDefaultKeyMap(KeyCode.D, ModuleType.Rest, false);//打坐修炼
			registerDefaultKeyMap(KeyCode.X, ModuleType.XP, false);//XP技能
		}
		
		public static function get instance():ShortcutsKey
		{
			if( _instance == null )
			{
				_instance = new ShortcutsKey();
			}
			return _instance;
		}
		
		public function hasKeyCode( keyCode:uint ):Boolean
		{
			if( keyCode >= 48 && keyCode <= 90 || keyCode == KeyCode.TAB)
			{
				if( keyCode > 57 && keyCode < 65  )
				{
					return false;
				}
				return true;
			}
			return false;
		}
		
		/**
		 * 注册默认值 
		 * @param key
		 * @param keyMap
		 * @param isShift
		 * 
		 */		
		private function registerDefaultKeyMap( key:uint,keyMap:Object,isShift:Boolean=false  ):void
		{
			_defaultKeyMap[ keyMap ] = KeyBoardManager.createKeyData(key,isShift);
		}
		
		/**
		 * 注册快捷键  
		 * @param key  键盘按键
		 * @param isCtrl  是否有ctrl
		 * @param keyMap  对应的键值映射
		 * 
		 */		
		public function register(key:uint,keyMap:Object,isShift:Boolean=false ):void
		{
			var keyData:KeyData = KeyBoardManager.createKeyData(key,isShift);
			var mapData:KeyMapData =  getKeyMap(keyMap);
			if( mapData )
			{
				keyData.keyMap = mapData;
				mapData.keyData = keyData;
			}
			else
			{
				keyData.keyMap  = null;
			}
		}
		
		public function getKeyMap( keyMap:Object ):KeyMapData
		{
			return _keyMap[ keyMap ];
		}
		
		
		public function getKeyMapData( keyCode:uint,isShift:Boolean = false ):KeyMapData
		{
			var keyMapData:KeyMapData;
			for each( keyMapData in moduleAry )
			{
				if( keyMapData.displayKeyData.isShift == isShift && keyMapData.displayKeyData.keyCode == keyCode )
				{
					return keyMapData;
				}
			}
			
			for each( keyMapData in skillsAry )
			{
				if( keyMapData.displayKeyData.isShift == isShift && keyMapData.displayKeyData.keyCode == keyCode )
				{
					return keyMapData;
				}
			}
			return null;
		}
		
		public function getDefaultKeyData( keyMap:Object ):KeyData
		{
			return _defaultKeyMap[keyMap];
		}
		
		/**
		 * 设置默认快捷键 
		 * 
		 */		
		public function setDefaultShortcutsKey():void
		{
			var keyMapData:KeyMapData;
			for each( keyMapData in moduleAry )
			{
				keyMapData.setDefault();
			}
			
			for each( keyMapData in skillsAry )
			{
				keyMapData.setDefault();
			}
		}
		
		public function addKeyMap( key:Object,name:String,isCanEdit:Boolean=true ):void
		{
			var mapData:KeyMapData = new KeyMapData(key,name,isCanEdit);
			_keyMap[key] = mapData;
			if( key is int )
			{
				skillsAry.push(mapData);
			}
			else
			{
				moduleAry.push( mapData );
			}
		}
		
		public function setServerStr( str:String ):void
		{
			if( str == "" || str == null)
			{
				setDefaultShortcutsKey();
			}
			else
			{
				var objMap:Object = com.mui.serialization.json.JSON.deserialize(str) as Object;
				var keyMapData:KeyMapData;
				var tempObj:Object;
				for each( keyMapData in moduleAry   )
				{
					if( keyMapData.isCanEdit == false )
					{
						keyMapData.setDefault();
					}
					else
					{
						tempObj = objMap[keyMapData.key];
						if(tempObj)
						{
							register(tempObj.c,keyMapData.key,tempObj.s==0?false:true);
						}
						else
						{
							//切换目标默认为tab
							if(keyMapData.key == ModuleType.SwitchTarget)
							{
								keyMapData.setDefault();
							}
							else
							{
								keyMapData.clear();
							}
						}
					}
				}
				
				for each( keyMapData in skillsAry )
				{
					if( keyMapData.isCanEdit == false )
					{
						keyMapData.setDefault();
					}
					else
					{
						tempObj = objMap[keyMapData.key];
						if(tempObj)
						{
							register(tempObj.c,keyMapData.key,tempObj.s==0?false:true);
						}
						else
						{
							keyMapData.clear();
						}
					}
				}
			}
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutKeyUpdate, moduleAry.concat(skillsAry)));
		}
		
		public function recoverySetter():void
		{
			var keyMapData:KeyMapData;
			for each( keyMapData in moduleAry )
			{
				keyMapData.recoveryKeyData();
			}
			
			for each( keyMapData in skillsAry )
			{
				keyMapData.recoveryKeyData();
			}
		}
		
		public function getServerStr():String
		{
			var obj:Object = {};
			var keyMapData:KeyMapData;
			var tempObj:Object;
			for each( keyMapData in moduleAry   )
			{
				if( keyMapData.isCanEdit )
				{
					keyMapData.updateKeyData();
					tempObj = keyMapData.getServerObject();
					if(tempObj)
					{
						obj[keyMapData.key] = tempObj;
					}
//					else
//					{
//						keyMapData.clear();
//					}
				}
			}
			
			for each( keyMapData in skillsAry )
			{
				if( keyMapData.isCanEdit )
				{
					keyMapData.updateKeyData();
					tempObj = keyMapData.getServerObject();
					if( tempObj )
					{
						obj[keyMapData.key] = tempObj;
					}
					else
					{
						keyMapData.clear();
					}
				}
			}
			

			Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutKeyUpdate, moduleAry.concat(skillsAry)));
			return com.mui.serialization.json.JSON.serialize(obj);
		}
	}
}