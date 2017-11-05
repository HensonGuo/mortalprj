/**
 * @heartspeak
 * 2014-2-27 
 */   	

package mortal.game.model.vo.pet
{
	public class PetChangeNameVO
	{
		public var petUid:String;
		public var name:String;
		
		public function PetChangeNameVO($petUid:String,$name:String)
		{
			petUid = $petUid;
			name = $name;
		}
	}
}