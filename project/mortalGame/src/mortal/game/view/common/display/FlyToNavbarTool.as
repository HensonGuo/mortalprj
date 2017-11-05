package mortal.game.view.common.display
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import modules.NavbarModule;
	
	import mortal.common.DisplayUtil;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.GameController;
	import mortal.game.view.common.ModuleType;
	
	/**
	 * 
	 * @author liuxuejiao
	 */
	public class FlyToNavbarTool
	{
		/**
		 * 飞入“背包”等用的时间秒
		 */
		public static const FlyToTime:Number = 1.5;
		/**
		 * 
		 */
		public function FlyToNavbarTool()
		{
		}
		/**
		 * 物品 飞到 背包 
		 * @param bitmapdata
		 * @param startPoint
		 * 
		 */
		public static function flyToBackPack( bitmapdata:BitmapData ,startPoint:Point ):void
		{
			var bitmap:Bitmap = new Bitmap( bitmapdata );
			bitmap.x = startPoint.x;
			bitmap.y = startPoint.y;
			bitmap.width = 36;
			bitmap.height = 36;
			LayerManager.topLayer.addChild(bitmap);
			var toPoint:Point = (GameController.navbar.view as NavbarModule).getNavbarIconGlobalPoint(ModuleType.Pack);
			TweenLite.to(bitmap, FlyToTime, {x:toPoint.x+10, y:toPoint.y+10, onComplete:onComplete, onCompleteParams:[bitmap]});
		}
		
		private static function onComplete(bitmap:Bitmap):void
		{
			if( bitmap && bitmap.parent )
			{
				bitmap.parent.removeChild(bitmap);
				bitmap = null;
			}
		}
		
		/**
		 * 物品 飞到 任意位置
		 * @param bitmapdata
		 * @param startPoint
		 * @param endPoint
		 * @param callBack
		 * @param isRemove 完成后是否移除
		 */
		public static function flyToAnyPoint( bitmapdata:BitmapData, startPoint:Point, endPoint:Point,callBack:Function = null, width:int = 0, height:int = 0, isRemove:Boolean=false):void
		{
			var bitmap:Bitmap = new Bitmap(bitmapdata);
			bitmap.x = startPoint.x;
			bitmap.y = startPoint.y;
			
			if(width != 0 && height != 0)
			{
				bitmap.width = width;
				bitmap.height = height;
			}
			
			LayerManager.topLayer.addChild(bitmap);
			TweenLite.to(bitmap, FlyToTime, {x:endPoint.x, y:endPoint.y,onComplete:onFlyToAnyPointEnd,onCompleteParams:[bitmap,callBack,isRemove]});
		}
		
		/**
		 * 飞到任务位置完成 
		 * 
		 */
		private static function onFlyToAnyPointEnd(bm:Bitmap,callBack:Function, isRemove:Boolean):void
		{
			if(callBack != null)
			{
				if(bm != null)
				{
					callBack(bm);
				}
			}
			if(isRemove)
			{
				DisplayUtil.removeMe(bm);
			}
		}
	}
}