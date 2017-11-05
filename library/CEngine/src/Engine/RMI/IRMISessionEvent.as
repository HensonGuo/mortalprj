package Engine.RMI
{
	public interface IRMISessionEvent
	{
		/**
		 *  session abandon
		 * */
		function onAbandon( session  : Session ):void;
	}
}