/**
 * @date 2011-3-14 上午11:09:07
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatPanel
{
	import com.gengine.core.IDispose;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.chat.chatViewData.ChatItemData;
	import mortal.game.view.chat.chatViewData.ChatType;

	public class ChatItem extends Sprite implements IDispose
	{
		private var _lineWidth:Number;
		private var _lineHeight:Number;
		private var _textBlock:TextBlock;
		private var _groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
		public function ChatItem()
		{
			
		}
		
		public function init(groupVector:Vector.<ContentElement> = null,width:int = 260,lineHeight:Number = 21):void
		{
			_lineWidth = width;
			_groupVector = groupVector;
			_lineHeight = lineHeight;
			this.mouseEnabled = false;
			createChildren();
		}
		
		/**
		 * 显示
		 */
		public function createChildren():void
		{
			if(!_groupVector || _groupVector.length == 0)
			{
				clear();
				return;
			}
			var groupElement:GroupElement = new GroupElement(_groupVector);
			_textBlock = new TextBlock();
			_textBlock.content = groupElement;
			createTextLines(_textBlock);
		}
		
		private function createTextLines(textBlock:TextBlock):void 
		{
			_totleHeight = 0;
			var isFirstLine:Boolean = true;
			var textLine:TextLine = textBlock.createTextLine (null, _lineWidth);
//			textLine.mouseChildren = false;
			while (textLine)
			{
				textLine.filters = [FilterConst.glowFilter];
				
				_col++;
//				trace(textLine.numChildren,textLine.atomCount);
//				textLine.removeChildAt(0);
//				textLine.getChildAt(0).filters = [FilterConst.glowFilter];
				addChild(textLine);
				textLine.mouseEnabled = false;
//				textLine.mouseChildren = false;
				textLine.doubleClickEnabled = false;
				
//				var textSprite:Sprite = textLine.getChildAt(0) as Sprite;
//				
//				for(var j:int = textSprite.numChildren -1 ;j>=0;j--)
//				{
//					var object:Object = textSprite.getChildAt(j);
//				}
				
//				trace(textLine.numChildren);
//				trace(textLine.getChildAt(0));
				
//				textLine.getChildAt(1).filters = [FilterConst.glowFilter];
//				for(var i:int = 0;i<textLine.atomCount;i++)
//				{
//					var obj:DisplayObject = textLine.getAtomGraphic(i);
//					if(obj)
//					{
//						obj.filters = [];
//						var objParent:DisplayObjectContainer = obj.parent;
//						trace(obj,objParent,objParent.parent,objParent.parent.parent);
//						trace(objParent.parent.numChildren,objParent.parent .getChildAt(0),objParent.parent.getChildAt(1));
//						trace(objParent.parent == textLine);
////						objParent.removeChild(obj);
////						objParent.addChild(obj);
//					}
//				}
				textLine.x = _col <= 1?0:5;
				_totleHeight += getLineHeight(textLine);
				textLine.y = _totleHeight + getTextLineYOffect(textLine);
				if(isFirstLine)
				{
					_firstLineHeight = getLineHeight(textLine);
					isFirstLine = false;
				}
				textLine = textBlock.createTextLine(textLine, _lineWidth);
			}
		}
		
		private var _normalHeight:Number = 19;
		private var _faceHeigth:Number = 24;
		private var _vipFaceHeigth:Number = 48;
		private var _firstLineHeight:Number = 18;
		
		private var _totleHeight:int = 0;
		
		private function isHaveFace(textLine:TextLine):Boolean
		{
			return textLine.height > 20;
		}
		
		private function isHaveVIPFace(textLine:TextLine):Boolean
		{
			return textLine.height > 30;
		}
		
		private function getLineHeight(textLine:TextLine):Number
		{
			return isHaveVIPFace(textLine)?_vipFaceHeigth:(isHaveFace(textLine)?_faceHeigth:_normalHeight);
		}
		
		private function getTextLineYOffect(textLine:TextLine):Number
		{
			return isHaveFace(textLine)?-6:-3;
		}
		
		public function getFirstLineHeight():Number
		{
			return _firstLineHeight;
		}
		
		public function set groupVector(value:Vector.<ContentElement>):void
		{
			_groupVector = value;
			clear();
			createChildren();
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
		
		private var _col:int = 0;
		
		public function get col():int
		{
			return _col;
		}
		
		override public function get height():Number
		{
			return _totleHeight;
//			return _col * _lineHeight;
		}
		
		public function get textBlock():TextBlock
		{
			return _textBlock;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			//trace("添加子对象",child);
			return super.addChild(child);	
		}

		public function get lineWidth():Number
		{
			return _lineWidth;
		}

		public function set lineWidth(value:Number):void
		{
			_lineWidth = value;
		}

		public function get lineHeight():Number
		{
			return _lineHeight;
		}

		public function set lineHeight(value:Number):void
		{
			_lineHeight = value;
		}

		public function dispose(isReuse:Boolean=true):void
		{
			clear();
			x = 0;
			y = 0;
			_groupVector = null;
			_textBlock = null;
			_lineWidth = 260;
			_lineHeight = 21;
			_normalHeight = 19;
			_faceHeigth = 24;
			_firstLineHeight = 18;
			ObjectPool.disposeObject(this);
		}
	}
}