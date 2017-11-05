/**
 * author chenriji
 * 2012年9月15日9:53:43
 */
package mortal.common
{
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GUIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mortal.component.gconst.FilterConst;

	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		/**
		 * 删除所有儿子 
		 * @param sp
		 * 
		 */		
		public static function removeAllChild(sp:DisplayObjectContainer):void
		{
			while(sp.numChildren > 0)
			{
				sp.removeChildAt(0);
			}
		}
		
		/**
		 * 获取字符串所占用的像素点 
		 * @param str
		 * @param fontSize
		 * @return 
		 * 
		 */		
		public static function getStringPixes(str:String, fontSize:int=12):int
		{
			var res:int = 0;
			if(str == null || str == "")
				return res;
			for(var i:int = 0; i < str.length; i++)
			{
				if(str.charCodeAt(i) < 255)
				{
					res += fontSize/2;
				}
				else
				{
					res += fontSize;
				}
			}
			return res;
		}
		
		/**
		 * 从显示列表中移除，null，或者没有parent不报错 
		 * @param mc
		 * 
		 */		
		public static function removeMe(mc:DisplayObject):void
		{
			if(mc == null)
			{
				return;
			}
			if(mc.parent != null)
			{
				mc.parent.removeChild(mc);
			}
		}
		
		/**
		 * @params 
		 * 		bmd:矩形bitmapData
		 * @return 非透明的不规矩形状Sprite
		 */
		public static function getNoneTransparentSprite(bmd:BitmapData):GSprite
		{
			if(bmd == null)
				return new GSprite();
			var width:int = bmd.width;
			var height:int = bmd.height;
			var res:GSprite = new GSprite();
			res.graphics.beginFill(0);
			
			for(var x:uint = 0; x < width; x++)  
			{  
				for(var y:uint = 0; y< height; y++)  
				{
					var color:uint = bmd.getPixel32(x,y);
					if(color)
					{ 
						res.graphics.beginFill(color);
						res.graphics.drawRect(x, y, 1, 1);
					}
				}  
			}  
			//以graphics画出bit的无透明区域  
			res.graphics.endFill();
			return res;
		}
		
		/**
		 * 获取显示对象的bitMapData 
		 * @param displayObj
		 * @return 
		 * 
		 */		
		public static function getBitMapData(displayObj:DisplayObject):BitmapData
		{
			if(displayObj == null 
				|| displayObj.width < 1 
				|| displayObj.height < 1)
			{
				return null;
			}
			var res:BitmapData = new BitmapData(displayObj.width, displayObj.height);
			res.draw(displayObj);
			return res;
		}
		
		/**
		 * 检查BitmapData是否可用、是否合法
		 */
		public static function isBitmapDataUsable(bitmapData:BitmapData):Boolean
		{
			if(bitmapData == null)
			{
				return false;
			}
			try
			{
				bitmapData.getPixel32(1, 1);
			}
			catch(err:Error)
			{
				return false;
			}
//			if(bitmapData.width == 0 || bitmapData.height == 0)
//			{
//				return false;
//			}
			return true;
		}
		
		/**
		 * 画透明度渐变的椭圆（圆形也在范围内） 
		 * @param sp 目标sprite
		 * @param color 颜色
		 * @param rx X半径
		 * @param ry Y半径
		 * @param outAlpha 最外围一圈的透明度
		 * @param centerAlpha 最内一圈的透明度
		 * @param precision 渐变精度，多少个像素点画一个渐变圈
		 * 
		 */		
		public static function drawFadingEllipse(sp:Sprite, color:uint, rx:int, ry:int, outAlpha:Number=0.13, centerAlpha:Number=0.8, precision:int=3):void
		{
			if(sp == null)
			{
				return;
			}
			sp.graphics.clear();
			var rate:Number = ry/rx;
			for(var i:int = 1; i <= rx; i += precision)
			{
				var alpha:Number = centerAlpha - (i/rx * (centerAlpha - outAlpha));
				sp.graphics.lineStyle(precision + 1, color, alpha);
				sp.graphics.drawEllipse(-i, -i*rate, i*2, i*2*rate);
			}
			sp.cacheAsBitmap = true;
		}
		
		/**
		 * 画中间漏空的一个遮罩， 回字形  
		 * @param sp
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param color
		 * @param alpha
		 * @param screenSize 屏幕大小（画的大小是，上下左右，都多出一个屏幕
		 * 
		 */			
		public static function drawHollowMask(sp:Sprite, width:int, height:int, color:uint=0x000000, alpha:Number=0.6, screenSize:int=1200):void
		{
			sp.graphics.clear();
			sp.graphics.beginFill(color, alpha);
			sp.graphics.drawRect(-screenSize, -screenSize, screenSize , screenSize*3);
			sp.graphics.drawRect(0, -screenSize, width, screenSize);
			sp.graphics.drawRect(0, height, width, 2*screenSize);
			sp.graphics.drawRect(width, -screenSize, 2*screenSize, 3*screenSize);
			sp.graphics.endFill();
			sp.cacheAsBitmap = true;
		}
		
		/**
		 * 获取属性名称的值为对应value值的儿子
		 * @param parent
		 * @param childName
		 * @return 
		 * 
		 */		
		public static function getChildByPropety(parent:DisplayObjectContainer, propertyName:String, value:*):DisplayObject
		{
			if(parent == null || parent.numChildren == 0)
			{
				return null;
			}
			var len:int = parent.numChildren;
			var subChild:DisplayObject;
			for(var i:int = 0; i < len; i++)
			{
				var child:DisplayObject = parent.getChildAt(i);
				if(child != null && child.hasOwnProperty(propertyName) && child[propertyName] == value)
				{
					return child;
				}
				if(child is DisplayObjectContainer)
				{
					subChild = getChildByPropety(child as DisplayObjectContainer, propertyName, value);
					if(subChild != null)
					{
						return subChild;
					}
				}
			}
			return null;
		}
		
		/**
		 * 两个可视对象的相对位置 
		 * @param contrastObj 参照物
		 * @param object object相对constratObj的相对位置
		 * @return 
		 * 
		 */		
		public static function getRelativePlace(contrastObj:DisplayObject, object:DisplayObject):Point
		{
			var pp:Point = new Point(0, 0);
			if(contrastObj == null || object == null)
			{
				return pp;
			}
			var p1:Point = contrastObj.localToGlobal(pp);
			var p2:Point = object.localToGlobal(pp);
			pp.x = p2.x - p1.x;
			pp.y = p2.y - p1.y;
			return pp;
		}
		
		/**
		 * 移除所有child， 并且释放所包含的GUIComponent  
		 * @param parent  被释放对象
		 * @param isReuse 是否回收
		 * @param isLoop 是否递归到每一层进行释放工作
		 * 
		 */		
		public static function removeAndDisposeAllGUIComponent(parent:DisplayObjectContainer, 
															   isReuse:Boolean=true, isLoop:Boolean=true):void
		{
			if(parent == null)
			{
				return;
			}
			var num:int = parent.numChildren;
			for(var i:int = num-1; i >= 0; i--)
			{
				var child:DisplayObject = parent.getChildAt(i);
				if(child == null)
				{
					continue;
				}
				parent.removeChild(child);
				if(child is GUIComponent)
				{
					GUIComponent(child).dispose(isReuse);
				}
				else if(isLoop && (child is DisplayObjectContainer))
				{
					removeAndDisposeAllGUIComponent(child as DisplayObjectContainer, isReuse, isLoop);
				}
			}
		}
		
		/**
		 * 设置组件的enable属性， 以及mouseEnable属性, 对于没有enabled属性的组件，设置filters
		 * @param obj 要设置的对象
		 * @param value 
		 * @param isSetMouseEnabled 是否设置mouseEnabled属性的值为value参数
		 * 
		 */		
		public static function setEnabled(obj:InteractiveObject, value:Boolean, isSetMouseEnabled:Boolean=true):void
		{
			if(obj == null)
			{
				return;
			}
			if(obj["enabled"] != null)
			{
				obj["enabled"] = value;
			}
			else
			{
				if(value)
				{
					obj.filters = [];
				}
				else
				{
					obj.filters = [FilterConst.colorFilter];
				}
			}
			
			if(isSetMouseEnabled)
			{
				obj.mouseEnabled = value;
			}
		}
		
		/**
		 * 把target添加到container中，需要将target显示最大化，但是不能放大 
		 * @param containerWidth
		 * @param containerHeight
		 * @param targetWidth
		 * @param targetHeight
		 * @return target最终的缩放大小
		 * 
		 */		
		public static function calculateFixedScale(containerWidth:int, containerHeight:int, targetWidth:int, targetHeight:int):Number
		{
			var d1:Number = containerWidth/containerHeight;
			var d2:Number = targetWidth/targetHeight;
			var res:Number;
			if(d1 > d2)
			{
				res = containerHeight/targetHeight;
			}
			else
			{
				res = containerWidth/targetWidth;
			}
			return res > 1? 1: res;
		}
	}
}