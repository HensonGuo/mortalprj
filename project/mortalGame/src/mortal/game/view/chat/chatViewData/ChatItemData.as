/**
 * @date 2011-3-14 下午12:01:16
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatViewData
{
	import com.gengine.core.IDispose;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;
	
	import mortal.game.view.chat.chatPanel.ChatCell;
	import mortal.game.view.chat.chatPanel.ChatStyle;

	public class ChatItemData implements IDispose
	{
		public function ChatItemData()
		{
			
		}
		
		public function init(type:String = null,cellVector:Vector.<ChatCellData> = null):void
		{
			if(!type)
			{
				type = ChatType.World;
			}
			_type = type;
			_cellVector = cellVector;
		}
		
		private var _type:String;
		private var _cellVector:Vector.<ChatCellData>;

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get cellVector():Vector.<ChatCellData>
		{
			return _cellVector;
		}

		public function set cellVector(value:Vector.<ChatCellData>):void
		{
			_cellVector = value;
		}
		
		public function addCellData(cellData:ChatCellData):void
		{
			_cellVector.push(cellData);
		}
		
		public function getAllElements():Vector.<ContentElement>
		{
			var vcContentEle:Vector.<ContentElement> = new Vector.<ContentElement>();
			var text:String;
//			var txtFormat:ElementFormat;
//			var textElement:TextElement = new TextElement("  " + _type + " " ,ChatStyle.getTitleFormat(_type));
//			vcContentEle.push(textElement);
			
			var title:ChatCellData = ObjectPool.getObject(ChatCellData);
			title.init(CellDataType.IMAGE);
			title.className = ChatStyle.getTitleImageName(_type);
			title.elementFormat = ChatStyle.getImageFormat(5);
			var chatCell:ChatCell = ObjectPool.getObject(ChatCell);
			chatCell.init(title);
			vcContentEle.push(chatCell.cellContentElement);
			
			if(_cellVector)
			{
				for(var i:int = 0;i<_cellVector.length;i++)
				{
					chatCell = ObjectPool.getObject(ChatCell);
					chatCell.init(_cellVector[i]);
					vcContentEle.push(chatCell.cellContentElement);
				}
			}
			return vcContentEle;
		}
		
		public function getContentElement():Vector.<ContentElement>
		{
			var vcContentEle:Vector.<ContentElement> = new Vector.<ContentElement>();
			if(_cellVector)
			{
				for(var i:int = 0;i<_cellVector.length;i++)
				{
					var chatCell:ChatCell = ObjectPool.getObject(ChatCell);
					chatCell.init(_cellVector[i]);
					vcContentEle.push(chatCell.cellContentElement);
				}
			}
			return vcContentEle;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_type = null;
			_cellVector = null;
			ObjectPool.disposeObject(this);
		}
	}
}