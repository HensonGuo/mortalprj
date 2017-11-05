package extend.flash.fireworks
{
	
	import com.gengine.utils.MathUitl;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.scene.player.info.ModelUtil;
	
	/**
	 * 烟花管理类 
	 * @author jianglang
	 * 
	 */	
	public class FWManager
	{
		private var _fwCache:Dictionary;
		
		private static var _instance:FWManager;
		
		public function FWManager()
		{
			if( _instance != null )
			{
				throw new Error( " FWManager is only a instance " );
			}
			_fwCache = new Dictionary();
		}
		
		public static function get instance():FWManager
		{
			if( _instance == null )
			{
				_instance = new FWManager();
			}
			return _instance;
		}
		/**
		 * 播放烟花 根据类型和编号 
		 * @param type
		 * @param index
		 * 
		 */		
		public function popup( type:int , index:int ,p:Point,fireType:int = 0,url:String = "",playType:int = FirePlayType.OrderPlay,interval:int = 300):void
		{
			if(url == "")
			{
				url = "fwSkill" + type+index + ".swf";
			}
			var fw:Fireworks = new Fireworks( url , p);
			fw.start(fireType,playType,interval);
//			addToStage( fw ) ;
		}
		
		public function fireWorksRandom():void
		{
//			FWManager.instance.popup(MathUitl.random(1,2),MathUitl.random(1,3));
		}
		
		private function addToStage( displayObject:DisplayObject ):void
		{
			LayerManager.highestLayer.addChild(displayObject);
		}
	}
}