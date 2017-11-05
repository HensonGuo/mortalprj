/**
 * 
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
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.info.item.ItemData;

	public class ItemMenuRegister
	{
		private static var _itemList:ListMenu;
		private static var _layer:Sprite;
		private static var _currentActiveObject:InteractiveObject;
		private static var _currentItemData:ItemData = null;
		private static var _dicObjInfo:Dictionary = new Dictionary(true);
		private static var _dicObjdata:Dictionary = new Dictionary(true);
		
		//注册点击显示
		public static function register(activeObject:InteractiveObject,itemData:ItemData,dataProvider:DataProvider=null):void
		{
			var opDataProvider:DataProvider;
			if(!hasRegister(activeObject))
			{
				if(dataProvider != null)
				{
					opDataProvider = dataProvider;
				}
				else
				{
					opDataProvider = ItemMenuConst.getDataProvider(itemData);
				}
				_dicObjInfo[activeObject] = itemData;
				_dicObjdata[activeObject] = opDataProvider;
				activeObject.addEventListener(MouseEvent.CLICK,showInfo);
			}
		}
		
		public static function unRegister(activeObject:InteractiveObject):void
		{
			activeObject.removeEventListener(MouseEvent.CLICK,showInfo);
			delete _dicObjInfo[activeObject];
			delete _dicObjdata[activeObject];
		}
		
		public static function hasRegister(activeObject:InteractiveObject):Boolean
		{
			return _dicObjInfo[activeObject]?true:false;
		}
		
		public static function hideOpList():void
		{
			if(_itemList)
			{
				_itemList.hide();
			}
		}
		
		private static function createItemList():void
		{
			if(!_itemList)
			{
				_itemList = new ListMenu();
				_itemList.width = 84;
				_itemList.visible = false;
//				_itemList.list.setStyle("cellRenderer",PlayerMenuCellRenderer);
				_itemList.list.drawNow();
				_itemList.list.addEventListener(ListEvent.ITEM_CLICK,opItemSelect);
			}
		}
		
		private static function showInfo(e:MouseEvent):void
		{
			if(!_layer)
			{
				_layer = LayerManager.topLayer;
			}
			createItemList();
			_currentActiveObject = e.currentTarget as InteractiveObject;
			_currentItemData = _dicObjInfo[_currentActiveObject];
			if(_currentActiveObject.parent)
			{
				_layer.addChild(_itemList);
				_itemList.dataProvider = ItemMenuConst.getEnabeldAttri(_dicObjdata[_currentActiveObject],_dicObjInfo[_currentActiveObject]);
				
				var x:Number = e.stageX;
				var y:Number = e.stageY;
				var paddingX:Number = 5;
				x = x < _layer.stage.stageWidth - _itemList.width - paddingX?x:x - _itemList.width - paddingX;
				y = y < _layer.stage.stageHeight - _itemList.height?y:y - _itemList.height;
				_itemList.show(x,y,_layer);
			}
			Global.stage.addEventListener(MouseEvent.CLICK,hideHandler);
			e.stopImmediatePropagation();
			
		}
		
		private static function hideHandler(e:MouseEvent):void
		{
			hideOpList();
			Global.stage.removeEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		private static function opItemSelect(e:ListEvent):void
		{
			ItemMenuConst.opearte(_itemList.list.dataProvider.getItemAt(e.index)["label"],_currentItemData);
		}
	}
}