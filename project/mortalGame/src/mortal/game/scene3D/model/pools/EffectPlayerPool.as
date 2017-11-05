package mortal.game.scene3D.model.pools
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import baseEngine.basic.RenderList;
	import baseEngine.system.Device3D;
	
	import mortal.game.scene3D.model.player.EffectPlayer;

	/**
	 * Manages objects by retaining disposed objects and returning them when a new object
	 * is requested, to avoid unecessary object creation and disposal and so avoid
	 * unnecessary object creation and garbage collection.
	 */
	public class EffectPlayerPool 
	{
		private static var pools:Dictionary = new Dictionary();
		private static var _instance:EffectPlayerPool;
		private var _timer:SecTimer;
		public function EffectPlayerPool()
		{
			_timer = new SecTimer(5*60);
			_timer.addListener(TimerType.ENTERFRAME,checkToDispose);
			_timer.start();
		}
		
		public static function get instance():EffectPlayerPool
		{
			if(!_instance)
			{
				_instance=new EffectPlayerPool();
			}
			return _instance;
		}
		private function checkToDispose(timer:SecTimer):void
		{

			var toDisposeTypeList:Array=new Array();
			
			var _time:Number=getTimer()-2000*60;
			for(var _url:String in pools)
			{
				var arr:Array=pools[_url];
				var len:int=arr.length;
				var i:int=0;
				while(i<len)
				{
					var obj:Object=arr[i];
					if(obj.time<_time)
					{
						EffectPlayer(obj.content).dispose(false);
						arr.splice(i,1);
						len--;
					}else
					{
						i++;
					}
				}
				if(len==0)
				{
					toDisposeTypeList.push(_url);
				}
			}
			for each(_url in toDisposeTypeList)
			{
				delete pools[_url];
			}
		}
		private function getPool( url:String ):Array
		{
			return url in pools ? pools[url] : pools[url] = new Array();
		}
		
		/**
		 * Get an object of the specified type. If such an object exists in the pool then 
		 * it will be returned. If such an object doesn't exist, a new one will be created.
		 * 
		 * @param type The type of object required.
		 * @param parameters If there are no instances of the object in the pool, a new one
		 * will be created and these parameters will be passed to the object constrictor.
		 * Because you can't know if a new object will be created, you can't rely on these 
		 * parameters being used. They are here to enable pooling of objects that require
		 * parameters in their constructor.
		 */
		public function getEffectPlayer( url:String,renderList:RenderList=null):EffectPlayer
		{
			if(renderList==null)
			{
				renderList=Device3D.scene.renderLayerList;
			}
			var pool:Array = getPool( url );
			var _effectPlayer:EffectPlayer;
			if( pool.length > 0 )
			{
				_effectPlayer=pool.shift().content;
				_effectPlayer.reset();
			}
			else
			{
				_effectPlayer=new EffectPlayer(url,renderList);
			}
			if(_effectPlayer.renderList!=renderList)
			{
				_effectPlayer.renderList=renderList
			}
			return _effectPlayer;
		}
		
		/**
		 * Return an object to the pool for retention and later reuse. Note that the object
		 * still exists, so you need to clean up any event listeners etc. on the object so 
		 * that the events stop occuring.
		 * 
		 * @param object The object to return to the object pool.
		 * @param type The type of the object. If you don't indicate the object type then the
		 * object is inspected to find its type. This is a little slower than specifying the 
		 * type yourself.
		 */
		public function dispose( object:EffectPlayer):void
		{
			var pool:Array = getPool( object.curUrl );
			pool.push( {"time":getTimer(),"content":object} );
		}
		public function hasDispose( object:EffectPlayer):Boolean
		{
			var pool:Array = getPool( object.curUrl );
			for each(var p:Object in pool)
			{
				if(p.content==object)
				{
					return true;
				}
			}
			return false;
		}
	}
}
