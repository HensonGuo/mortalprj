/**
 * @date	2011-3-1 下午03:45:05
 * @author  宋立坤
 * 
 */	
package mortal.game.view.skill
{
	import Message.DB.Tables.TSkill;
	import Message.Public.ESkillType;
	
	import com.gengine.utils.HTMLUtil;
	
	import extend.language.Language;
	
	import mortal.game.cache.Cache;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.scene3D.player.info.ModelInfo;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;

	public class SkillInfo extends ModelInfo
	{
		private var _position:int;			//位置
		
		public var tSkill:TSkill;			//技能表
		public var learned:Boolean = false;//是否已学
		public var autoUse:Boolean;		//是否自动释放
		
		private var _preLearned:Boolean;		//前置技能是否已学
		private var _nextSkill:TSkill;			//下一等级技能表
		private var _getBookInfos:Array;		//技能书获取途径
		private var _cdDt:Date = new Date();	//冷却开始时间
		
		//符文动态属性
		private var _distance:int;				//释放距离
		private var _useTime:int;				//释放时间
		private var _coolDownTime:int;			//其他东西影响CD时间， 例如符文减少cd时间20秒， 那么值就是-20
		private var _baseEffect:int;			//基础伤害
		private var _addEffect:int;			//附加伤害
		private var _clearCd:int;				//清理cd
		
		public var quickView:Boolean;			//是否预览效果
		
		public function SkillInfo()
		{
		}
		
		public function set preLearned(value:Boolean):void
		{
			this._preLearned = value;
		}
		
		public function get isComboSkill():Boolean
		{
			if(tSkill == null || tSkill.combo == null || tSkill.combo == "")
			{
				return false;
			}
			return true;
		}
		
		public function get preLearned():Boolean
		{
			if(tSkill.preSkills  == null || tSkill.preSkills == "")
			{
				return true;
			}
			else
			{
				var arr:Array = tSkill.preSkills.split("#");
				for(var i:int = 0; i < arr.length; i++)
				{
					var id:int = int(arr[i]);
					// 6位为技能组， 8位为技能id
					// 判断所有技能都已经学习， 技能组内所有技能都已经学习
				}
			}
			return _preLearned;
		}
		
		public function get nextSkill():TSkill
		{
			if(_nextSkill == null)
			{
				if(isMaxLevel())
				{
					return null;
				}
				_nextSkill = SkillConfig.instance.getSkillByLevel(tSkill.series, tSkill.skillLevel + 1);
			}
			return _nextSkill;
		}
		
		public function get maxLevel():int
		{
			return SkillConfig.instance.getMaxLevelBySerialId(tSkill.series);
		}
		
		public function isMaxLevel():Boolean
		{
			return maxLevel == tSkill.skillLevel;
		}
		
		public function get preSkill():TSkill
		{
			if(tSkill.preSkills != null && tSkill.preSkills != "")
			{
				return SkillConfig.instance.getInfoByName(int(tSkill.preSkills));
			}
			return null;
		}
		
		public function get getBookInfos():Array
		{
			return _getBookInfos;
		}
		
		public function get position():int
		{
			if(tSkill && tSkill.posType > 0)
			{
				return tSkill.posType;
			}
			return _position;
		}
		
		public function set position(value:int):void
		{
			_position = value;
		}
		
		public function get skillLevel():int
		{
			if(tSkill)
			{
				return tSkill.skillLevel;
			}
			return 0;
		}
		
		public function get levelLimited():int
		{
			if(tSkill)
			{
				return tSkill.levelLimit;
			}
			return 0;
		}
		
		public function get clearOtherCd():Boolean
		{
			return (_clearCd == 1);
		}
		
		/**
		 * 返回职业 
		 * @return 
		 * 
		 */
		public function get skillCareer():int
		{
			if(tSkill)
			{
			 	return SkillUtil.getCarrer(tSkill); 
			}
			return 0;
		}
		
		/**
		 * CD结束的时间
		 * @param value
		 * @return 
		 * 
		 */
		public function set cdDt(value:Date):void
		{
			_cdDt = value;
		}
		
		/**
		 * CD结束的时间 
		 * @return 
		 * 
		 */		
		public function get cdDt():Date
		{
			return _cdDt;
		}
		
		/**
		 * 更新技能书获取途径说明 
		 * 
		 */
		public function updateGetBookInfo():void
		{
			if(learned)//已学
			{
				if(_getBookInfos != null)
				{
					_getBookInfos.splice(0);
				}
				return;
			}
			
			if(!_getBookInfos)
			{
				_getBookInfos = [];
			}
		}
		
		/**
		 * 是否可升级 
		 * @return 
		 * 
		 */		
		public function upgradable():Boolean
		{
			if(ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug))
			{
				return true;
			}
			if(!learned)
			{
				return false;
			}
			
			if(isMaxLevel())//满级
			{
				return false;
			}
			
			if(!isLevelEnough())
			{
				return false;
			}
			
			if(!isExperienceEnough())//经验不够
			{
				return false;
			}
			if(!isCoinEnough())
			{
				return false;
			}
			if(!isSkillPointEnough())
			{
				return false;
			}
			return true;
		}
		
		public function isExperienceEnough(info:TSkill=null):Boolean
		{
			if(info == null)
			{
				info = nextSkill;
			}
			if(info && info.needExperience > Cache.instance.role.roleInfo.experience)//经验不够
			{
				return false;
			}
			return true;
		}
		
		public function isLevelEnough(info:TSkill=null):Boolean
		{
			if(info == null)
			{
				info = nextSkill;
			}
			if(info && info.levelLimit > Cache.instance.role.entityInfo.level)//等级不够
			{
				return false;
			}
			return true;
		}
		
		public function isSkillPointEnough(info:TSkill=null):Boolean
		{
			if(info == null)
			{
				info = nextSkill;
			}
			if(info && info.needVitalEnergy > Cache.instance.login.loginGame.money.vitalEnergy)
			{
				return false;
			}
			return true;
		}
		
		public function isCoinEnough(info:TSkill=null):Boolean
		{
			if(info == null)
			{
				info = nextSkill;
			}
			if(info && info.needCoin > Cache.instance.login.loginGame.money.coin 
				+ Cache.instance.login.loginGame.money.coinBind)//铜钱不够
			{
				return false;
			}
			return true;
		}
		
		public function isSkillBookEnough():Boolean
		{
			if(tSkill.needSkillBook > 0 && Cache.instance.pack.backPackCache.getItemByCode(tSkill.needSkillBook) == null)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 是否可学习 
		 * @return 
		 * 
		 */		
		public function learnable():Boolean
		{
			if(ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug))
			{
				return true;
			}
			
			if(learned || !preLearned)
			{
				return false;
			}
			
			if(!isLevelEnough(tSkill))//等级不够
			{
				return false;
			}
			if(!isExperienceEnough(tSkill))//经验不够
			{
				return false;
			}
			if(!isCoinEnough(tSkill))//铜钱不够
			{
				return false;
			}
			if(!isSkillPointEnough(tSkill))
			{
				return false;
			}
			if(!isSkillBookEnough())
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 基础伤害 返回百分号前面的值
		 * @return 
		 * 
		 */
		public function get baseHurt():int
		{
			return int(tSkill.hurtEffect)%1000;
		}
		
		/**
		 * 附加伤害 
		 * @return 
		 * 
		 */
		public function get addHurt():int
		{
			return int(tSkill.hurtEffect)/1000;
		}
		
		/**
		 * 基础伤害 返回百分号前面的值
		 * @return 
		 * 
		 */
		public function get baseHurtStr():String
		{
			var result:String = (int(tSkill.hurtEffect)%1000).toString();
			if(_baseEffect != 0)
			{
				result += getRuneStr(_baseEffect,"#FEAE58");
			}
			return result;
		}
		
		/**
		 * 附加伤害 
		 * @return 
		 * 
		 */
		public function get addHurtStr():String
		{
			var result:String = (int(tSkill.hurtEffect)/1000).toString();
			if(_addEffect != 0)
			{
				result += getRuneStr(_addEffect);
			}
			return result;
		}
		
		/**
		 * 基础属性 
		 * @param skill
		 * @return 
		 * 
		 */
		private function getBaseInfo(skill:TSkill):String
		{
			var info:String = "";
			var val:String;
			var addVal:int;//符文附加效果
//			if(EightyDefenseCopyConfig.instance.isEightyDefenseSkill(tSkill.skillId))
//			{
//				//消耗真气
//				info += HTMLUtil.addColor(Language.getString(20329) + "："+ EightyDefenseCopyConfig.instance.getSkillUseScoreById(tSkill.skillId),"#00ff00") + "<br>";
//			}
//			else
//			{
//				//消耗法力
//				info += HTMLUtil.addColor(Language.getString(20215) + "："+ skill.consume,"#00ff00") + "<br>";
//			}
//			//冷却时间
//			val = Number(skill.cooldownTime/1000).toString() + Language.getString(20693);
//			addVal = Cache.instance.rune.getRuneSkillEffect(skill,baseId,ERuneEffectType._ERuneEffectCoolDown);
//			if(addVal != 0)
//			{
//				val += getRuneStr(Number(addVal/1000),"#FEAE58") + HTMLUtil.addColor(Language.getString(20693),"#FEAE58");
//			}
//			info += HTMLUtil.addColor(Language.getString(20216) + "：" + val,"#00ff00") + "<br>";
//			//持续时间
//			if(skill.additionState != 0)
//			{
//				var state:TState = SkillStateConfig.instance.getInfoByName(skill.additionState);
//				if(state != null && state.lastTime > 0)
//				{
//					info += HTMLUtil.addColor(Language.getString(20218) + "：" + Number(state.lastTime/1000) + Language.getString(20217),"#00ff00") + "<br>";
//				}
//			}
//			//释放距离
//			val = skill.attackDistance.toString();
//			addVal = Cache.instance.rune.getRuneSkillEffect(skill,baseId,ERuneEffectType._ERuneEffectDistance);
//			if(addVal != 0)
//			{
//				val += getRuneStr(addVal);
//			}
//			info += HTMLUtil.addColor(Language.getString(20219) + "：" + val,"#00ff00") + "<br>";
			return info;
		}
		
		/**
		 * 伤害效果
		 * @param skill
		 * @return 
		 * 
		 */
		private function getEffectInfo(skill:TSkill):String
		{
			var info:String = "";
//			if(tSkill.skillType == ESkillType._ESkillTypeTrap)
//			{
//				return info;
//			}
//			var addEffect:int = int(skill.hurtEffect)/1000;
//			var baseEffect:int = int(skill.hurtEffect)%1000;
//			var addVal:int;//符文效果
//			if(baseEffect > 0)
//			{
//				info += getBaseEffect(baseEffect);
//				addVal = Cache.instance.rune.getRuneSkillEffect(skill,baseId,ERuneEffectType._ERuneEffectValue);
//				if(addVal != 0)//符文效果
//				{
//					info += getRuneStr(addVal) + HTMLUtil.addColor("%","#FEAE58");
//				}
//				info += "<br>";
//			}
//			if(addEffect > 0)
//			{
//				info += getAddEffect(addEffect);
//				addVal = Cache.instance.rune.getRuneSkillEffect(skill,baseId,ERuneEffectType._ERuneEffectValue,false);
//				if(addVal != 0)//符文效果
//				{
//					info += getRuneStr(addVal);
//				}
//				info += "<br>";
//			}
			return info;
		}
		
		/**
		 * 升级条件 
		 * @param skill
		 * @return 
		 * 
		 */
		private function learnInfo():String
		{
			var info:String = "";
			if(nextSkill.levelLimit > Cache.instance.role.entityInfo.level)
			{
				info += HTMLUtil.addColor(Language.getString(20221) + "：" + nextSkill.levelLimit,"#ff1414") + "<br>";//需要等级
			}
			
			if(nextSkill.needExperience > Cache.instance.role.roleInfo.experience)
			{
				info += HTMLUtil.addColor(Language.getString(20222) + "：" + nextSkill.needExperience,"#ff1414" ) + "<br>";//需要经验
			}
			
			if(nextSkill.needCoin > Cache.instance.login.loginGame.money.coin && nextSkill.needCoin > Cache.instance.login.loginGame.money.coinBind)
			{
				info += HTMLUtil.addColor(Language.getString(20223) + "：" + nextSkill.needCoin,"#ff1414" ) + "<br>";//需要铜钱
			}
			if(!preLearned && preSkill!=null)
			{
				info += HTMLUtil.addColor(Language.getString(20224) + "：" + preSkill.name,"#ff1414") + "<br>";//需要技能
			}
			return info;
		}
		
		/**
		 * 基础伤害 
		 * @return 
		 * 
		 */
		private function getBaseEffect(value:int):String
		{
//			if(tSkill.type == ESkillType._ESkillTypeTrap)
//			{
//				return "";
//			}
			
			var str:String = Language.getString(20225);//"伤害";
			if(tSkill.type == ESkillType._ESkillTypeCure)//治疗
			{
				str = Language.getString(20226);//"回血";
			}
			return HTMLUtil.addColor(Language.getString(20227) + str + "：" + value + "%","#f5ff00");//基础
		}
		
		/**
		 * 附加伤害 
		 * @return 
		 * 
		 */
		private function getAddEffect(value:int):String
		{
			return "";
//			if(tSkill.skillType == ESkillType._ESkillTypeTrap)
//			{
//				return "";
//			}
//			
//			var str:String = Language.getString(20225);//"伤害";
//			if(tSkill.skillType == ESkillType._ESkillTypeCure)//治疗
//			{
//				str = Language.getString(20226);//"回血";
//			}
//			return HTMLUtil.addColor(Language.getString(20228) + str + "：" + value,"#f5ff00");//附加
		}
		
		/**
		 * 返回释放类型 
		 * @return 
		 * 
		 */
		public function getUseType(needRuneEffect:Boolean=true):String
		{
			return "...";
//			if(tSkill.type == ESkillUseType._ESkillUseTypeInitiative)//主动
//			{
//				if(tSkill.leadTime > 0)//引导时间
//				{
//					return Language.getString(21090);//"引导释放";
//				}
//				else if(tSkill.useTime > 0)//施法时间
//				{
//					var addVal:int = Cache.instance.rune.getRuneSkillEffect(tSkill,baseId,ERuneEffectType._ERuneEffectUseTime);
//					var result:String = Language.getStringByParam(21091,tSkill.useTime/1000);//tSkill.useTime + "秒施法";;
//					if(addVal != 0 && needRuneEffect)//符文效果
//					{
//						result += getRuneStr(addVal/1000) + HTMLUtil.addColor(Language.getString(20217),"#FEAE58");
//					}
//					return result;
//				}
//				else
//				{
//					return Language.getString(21092);//"瞬间释放";
//				}
//			}
//			return GameDefConfig.instance.getSkillUseType(tSkill.useType).name
		}
		
		/**
		 * 是否可以拖动 
		 * @return 
		 * 
		 */
		public function get dragAble():Boolean
		{
			if(quickView)
			{
				return false;
			}
			if(tSkill)
			{
//				if(tSkill.useType == ESkillUseType._ESkillUseTypeInitiative || tSkill.useType == ESkillUseType._ESkillUseTypeAuto)
//				{
					return true;
//				}
			}
			return false;	
		}
		
		/**
		 * 释放距离 
		 * @return 
		 * 
		 */
		public function get distance():int
		{
			return tSkill.distance + _distance;
		}
		
		/**
		 * 释放距离 
		 * @return 
		 * 
		 */
		public function get attackDisStr():String
		{
			var result:String = tSkill.distance.toString();
			if(_distance != 0)
			{
				result += getRuneStr(_distance);
			}
			return result;
		}

		/**
		 * 消耗魔法
		 * @return 
		 * 
		 */
		public function get magicNeed():int
		{
			if(tSkill)
			{
				return tSkill.consume;
			}
			return 0;
		}
		
		public function get skillId():int
		{
			if(tSkill)
			{
				return tSkill.skillId;
			}
			return 0;
		}
		
		public function get skillType():int
		{
			if(tSkill)
			{
				return tSkill.type;
			}
			return 0;
				
		}
		
		public function get useType():int
		{
			if(tSkill)
			{
				return tSkill.type;
			}
			return 0;
		}
		
		/**
		 * 施法时间 
		 * @return 
		 * 
		 */
		public function get useTime():int
		{
			return _useTime + tSkill.useTime;
		}
		
		/**
		 * 施法时间 
		 * @return 
		 * 
		 */
		public function get useTimeStr():String
		{
			var result:String = tSkill.useTime.toString();
			if(_useTime != 0)
			{
				result += getRuneStr(_useTime);
			}
			return result;
		}
		
		/**
		 * 引导时间 
		 * @return 
		 * 
		 */
		public function get leadTime():int
		{
			if(tSkill)
			{
				return tSkill.leadTime;
			}
			return 0;
		}
		
		/**
		 * 引导次数 
		 * @return 
		 * 
		 */
		public function get leadCount():int
		{
			if(tSkill)
			{
				return tSkill.leadCount;
			}
			return 0;
		}
		
		/**
		 * 冷却时间 
		 * @return 
		 * 
		 */
		public function get cooldownTime():int
		{
			return _coolDownTime + tSkill.cooldownTime;
		}
		
		/**
		 * 冷却时间 
		 * @return 
		 * 
		 */
		public function get cooldownTimeStr():String
		{
			var result:String = Number(tSkill.cooldownTime/1000).toString() + Language.getString(20693);
			if(_coolDownTime != 0)
			{
				result += getRuneStr(Number(_coolDownTime/1000)) + HTMLUtil.addColor(Language.getString(20693),"#FEAE58");
			}
			return result;
		}
		
		public function get skillName():String
		{
			if(tSkill)
			{
				return tSkill.name;
			}
			return "";
		}
		
		
		
		//--------------------- 符文 -------------------------
	
		
		/**
		 * 符文效果 
		 * @param value
		 * @return 
		 * 
		 */
		public function getRuneStr(value:Number,color:String="#FEAE58"):String
		{
			if(value > 0)
			{
				return HTMLUtil.addColor("  " + Language.getString(27526) + "＋" + value,color);
			}
			return HTMLUtil.addColor("  " +  Language.getString(27526) + "－" + (-value),color);
		}
	}
}