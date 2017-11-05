/**
 * @date 2013-2-21 下午05:51:22
 * @author chenriji
 */
package mortal.game.resource
{
	import Message.Db.Tables.TAchievementDetatil;
	
	import com.gengine.debug.Log;
	
	import flash.utils.getTimer;
	
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.resource.configBase.TLevelSeal;

	public class ConfigCenterDemo
	{
		public function ConfigCenterDemo()
		{
		}
		
		public function test():void
		{
			var levelSeal:TLevelSeal = ConfigCenter.getConfigs(ConfigConst.TLevelSeal, ["level"], [100], true) as TLevelSeal;
			var levelSeal2:TLevelSeal = ConfigCenter.getConfigs(ConfigConst.TLevelSeal, "level", 100, true) as TLevelSeal;
			// 正常使用
			var arr6:Array = ConfigCenter.getConfigs(ConfigConst.test1, ["category","goalProcess"], [1,"0,40"]);
			var arr5:Array = ConfigCenter.getConfigs(ConfigConst.test2, ["category2"], [1]);
			var arr4:Array = ConfigCenter.getConfigs(ConfigConst.test1, ["code"], [90101020]); 
			
			// 只获取其中一个结构
			var config:TAchievementDetatil = 
				ConfigCenter.getConfigs(ConfigConst.test1, ["code"], [90101020], true) as TAchievementDetatil;
			
			// 特殊情况测试
			var arr:Array = ConfigCenter.getConfigs(ConfigConst.test1,  null, null);
			var arr1:Array = ConfigCenter.getConfigs(ConfigConst.test1, null, []);
			var arr2:Array = ConfigCenter.getConfigs(ConfigConst.test1, [], null);
			var arr3:Array = ConfigCenter.getConfigs(ConfigConst.test1, [], []);
			
			
			
			// 联合测试，性能
			var startTime:int = getTimer();
			for(var i:int = 0; i < 100; i++)
			{
				var arr7:Array = ConfigCenter.getUnionConfigs(ConfigConst.test1,
					ConfigConst.test2, ["code"], ["code2"]);
			}
			Log.system("ConfigCenter 测试联合从用512个文件中取数据一共使用了：" + (getTimer() - startTime) + "毫秒");
		}
	}
}