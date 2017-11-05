package mortal.game
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 游戏布局类 
	 * @author jianglang
	 * 
	 */	
	public class GameLayout
	{
		private var _stage:Stage = Global.stage;
		
		private static var _instance:GameLayout;
		
		private var _resizeCount:int = 0;
		
		private var _isReSize:Boolean = false;//是否缩放
		
		private var _stageChangeW:Number = 1;			//舞台宽度改变量
		private var _stageChangeH:Number = 1;			//舞台高度改变量
		
		public function GameLayout( )
		{
			if( _instance != null )
			{
				throw new Error(" GameLayout 是单例 ");
			}
		}
		
		public static function get instance():GameLayout
		{
			if( _instance == null )
			{
				_instance = new GameLayout();
			}
			return _instance;
		}
		
		public function get stageChangeW():Number
		{
			return _stageChangeW;
		}
		
		public function get stageChangeH():Number
		{
			return _stageChangeH;
		}
		
		public function init():void
		{
			_stage.addEventListener(Event.RESIZE,onResizeHandler);
		}
		
		private function onResizeHandler( event:Event ):void
		{
			if( event.target is Stage )
			{
				if( _isReSize == false )
				{
					_isReSize = true;
					setTimeout(resize,50);
				}
				_resizeCount++;
//				resize();
			}
		}
		
		public function resize( isForce:Boolean = true ):void
		{
//			if( isForce )
//			{
//				if( _resizeCount > 0 )
//				{
//					return;					
//				}
//			}
			Log.debug("场景resize:"+_resizeCount);
			_resizeCount = 0;
			_isReSize = false;
			
			//注意:此处变为偶数，防止3d场景中文字出现模糊；
			var swidth:int = int( _stage.stageWidth*0.5)*2;
			var sheight:int = int(_stage.stageHeight*0.5)*2;
			
			swidth>2048 && (swidth=2048)//3d场景宽最大为2048，否则性能急聚下降
			sheight>1024 && (sheight=1024);//3d场景高最大为1024，否则性能急聚下降
			
			_stageChangeW =  swidth/SceneRange.display.width;
			_stageChangeH = sheight/SceneRange.display.height;

			
			SceneRange.display.width = swidth;
			SceneRange.display.height = sheight;
			
			if( Game.mapInfo )
			{
				SceneRange.init(Game.mapInfo);
			}
			
			if(Game.scene.isInLockScene)
			{
				Game.scene.scrollRect = SceneRange.display;
			}
			else if( RolePlayer.instance.isInitInfo)
			{
				RolePlayer.instance.setPixlePoint(RolePlayer.instance.x2d,RolePlayer.instance.y2d,true,false);
			}
			Game.scene.resetViewPort();
			
			MsgManager.resize();
			EffectManager.stageResize();
			
			LayerManager.uiLayer.stageResize();
			LayerManager.smallIconLayer.stageResize();
			LayerManager.windowLayer.resize(_stageChangeW,_stageChangeH);
			
//			trace("bitmap:" + SceneRange.bitmap );
//			trace("display:" + SceneRange.display );
//			trace("map:" + SceneRange.map );
//			trace("moveMap:" + SceneRange.moveMap );
			Dispatcher.dispatchEvent(new DataEvent(EventName.StageResize));
		}
	}
}