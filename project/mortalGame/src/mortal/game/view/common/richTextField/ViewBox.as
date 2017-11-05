package mortal.game.view.common.richTextField
{
	import com.mui.controls.GSprite;
	
	import flash.display.Sprite;
	
	import mortal.game.view.richTextField.RichTextField;

	public class ViewBox extends GSprite
	{
		private var _itemVec:Vector.<RichTextField>
		
		private var _totalHeight:Number = 0;
		
		private var _topPading:Number = 12;
		
		private var _lineHeight:Number;
		
		private var _col:int;
		
		
		/**
		 * 
		 * @param topPading  上间距
		 * @param lintHeight  行间距
		 * 
		 */		
		public function ViewBox(topPading:Number = 12,lintHeight:Number = 0)
		{
			super();
			_lineHeight = lintHeight;
			_topPading = topPading;
			_itemVec = new Vector.<RichTextField>;
			this.mouseEnabled = false;
		}
		
		/**
		 * 添加内容 
		 * @param rtf
		 * 
		 */		
		public function addMsg(rtf:RichTextField):void
		{
			_col++;
			_itemVec.push(rtf);
			rtf.y = _totalHeight + this.y + 20 + (_col - 1)*_lineHeight;
			_totalHeight += (rtf.height + _topPading);
			addChild(rtf);
		}
		
		public function get topPading():Number
		{
			return _topPading;
		}
		
		public function set topPading(num:Number):void
		{
			_topPading = num;
		}
	}
}