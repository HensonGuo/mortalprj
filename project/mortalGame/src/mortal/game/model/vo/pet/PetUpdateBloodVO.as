/**
 * @heartspeak
 * 2014-3-7 
 */   	

package mortal.game.model.vo.pet
{
	public class PetUpdateBloodVO
	{
		public var petUid:String;
		public var isTenTimesUpdate:Boolean = false;
		public var blood:int = 0;
		public var isAutoBuyItems:Boolean = false;
		
		public function PetUpdateBloodVO($petUid:String,$isTenTimesUpdate:Boolean,$blood:int,$isAutoBuyItems:Boolean):void
		{
			petUid = $petUid;
			isTenTimesUpdate = $isTenTimesUpdate;
			blood = $blood;
			isAutoBuyItems = $isAutoBuyItems;
		}
	}
}