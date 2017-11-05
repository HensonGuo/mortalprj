package mortal.component.skin.scrollPanePink
{
	import flash.geom.Rectangle;
	
	import mortal.component.skin.scrollPane.BaseScrollSkill;
	import mortal.game.resource.ImagesConst;
	
	public class ThumbUpSkinPink extends BaseScrollSkill
	{
		public function ThumbUpSkinPink(fullClassName:String=null, scale9Grid:Rectangle=null)
		{
			super(ImagesConst.ChatScrollThumbUpSkin, new Rectangle(5,7,1,10));
		}
		
		override public function set width(value:Number):void
		{
			if(bitmap && _scale9Grid && !isNaN(value))
			{
				bitmap.width = 9;
				bitmap.x = 2;
			}
		}
		
//		override public function set height(value:Number):void
//		{
//			value = value < 25?25:value;
//			super.height = value;
//		}
	}
}