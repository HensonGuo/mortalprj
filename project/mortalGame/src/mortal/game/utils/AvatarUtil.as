/**
 * @heartspeak
 * 2014-3-21 
 */   	

package mortal.game.utils
{
	public class AvatarUtil
	{
		//定义头像的几种枚举常量
		public static const Big:int = 1;
		public static const Small:int = 2;
		public static const Group:int = 3;
		
		/**
		 * 根据职业和性别获取资源路径 
		 * @param career
		 * @param sex
		 * @param type
		 * @return 
		 * 
		 */
		public static function getPlayerAvatarUrl(career:int,sex:int,type:int = 1):String
		{
			var str:String = "AvatarBig";
			switch(type)
			{
				case Big:
					str = "AvatarBig";
					break;
				case Small:
					str = "AvatarSmall";
					break;
				case Group:
					str = "AvatarGroup";
					break;
			}
			return str + "_" + 1 + "_" + 0 + ".png";
//			return type + "_" + career "_" + sex + ".png";
		}
		
		/**
		 * 根据职业和性别获取资源 
		 * @param career
		 * @param sex
		 * @param type
		 * @return 
		 * 
		 */
		public static function getPlayerAvatar(career:int,sex:int,type:int = 1):String
		{
			var str:String = "AvatarBig";
			switch(type)
			{
				case Big:
					str = "AvatarBig";
					break;
				case Small:
					str = "AvatarSmall";
					break;
				case Group:
					str = "AvatarGroup";
					break;
			}
			return str + "_" + 1 + "_" + 0 ;
		}
	}
}