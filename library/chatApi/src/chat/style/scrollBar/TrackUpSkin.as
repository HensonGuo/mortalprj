/**
 * @date 2011-4-29 下午04:25:44
 * @author  wyang
 * 
 */  

package chat.style.scrollBar
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class TrackUpSkin extends BaseScrollSkill
	{
		public function TrackUpSkin()
		{
			super(trackUpSkin,new Rectangle(5,8,6,17));
//			this.addChild(GlobalClass.getScaleBitmap("trackUpSkin",new Rectangle(8,17,1,1)));
		}
		override public function set width(value:Number):void
		{
			if(bitmap && _scale9Grid && !isNaN(value))
			{
				bitmap.width = 16;
			}
		}
	}
}