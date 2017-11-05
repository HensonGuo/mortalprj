package mortal.game.view.common.richTextField
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mortal.game.view.richTextField.viewData.CellDataType;
	import mortal.game.view.richTextField.viewData.CellData;
	
	
	public class Cell
	{
		private var _cellData:CellData;          //聊天的信息
		private var _cellContentElement:ContentElement;    //聊天中可点击的数据元素
		private var _elementFormat:ElementFormat;          //可点击的数据元素的格式
		private var _dipatcher:EventDispatcher;
		
//		private static var _playerOpList:ListMenu;
//		private static var _currnetCell:ChatCell;
//		private static var _toolTip:Tooltip;
		public function Cell(cellData:CellData)
		{
			init(cellData);
		}
		
		private function init(cellData:CellData):void
		{
			_cellData = cellData;
			_dipatcher = new EventDispatcher;
			_elementFormat = cellData.elementFormat?cellData.elementFormat:new ElementFormat();
			create();
		}
		
//		public function init(cellData:ChatCellData):void
//		{
//			_cellData = cellData;
//			_elementFormat = cellData.elementFormat?cellData.elementFormat:new ElementFormat();
//			_dipatcher = new EventDispatcher();
//			if(!_playerOpList)
//			{
//				_playerOpList = new ListMenu();
//				_playerOpList.width = 86;
//				_playerOpList.visible = false;
//				_playerOpList.list.setStyle("cellRenderer",PlayerMenuCellRenderer);
//				_playerOpList.list.drawNow();
//				_playerOpList.list.addEventListener(ListEvent.ITEM_CLICK,playerOpItemSelect);
//			}
//			create();
//		}
		
		private function create():void
		{
			switch(_cellData.type)
			{
				case CellDataType.IMAGE:
					var bmp:Bitmap = new Bitmap(new BitmapData(20,20),"auto");
					_cellContentElement = new GraphicElement(bmp,bmp.width,bmp.height,_elementFormat);
					break;
				case "movieClip":          //表情动画
					var mc:MovieClip = _cellData.data as MovieClip;
					mc.mouseEnabled = false;
					mc.mouseChildren = false;
					mc.addEventListener(Event.ADDED_TO_STAGE,onMCAddToStage);
					mc.addEventListener(Event.REMOVED_FROM_STAGE,onMCRemoveFromStage);
					_cellContentElement = new GraphicElement(mc,mc.width,mc.height,_elementFormat);
					(_cellContentElement as GraphicElement).graphic.filters = [];
//					setMouseCanClick();
					break;
				case "text":
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
					break;
				case "link":
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,click);
					break;
			}
		}
		
		private function click(e:MouseEvent):void
		{
			
		}
		
		private function setLink():void
		{
			var textField:TextField;
			var textFormat:TextFormat;
			textField = new  TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.multiline = true;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.y = 6;
			textFormat = new TextFormat();
			textFormat.color = _elementFormat.color;
			textFormat.underline = true;
			textFormat.size = _elementFormat.fontSize;
			textFormat.letterSpacing = _elementFormat.trackingLeft;
			textField.defaultTextFormat = textFormat;
			textField.text = _cellData.text;
			_cellContentElement = new GraphicElement(textField,textField.width,textField.height,_elementFormat,_dipatcher);
			setMouseCanClick();
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
		
		private function onMCAddToStage(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.play();
		}
		
		private function onMCRemoveFromStage(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.stop();
		}
		
		
		public function get cellData():CellData
		{
			return _cellData;
		}
		
		public function set cellData(value:CellData):void
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
		}
	}
}