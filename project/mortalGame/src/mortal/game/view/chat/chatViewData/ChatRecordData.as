/**
 * @date 2011-6-20 上午11:56:32
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatViewData
{
	import com.gengine.core.IDispose;
	import com.gengine.utils.pools.ObjectPool;

	public class ChatRecordData implements IDispose
	{
		public var playerName:String;
		public var time:Date;
		public var content:String;
		public function ChatRecordData()
		{
		}
		
		public function dispose():void
		{
			playerName = null;
			time = null;
			content = null;
			ObjectPool.disposeObject(this);
		}
	}
}