/**
 * @date	Mar 9, 2011 4:44:22 PM
 * @author  huangliang
 * 
 */
package mortal.game.view.common.tooltip.tooltips.base
{
	import com.mui.controls.BaseToolTip;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mortal.common.DisplayUtil;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 
	 * @author huangliang
	 */
	
	public class ToolTipScaleBg extends BaseToolTip
	{
//		protected var bg:Bitmap;
		
		
		protected var _bgName:String;
		
		protected var _scaleBg:ScaleBitmap;
		/**
		 * 
		 */
		public function ToolTipScaleBg()
		{
			super();
			
			super.addChild(contentContainer2D);
		}
		
		public function setBg(bgName:String="ToolTipBg"):void
		{
			if(_bgName == bgName)
			{
				return;
			}
			_bgName = bgName;
			if(_scaleBg != null)
			{
				_scaleBg.dispose(true);
				_scaleBg = null;
			}
			_scaleBg = UIFactory.bg(0, 0, 120, 60, null, _bgName);//ResourceConst.getScaleBitmap(_bgName);
			super.addChildAt(_scaleBg, 0);
		}
		
		override protected function updateSize(w:Number,h:Number):void
		{
//			_scaleBg.width = _width;
//			_scaleBg.height = _height;
			super.updateSize(w, h);
			if(_scaleBg != null)
			{
				_scaleBg.setSize(_width, _height);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(contentContainer2D != child)
			{
				this.contentContainer2D.addChild(child);
			}
			else
			{
				super.addChild(child);
			}
			return child;
		}
	}
}