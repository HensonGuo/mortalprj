/**
 * @date 2011-5-4 下午07:15:43
 * @author  hexiaoming
 * 
 */ 
package mortal.game.scene3D.model.data
{
	import Message.Game.SDoFight;
	
	import flash.utils.Dictionary;

	public class FightData
	{
		private static var bFAttackIdList:Array = new Array();
		private static var dicBFIdDF:Dictionary = new Dictionary();
		
		public static function addBeginFight(attackId:int):void
		{
			if(!isInBeginFight(attackId))
			{
				bFAttackIdList.push(attackId);
			}
		}
		
		public static function removeBeginFight(attackId:int):void
		{
			if(isInBeginFight(attackId))
			{
				delete dicBFIdDF[attackId];
				bFAttackIdList.splice(bFAttackIdList.indexOf(attackId),1);
			}
		}
		
		public static function isInBeginFight(attackId:int):Boolean
		{
			return bFAttackIdList.indexOf(attackId)>=0;
		}
		
		public static function addDoFight(doFight:SDoFight):Boolean
		{
			if(isInBeginFight(doFight.attackId))
			{
				if(dicBFIdDF.hasOwnProperty(doFight.attackId))
				{
					(dicBFIdDF[doFight.attackId] as Array).push(doFight);
				}
				else
				{
					dicBFIdDF[doFight.attackId] = [doFight];
				}
				return true;
			}
			else
			{
				return false;
			}
		}

		public static function getDoFight(attackId:int):Array
		{
			return dicBFIdDF[attackId] as Array;
		}
	}
}
