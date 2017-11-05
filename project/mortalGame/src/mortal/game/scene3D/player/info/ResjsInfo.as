package mortal.game.scene3D.player.info
{
	import com.gengine.utils.ObjectParser;

	public class ResjsInfo
	{
		
		public function ResjsInfo()
		{
			
		}
		
		public function putObject( obj:Object ):void
		{
			ObjectParser.putObject(obj,this);
		}
		
		public function clear():void
		{
			
		}
	}
}