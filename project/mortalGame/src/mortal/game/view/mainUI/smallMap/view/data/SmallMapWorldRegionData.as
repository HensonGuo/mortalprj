/**
 * 2014-2-17
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.data
{
	public class SmallMapWorldRegionData
	{
		public function SmallMapWorldRegionData($type:int, $value:String, $x:int, $y:int)
		{
			this.type = $type;
			this.value = $value;
			this.x = $x;
			this.y = $y;
		}
		
		public static const World:int = 0;
		public static const Region:int = 1;
		
		public var x:int;
		public var y:int;
		public var value:String;
		public var type:int;
	}
}