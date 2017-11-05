package modules
{
	import Message.Public.SPoint;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	public class MapNavBarModule extends View
	{
		private var _bg:GBitmap;
		private var _btn:GLoadedButton;
		private var _txt:GTextFiled;
		
		public function MapNavBarModule()
		{
			super();
			this.layer = LayerManager.uiLayer;
			this.mouseEnabled = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.gBitmap(ImagesConst.MapRightTop_bg, 0, 0, this);
			_btn = UIFactory.gLoadedButton(ImagesConst.MapBall_upSkin, 201, 7, 58, 57, this);
			
			var tf:TextFormat = GlobalStyle.textFormatPutong;
			tf.align = TextAlign.CENTER;
			_txt = UIFactory.gTextField("", 0, 25, 228, 20, this, tf);
			_btn.configEventListener(MouseEvent.CLICK, openSmallMapHandler);
		}
		
		public function updateToCurrent(p:SPoint=null):void
		{
			if(Game.mapInfo == null)
			{
				return;
			}
			var mapName:String = GameMapConfig.instance.getMapInfo(Game.mapInfo.mapId).name;
			_txt.text = mapName + " (" + int(RolePlayer.instance.x2d).toString() + ", " 
				+ int(RolePlayer.instance.y2d).toString() + ")";
		}
		
		private function openSmallMapHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapShowHide));
		}
		
		override public function stageResize():void
		{
			this.x = SceneRange.display.width - 270;
			this.y = 0;
		}
	}
}