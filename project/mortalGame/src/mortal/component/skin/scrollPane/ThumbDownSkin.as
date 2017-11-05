/**
 * @date 2011-4-29 下午04:41:19
 * @author  wyang
 * 
 */  

package mortal.component.skin.scrollPane
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ThumbDownSkin extends BaseScrollSkill
	{
		private var pic:Bitmap;
		public function ThumbDownSkin()
		{
			super("thumbUpSkin");
//			pic = GlobalClass.getScaleBitmap("thumbUpSkin", new Rectangle(8,17,1,1));
//			this.addChild(pic);
		}
	}
}