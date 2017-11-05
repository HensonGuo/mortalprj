package Engine.RMI
{
	import Framework.Util.Exception;
	
	public interface IRMIPrepareCommandHandler
	{
		/**
		 * 包的数据正常返回
		 * @param call
		 * 
		 */		
		function prepareBackCommand( 
		                            backObject : RMIObject  
								):void;
		
		/**
		 * 包的数据返回异常
		 * @param call
		 * 
		 */		
		function prepareBackException(
									 backObject : RMIObject , 
									 ex : Exception 
		 							):void;
		
		/**
		 * 过滤通信包
		 * 返回 true 可以发送 其他的不能发送 
		 * @param call
		 * @param context
		 * @param backObject
		 * @return 
		 * 
		 */		
		function prepareCommand( call : SRMICall , context : Context , backObject : RMIObject ):Boolean;
	}
}