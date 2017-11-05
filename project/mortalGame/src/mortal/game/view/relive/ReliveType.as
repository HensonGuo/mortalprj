/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.view.relive
{
	public class ReliveType
	{
		public function ReliveType()
		{
		}
		
		/**
		 * 普通复活 
		 */		
		public static const General:int = 0;
		/**
		 * 道具原地复活 
		 */		
		public static const Prop:int = 1;
		/**
		 * 复活点复活 
		 */		
		public static const RelivePoint:int = 2;
		/**
		 * 强制复活（服务器直接处理） 
		 */		
		public static const Force:int = 3;
		/**
		 * 失败了退出副本，并且服务器自动复活（服务器处理） 
		 */		
		public static const FailCopy:int = 4;
	}
}