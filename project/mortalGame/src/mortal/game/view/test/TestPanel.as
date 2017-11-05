package mortal.game.view.test
{
	import Message.Game.AMI_IMap_revival;
	import Message.Game.AMI_IPet_getPetInfo;
	import Message.Game.AMI_IPet_getPlayerPetInfo;
	import Message.Game.AMI_IPet_setPetMode;
	import Message.Game.AMI_IPet_setPetState;
	import Message.Game.AMI_ITest_addBuff;
	import Message.Game.AMI_ITest_addExperience;
	import Message.Game.AMI_ITest_addItem;
	import Message.Game.AMI_ITest_addLifeOrMana;
	import Message.Game.AMI_ITest_addMoney;
	import Message.Game.AMI_ITest_changeCamp;
	import Message.Game.AMI_ITest_changeGuildData;
	import Message.Game.AMI_ITest_clearBoss;
	import Message.Game.AMI_ITest_clearMount;
	import Message.Game.AMI_ITest_completeTask;
	import Message.Game.AMI_ITest_createBoss;
	import Message.Game.AMI_ITest_endTask;
	import Message.Game.AMI_ITest_passMap;
	import Message.Game.AMI_ITest_updateLevel;
	import Message.Game.AMI_ITest_updateOnlineTime;
	import Message.Game.SPet;
	import Message.Public.ECareer;
	import Message.Public.EEntityType;
	import Message.Public.EPetState;
	import Message.Public.EPrictUnit;
	import Message.Public.ERevival;
	import Message.Public.SEntityId;
	import Message.Public.SPoint;
	
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.display.ScaleBitmap;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mortal.common.DisplayUtil;
	import mortal.component.window.BaseWindow;
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.scene3D.fight.SkillEffectUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	
	public class TestPanel extends BaseWindow
	{
		private var _scrollPane:GScrollPane;
		private var _leftBodySprite:Sprite;
		private var _rightBodySprite:Sprite;
		
		public function TestPanel()
		{
			super();
			setSize(900,550);
			titleHeight = 35;
		}
		
		private function addButton( name:String,box:DisplayObjectContainer ,width:Number = 60):GButton
		{
			var btn:GButton = UIFactory.gButton(name,0,0,width,22,box);
			return btn;
		}
		
		private function addTextInput(box:DisplayObjectContainer,width:Number = 60):GTextInput
		{
			var text:GTextInput = UIFactory.gTextInput(0,0,width,20,box);
			//			text.restrict = "0-9";
			return text;
		}
		
		private function addTextFiled( name:String,box:DisplayObjectContainer,width:Number = 80 ):TextField
		{
			return UIFactory.textField(name,0,0,width,20,box);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			var bg:ScaleBitmap = UIFactory.bg(17,45,868,490,this);
			
			_rightBodySprite = new Sprite();
			_rightBodySprite.x = 439;
			_rightBodySprite.y = 48;
			_rightBodySprite.mouseEnabled = false;
			this.addChild(_rightBodySprite);
			
			_leftBodySprite = new Sprite();
			_leftBodySprite.mouseEnabled = false;
			_leftBodySprite.x = 20;
			_leftBodySprite.y = 48;
			this.addChild(_leftBodySprite);
			
			//左边
			addBoss();
			addRelive();
			addMapPass();
			addMapJump();
			addMoney();
			addLevel();
			addCamp();
			addPet();
			addMount();
			addWizard();
			addSceen();
			addGuildData();
			addTestMemory();
			
			//右边
			addItem();
			addItemByName();
			addSkill();
			testSystemSetting();
			addOnlineTime();
			addShortcut();
			addBuff();
			addBlood();
			addExp();
			addCopy();
			addClearBoss();
			addRune();
			addTask();
		}
		
		private function addTask():void
		{
			var box:GBox = addRightBox();
			addTextFiled("任务Id：", box, 80);
			var textInput:GTextInput = addTextInput(box,100);
			var btn:Button = addButton("完成任务",box);
			var btn2:Button = addButton("提交任务",box);
			btn.addEventListener(MouseEvent.CLICK, completeHandler);
			btn2.addEventListener(MouseEvent.CLICK, endHandler);
			function completeHandler(evt:MouseEvent):void
			{
				var id:int = int(textInput.text);
				GameRMI.instance.iTestPrx.completeTask_async(new AMI_ITest_completeTask(), id);
			}
			function endHandler(evt:MouseEvent):void
			{
				var id:int = int(textInput.text);
				GameRMI.instance.iTestPrx.endTask_async(new AMI_ITest_endTask(), id);
			}
		}
		
		private function addRune():void
		{
			var box:GBox = addRightBox();
			addTextFiled("符文Id：", box, 80);
			var textInput:GTextInput = addTextInput(box,100);
			var btn:Button = addButton("激活符文",box);
			var btn2:Button = addButton("升级符文",box);
			btn.addEventListener(MouseEvent.CLICK, activeHandler);
			btn2.addEventListener(MouseEvent.CLICK, upgradeHandler);
			function activeHandler(evt:MouseEvent):void
			{
				var id:int = int(textInput.text);
				GameProxy.role.activeRune(id);
			}
			function upgradeHandler(evt:MouseEvent):void
			{
				var id:int = int(textInput.text);
				GameProxy.role.upgradeRune(id);
			}
		}
		
		
		private function addBoss():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("刷怪：",box,40);
			var textInput:GTextInput = addTextInput(box,100);
			textInput.text = "10000000";
			
			var btn:Button = addButton("刷怪",box);
			btn.addEventListener(MouseEvent.CLICK,addBossHandler);
			
			function addBossHandler():void
			{
				GameRMI.instance.iTestPrx.createBoss_async(new AMI_ITest_createBoss(),int(textInput.text));
			}
		}
		
		private function addItem():void
		{
			var box:GBox = addRightBox();
			addTextFiled("物品Code：", box, 80);
			var textInput:GTextInput = addTextInput(box,100);
			textInput.text = "110000002";
			addTextFiled("数量：",box,40);
			var textInput2:GTextInput = addTextInput(box,100);
			textInput2.text = "1";
			
			var btn:Button = addButton("添加",box);
			btn.addEventListener(MouseEvent.CLICK,addBossHandler);
			
			function addBossHandler():void
			{
				GameRMI.instance.iTestPrx.addItem_async(new AMI_ITest_addItem(), int(textInput.text), int(textInput2.text));
			}
		}
		
		private function addItemByName():void
		{
			var box:GBox = addRightBox();
			addTextFiled("物品名字：", box, 80);
			var textInput:GTextInput = addTextInput(box,80);
			textInput.text = "";
			
			var btn2:Button = addButton("获取Id",box);
			btn2.addEventListener(MouseEvent.CLICK,getIdHandler);
			
		
			addTextFiled("物品Id：",box,40);
			var textInput2:GTextInput = addTextInput(box,80);
			textInput2.text = "";
			
			var btn:Button = addButton("添加",box);
			btn.addEventListener(MouseEvent.CLICK,addItemHandler);
			
			function addItemHandler():void
			{
				GameRMI.instance.iTestPrx.addItem_async(new AMI_ITest_addItem(), int(textInput2.text), 1);
			}
			
			function getIdHandler():void
			{
				var itemInfo:ItemInfo = ItemConfig.instance.getItemNameByCode(textInput.text);
				if(itemInfo)
				{
					var id:int = ItemConfig.instance.getItemNameByCode(textInput.text).code;
				}
				else
				{
					MsgManager.showRollTipsMsg("物品不存在");
				}
				
				textInput2.text = id.toString();
			}
		}
		
		private function addMount():void
		{
			var box:GBox = addLeftBox();
			
			var cb:GComboBox = UIFactory.gComboBox(120,70,100,22);
			cb.editable = false;
			cb.addItem({label:"所有绿色坐骑",type:0});
			cb.addItem({label:"所有蓝色坐骑",type:1});
			cb.addItem({label:"所有紫色坐骑",type:2});
			cb.addItem({label:"所有橙色坐骑",type:3});
			box.addChild(cb);
			cb.drawNow();
			
			var btn:Button = addButton("添加",box);
			btn.addEventListener(MouseEvent.CLICK,addMountHandler);
			
			var btn2:Button = addButton("删除所有坐骑",box,100);
			btn2.addEventListener(MouseEvent.CLICK,delMountHandler);
			
			function addMountHandler():void
			{
				for each(var i:MountData in MountConfig.instance.mountList)
				{
					GameRMI.instance.iTestPrx.addItem_async(new AMI_ITest_addItem(), i.itemMountInfo.species + int(cb.selectedItem["type"]), 1);
				}
			}
			
			function delMountHandler():void
			{
				for each(var i:MountData in MountConfig.instance.mountList)
				{
					GameRMI.instance.iTestPrx.clearMount_async(new AMI_ITest_clearMount());
				}
			}
		}
		
		private function addWizard():void
		{
			var box:GBox = addLeftBox();
			
			var cb:GComboBox = UIFactory.gComboBox(120,70,100,22);
			cb.editable = false;
			cb.addItem({label:"第一斗魂",type:180061000});
			cb.addItem({label:"第二斗魂",type:180061001});
			cb.addItem({label:"第三斗魂",type:180061002});
			cb.addItem({label:"第四斗魂",type:180061003});
			box.addChild(cb);
			cb.drawNow();
			
			var btn:Button = addButton("添加",box);
			btn.addEventListener(MouseEvent.CLICK,addMountHandler);
			
			function addMountHandler():void
			{
				GameRMI.instance.iTestPrx.addItem_async(new AMI_ITest_addItem(), cb.selectedItem["type"], 1);
			}
		}
		
		private function addGuildData():void
		{
			var box:GBox = addLeftBox();
			
			var cb:GComboBox = UIFactory.gComboBox(120,70,100,22);
			cb.editable = false;
			cb.addItem({label:"工会资源",type:1});
			cb.addItem({label:"工会资金",type:2});
			cb.addItem({label:"玩家今日贡献",type:3});
			cb.addItem({label:"玩家本周贡献",type:4});
			cb.addItem({label:"玩家总贡献",type:5});
			cb.addItem({label:"玩家当前贡献",type:6});
			cb.addItem({label:"玩家活跃度",type:7});
			cb.addItem({label:"玩家累存资源",type:8});
			box.addChild(cb);
			cb.drawNow();
			
			var textInput:GTextInput = addTextInput(box,80);
			textInput.text = "";
			
			var btn:Button = addButton("添加",box);
			function addHandler():void
			{
				GameRMI.instance.iTestPrx.changeGuildData_async(new AMI_ITest_changeGuildData(), cb.selectedItem["type"], int(textInput.text));
			}
			btn.addEventListener(MouseEvent.CLICK,addHandler);
		}
		
		private var _zujians:Array = [];
		private function addTestMemory():void
		{
			var box:GBox = addLeftBox();
			var btn1:Button = addButton("测试组件内存",box);
			btn1.addEventListener(MouseEvent.CLICK,onClickBtnxx);
			function onClickBtnxx(e:MouseEvent):void
			{
				if(_zujians.length > 0)
				{
					for(var i:int = 0; i < _zujians.length; i++)
					{
						BitmapNumberText(_zujians[i]).dispose(true);
					}
				}
				_zujians = [];
				for(i = 0; i < 100; i++)
				{
					var text:BitmapNumberText = UIFactory.bitmapNumberText(0, 0, "EquipmentTipsNumber.png", 16, 16, -5);
					text.text = "1234324323422";
					_zujians.push(text);
				}
			}
		}
		
		
		private function addSceen():void
		{
			var box:GBox = addLeftBox();
			var btn1:Button = addButton("锁屏",box);
			var btn2:Button = addButton("解除锁屏",box);
			var btn3:Button = addButton("移动屏幕",box);
			var btn4:Button = addButton("解除移动",box);
			var btn5:Button = addButton("说话",box);
			var btn6:Button = addButton("移除说话",box);
			
			btn1.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn2.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn3.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn4.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn5.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn6.addEventListener(MouseEvent.CLICK,onClickBtn);
			
			
			box = addLeftBox();
			var btn7:Button = addButton("抖屏",box);
			var btn8:Button = addButton("剧情特效",box);
			var btn9:Button = addButton("移除特效",box);
			var btn10:Button = addButton("缩放屏幕",box);
			
			btn7.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn8.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn9.addEventListener(MouseEvent.CLICK,onClickBtn);
			btn10.addEventListener(MouseEvent.CLICK,onClickBtn);
			
			function onClickBtn(e:MouseEvent):void
			{
				var btn:Button = e.currentTarget as Button;
				switch(btn)
				{
					case btn1:
						//						Game.scene.lockSceen();
						Game.scene.setMouseEnabled(false);
						break;
					case btn2:
						//						Game.scene.unLockSceen();
						Game.scene.setMouseEnabled(true);
						break;
					case btn3:
						Game.scene.tweenScrollRect(1000,1000);
						break;
					case btn4:
						Game.scene.stopTweenScrollRect();
						break;
					case btn5:
						LayerManager.entityTalkLayer.addTalk(RolePlayer.instance,"/1我就说句话而已，不要介意噢/b1");
						break;
					case btn6:
						LayerManager.entityTalkLayer.removeTalk(RolePlayer.instance);
						break;
					case btn7:
						Game.scene.shake(0);
						break;
					case btn8:
						SkillEffectUtil.addDramaEffect(100000);
						break;
					case btn9:
						SkillEffectUtil.removeDramaEffect(100000);
						break;
					case btn10:
						if(Game.scene.sceneScale == 1)
						{
							Game.scene.sceneScale = 0.8;
							RolePlayer.instance.scaleX = 2;
							RolePlayer.instance.scaleY = 2;
							RolePlayer.instance.scaleZ = 2;

						}
						else
						{
							Game.scene.sceneScale = 1;
							RolePlayer.instance.scaleX = 1;
							RolePlayer.instance.scaleY = 1;
							RolePlayer.instance.scaleZ = 1;
						}
						break;
				}
			}
		}
		
		private function addExp():void
		{
			var box:GBox = addRightBox();
			addTextFiled("加经验：", box, 80);
			var textInput:GTextInput = addTextInput(box, 80);
			textInput.text = "1000";
			
			var cb:GComboBox = UIFactory.gComboBox(100,70,80,22);
			cb.editable = false;
			cb.addItem({label:"人物",type:1});
			cb.addItem({label:"宠物",type:4});
			box.addChild(cb);
			cb.drawNow();
			
			var btn:Button = addButton("添加",box);
			btn.addEventListener(MouseEvent.CLICK,addBossHandler);
			
			function addBossHandler(e:MouseEvent):void
			{
				GameRMI.instance.iTestPrx.addExperience_async(new AMI_ITest_addExperience(), new EEntityType(int(cb.selectedItem["type"])), int(textInput.text));
			}
		}
		
		private function addCopy():void
		{
			var box:GBox = addRightBox();
			var txt:TextField = addTextFiled("副本ID：", box, 80);
			var textInput:GTextInput = addTextInput(box, 80);
			
			var btn:Button = addButton("进入",box);
			btn.addEventListener(MouseEvent.CLICK, enterCopyHandler);
			var btn2:Button = addButton("退出", box);
			btn2.addEventListener(MouseEvent.CLICK, leaveCopy);
			
			function enterCopyHandler(evt:MouseEvent):void
			{
				var id:int = int(textInput.text);
				GameProxy.copy.enterCopy(id);
			}
			function leaveCopy(evt:MouseEvent):void
			{
				GameProxy.copy.leaveCopy();
			}
		}
		
		private function testSystemSetting():void
		{
			var box:GBox = addRightBox();
			var check:GCheckBox = UIFactory.checkBox("Debug学习、升级技能", 0, 0, 150, 25, box);
			
			var isDone:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
			check.selected = isDone;
			
			check.addEventListener(Event.CHANGE, selectedChanged);
			function selectedChanged(evt:Event):void
			{
				ClientSetting.local.setIsDone(check.selected, IsDoneType.IsSkillDebug);
				//				SystemSetting.save();
			}
			
			var isCD:GCheckBox = UIFactory.checkBox("使用技能不CD", 0, 0, 150, 25, box);
			var isCDData:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsNotCD);
			isCD.selected = isCDData;
			isCD.addEventListener(Event.CHANGE, cdChanged);
			function cdChanged(evt:Event):void
			{
				ClientSetting.local.setIsDone(isCD.selected, IsDoneType.IsNotCD);
			}
			
			var btn:GButton = UIFactory.gButton("仇恨调试", 0, 0, 50, 22, box);
			btn.addEventListener(MouseEvent.CLICK, showThreatHandler);
			function showThreatHandler(evt:MouseEvent):void
			{
				if(GameController.skill.threatModule.isHide)
				{
					GameController.skill.threatModule.show()
				}
				else
				{
					GameController.skill.threatModule.hide();
				}
			}
		}
		
		private function addSkill():void
		{
			var box:GBox = addRightBox();
			addTextFiled("技能Id：", box, 80);
			var textInput:GTextInput = addTextInput(box,150);
			
			switch(Cache.instance.role.roleInfo.career)
			{
				case ECareer._ECareerWarrior:
					textInput.text = "10001001";
					break;
				case ECareer._ECareerArcher:
					textInput.text = "11001001";
					break;
				case ECareer._ECareerMage:
					textInput.text = "12001001";
					break;
				case ECareer._ECareerPriest:
					textInput.text = "13001001";
					break;
			}
			
			
			var btn:Button = addButton("学习技能",box);
			btn.addEventListener(MouseEvent.CLICK, learnSkillHandler);
			
			
			
			
			function learnSkillHandler():void
			{
				var isDebug2:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
				GameProxy.role.learnSkill(int(textInput.text), isDebug2);
			}
			
			
			var box2:GBox = addRightBox();
			addTextFiled("技能Id：", box2, 80);
			var textInput2:GTextInput = addTextInput(box2,100);
			textInput2.text = "10001001";
			
			var btn2:Button = addButton("升级技能",box2);
			btn2.addEventListener(MouseEvent.CLICK, upgradeSkillhandler);
			
			function upgradeSkillhandler():void
			{
				var isDebug:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
				GameProxy.role.upgradeSkill(int(textInput2.text), isDebug);
			}
		}
		
		private function addRelive():void
		{
			var box:GBox = addLeftBox();
			
			var btn:Button = addButton("复活",box);
			btn.addEventListener(MouseEvent.CLICK,reliveHandler);
			
			function reliveHandler():void
			{
				GameRMI.instance.iMapPrx.revival_async(new AMI_IMap_revival(),ERevival._ERevivalPoint);
			}
		}
		
		/**
		 * 添加地图传送 
		 * 
		 */		
		private function addMapPass():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("地图Id", box, 50);
			var textInput:GTextInput = addTextInput(box,60);
			
			var btn:Button = addButton("传送",box);
			btn.addEventListener(MouseEvent.CLICK,passHandler);
			
			function passHandler():void
			{
				var mapId:int = int(textInput.text);
				GameRMI.instance.iTestPrx.passMap_async(new AMI_ITest_passMap(),mapId);
			}
		}
		
		private function addMoney():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("加金钱：",box);
			
			var cb:GComboBox = UIFactory.gComboBox(100,70,80,22);
			cb.editable = false;
			
			cb.addItem({label:"元宝",type:EPrictUnit._EPriceUnitGold});
			cb.addItem({label:"绑定元宝",type:EPrictUnit._EPriceUnitGoldBind});
			cb.addItem({label:"铜钱",type:EPrictUnit._EPriceUnitCoin});
			cb.addItem({label:"绑定铜钱",type:EPrictUnit._EPriceUnitCoinBind});
			cb.addItem({label:"真气",type:EPrictUnit._EPriceUnitVitalEnergy});
			cb.addItem({label:"符能",type:EPrictUnit._EPriceUnitRunicPower});
			
			box.addChild(cb);
			cb.drawNow();
			
			var moneyAmount:TextInput = addTextInput(box);;
			moneyAmount.text  = "5000";
			
			var btn:Button = addButton("确定",box);
			btn.addEventListener(MouseEvent.CLICK,addMoneyHandler);
			
			var allbtn:Button = addButton("全加1万",box,60);
			allbtn.addEventListener(MouseEvent.CLICK,addallMoneyHandler);
			
			function addallMoneyHandler(e:MouseEvent):void
			{
				var arr:Array = [EPrictUnit._EPriceUnitGold,EPrictUnit._EPriceUnitGoldBind,EPrictUnit._EPriceUnitCoin,EPrictUnit._EPriceUnitVitalEnergy,EPrictUnit._EPriceUnitCoinBind]
				for each(var i:int in arr)
				{
					GameRMI.instance.iTestPrx.addMoney_async(new AMI_ITest_addMoney(),i,10000);
				}
			}
			
			function addMoneyHandler(e:MouseEvent):void
			{
				GameRMI.instance.iTestPrx.addMoney_async(new AMI_ITest_addMoney(),parseInt(cb.selectedItem["type"]),parseInt(moneyAmount.text));
			}
		}
		
		/**
		 * 更新等级 
		 * 
		 */		
		private function addLevel():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("更新等级", box, 50);
			var textInput:GTextInput = addTextInput(box,60);
			textInput.text = "60";
			
			var cb:GComboBox = UIFactory.gComboBox(100,70,80,22);
			cb.editable = false;
			cb.addItem({label:"人物",type:1});
			cb.addItem({label:"宠物",type:4});
			box.addChild(cb);
			cb.drawNow();
			
			var btn:Button = addButton("确定",box);
			btn.addEventListener(MouseEvent.CLICK,passHandler);
			
			function passHandler():void
			{
				var level:int = int(textInput.text);
				GameRMI.instance.iTestPrx.updateLevel_async( new AMI_ITest_updateLevel(successUpDate,null,level), new EEntityType(int(cb.selectedItem["type"])) , level);
			}
			
			function successUpDate(e:AMI_ITest_updateLevel):void
			{
				Cache.instance.role.entityInfo.level = int(e.userObject);
			}
		}
		
		/**
		 * 修改阵营 
		 * 
		 */		
		private function addCamp():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("更新阵营", box, 50);
			
			var cb:GComboBox = UIFactory.gComboBox(100,70,80,22);
			cb.editable = false;
			cb.addItem({label:"仙",type:1});
			cb.addItem({label:"魔",type:2});
			cb.addItem({label:"妖",type:3});
			box.addChild(cb);
			cb.drawNow();
			
			var btn:Button = addButton("确定",box);
			btn.addEventListener(MouseEvent.CLICK,passHandler);
			
			function passHandler():void
			{
				GameRMI.instance.iTestPrx.changeCamp_async( new AMI_ITest_changeCamp(), int(cb.selectedItem["type"]));
			}
		}
		
		/**
		 * 添加宠物 
		 * 
		 */		
		private function addPet():void
		{
			var box:GBox = addLeftBox();
			
			var btn:Button;
			btn = addButton("获取宠物",box);
			btn.addEventListener(MouseEvent.CLICK,getPetHandler);
			
			btn = addButton("出战宠物",box);
			btn.addEventListener(MouseEvent.CLICK,petHandler);
			
			
			function getPetHandler():void
			{
				GameRMI.instance.iPetPrx.getPlayerPetInfo_async(new AMI_IPet_getPlayerPetInfo());
			}
			
			function petHandler():void
			{
				var uid:String;
				if( Cache.instance.pet.pets.length)
				{
					var num:int = int(Math.random() * Cache.instance.pet.pets.length);
					uid = Cache.instance.pet.pets[num].publicPet.uid;
					GameRMI.instance.iPetPrx.setPetState_async( new AMI_IPet_setPetState(),uid,new EPetState(EPetState._EPetStateActive));
				}
			}
		}
		
		/**
		 * 修改buff 
		 * 
		 */		
		private function addBuff():void
		{
			var box:GBox = addRightBox();
			addTextFiled("buff",box);
			
			var textInput:GTextInput = addTextInput(box,80);
			textInput.text = "10010001";
			
			var btn:Button = addButton("确定",box);
			btn.addEventListener(MouseEvent.CLICK,changeBuffHandler);
			
			function changeBuffHandler(e:MouseEvent):void
			{
				GameRMI.instance.iTestPrx.addBuff_async(new AMI_ITest_addBuff(),int(textInput.text));
			}
		}
		
		
		/**
		 * 加血加魔 
		 * 
		 */		
		private function addBlood():void
		{
			var box:GBox = addRightBox();
			addTextFiled("血量",box);
			
			var cb:GComboBox = UIFactory.gComboBox(100,70,80,22);
			cb.editable = false;
			cb.addItem({label:"血液",type:1});
			cb.addItem({label:"蓝",type:2});
			box.addChild(cb);
			cb.drawNow();
			
			var tg:GComboBox = UIFactory.gComboBox(150,70,80,22);
			tg.editable = false;
			tg.addItem({label:"人物",type:1});
			tg.addItem({label:"宠物",type:4});
			box.addChild(tg);
			tg.addEventListener(Event.CHANGE,onChangeCb);
			tg.drawNow();
			
			var tg2:GComboBox = UIFactory.gComboBox(150,70,80,22);
			tg2.editable = false;
			tg2.drawNow();
			
			var textInput:GTextInput = addTextInput(box,60);
			textInput.text = "10000";
			
			var btn:Button = addButton("确定",box);
			btn.addEventListener(MouseEvent.CLICK,changeBlood);
			
			function onChangeCb(e:Event):void
			{
				var type:int = tg.selectedItem["type"];
				if(type == 1)
				{
					DisplayUtil.removeMe(tg2);
					box.resetPosition2();
				}
				else
				{
					box.addChildAt(tg2,3);
					updateTg2();
					box.resetPosition2();
				}
			}
			
			function updateTg2():void
			{
				tg2.removeAll();
				if(Cache.instance.pet.pets && Cache.instance.pet.pets.length)
				{
					for(var i:int = 0;i < Cache.instance.pet.pets.length;i++)
					{
						var pet:SPet = Cache.instance.pet.pets[i] as SPet;
						tg2.addItem({label:pet.publicPet.name,uid:pet.publicPet.uid});
					}
				}
				tg2.drawNow();
			}
			
			function changeBlood(e:MouseEvent):void
			{
				var type:int = tg.selectedItem["type"];
				var uid:String = "";
				if(type == 4 && tg2.dataProvider.length)
				{
					uid = tg2.selectedItem["uid"];
				}
				GameRMI.instance.iTestPrx.addLifeOrMana_async(new AMI_ITest_addLifeOrMana(),new EEntityType(parseInt(tg.selectedItem["type"])), parseInt(cb.selectedItem["type"]),int(textInput.text), uid);
			}
		}
		
		/**
		 * 修改在线时间 
		 * 
		 */		
		private function addOnlineTime():void
		{
			var box:GBox = addRightBox();
			addTextFiled("在线时间(分钟)",box);
			
			var textInput:GTextInput = addTextInput(box,60);
			
			var btn:Button = addButton("修改",box);
			btn.addEventListener(MouseEvent.CLICK,changeTimeHandler);
			
			function changeTimeHandler(e:MouseEvent):void
			{
				GameRMI.instance.iTestPrx.updateOnlineTime_async(new AMI_ITest_updateOnlineTime(),int(textInput.text));
			}
		}
		
		private function addShortcut():void
		{
			var box:GBox = addRightBox();
			addTextFiled("技能ID：",box);
			
			var textInput:GTextInput = addTextInput(box,100);
			
			addTextFiled("快捷键1-20",box);
			var textInput2:GTextInput = addTextInput(box,60);
			
			var btn:Button = addButton("添加",box);
			btn.addEventListener(MouseEvent.CLICK,changeTimeHandler);
			
			function changeTimeHandler(e:MouseEvent):void
			{
				var pos:int = int(textInput2.text);
				if(pos < 1 || pos > 20)
				{
					return;
				}
				Cache.instance.shortcut.addShortCut(pos, CDDataType.skillInfo, int(textInput.text));
				Cache.instance.shortcut.save();
			}
		}
		
		/**
		 * 添加地图传送 
		 * 
		 */		
		private function addMapJump():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("x", box, 20);
			var textInput:GTextInput = addTextInput(box,60);
			
			addTextFiled("y", box, 20);
			var textInput2:GTextInput = addTextInput(box,60);
			
			var btn:Button = addButton("跳跃",box);
			btn.addEventListener(MouseEvent.CLICK,jumpHandler);
			
			function jumpHandler():void
			{
				var x:int = int(textInput.text);
				var y:int = int(textInput2.text);
				var p:SPoint =  new SPoint();
				p.x = x;
				p.y = y;
				GameProxy.sceneProxy.jumpPoint(p);
			}
		}
		
		private function addClearBoss():void
		{
			var box:GBox = addLeftBox();
			
			addTextFiled("负数清除所有怪", box, 90);
			var textInput:GTextInput = addTextInput(box,60);
			textInput.text = "-1";
			
			var btn:Button = addButton("清除boss",box);
			btn.addEventListener(MouseEvent.CLICK,kill);
			
			function kill(e:MouseEvent):void
			{
				GameRMI.instance.iTestPrx.clearBoss_async(new AMI_ITest_clearBoss(),int(textInput.text),new SEntityId);
			}
		}
		
		/************************************************************
		 * 右边
		/************************************************************/
		private function addRightBox():GBox
		{
			var box:GBox = new GBox();
			box.horizontalGap = 5;
			box.direction = GBoxDirection.HORIZONTAL;
			_rightBodySprite.addChild(box);
			box.y = _rightY;
			
			_rightY += 25;
			return box;
		}
		private var _rightY:int = 0;
		
		private function addLeftBox():GBox
		{
			var box:GBox = new GBox();
			box.horizontalGap = 5;
			box.direction = GBoxDirection.HORIZONTAL;
			box.x = 0;
			box.y = _leftY;
			_leftBodySprite.addChild(box);
			_leftY += 25;
			return box;
		}
		private var _leftY:Number = 0;
	}
}