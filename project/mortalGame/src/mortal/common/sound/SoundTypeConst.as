/**
 * @date 2011-6-25 上午11:27:59
 * @author  陈炯栩
 * 
 */

package mortal.common.sound
{
	import Message.Public.ECareer;

	public class SoundTypeConst
	{
		
		/**	宝石类操作成功	*/
		public static const JewelsUpdateSuccess:String = "JewelsUpdateSuccess";
		
		/**	宝石类操作失败	*/
		public static const JewelsUpdateFailed:String = "JewelsUpdateFailed";
		
		/**	宠物死亡*/
		public static const PetsDead:String = "PetsDead";
		
		/**	怪物死亡	*/
		public static const MonstersDead:String = "MonstersDead";
		
		/**	技能学习	*/
		public static const LearnSkill:String = "LearnSkill";
		
		/**	角色升级	*/
		public static const RoleUpgrade:String = "RoleUpgrade";	
		
		/**	接受任务	*/
		public static const AcceptTask:String = "AcceptTask";
		
		/**	界面点击	*/
		public static const UIclick:String = "UIclick";
		
		/**	界面关闭	*/
		public static const UIclose:String = "UIclose";
		
		/**	男角色死亡	*/
		public static const MaleRoleDead:String = "MaleRoleDead";
		
		/**	女角色死亡	*/
		public static const FemaleRoleDead:String = "FemaleRoleDead";
		
		/**	拾取物品	*/
		public static const PickupGoods:String = "PickupGoods";	 
		
		/**	完成任务	*/
		public static const CompleteTask:String = "CompleteTask";	 
		
		/**	物品摧毁	*/
		public static const DestroyGoods:String = "DestroyGoods";	 
		
		/**	物品掉落	*/
		public static const GoodsDropOut:String = "GoodsDropOut";	 
		
		/**	物品买卖	*/
		public static const GoodsTrade:String = "GoodsTrade";	 
		
		/**	信件到达	*/
		public static const LettersReack:String = "LettersReack";	 
		
		/**	装备类操作成功	*/
		public static const EquipmentsUpdateSuccess:String = "EquipmentsUpdateSuccess";	 
		
		/**	装备类操作失败	*/
		public static const EquipmentsUpdateFailed:String = "EquipmentsUpdateFailed";	 
		
		/** 烟花音效	*/
		public static const Fireworks:String = "Fireworks";	 
		
		/** 分页按钮	*/
		public static const PagingButtons:String = "PagingButtons";	 
		
		/** 拖动物品	*/
		public static const MoveItems:String = "MoveItems";	 
		
		/** 转移物品	*/
		public static const Transfer:String = "Transfer";	 
		
		/** 打开背包	*/
		public static const OpenBackpack:String = "OpenBackpack";
		
		/** 包裹整理	*/
		public static const BackpackFinishing:String = "BackpackFinishing";
		
		/** 打开任务面板	*/
		public static const OpenTaskPane:String = "OpenTaskPane";
		
		/** 打开商城音效	*/
		public static const OpenMall:String = "OpenMall";
		
		/** 装备修理	*/
		public static const EquipmentRepair:String = "EquipmentRepair";
		
		/** 复活	*/
		public static const Resurrection:String = "Resurrection";
		
		/** 使用药品音效	*/
		public static const UseDrugs:String = "UseDrugs";
		
		/** 任务失败	*/
		public static const TaskFail:String = "TaskFail";
		
		/** 任务删除	*/
		public static const GiveUpTask:String = "GiveUpTask";
		
		/** 宠物升级	*/
		public static const PetUpdate:String = "PetUpdate";
		
		/** 摆摊物品上下架	*/
		public static const GoodsShelves:String = "GoodsShelves";
		
		/** 摆摊	*/
		public static const SetUpAStall:String = "SetUpAStall";
		
		/** 道具传送	*/
		public static const PropertyTransfer:String = "PropertyTransfer";
		
		/** 传送音效	*/
		public static const Delivery:String = "Delivery";
		
		/** 道具BUFF音效	*/
		public static const UseBuffDrugs:String = "UseBuffDrugs";
		
		/** 好友信息提示	*/
		public static const InformationPresentation:String = "InformationPresentation";
		
		/** 召唤宠物	*/
		public static const GetPet:String = "GetPet";
		
		/**	点击NPC	 */		
		public static const ClickNPC:String = "ClickNPC";
		
		/** 新手普通攻击	*/
		public static const Attack00:String = "Attack00";
		
		/** 武灵普通攻击	*/
		public static const Attack01:String = "Attack01";
		
		/** 幻羽普通攻击	*/
		public static const Attack02:String = "Attack02";
		
		/** 法尊普通攻击	*/
		public static const Attack03:String = "Attack03";
		
		/** 天机普通攻击	*/
		public static const Attack04:String = "Attack04";
		
		/** 根骨提升	*/
		public static const GenGuS:String = "GenGuS";
		public static const GenGuF:String = "GenGuF";
		
		/** 炼化 */
		public static const HeCheng:String = "HeCheng";
		
		/** 抽仙境 */
		public static const YaoJiang:String = "YaoJiang";
		
		/** 宠物装备 */
		public static const EquidAdvanted:String = "EquidAdvanted";
		public static const EquidReset:String = "EquidReset";
		public static const PetEquipmentQuality:String = "PetEquipmentQuality";
		
		
		/** 宠物灵性成长提升 */
		public static const LingXingS:String = "LingXingS";
		public static const LingXingF:String = "LingXingF";
		public static const ChengZhangS:String = "ChengZhangS";
		public static const ChengZhangF:String = "ChengZhangF";
		
		/** 装备进阶 */
		public static const StrengEquipmentPerfect:String = "StrengEquipmentPerfect";
		public static const StrengEquipmentNotPerfect:String = "StrengEquipmentNotPerfect";
		public static const WashingEquipment:String = "WashingEquipment";
		public static const EquippedAdvanced:String = "EquippedAdvanced";
		public static const EquipmentDecomposition:String = "EquipmentDecomposition";
		public static const EquipmentQuality:String = "EquipmentQuality";
		public static const EnhancedTransfer:String = "EnhancedTransfer";
		public static const EquipmentPunching:String = "EquipmentPunching";
		public static const EquippedJingLian:String = "EquippedJingLian";
		public static const EquipmentRongH:String = "EquipmentRongH"; //融合
		public static const EquipmentRongL:String = "EquipmentRongL"; //熔炼
		
		/** 宝石操作 */
		public static const JewelsSet:String = "JewelsSet";
		public static const JewelsExtraction:String = "JewelsExtraction";
		public static const JewelsQuenching:String = "JewelsQuenching";
		public static const JewelsSynthesisSuccess:String = "JewelsSynthesisSuccess";
		public static const JewelsSynthesisFailure:String = "JewelsSynthesisFailure";
		public static const JewelsTransformation:String = "JewelsTransformation";
		
		
		/** 铲土挖宝 */
		public static const WordPower:String = "WordPower";
		
		/** 拾取金币 */
		public static const PickUpCoins:String = "PickUpCoins";
		
		
		
		/** 钢琴音符	*/
		public static const piano31:String = "piano31";
		public static const piano32:String = "piano32";
		public static const piano33:String = "piano33";
		public static const piano34:String = "piano34";
		public static const piano35:String = "piano35";
		public static const piano36:String = "piano36";
		public static const piano37:String = "piano37";
		public static const piano21:String = "piano21";
		public static const piano22:String = "piano22";
		public static const piano23:String = "piano23";
		
		
		/**
		 * 返回相应职业的攻击音效type
		 * @param career
		 * 
		 */		
		public static function getAttackSoundByCareer(career:int):String
		{
//			switch(career)
//			{
//				case ECareer._ECareerWarrior:
//				case ECareer._ECareerWarriorD:
//					return Attack01;
//				case ECareer._ECareerArcher:
//				case ECareer._ECareerStabber:
//					return Attack02;
//				case ECareer._ECareerFireMage:
//				case ECareer._ECareerIceMage:
//					return Attack03;
//				case ECareer._ECareerDoctor:
//				case ECareer._ECareerPriest:
//					return Attack04;
//				default:
					return Attack00;
//			}
		}
		
		public function SoundTypeConst()
		{
		}
	}
}