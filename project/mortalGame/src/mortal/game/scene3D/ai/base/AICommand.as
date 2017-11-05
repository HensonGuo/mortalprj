/**
 * 2013-12-16
 * @author chenriji
 **/
package mortal.game.scene3D.ai.base
{
	import mortal.game.scene3D.ai.data.AIData;

	public class AICommand implements IAICommand
	{
		protected var _callback:Function;
		protected var _data:AIData;
		
		public function AICommand()
		{
		}
		
		public function set data($data:AIData):void
		{
			_data = $data;
		}
		
		public function get data():AIData
		{
			return _data;
		}
		
		public function start(onEnd:Function=null):void
		{
			_callback = onEnd;
		}
		
		public function stop():void
		{
			endAI();
		}
		
		public function get stopable():Boolean
		{
			return true;
		}
		
		public function endAI():void
		{
			if(_callback != null)
			{
				_callback.apply();
			}
			
			_callback = null;
		}
	}
}