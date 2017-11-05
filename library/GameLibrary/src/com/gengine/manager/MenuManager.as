package com.gengine.manager
{
	import com.gengine.core.Singleton;
	import com.gengine.global.Global;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 右键菜单管理 
	 * @author jianglang
	 * 
	 */	
	public class MenuManager extends Singleton
	{
		private static var _instacne:MenuManager;
		
		private var _contextMenu:ContextMenu ;
		private var _container:DisplayObjectContainer;
		
		public function MenuManager()
		{
			_contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
		}
		
		public static function get instance():MenuManager
		{
			if( _instacne == null )
			{
				_instacne = new MenuManager();
			}
			return _instacne;
		}
		
		public function initMenu( container:DisplayObjectContainer ):void
		{
			_container = container;
			if( _container )
			{
				_container.contextMenu = _contextMenu;
			}
		}
		
		public function addItem( menuLabel:String,callback:Function = null ):void
		{
			var isCallback:Boolean = callback is Function;
			var item:ContextMenuItem
			if( isCallback )
			{
				item = new ContextMenuItem(menuLabel,false);
			}
			else
			{
				item = new ContextMenuItem(menuLabel,false,false);
			}
			_contextMenu.customItems.push(item);
			if( isCallback )
			{
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				
				function menuItemSelectHandler(event:ContextMenuEvent):void
				{
					callback();
				}
			}
		}
		
	}
}