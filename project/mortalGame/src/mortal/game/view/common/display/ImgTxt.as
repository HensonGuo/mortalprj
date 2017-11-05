/**
 * @date	2011-3-11 下午10:24:37
 * @author  宋立坤
 * 
 */	
package mortal.game.view.task.imgtxt
{
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mortal.game.view.common.display.FlyFootBmp;
	
	public class ImgTxt extends Sprite
	{
		private var _textField:TextField;

		private var _dic:Array = [];
		private var _linkIndex:int;
		
		public function ImgTxt()
		{
			mouseEnabled = false;
			super();
		}
		
		public function getLinkIndex(key:Object):int
		{
			if(_dic[key] != null)
			{
				return _dic[key];
			}
			return 0;
		}
		
		private const replaceStr:String = HTMLUtil.addColor("       ","#ffffff");
		
		/**
		 * 构建图片txt 
		 * @param str
		 * @param staIndex
		 * @param textField
		 * @param imgName
		 * @param hide
		 * @return 
		 * 
		 */
		public function bulidPic(str:String,staIndex:int,textField:TextField,imgName:String,hide:Boolean=false,replaceType:int = 0):int
		{
			_linkIndex = int(str.substr(1));
			_textField = textField;
			
			var startNum:Number = textField.text.indexOf(str,staIndex);
			
			var r:Rectangle = textField.getCharBoundaries(startNum);
			
			if(r==null)
			{
				return startNum+1;
			}
			
			if(textField.getLineIndexOfChar(startNum)>(textField.bottomScrollV))
			{
				return textField.text.length;
			}
				
			if(hide)
			{
				textField.htmlText = textField.htmlText.replace(str,"");
			}
			else
			{
				var bitmap:FlyFootBmp = ObjectPool.getObject(FlyFootBmp);
				bitmap.update();
				bitmap.x = r.x+textField.x-1;
				bitmap.y = r.y-(textField.scrollV-1)*textField.getLineMetrics(0).height+textField.y-2;
				bitmap.name = _linkIndex + "";
				this.addChild(bitmap);

				var repStr:String = replaceType == 0?replaceStr:"      ";
				if(r.x <= 10)//在一行的开头
				{
					repStr = replaceType == 0?"\n"+replaceStr:"\n    ";
				}
				else if(r.x >= textField.width-45)//在行末
				{
					if(textField.text.indexOf(str) < textField.text.length - 3)//后面还有数字
					{
						repStr = "\n"
					}
				}
				
				textField.htmlText = textField.htmlText.replace(str,repStr);
			}
				
			
			return startNum+1;
			
		} 
		
		public function getImgRect():Rectangle
		{
			if(numChildren > 0)
			{
				var sprite:Sprite = getChildAt(0) as Sprite;
				if(sprite != null)
				{
					return new Rectangle(sprite.x,sprite.y,sprite.width,sprite.height);
				}
			}
			return new Rectangle(x,y,width,height);
		}
		
		public function getTargetRect(txt:String):Rectangle
		{
			if(_textField == null)
			{
				return new Rectangle(x,y,width,height);;
			} 
			var startNum:Number = _textField.text.indexOf(txt);
			var r:Rectangle = _textField.getCharBoundaries(startNum);
			if(r == null)
			{
				return getImgRect();	
			}
			r.x += _textField.x;
			r.y += -(_textField.scrollV-1)*_textField.getLineMetrics(0).height+_textField.y-2;
			r.width *= txt.replace(" ","") .length;
			return r;
		}
			
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			_dic.splice(0);
			_textField = null;
			var sprite:FlyFootBmp;
			while(numChildren > 0)
			{
				sprite = getChildAt(0) as FlyFootBmp;
				sprite.dispose();
				removeChild(sprite);
				ObjectPool.disposeObject(sprite);
			}
		}
	}
}