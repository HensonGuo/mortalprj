package mortal.game.view.common.richTextField
{
	import RichTextfield.Cell;
	
	import com.mui.controls.GSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	import mortal.game.view.richTextField.viewData.CellData;
	
	public class RichTextField extends GSprite
	{
		
		private var _cellVector:Vector.<CellData>;    //图文信息
		
		private var _elementVector:Vector.<ContentElement>;     //储存图文信息
		
		private var _textBlock:TextBlock;     //文本块
		
		private var _lineWidth:int;      //文本块宽度
		
		private var _lineHeight:Number;    //文本行高度
		
		private var _totleHeight:int;
		
		private var _col:int;
		
		private var _indentation:Boolean;
		
		/**
		 * 
		 * @param width 行宽度  
		 * @param lineHeight  行间距
		 * @param indentation  是否首行缩进
		 */		
		public function RichTextField( lineWidth:int = 260 , lineHeight:int = 21 , indentation:Boolean = false)
		{
			super();
			_elementVector = new Vector.<ContentElement>();
			_cellVector = new Vector.<CellData>;
			_lineWidth = lineWidth;
			_lineHeight = _lineHeight;
			_indentation = indentation;
			this.mouseEnabled = false;
			this.cacheAsBitmap = true;
			
		}
		
		/**给富文本输入数据
		 * 
		 * @param arr
		 * @param 格式:append({type:"text",text:"文本"},{type:"movieClip",data:displayObject})
		 * @param
		 * @param {type:"text",text:"文本"}  插入文本
		 * @param {type:"text",text:"\n"}   换行 
		 * @param {type:"movieClip",data:displayObject} 插入动画
		 * 
		 */				
		public function append(...arr):void
		{
			changeDataAndCreate(arr);
		}
		
		/**给富文本输入数据
		 * 
		 * @param arr
		 * @param 格式:appendArr(arr}
		 */	
		public function appendArr(arr:Array):void
		{
			changeDataAndCreate(arr);
		}
		
		private function changeDataAndCreate(arr:Array):void
		{
			var length:int = arr.length;
			for(var i:int; i < length; i++)
			{
				//                trace(arr[i].text);
				var cellData:CellData = new CellData;
				cellData.elementFormat = (arr[i] as Object).elementFormat? (arr[i] as Object).elementFormat:new ElementFormat(null,15,0xFFFFFF);
				
				cellData.type = (arr[i] as Object).type? (arr[i] as Object).type:"";
				cellData.text = (arr[i] as Object).text? (arr[i] as Object).text:"";
				cellData.className = (arr[i] as Object).className? (arr[i] as Object).className:"";
				cellData.linkUrl = (arr[i] as Object).linkUrl? (arr[i] as Object).linkUrl:"";
				cellData.uid = (arr[i] as Object).uid? (arr[i] as Object).uid:"";
				
				cellData.data = (arr[i] as Object).data? (arr[i] as Object).data:null;
				
				_cellVector.push(cellData); 
			}			
			getElements();
			craeteChildren();
		}
		
		private function getElements():void        //将cellData数组转化为elements数组
		{
			if(_cellVector)
			{
				var l:int = _cellVector.length;
				for(var i:int = 0;i<l;i++)
				{
					var cell:Cell = new Cell(_cellVector[i]);
					_elementVector.push(cell.cellContentElement);
				}
			}
		}
		
		private function  craeteChildren():void
		{
			if(!_elementVector || _elementVector.length == 0)
			{
				clear();
				return;
			}
			
			var groupElement:GroupElement = new GroupElement(_elementVector);
			_textBlock = new TextBlock();
			_textBlock.content = groupElement;
			createTextLines(_textBlock);
		}
		
		private function createTextLines(textBlock:TextBlock):void 
		{
			_totleHeight = 0;
			var isFirstLine:Boolean = true;
			var textLine:TextLine = textBlock.createTextLine (null, _lineWidth);
			while (textLine)
			{
				_col++;
				addChild(textLine);
				textLine.mouseEnabled = false;
				textLine.doubleClickEnabled = false;
//				textLine.x = 0;
				if(_indentation)
				{
					textLine.x = _col <= 1?0.5:0;
				}
				else
				{
					textLine.x = 0;
				}
				
				textLine.y = _totleHeight +textLine.height + _lineHeight*(_col - 1);
				_totleHeight += (textLine.height );
			}
		}
		
		private function clear():void
		{
			var obj:DisplayObject;
			for(var i:int = this.numChildren - 1;i>=0;i--)
			{
				obj = this.getChildAt(i);
				this.removeChildAt(i);
			}
			_totleHeight = 0;
			_col = 0;
		}
		
		
		public function get cellVector():Vector.<CellData>
		{
			return _cellVector;
		}
		
		public function set cellVector(cellVector:Vector.<CellData>):void
		{
			_cellVector = cellVector;
		}
		
		
		
	
	}
}