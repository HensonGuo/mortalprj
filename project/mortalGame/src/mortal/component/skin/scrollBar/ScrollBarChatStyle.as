package mortal.component.skin.scrollBar
{
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	
	import mortal.component.skin.scrollPanePink.DownArrowOverSkinPink;
	import mortal.component.skin.scrollPanePink.DownArrowUpSkinPink;
	import mortal.component.skin.scrollPanePink.ThumbOverSkinPink;
	import mortal.component.skin.scrollPanePink.ThumbUpSkinPink;
	import mortal.component.skin.scrollPanePink.TrackUpSkinPink;
	import mortal.component.skin.scrollPanePink.UpArrowOverSkinPink;
	import mortal.component.skin.scrollPanePink.UpArrowUpSkinPink;
	
	public class ScrollBarChatStyle extends SkinStyle
	{
		private var _rect:Rectangle = new Rectangle(3,4,12,11);
		public function ScrollBarChatStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			
			//向下按钮
			component.setStyle("downArrowUpSkin",DownArrowUpSkinPink);
			component.setStyle("downArrowOverSkin",DownArrowOverSkinPink);
			component.setStyle("downArrowDownSkin",DownArrowUpSkinPink);
			component.setStyle("downArrowDisabledSkin",DownArrowUpSkinPink);
			
			//向上按钮
			component.setStyle("upArrowUpSkin",UpArrowUpSkinPink);
			component.setStyle("upArrowOverSkin",UpArrowOverSkinPink);
			component.setStyle("upArrowDownSkin",UpArrowUpSkinPink);
			component.setStyle("upArrowDisabledSkin",UpArrowUpSkinPink);
			
			//轨道底
			component.setStyle("trackUpSkin",TrackUpSkinPink);
			component.setStyle("trackOverSkin",TrackUpSkinPink);
			component.setStyle("trackDownSkin",TrackUpSkinPink);
			component.setStyle("trackDisabledSkin",TrackUpSkinPink);
			
			//滑块
			component.setStyle("thumbUpSkin", ThumbUpSkinPink);
			component.setStyle("thumbOverSkin", ThumbOverSkinPink);
			component.setStyle("thumbDownSkin", ThumbUpSkinPink);
			component.setStyle("thumbDisabledSkin",ThumbUpSkinPink);
			
//			component.setStyle("contentPadding",13);
		}
	}
}