/**
 * @date 2011-4-29 下午04:38:48
 * @author  wyang
 * 
 */  

package chat.style.scrollBar
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ThumbUpSkin extends BaseScrollSkill
	{
		private var pic:Bitmap;
		public function ThumbUpSkin()
		{
			super(thumbUpSkin,new Rectangle(6,7,4,19));
//			pic = GlobalClass.getScaleBitmap("thumbUpSkin",new Rectangle(8,17,1,1));
//			this.addChild(pic);
		}
	}
}