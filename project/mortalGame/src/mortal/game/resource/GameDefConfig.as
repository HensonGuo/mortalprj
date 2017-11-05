/**
 * @date	2011-3-10 下午04:19:31
 * @author  宋立坤
 * 
 */	
package mortal.game.resource
{
	import Message.Public.EEquip;
	import Message.Public.ESex;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.HTMLUtil;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.info.DefInfo;
	import mortal.game.resource.info.item.ItemData;
	
	public class GameDefConfig
	{
		private static var _instance:GameDefConfig;
		private var _data:Dictionary = new Dictionary();	
		private var _xmlDic:Dictionary = new Dictionary();
		
		
		public function GameDefConfig()
		{
			if(_instance != null)
			{
				throw new Error(" GameDefConfig 单例 ");
			}
			_instance = this;
			init();
		}
		
		public static function get instance():GameDefConfig
		{
			if(_instance == null)
			{
				_instance = new GameDefConfig();
			}
			return _instance;
		}
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var xmllist:Array = dic.items as Array;
			
			for each (var x:Object in xmllist)
			{
				var type:String  = x.type.toString();
				var data:DefInfo;
				if(x.item is Array)
				{
					for each (var xx:Object in x.item as Array)
					{
						data = new DefInfo();
						data.type = type;
						data.text = xx.text;
						data.id = xx.id;
						data.text1 = xx.text1;
						data.text2 = xx.text2;
						data.text3 = xx.text3;
						data.value = xx.value;
						addItem(data);
					}
				}
				else
				{
					data = new DefInfo();
					data.type = type;
					data.text = x.item.text;
					data.id = x.item.id;
					data.text1 = x.item.text1;
					data.text2 = x.item.text2;
					data.text3 = x.item.text3;
					data.value = x.item.value;
					addItem(data);
				}
				_xmlDic[type] = x;
			}
		}
		
		/**
		 * 添加一个定义
		 * @param data
		 * 
		 */
		private function addItem(data:DefInfo):void
		{
			_data[data.type+"-"+data.id] = data;
		}
		
		/**
		 * 获得一个定义项 
		 * @return 
		 * 
		 */
		public function getItem(type:String,id:int):DefInfo
		{
			return _data[type+"-"+id] as DefInfo;
		}
		
		/**
		 * 奖励类型 
		 * @return 
		 * 
		 */
		public function getRewardDef(id:int):DefInfo
		{
			return getItem("reward",id);
		}
		
		/**
		 * 实体类型 
		 * @param id
		 * @return 
		 * 
		 */
		public function getEntityDef(id:int):DefInfo
		{
			return getItem("entity",id);
		}
		
		/**
		 * 绑定
		 * @param id
		 * @return 
		 * 
		 */
		public function getEBind(id:int):DefInfo
		{
			return getItem("EBind",id);
		}
		
		/**
		 * 装备品质
		 * @param id
		 * @return 
		 * 
		 */
		public function getEPrefixx(id:int,type:int):DefInfo
		{
			return getItem("EPrefix",id);
		}
		
		/**
		 * 物品类型
		 * @param id
		 * @return 
		 * 
		 */
		public function getECategory(id:int):DefInfo
		{
			return getItem("ECategory",id);
		}
		
		/**
		 * 性别 
		 * @param id
		 * @return 
		 * 
		 */
		public function getSex(id:int):DefInfo
		{
			return getItem("ESex",id);
		}
		
		/**
		 * 返回技能使用类型
		 * @param id
		 * @return 
		 * 
		 */
		public function getSkillUseType(id:int):DefInfo
		{
			return getItem("ESkillUseType",id);
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("gamedef.xml");
			write( object.root );
		}
		
		public function getDefaultModel( camp:int ):DefInfo
		{ 
			return getItem("ECampModel",camp);
		}
		
		public function getMoneyIcon( type:int ):String
		{
			return getItem("EPrictUnitIcon",type).text;
		}
		
		public function getEquipName(type:int):String
		{
			return getItem("EEquip",type).text;
		}
		
		public function getMoneyBigIcon( type:int ):String
		{
			return getItem("EPrictUnitBigIcon",type).text;
		}
		
		/**
		 * 获取阵营
		 * @param camp 阵营编号
		 * @return 
		 * 
		 */		
		public function getECamp(camp:int):DefInfo
		{
			return getItem("ECamp",camp);
		}
		
		/**
		 * 获取阵营的html文本(显示不同颜色) 
		 * @param camp
		 * @return 
		 * 
		 */		
		public function getCampHtml(camp:int):String
		{
			return HTMLUtil.addColor(getECamp(camp).text,getECamp(camp).text1);
		}
		
		/**
		 * 获取职业缩写
		 * @param camp
		 * @return 
		 * 
		 */		
		public function getECarrerShot(carrar:int):String
		{
			return getItem("ECareerShot",carrar).text;
		}
		
		
		/**
		 * 获取职业
		 * @param camp
		 * @return 
		 * 
		 */		
		public function getCarrer(carrar:int):String
		{
			return getItem("ECareer",carrar).text;
		}
		
		/**
		 * 获取职业小图标
		 * @param camp
		 * @return 
		 * 
		 */		
		public function getECarrerSmallPic(carrar:int):String
		{
			return getItem("ECareerSmallPic",carrar).text;
		}
		
		/**
		 * 获取职业图标
		 * @param camp
		 * @return 
		 * 
		 */		
		public function getECarrerPic(carrar:int):String
		{
			return getItem("ECareerPic",carrar).text;
		}
		
		/**
		 * 获取职业 
		 * @param career 职业编号
		 * @return 
		 * 
		 */		
		public function getECareer(career:int):DefInfo
		{
			return getItem("ECareer",career);
		}		
		
		/**
		 * 货币单位对应的图片名称
		 * @param id
		 * @return 
		 * 
		 */
		public function getEPrictUnitImg(id:int):String
		{
			var imgName:String = "";
			var defInfo:DefInfo = getItem("EPrictUnitIcon",id);
			if(defInfo){
				imgName = defInfo.text;
			}
			return imgName;
		}
		
		/**
		 * 货币单位对应的名称
		 * @param id
		 * @return 
		 * 
		 */
		public function getEPrictUnitName(id:int):String
		{
			var unitName:String = "";
			var defInfo:DefInfo = getItem("EPrictUnitName",id);
			if(defInfo){
				unitName = defInfo.text;
			}
			return unitName;
		}
		
		public function getEPrictNameAddColoer(id:int, color:String="#f2de47"):String
		{
			var unitName:String = getEPrictUnitName(id);
			return HTMLUtil.addColor(unitName,color);
		}
		
		/**
		 * 地图加载文件数组和刷怪地图数据配置 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getLoadMapConfig( type:int ):Array
		{
			var item:DefInfo = getItem("LoadMapConfig",type);
			if(item == null)
			{
				return null;
			}
			return item.text.split(",");
		}
		
		/**
		 * 返回建筑名称
		 * @param type 建筑类型
		 * @return 
		 * 
		 */
		public function getGuildBuildingName(type:int):String
		{
			return getItem("EGuildStructureType",type).text;
		}
		
		/**
		 * 返回NPC信息 
		 * @param effect
		 * @return 
		 * 
		 */
		public function getNpcByEffect(effect:int, mapId:int = -1):Object
		{
			var item:DefInfo;
			if(mapId == -1)
			{
				item = getItem("NPCEffect",effect);
			}
			else
			{
				item = getNpcEffectInfo(effect,mapId);
			}
			
			if(!item)
			{
				throw new Error("未知的功能NPC effect="+effect);
			}
			return {npcId:item.text1,mapId:item.text}
		}
		private var _npcEffectDic:Dictionary;
		private function getNpcEffectInfo(effect:int, mapId:int):DefInfo
		{
			if(!_npcEffectDic)
			{
				_npcEffectDic = new Dictionary();
				var data:DefInfo;
				var arr:Array = _xmlDic["NPCEffect"].item as Array;
				for each (var xx:Object in arr)
				{
					data = new DefInfo();
					data.type = "NPCEffect";
					data.text = xx.text;
					data.id = xx.id;
					data.text1 = xx.text1;
					data.text2 = xx.text2;
					data.value = xx.value;
					_npcEffectDic[data.id + "_" + data.text] = data;
				}
			}
			return _npcEffectDic[effect + "_" + mapId];
		}
		
		/**
		 *获取EReward奖励类型名称
		 * @param type
		 * @return 
		 * 
		 */		
		public function getERewardName(type:int):String
		{
			return getItem("reward",type).text.split("　").join("");
		}
		
		/**
		 *拿数字汉字 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getChineseNum(id:int):String
		{
			var str:String = "";
			var defInfo:DefInfo = getItem("ChineseNum",id);
			if(defInfo){
				str = defInfo.text;
			}
			return str;
		}
		
		/**
		 * 根据字母获取字母 
		 * @param $value
		 * @param $max
		 * @return 
		 * 
		 */		
		public function getFigureToLetter( $value:int, $max:Boolean=true ):String
		{
			var str:String = "";
			var defInfo:DefInfo = getItem( 'FigureToLetter', $value );
			if( defInfo )
			{
				str = $max ? defInfo.text : defInfo.text1;
			}
			return str;
		}
		
		private var _attackBattles:Dictionary;
		
		private function get attackBatters():Dictionary
		{
			if(!_attackBattles)
			{
				_attackBattles = new Dictionary();
				var i:int = 1;
				var defInfo:DefInfo;
				do
				{
					defInfo = getItem( "AttackBatter", i++ );
					if(defInfo)
					{
						_attackBattles[defInfo.text] = defInfo.text1;
					}
				}while(defInfo != null)
			}
			return _attackBattles;
		}
		
		/**
		 * 是否连击 
		 * @param attack1
		 * @param attack2
		 * @return 
		 * 
		 */		
		public function isAttackBatter(attack1:String,attack2:String):Boolean
		{
			if(attackBatters[attack1] == attack2)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 是否攻击动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public function getLeadActions():Array
		{
			return _xmlDic["PlayerLeadAction"].item as Array;
		}
		
		
		private var _dicAttributeName:Dictionary;
		/**
		 * 通过一个属性名字 获取属性对应的显示名字 
		 * @param value
		 * @return 
		 * 
		 */		
		public function getAttributeName(value:String):String
		{
			if(!_dicAttributeName)
			{
				_dicAttributeName = new Dictionary();
				for each(var item:Object in _xmlDic["AttributeName"].item)
				{
					_dicAttributeName[item.text] = item.text1;
				}
			}
			return _dicAttributeName[value];
		}
		
		/**
		 * 血脉拿血脉对应的文字
		 * @param id
		 * @return 
		 * 
		 */		
		public function getBloodName(id:int):String
		{
			var str:String = "";
			var defInfo:DefInfo = getItem("PetBlood",id);
			if(defInfo){
				str = defInfo.text;
			}
			return str;
		}
		
		/**
		 * 血脉拿血脉对应的坐标
		 * @param id
		 * @return 
		 * 
		 */		
		public function getBloodPostion(id:int,isLeft:Boolean = false):Array
		{
			var str:String = "";
			var defInfo:DefInfo = getItem("PetBloodPosition",id);
			if(isLeft)
			{
				str = defInfo.text;
			}
			else
			{
				str = defInfo.text1;
			}
			str = str.replace(new RegExp(/[\[\]]/g),"");
			var ary:Array = str.split(",");
			var pointArray:Array = new Array();
			for(var i:int = 0; i < ary.length;i+=2)
			{
				var point:Point = new Point();
				point.x = ary[i];
				point.y = ary[i+1];
				pointArray.push(point);
			}
			return pointArray;
		}
		
		
		/**
		 * 获取兽魂石刷新次数的星星数
		 * @param freshCount
		 */
		private var _petSkillBookFreshStarArr:Array = null;
		public function getPetSkillBookFreshStarNum(freshCount:int):Number
		{
			if (_petSkillBookFreshStarArr == null)
			{
				var str:String = getItem("PetFreshSkillStarNum", 1).text;
				str = str.replace(new RegExp(/[\[\]]/g),"");
				_petSkillBookFreshStarArr = str.split(",");
			}
			for (var i:int = 0; i < _petSkillBookFreshStarArr.length / 3; i++)
			{
				var index:int = i * 3;
				var minFreshCount:int = _petSkillBookFreshStarArr[index + 0];
				var maxFreshCount:int = _petSkillBookFreshStarArr[index + 1];
				var starNum:Number = _petSkillBookFreshStarArr[index + 2];
				
				//reach max num
				if (maxFreshCount == -1)
					return starNum;
				if (freshCount > maxFreshCount)
					continue;
				return starNum;
			}
			return 0;
		}
		
		/**
		 * 公会职位 
		 * @return 
		 * 
		 */		
		public function getGuildPositonInfo(position:int):DefInfo
		{
			return getItem("EGuildPostion",position);
		}
		
		/**
		 * 公会职位名字
		 * @return 
		 * 
		 */		
		public function getGuildPositonName(position:int):String
		{
			return getItem("EGuildPostion",position).text;
		}
	}
}