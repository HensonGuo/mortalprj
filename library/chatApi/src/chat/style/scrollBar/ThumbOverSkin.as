/**
 * @date 2011-4-29 下午04:40:12
 * @author  wyang
 * 
 */  

package chat.style.scrollBar
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ThumbOverSkin extends BaseScrollSkill
	{
		public function ThumbOverSkin()
		{
			super(thumbOverSkin,new Rectangle(6,7,4,19));
//			pic = GlobalClass.getScaleBitmap("thumbOverSkin",new Rectangle(8,17,1,1));
//			this.addChild(pic);
		}
	}
}