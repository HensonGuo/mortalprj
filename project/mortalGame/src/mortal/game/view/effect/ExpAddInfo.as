/**
 * @date 2011-10-28 上午10:33:06
 * @author  陈炯栩
 * 
 */ 
package mortal.game.view.effect
{
	public class ExpAddInfo
	{
		
		public var code:int;
		public var valueAdd:int;
		
		public function ExpAddInfo(valueAdd:int,code:int = 0)
		{
			this.code = code;
			this.valueAdd = valueAdd;
		}
	}
}