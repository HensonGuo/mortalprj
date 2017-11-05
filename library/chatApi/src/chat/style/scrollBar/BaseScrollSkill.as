package chat.style.scrollBar
{
	import chat.ChatRes;
	
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class BaseScrollSkill extends Sprite
	{
		
		protected var bitmap:ScaleBitmap;
		protected var _scale9Grid:Rectangle;
		public function BaseScrollSkill( cls:Class = null ,scale9Grid:Rectangle = null  )
		{
			_scale9Grid = scale9Grid;
			if( cls )
			{
				bitmap = ChatRes.getScaleBitmap(cls,scale9Grid);
			}
			if( bitmap )
			{
				this.addChild(bitmap);
			}
		}
		
		override public function set width(value:Number):void
		{
//			super.width = value;
			if(bitmap && _scale9Grid && !isNaN(value))
			{
				bitmap.width = 16;
			}
		}
		
		override public function set height(value:Number):void
		{
//			super.height = value;
			if(bitmap && _scale9Grid && !isNaN(value))
			{
				bitmap.height = value;
			}
		}
	}
}