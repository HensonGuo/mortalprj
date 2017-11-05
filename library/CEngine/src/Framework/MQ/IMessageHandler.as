package Framework.MQ
{	
	import Framework.MQ.MessageBlock;
	
	public interface IMessageHandler
	{
		function onMessage( mb : MessageBlock ) : void;
	}
}
