package mortal.game.resource.configBase
{

	public class ConfigConst
	{
		public function ConfigConst()
		{
		}
		
		public static const item:String = "t_item.json";
		public static const bagGrid:String = "t_open_bag_grid.json";
		public static const expLevel:String = "t_experience.json";
		
		public static const test1:String = "t_test1.json";
		public static const test2:String = "t_test2.json";
		public static const TLevelSeal:String = "t_level_seal.json";
		
		
		/**
		 * 结构名字对应的配置文件 + ";" + 主键， 例如： 
		 * Message.Db.Tables.TAchievementDetatil;name 对应 t_test1.json, 用";"分割， name表示主键为name， 假如配置了，
		 * 可以直接使用getConfigFromMainCache获取配置
		 */		
		public static const map:Object = {
			"t_item.json":"mortal.game.resource.info.item.ItemInfo;code",
			"t_open_bag_grid.json":"Message.DB.Tables.TOpenBagGrid;grid",
			"t_experience.json":"Message.DB.Tables.TExperience;level",
			
			
			"t_test1.json":"Message.Db.Tables.TAchievementDetatil;name",
			"t_test2.json":"mortal.game.resource.configBase.TAchievementDetial2;name_lvel",
			"t_level_seal.json":"mortal.game.resource.configBase.TLevelSeal"
		};
		
		public static const changeFormat:Object = {
			"t_item.json":["beginTime;Date", ""]
		};
		
		private var detail2:TAchievementDetial2;
	}
}