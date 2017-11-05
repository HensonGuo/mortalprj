/**
 * @date 2011-3-14 上午11:53:32
 * @author  hexiaoming
 * 
 */ 
package chat.display.item
{
	import chat.ChatLayerManager;
	import chat.display.menu.ChatMeneOperate;
	import chat.display.menu.ListMenu;
	import chat.display.menu.PlayerMenuCellRenderer;
	import chat.textData.CellDataType;
	import chat.textData.ChatCellData;
	import chat.textData.ChatData;
	
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ChatCell
	{
		private var _cellData:ChatCellData;
		private var _cellContentElement:ContentElement;
		private var _elementFormat:ElementFormat;
		private var _dipatcher:EventDispatcher;
		
		private static var _playerOpList:ListMenu;
		private static var _currnetCell:ChatCell;
		
		public function ChatCell()
		{
			
		}
		
		public function init(cellData:ChatCellData):void
		{
			_cellData = cellData;
			_elementFormat = cellData.elementFormat?cellData.elementFormat:new ElementFormat();
			_dipatcher = new EventDispatcher();
			if(!_playerOpList)
			{
				_playerOpList = new ListMenu();
				_playerOpList.width = 86;
				_playerOpList.visible = false;
				_playerOpList.list.setStyle("cellRenderer",PlayerMenuCellRenderer);
				_playerOpList.list.drawNow();
				_playerOpList.list.addEventListener(ListEvent.ITEM_CLICK,playerOpItemSelect);
			}
			create();
		}
		
		/**
		 *创建显示 
		 */
		private function create():void
		{
			
			switch(_cellData.type)
			{
				case CellDataType.GENERAL:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
					break;
				case CellDataType.PLAYER:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,_dipatcher);
					_dipatcher.addEventListener(MouseEvent.CLICK,showPlayerOperate);
					setMouseCanClick();
					break;
				default:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
					break;
			}
		}
		
		private function setMouseCanClick():void
		{
			_dipatcher.addEventListener(MouseEvent.MOUSE_OVER,mouseStyleHandler);
			_dipatcher.addEventListener(MouseEvent.MOUSE_OUT,mouseStyleHandler);
		}
		
		private function mouseStyleHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_OVER)
			{
				Mouse.cursor = MouseCursor.BUTTON;
			}
			if(e.type == MouseEvent.MOUSE_OUT)
			{
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		private function playerOpItemSelect(e:ListEvent):void
		{
			ChatMeneOperate.Opearte(_playerOpList.list.dataProvider.getItemAt(e.index)["eventType"],_currnetCell.cellData.data as ChatData);
		}
		
		private function showPlayerOperate(e:MouseEvent):void
		{
			var obj:DisplayObject = e.target as DisplayObject;
			if(obj.parent)
			{
				_currnetCell = this;
				ChatLayerManager.menuLayer.addChild(_playerOpList);
				_playerOpList.dataProvider = ChatMeneOperate.getPlayerDataProvider();
				var opX:Number = e.stageX;
				var opY:Number = e.stageY - _playerOpList.height;
				if(opY < 0)
				{
					opY = e.stageY;
				}
				_playerOpList.show(opX,opY,ChatLayerManager.menuLayer);
				Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
			}
			e.stopImmediatePropagation();
		}
		
		
		private function stageClickHandler(e:MouseEvent):void
		{
			_playerOpList.hide();
			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
		}
		
		public function get cellData():ChatCellData
		{
			return _cellData;
		}

		public function set cellData(value:ChatCellData):void
		{
			_cellData = value;
		}

		public function get cellContentElement():ContentElement
		{
			return this._cellContentElement;
		}
		
		public function dispose():void
		{
			_cellContentElement = null;
			_elementFormat = null;
			_dipatcher = null;
			_cellData.dispose();
			_cellData = null;
			ObjectPool.disposeObject(this);
		}
	}
}