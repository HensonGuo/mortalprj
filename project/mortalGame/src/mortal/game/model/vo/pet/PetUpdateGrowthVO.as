/**
 * @heartspeak
 * 2014-3-4 
 */   	

package mortal.game.model.vo.pet
{
	public class PetUpdateGrowthVO
	{
		public var petUid:String;
		public var isAutoBuy:Boolean;
		public var count:int = 1;
		public var target:int = 0;
		
		public function PetUpdateGrowthVO($petUid:String,$isAutoBuy:Boolean,$count:int = 1,$target:int = 0)
		{
			petUid = $petUid;
			isAutoBuy = $isAutoBuy;
			count = $count;
			target = $target;
		}
	}
}