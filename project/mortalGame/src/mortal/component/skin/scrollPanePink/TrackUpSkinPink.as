package mortal.component.skin.scrollPanePink
{
	import flash.geom.Rectangle;
	
	import mortal.component.skin.scrollPane.BaseScrollSkill;
	import mortal.game.resource.ImagesConst;
	
	public class TrackUpSkinPink extends BaseScrollSkill
	{
		public function TrackUpSkinPink(fullClassName:String=null, scale9Grid:Rectangle=null)
		{
			super(ImagesConst.ChatScrollTrackUpSkin, new Rectangle(2,8,1,1));
		}
		override public function set width(value:Number):void
		{
			if(bitmap && _scale9Grid && !isNaN(value))
			{
				bitmap.width = 3;
				bitmap.x = 5;
			}
		}
	}
}