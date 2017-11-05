/**
 * 2014-3-7
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.ai.data.CallBackData;
	
	public class CallBackAI extends AICommand
	{
		public function CallBackAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			var callbackData:CallBackData = this._data as CallBackData;
			if(callbackData != null && callbackData.callback != null)
			{
				if(callbackData.params != null)
				{
					callbackData.callback.apply(null, [callbackData.params]);
				}
				else
				{
					callbackData.callback.apply();
				}
			}
			super.stop();
		}
	}
}