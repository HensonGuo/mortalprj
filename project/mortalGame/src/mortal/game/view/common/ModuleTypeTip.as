/**
 * 所有功能按钮Tip
 * @date   2012-6-26 下午10:24:48
 * @author shiyong
 * 
 */
package mortal.game.view.common
{
	import extend.language.Language;
	
	import flash.utils.Dictionary;

	public class ModuleTypeTip
	{
		private static var _tipsDict:Dictionary;
		
		private static var _instance:ModuleTypeTip;
		
		public function ModuleTypeTip()
		{
			if( _instance  )
			{
				throw new Error("ModuleTypeTip singleton ");
			}
			init();
		}
		
		public static function get instance():ModuleTypeTip
		{
			if(!_instance)
			{
				_instance = new ModuleTypeTip();
			}
			return _instance;
		}

		/**
		 *根据类型，获取Tip 
		 * @param type ModuleType
		 * @param rest
		 * 
		 */		
		public function getTip(type:String , ...rest):String
		{
			var langugeCode:int = _tipsDict[type] as int;
			return Language.getStringByParam(langugeCode,rest);
		}
		
		private function init():void
		{
			_tipsDict = new Dictionary();
			regTip(ModuleType.AutoFight,"开始/关闭挂机",51031);
			regTip(ModuleType.Pack,"背包",51005);
			regTip(ModuleType.Players,"人物",51004);
			regTip(ModuleType.Rest,"打坐");
			regTip(ModuleType.Mail,"信件",51033);
			regTip(ModuleType.Friend,"好友",51007);
			regTip(ModuleType.Guild,"仙盟",51008);
			regTip(ModuleType.DownUpMounts,"上下坐骑");
			regTip(ModuleType.Fu,"福利公告",51029);
			regTip(ModuleType.Mounts,"坐骑",51116);
			regTip(ModuleType.Build,"炼器",51023);
			regTip(ModuleType.Jewel,"宝石",51024);
			regTip(ModuleType.Tu,"地图",51027);
			regTip(ModuleType.Daily,"日常",51009);
			regTip(ModuleType.Bang,"排行榜",51030);
			regTip(ModuleType.Tasks,"任务");
			regTip(ModuleType.PetsRest,"召唤/收回宠物");//特殊处理
			regTip(ModuleType.Shops,"商城",51017);
			regTip(ModuleType.Group,"队伍",51113);
			regTip(ModuleType.WuXing,"五行",51120);
			regTip(ModuleType.Skills,"技能",51010);
			regTip(ModuleType.Pets,"宠物",51006);
			regTip(ModuleType.XpSkill,"释放九天神雷");
			regTip(ModuleType.Market,"市场",51021);
			regTip(ModuleType.RangeAutoFight,"范围挂机");
			
			regTip(ModuleType.SwitchTarget,"切换目标");
			regTip(ModuleType.CancelTarget,"取消目标/关闭界面");
			regTip(ModuleType.FullScreen,"全屏/窗口切换",51034);
			regTip(ModuleType.HidePlayerPet,"屏蔽玩家、宠物");//特殊处理
			regTip(ModuleType.PickBox,"拾取掉落箱子");
			regTip(ModuleType.StartOrEndChat,"开始/结束聊天");
			regTip(ModuleType.NotMove,"原地停留");
		}
		
		/**
		 *注册 
		 * @param type
		 * @param tip 提示，暂不用
		 * @param langugeCode
		 * 
		 */		
		private function regTip(type:String,tip:String,langugeCode:int=0):void
		{
			_tipsDict[type] = langugeCode;
		}
	}
}