/**
 * @heartspeak
 * 2014-2-27 
 */   	

package mortal.game.model.vo.pet
{
	public class PetChangeModeVO
	{
		public var petUid:String;
		public var type:int;
		
		public function PetChangeModeVO($petUid:String,$type:int)
		{
			petUid = $petUid;
			type = $type;
		}
	}
}