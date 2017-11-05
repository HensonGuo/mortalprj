package mortal.game.view.pet.view
{
	import Message.DB.Tables.TPetConfig;
	import Message.Game.SPet;
	
	import com.mui.controls.GImageBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.events.DragEvent;
	
	import flash.events.MouseEvent;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.PetConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.PetConfig;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.panel.SkillItem;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class PetSkillSealPanel extends PetPanelBase
	{
		private static const MAX_EQUIP_SKILL_COUNT:int = 8;
		private static const MAX_LIB_SKILL_COUNT:int = 20;
		private var _talentSkill:SkillItem;//天赋技能
		private var _equipSkillList:Vector.<SkillItem> = new Vector.<SkillItem>();
		private var _libSkillList:Vector.<SkillItem> = new Vector.<SkillItem>();
		
		private var _txtName:GTextFiled;
		private var _txtPetType:GTextFiled;
		private var _txtCombat:GTextFiled;
		private var _petHead:GImageBitmap;
		
		public function PetSkillSealPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			LoaderHelp.addResCallBack(ResFileConst.petSkillSeal,layoutUI);
		}
		
		private function layoutUI():void
		{
			_isLoadComplete = true;
			
			UIFactory.bg(184, 69, 570, 418, this);
			UIFactory.bg(189, 73, 560, 110, this, ImagesConst.petSealUpBg);
			UIFactory.bg(189, 356, 560, 128, this, ImagesConst.petSealDownBg);
			UIFactory.bitmap(ImagesConst.petTalentSkillCell, 199, 78, this);
			UIFactory.bitmap(ImagesConst.petEquipSkillTip, 302, 80, this);
			UIFactory.bitmap(ImagesConst.petSealMiddleBg, 189, 186, this);
			
			_talentSkill = UIFactory.getUICompoment(SkillItem,225,105,this);
			_talentSkill.setSize(42, 42);
			_talentSkill.setBg(ImagesConst.PackItemBg);
			_talentSkill.configEventListener(MouseEvent.CLICK, onSealSkill);
			_talentSkill.configEventListener(DragEvent.Event_Move_In, onUnSealOrUpdateSkill);
			
			for (var i:int = 0; i < MAX_EQUIP_SKILL_COUNT; i++)
			{
				var x:int = 304 + 52 * i;
				var y:int = 110;
				var skillItem:SkillItem = UIFactory.getUICompoment(SkillItem, x, y, this);
				skillItem.setSize(42, 42);
				skillItem.setBg(ImagesConst.PackItemBg);
				skillItem.configEventListener(MouseEvent.CLICK, onSealSkill);
				skillItem.configEventListener(DragEvent.Event_Move_In, onUnSealOrUpdateSkill);
				_equipSkillList.push(skillItem);
			}
			
			for (var j:int = 0; j < MAX_LIB_SKILL_COUNT; j++)
			{
				x = 217 + 50 * (j % 10)
				y = j > 9 ? 426 : 378;
				skillItem = UIFactory.getUICompoment(SkillItem, x, y, this);
				skillItem.setSize(42, 42);
				skillItem.setBg(ImagesConst.PackItemBg);
				skillItem.configEventListener(DragEvent.Event_Move_In, onUnSealOrUpdateSkill);
				skillItem.configEventListener(MouseEvent.CLICK, unSealSkill);
				_libSkillList.push(skillItem);
			}
			
			_txtName = UIFactory.gTextField("测试宠物",446,240,92,20,this,GlobalStyle.textFormatItemOrange);
			_txtPetType = UIFactory.gTextField("天阶.神兽",446,260,92,20,this,GlobalStyle.textFormatPutong);
			_txtCombat = UIFactory.gTextField("战斗力.000",446,280,92,20,this,GlobalStyle.textFormatPutong);
			_petHead = UIFactory.gImageBitmap("",386,246,this);
			
			updateMsg(_pet);
			NetDispatcher.addCmdListener(ServerCommand.PetSkillUpdate,onSkillUpdate);
		}
		
		protected function onSkillUpdate(obj:Object):void
		{
			updateMsg(_pet);
		}
		
		
		override public function updateMsg(pet:SPet):void
		{
			super.updateMsg(pet);
			if (!_isLoadComplete)
				return;
			
			if(pet)
			{
				_txtName.htmlText = PetUtil.getNameHtmlText(pet);
				_txtPetType.text = "天阶·神兽";
				_txtCombat.text = "战斗力：" + pet.publicPet.combatCapabilities.toString();
				var tpetConfig:TPetConfig = PetConfig.instance.getInfoByCode(pet.publicPet.code);
				_petHead.imgUrl = tpetConfig.avatar + ".png";
			}
			else
			{
				_txtName.text = "";
				_txtPetType.text = "";
				_txtCombat.text = "";
				_petHead.bitmapData = null;
			}
			
			//天赋技能
			if (pet)
			{
				var talentSkillList:Vector.<SkillInfo> = Cache.instance.pet.getTalentSkillList(pet.publicPet.uid);
				var skillInfo:SkillInfo = talentSkillList.length > 0 ? talentSkillList[0] : null;
				_talentSkill.setSkillInfo(skillInfo);
			}
			else
			{
				_talentSkill.setSkillInfo(null);
			}
			_talentSkill.isDragAble = true;
			
			//刷新技能格子
			for (var i:int = 0; i < MAX_EQUIP_SKILL_COUNT; i++)
			{
				var cell:SkillItem = _equipSkillList[i];
				cell.isDropAble = true;
				if (pet)
				{
					var openNum:int = Cache.instance.pet.getPassiveSkillOpenPosNum(_pet.publicPet.uid);
					var index:int = i + 1;
					if (index > openNum)
					{
						cell.source = GlobalClass.getBitmap(ImagesConst.Locked);
						cell.isDropAble = false;
					}
					else
					{
						skillInfo = Cache.instance.pet.getPetSkill(pet.publicPet.uid, i + PetConst.PASSIVE_SKILL_START_POS);
						cell.setSkillInfo(skillInfo);
						cell.isDragAble = skillInfo != null;
						cell.isDropAble = true;
					}
				}
				else
				{
					cell.setSkillInfo(null);
					cell.isDropAble = false;
				}
			}
			//刷新技能仓库格子
			for (var j:int = 0; j < MAX_LIB_SKILL_COUNT; j++)
			{
				cell = _libSkillList[j];
				skillInfo = Cache.instance.pet.getLibSkill(j);
				cell.setSkillInfo(skillInfo);
				cell.isDropAble = true;
				cell.isDragAble = skillInfo != null;
			}
		}
		
		/**
		 * 封印技能
		 */	
		private function onSealSkill(event:MouseEvent):void
		{
			var item:SkillItem = event.target.parent as SkillItem;
			if (item == null)
				return;
			var skillInfo:SkillInfo = item.dragSource as SkillInfo;
			if (skillInfo == null)
				return;
			var obj:Object = new Object();
			obj.petuid = _pet.publicPet.uid;
			obj.skillID = skillInfo.skillId;
			Dispatcher.dispatchEvent(new DataEvent(EventName.PetSealSkill, obj));
		}
		
		/**
		 * 解封技能
		 */	
		private function unSealSkill(event:MouseEvent):void
		{
			var item:SkillItem = event.target.parent as SkillItem;
			if (item == null)
				return;
			var skillInfo:SkillInfo = item.dragSource as SkillInfo;
			if (skillInfo == null)
				return;
			if (_pet == null)
			{
				MsgManager.showRollTipsMsg("请选择一个宠物");
				return;
			}
			var isTalentSkill:Boolean = PetUtil.isTalentSkill(skillInfo.skillId);
			var toPos:int = searchFreeSkillPos(isTalentSkill);;
			if (toPos == -1)
				return;
			var obj:Object = new Object();
			obj.petuid = _pet.publicPet.uid;
			obj.fromPos = _libSkillList.indexOf(item);
			obj.toPos = toPos;
			Dispatcher.dispatchEvent(new DataEvent(EventName.PetUnsealSkill, obj));
		}
		
		/**
		 * 搜索空闲技能位置
		 */	
		private function searchFreeSkillPos(isTalentSkill:Boolean):int
		{
			if (isTalentSkill)
			{
				for (var i:int = PetConst.TALENT_SKILL_START_POS; i <= PetConst.TALENT_SKILL_END_POS; i++)
				{
					var skill:SkillInfo = Cache.instance.pet.getPetSkill(_pet.publicPet.uid, i);
					if (skill == null)
						return i;
				}
			}
			else
			{
				var openNum:int = Cache.instance.pet.getPassiveSkillOpenPosNum(_pet.publicPet.uid);
				for (i = PetConst.PASSIVE_SKILL_START_POS; i <= PetConst.PASSIVE_SKILL_END_POS; i++)
				{
					var index:int = i - PetConst.PASSIVE_SKILL_START_POS + 1;
					if (index > openNum)
						return -1;
					skill = Cache.instance.pet.getPetSkill(_pet.publicPet.uid, i);
					if (skill == null)
						return i;
				}
			}
			return -1;
		}
		
		/**
		 * 解封技能或者改变技能位置
		 */
		private function onUnSealOrUpdateSkill(event:DragEvent):void
		{
			var dragItem:SkillItem=event.dragItem as SkillItem;
			var dropItem:SkillItem=event.dropItem as SkillItem;
			var dragItemIsLibSkill:Boolean = _libSkillList.indexOf(dragItem) != -1;
			var dropItemIsPetSkill:Boolean = _equipSkillList.indexOf(dropItem) != -1 || dropItem == _talentSkill;
			if (dragItemIsLibSkill && dropItemIsPetSkill)
			{
				//解封技能
				if (dropItem.dragSource != null)
				{
					MsgManager.showRollTipsMsg("请选择空闲的技能位！");
					return;
				}
				var dragItemIsTalentSkill:Boolean = PetUtil.isTalentSkill((dragItem.dragSource as SkillInfo).skillId);
				if (dragItemIsTalentSkill)
				{
					if (dropItem != _talentSkill)
					{
						MsgManager.showRollTipsMsg("请将天赋技能放置正确的位置！");
						return;
					}
				}
				var dropItemIsTalentSkill:Boolean = dropItem == _talentSkill;
				if (dropItemIsTalentSkill)
				{
					if (!dragItemIsTalentSkill)
					{
						MsgManager.showRollTipsMsg("此位置只能放置天赋技能！");
						return;
					}
				}
				if (_pet == null)
				{
					MsgManager.showRollTipsMsg("请选择一个宠物");
					return;
				}
				var obj:Object = new Object();
				obj.petuid = _pet.publicPet.uid;
				obj.fromPos = _libSkillList.indexOf(dragItem);
				obj.toPos = _equipSkillList.indexOf(dropItem) + PetConst.PASSIVE_SKILL_START_POS;
				Dispatcher.dispatchEvent(new DataEvent(EventName.PetUnsealSkill, obj));
			}
			else if (!dragItemIsLibSkill && dropItemIsPetSkill)
			{
				//更改宠物技能位置
				obj = new Object();
				obj.petuid = _pet.publicPet.uid;
				obj.skillID = (dragItem.dragSource as SkillInfo).skillId;
				obj.toPos = _equipSkillList.indexOf(dropItem) + PetConst.PASSIVE_SKILL_START_POS;
				Dispatcher.dispatchEvent(new DataEvent(EventName.PetChangeSkillPos, obj));
			}
		}
		
		override public function updatePetAttribute(uid:String):void
		{
			if (_pet && _pet.publicPet.uid == uid)
			{
				updateMsg(_pet);
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_equipSkillList.length = 0;
			_libSkillList.length = 0;
			NetDispatcher.removeCmdListener(ServerCommand.PetSkillUpdate,onSkillUpdate);
			super.disposeImpl(isReuse);
		}
	}
}