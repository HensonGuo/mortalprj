/**
 * @date 2013-1-15 上午11:08:39
 * @author chenriji
 */
package mortal.common.text
{
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GTextFiled;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mortal.common.DisplayUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.view.common.UIFactory;
	
	public class AutoLayoutTextContainer extends GBox
	{
		 //所有的text
		private var _texts:Array;
		
		//不参与自动调节位置的索引 	
		private var _neverLayoutIndexs:Array;
		
		/**
		 * visible属性是否影响参与自动调节位置 
		 */		
		public var layoutByVisible:Boolean = true;
		/**
		 * visible属性为false的不参与自动调节位置 
		 */		
		public static const layoutByVisible_Work:Boolean = true;
		/**
		 * visible属性为false的参与自动调节位置 
		 */		
		public static const layoutByVisible_Not_Work:Boolean = false;
		
		/**
		 * 文本等容器， 主要是加入了方便添加文本的处理, 也可以addChild任何DisplayObect
		 * 支持竖直、水平方向自动排列的文本容器， 对GBox进行了装饰， 更加方便添加文本、修改文本内容等
		 * 默认：GBoxDirection.VERTICAL
		 * 默认：verticalGap = 5
		 * @author chenriji
		 * 
		 */	
		public function AutoLayoutTextContainer()
		{
			super();
			this.direction = GBoxDirection.VERTICAL;
			this.verticalGap = 5;
			this.layoutByVisible = true;
		}
		
		/**
		 * 添加一个新的文本显示，并且立马刷新layout
		 * @param index
		 * @param str
		 * @param textWidth
		 * @param size
		 * @param autoStr
		 * @param leading
		 * @param format
		 * @param bold 是否粗体字
		 * @return 
		 * 
		 */		
		public function addNewText(textWidth:int=220, str:String="", size:int=12, color:uint=0xB1efff, 
								   autoStr:String=TextFieldAutoSize.LEFT, leading:int=3, 
								   format:TextFormat=null, bold:Boolean=false):GTextFiled
		{
			var txt:GTextFiled = UIFactory.autoSizeGTextFiled(str, 0, 0, textWidth, this, autoStr, leading);
			var tf:TextFormat = txt.defaultTextFormat;
			tf.size = size;
			tf.color = color;
			tf.bold = bold;
			txt.defaultTextFormat = tf;
			
			if(format != null)
			{
				txt.defaultTextFormat = format;
			}
			if(_texts == null)
			{
				_texts = [];
			}
			_texts.push(txt);
			resetPosition();
			
			return txt;
		}
		
		/**
		 * 添加不参与自动调节位置的索引 
		 * @param index
		 * 
		 */		
		public function addNeverLayoutIndex(index:int):void
		{
			if(_neverLayoutIndexs == null)
			{
				_neverLayoutIndexs = [];
			}
			if(_neverLayoutIndexs.indexOf(index))
			{
				return;
			}
			_neverLayoutIndexs.push(index);
		}
		
		/**
		 * 删除不参与自动调节位置的索引 
		 * @param index
		 * 
		 */		
		public function delNeverLayout(index:int):void
		{
			if(_neverLayoutIndexs == null)
			{
				return;
			}
			var i:int = _neverLayoutIndexs.indexOf(index);
			if(i < 0)
			{
				return;
			}
			_neverLayoutIndexs.splice(i, 1);
		}
		
		/**
		 *  重写位置调整
		 *  修改为： 不可见的不参与排列
		 * 
		 */		
		protected override function resetPosition():void
		{
			var i:int, len:int = 0;
			const numChildren:int = this.numChildren;
			var o:DisplayObject;
			
			if (this.direction == GBoxDirection.VERTICAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i);
					if(!shouldLayout(i, o))
					{
						continue;
					}
					o.x = 0;
					o.y = len + verticalGap;
					len = o.y + o.height;
				}
			}
			else if (this.direction == GBoxDirection.HORIZONTAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i);
					if(!shouldLayout(i, o))
					{
						continue;
					}
					o.x = len + horizontalGap;
					o.y = 0;
					len = o.x + o.width;
				}
			}
		}
		
		/**
		 * 是否应该参与位置自动调节 
		 * @param index
		 * @param obj
		 * @return 
		 * 
		 */		
		private function shouldLayout(index:int, obj:DisplayObject):Boolean
		{
			if(_neverLayoutIndexs != null && _neverLayoutIndexs.indexOf(index) >= 0)
			{
				return false;
			}
			if(layoutByVisible == layoutByVisible_Work && obj.visible == false)
			{
				return false;
			}
			if(obj is TextField && (TextField(obj).text == ""))
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 删除之后的 
		 * @param index
		 * 
		 */		
		public function split(index:int):void
		{
			if(_texts == null)
			{
				return;
			}
			var len:int = _texts.length;
			for(var i:int = index; i < len; i++)
			{
				DisplayUtil.removeMe(_texts[i]);
			}
			if(i != index)
			{
				_texts.splice(index);
			}
		}
		
		/**
		 * 设置某个文本的内容，并且立马刷新layout
		 * @param index
		 * @param str
		 * @param isSetHtml
		 * @return 
		 * 
		 */			
		public function setText(index:int, str:String, isSetHtml:Boolean=true):Boolean
		{
			var txt:GTextFiled = getTextByIndex(index);
			if(txt == null)
			{
				return false;
			}
			if(isSetHtml)
			{
				txt.htmlText = str;
			}
			else
			{
				txt.text = str;
			}
			resetPosition();
			return true;
		}
		
		/**
		 * 根据下标获取GTextField
		 * @param index
		 * @return 
		 * 
		 */		
		public function getTextByIndex(index:int):GTextFiled
		{
			if(_texts == null)
			{
				return null;
			}
			return _texts[index];
		}
		
		override public function get height():Number
		{
			if(this.direction == GBoxDirection.HORIZONTAL)
			{
				return super.height;
			}
			else if(this.direction == GBoxDirection.VERTICAL)
			{
				for(var i:int = this.numChildren - 1; i >= 0; i--)
				{
					var lastObj:DisplayObject = this.getChildAt(i);
					if(shouldLayout(i, lastObj))
					{
						return lastObj.y + lastObj.height; 
					}
				}
				return 0;
			}
			return super.height;
		}
		
		override public function get width():Number
		{
			if(this.direction == GBoxDirection.HORIZONTAL)
			{
				for(var i:int = this.numChildren - 1; i >= 0; i--)
				{
					var lastObj:DisplayObject = this.getChildAt(i);
					if(shouldLayout(i, lastObj))
					{
						return lastObj.x + lastObj.width; 
					}
				}
				return 0;
			}
			else if(this.direction == GBoxDirection.VERTICAL)
			{
				return super.width;
			}
			return super.width;
		}
	}
}