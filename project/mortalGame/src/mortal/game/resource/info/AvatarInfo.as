/**
 * 头像信息
 * 
 * XianMeng CangQiong LuoCha
 * 
 * @date	2011-3-28 下午12:48:08
 * @author shiyong
 * 
 */

package mortal.game.resource.info
{
	import Message.Public.SEntityId;
	
	import com.gengine.debug.Log;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.SpecialLoaderManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.mui.controls.GImageBitmap;
	
	import mortal.common.global.PathConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResConfig;

	public class AvatarInfo
	{
		
		public function AvatarInfo()
		{
		}
		
		public static function getUpdateAvatar(entityId:SEntityId,type:int,callBack:Function = null):void
		{
			SpecialLoaderManager.Load("userImage_" + entityId.id + "_" + type,PathConst.headImagePath + entityId.id + "_" + type + ".jpg",callBack);
		}
		
		/**
		 * 获取头像
		 * @param camp 阵营
		 * @param sex  性别
		 * @param type 类型(查看AvatarType)
		 * 
		 * @return Bitmap
		 * 
		 */
		public static function getAvatar(camp:int,sex:int,type:int,callback:Function,avatarId:int=0):void
		{
			var avatarName:String = getPlayerAvatarName(camp,sex,type,avatarId);
			LoaderManager.instance.load(avatarName,callback);
			Log.system("getAvatar："+avatarName);
		}
		
		/**
		 *获取玩家头像名称 
		 * @param camp
		 * @param sex
		 * @param type
		 * @return 
		 * 
		 */
		public static function getPlayerAvatarName(camp:int,sex:int,type:int,avatarId:int=0):String
		{
			if (avatarId == 0) 
			{
				var campString:String = "XianMeng";
				if(camp == 1)
				{
					campString = "XianMeng";
				}
				else if(camp == 2)
				{
					campString = "CangQiong";
				}
				else if(camp == 3)
				{
					campString = "LuoCha";
				}
				return campString + "_" + sex + "_" + type+".png";
			}
			else
			{
				//新的头像id唯一 不需要性别来取
				return avatarId + "_"+ type.toString()+".png";
			}

		}
		
		public static function createPlayerAvatar(camp:int,sex:int,type:int,avatarId:int=0):GImageBitmap
		{
			return new GImageBitmap(getPlayerAvatarName(camp,sex,type,avatarId));
		}
		
		/**
		 *获取玩家头像的url 
		 * @param camp
		 * @param sex
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getPlayerAvatarUrl(camp:int,sex:int,type:int,avatarId:int=0):String
		{
			var avatarName:String = getPlayerAvatarName(camp,sex,type,avatarId);
			var info:ResourceInfo = ResConfig.instance.getInfoByName( avatarName + ".png");
			if(info)
			{
				return info.path;
			}
			return "";
		}
		
		/**
		 *根据code获取怪物头像的名称
		 * 
		 */		
		public static function getBossAvatarName(code:int):String
		{
			return "";
		}
		
		/**
		 *根据阵营获取阵营图片名称 
		 * @param camp
		 * @return 
		 * 
		 */		
		public static function getPicNameByCamp(camp:int):String
		{
			var picName:String = "";
			if(camp == 1)//逍遥
			{
				picName = ImagesConst.CampXiao;
			}
			else if(camp == 2)//星辰
			{
				picName = ImagesConst.CampXing;
			}
			else if(camp == 3)//苍穹
			{
				picName = ImagesConst.CampCang;
			}
			return picName;
		}
	}
}