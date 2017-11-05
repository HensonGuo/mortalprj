/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.resource.info.item
{
	import com.gengine.utils.ObjectParser;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class ItemExInfo
	{
		public var strengthen:int; // 强化等级
		
		public var currentStrengthen:int; // 当前强化等级的强化进度， 万分比， 0代表完美+x， 100代表1%
		
		public var bd:int;// 绑定信息
		
		// 镶嵌的宝石1-8
		public var h1:String;
		
		public var h2:String;
		
		public var h3:String;
		
		public var h4:String;
		
		public var h5:String;
		
		public var h6:String;
		
		public var h7:String;
		
		public var h8:String;
		
		public var hole_num:int;// 宝石开孔数
		
		public var qual:int; // 品质
		
		public var strengthenAmount:int; //强化次数
		
		public var jewelexper:int;// 宝石升级当前经验
		
		
		// 洗练附加属性1-6
		public var addition1:int;
		
		public var addition2:int;
		
		public var addition3:int;
		
		public var addition4:int;
		
		public var addition5:int;
		
		public var addition6:int;
		
		
		// 洗练附加属性星级1-6
		public var addStar1:int;
		
		public var addStar2:int;
		
		public var addStar3:int;
		
		public var addStar4:int;
		
		public var addStar5:int;
		
		public var addStar6:int;
		
		
		public var refresh_lock:String;// 锁定属性记录
		
		public var max_refresh_Level:int//洗炼广播过的最高属性等级
		
		public var refresh_count:int;//洗炼次数
		
		public var refresh_refDict:Array//洗炼属性字典
		
		public var petSkillRandTime:int//宠物技能随即次数
		
		public var petSkillRandItem:String//随机的宠物技能物品
		
		public function ItemExInfo()
		{
			
		}
		
		/**
		 * 赋值 
		 * @param obj
		 * 
		 */		
		public function putObject( obj:Object ):void
		{
			if(obj)
			{
//				ObjectParser.putObject(obj,this);
				ClassTypesUtil.copyValue(this,obj);
			}
			else
			{
				clear();
			}
		}
		
		/**
		 * 清空 
		 * 
		 */		
		public function clear():void
		{
			var vars:Array = ObjectParser.getClassVars(this);
			
			var key:*;
			for each(key in vars)
			{
				if(this[key] is int)
				{
					this[key] = 0;
				}
				else if(this[key] is String)
				{
					this[key]  = "";
				}
			}
		}
		
		/**
		 * 拷贝 
		 * @return 
		 * 
		 */		
		public function clone():ItemExInfo
		{
			var info:ItemExInfo = new ItemExInfo();
			
			var vars:Array = ObjectParser.getClassVars(this);
			var key:*;
			for each(key in vars)
			{
				info[key] = this[key];
			}
			
			return info;
		}
		
	}
}