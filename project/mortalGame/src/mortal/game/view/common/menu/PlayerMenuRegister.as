/**
 * @date 2011-4-3 下午03:44:20
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.common.menu
{
	import com.gengine.global.Global;
	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mortal.game.manager.LayerManager;

	public class PlayerMenuRegister
	{
		private static var _playerOpList:ListMenu;
		private static var _layer:Sprite;
		private static var _currnetActiveObject:InteractiveObject;
		private static var _currentPlayerData:* = null;
		private static var _data:Object = null;
		private static var _dicObjInfo:Dictionary = new Dictionary(true);
		private static var _dicObjdata:Dictionary = new Dictionary(true);
		
		//注册点击显示
		public static function Register(activeObject:InteractiveObject,playerData:*,opDataProvider:DataProvider = null):void
		{
			if(!HasRegister(activeObject))
			{
				if(!opDataProvider)
				{
					opDataProvider = PlayerMenuConst.ChatOpMenu;
				}
				
				if(opDataProvider.length == 0)
				{
					return;
				}
				
				_dicObjInfo[activeObject] = playerData;
				_dicObjdata[activeObject] = opDataProvider;
				activeObject.addEventListener(MouseEvent.CLICK,showInfo,false,0);
				activeObject.addEventListener(Event.REMOVED_FROM_STAGE,unRegister);
			}
		}
		
		private static function unRegister(e:Event):void
		{
			PlayerMenuRegister.UnRegister(e.target as InteractiveObject);
		}
		
		public static function UnRegister(activeObject:InteractiveObject):void
		{
			activeObject.removeEventListener(MouseEvent.CLICK,showInfo);
//			if(_dicObjInfo.hasOwnProperty(activeObject))
//			{
				delete _dicObjInfo[activeObject];
				delete _dicObjdata[activeObject];
//			}
		}
		
		//直接显示
		public static function ShowOpList(playerData:*,x:Number,y:Number,opDataProvider:DataProvider = null):void
		{
			if(!opDataProvider)
			{
				opDataProvider = PlayerMenuConst.ChatOpMenu;
			}
			if(!_layer)
			{
				_layer = LayerManager.topLayer;
			}
			createPlayerOpList();
			_currentPlayerData = playerData;
			_layer.addChild(_playerOpList);
			_playerOpList.dataProvider = PlayerMenuConst.getEnabeldAttri(opDataProvider,playerData);
			x = x < _layer.stage.stageWidth - _playerOpList.width?x:x - _playerOpList.width;
			y = y < _layer.stage.stageHeight - _playerOpList.height?y:y - _playerOpList.height;
			_playerOpList.show(x,y,_layer);
		}
		
		public static function HasRegister(activeObject:InteractiveObject):Boolean
		{
			return _dicObjInfo[activeObject]?true:false;
		}
		
		public static function HideOpList():void
		{
			if(_playerOpList)
			{
				_playerOpList.hide();
			}
		}
		
		private static function createPlayerOpList():void
		{
			if(!_playerOpList)
			{
				_playerOpList = new ListMenu();
				_playerOpList.width = 86;
				_playerOpList.visible = false;
				_playerOpList.list.setStyle("cellRenderer",PlayerMenuCellRenderer);
				_playerOpList.list.drawNow();
				_playerOpList.list.addEventListener(ListEvent.ITEM_CLICK,PlayerOpItemSelect);
			}
		}
		
		private static function showInfo(e:MouseEvent):void
		{
			if(!_layer)
			{
				_layer = LayerManager.topLayer;
			}
			createPlayerOpList();
			_currnetActiveObject = e.currentTarget as InteractiveObject;
			_currentPlayerData = _dicObjInfo[_currnetActiveObject];
			if(_currnetActiveObject.parent)
			{
				_layer.addChild(_playerOpList);
				_playerOpList.dataProvider = PlayerMenuConst.getEnabeldAttri(_dicObjdata[_currnetActiveObject],_dicObjInfo[_currnetActiveObject]);
				
				var x:Number = e.stageX;
				var y:Number = e.stageY;
				x = x < _layer.stage.stageWidth - _playerOpList.width?x:x - _playerOpList.width;
				y = y < _layer.stage.stageHeight - _playerOpList.height?y:y - _playerOpList.height;
				_playerOpList.show(x,y,_layer);
			}
			Global.stage.addEventListener(MouseEvent.CLICK,hideHandler);
			e.stopImmediatePropagation();
		}
		
		private static function hideHandler(e:MouseEvent):void
		{
			HideOpList();
			Global.stage.removeEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		private static function PlayerOpItemSelect(e:ListEvent):void
		{
			PlayerMenuConst.Opearte(_playerOpList.list.dataProvider.getItemAt(e.index)["label"],_currentPlayerData);
		}
	}
}