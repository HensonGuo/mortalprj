/**
 * @heartspeak
 * 2014-1-16 
 */   	

package mortal.game.view.tools
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	
	import flash.geom.Point;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.common.display.FlyToNavbarTool;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	
	public class FlyEntityController extends Controller
	{
		
		private var _lastCustomPoint:Point;
		
		public function FlyEntityController()
		{
			super();
		}
		
		override protected function initServer():void
		{
			super.initServer();
			Dispatcher.addEventListener(EventName.FlyItemToPack,flyItemToPackHandler);
		}
		
		/**
		 * 物品飞到背包 
		 * @param e
		 * 
		 */	
		private function flyItemToPackHandler(e:DataEvent):void
		{
			var itemData:ItemData = e.data as ItemData;
			var icon:String;
			icon = itemData.itemInfo.icon + ".jpg";
			LoaderManager.instance.load(icon,onLoaded);
		}
		
		private function onLoaded(info:ImageInfo):void
		{
			if(_lastCustomPoint == null)
			{
				_lastCustomPoint = new Point(RolePlayer.instance.stagePointX, RolePlayer.instance.stagePointY);
			}
			FlyToNavbarTool.flyToBackPack(info.bitmapData, _lastCustomPoint);
			_lastCustomPoint = null;
		}
	}
}