/**
 * @date	2011-2-23 下午02:29:41
 * @author  jianglang
 *  处理游戏整体相关事件
 */

package mortal.game.manager
{
	import baseEngine.system.Device3D;
	
	import com.gengine.global.Global;
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.keyBoard.KeyCode;
	import com.gengine.keyBoard.KeyEvent;
	import com.gengine.utils.MathUitl;
	
	import extend.js.JSASSender;
	
	import fl.controls.TextInput;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import mortal.common.cd.KeyBoardCd;
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.component.gconst.GameConst;
	import mortal.component.window.DebugWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.scene3D.GameCamera;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.chat.ChatModule;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.test.TestPanel;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.IView;

	public class GameManager
	{
		private static var _instance:GameManager=new GameManager();
		
		private var _showHideNum:int = 0;
		
		public function GameManager()
		{
			if (_instance != null)
			{
				throw new Error("GameManager 单例");
			}
		}

		public static function get instance():GameManager
		{
			return _instance;
		}
		
		public var leaveTime:Number = 0;
		CONFIG::Debug
		{
			private var _testPanel:TestPanel;
		}
		
		public function init():void
		{
//			ShortcutsKey.instance.setDefaultShortcutsKey();
			KeyBoardManager.instance.addEventListener(KeyEvent.KEY_DOWN, onKeyDownHandler);
			KeyBoardManager.instance.addEventListener(KeyEvent.KEY_UP, onKeyUpHandler);
			KeyBoardManager.instance.start();
		}

		private function onKeyUpHandler(event:KeyEvent):void
		{
			var keycode:uint=event.keyEvent.keyCode;
//			if (event.keyEvent.keyCode == KeyCode.CONTROL)
//			{
//				AIManager.isStopWalk=false;
//			}
//			else
			if( keycode == KeyCode.D )
			{
				KeyBoardCd.keyUp(keycode);
			}
			else
			{
				if(event.keyData != null && event.keyData.keyMap != null)
				{
					var keyMapKey:Object = event.keyData.keyMap.key;
					if (keyMapKey >= 1 && keyMapKey <= 20) //自定义快捷键
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarKeyUp, keycode));
					}
				}
			}
				
			
		}
		

		private function onKeyDownHandler(event:KeyEvent):void
		{
			if (event.keyEvent.target is TextField)
			{
				if (event.keyEvent.target.type == TextFieldType.INPUT)
				{
					return;
				}
			}
			if (event.keyEvent.target is TextInput)
			{
				return;
			}
			if( hasKeyCodeEvent(event.keyEvent.keyCode,event) == false )
			{
				if( event.keyData.keyMap )
				{
					KeyEventHandler(event.keyData.keyMap.key,event);
				}
			}
		}
		
		/**
		 * 键值 
		 * 
		 */		
		private function hasKeyCodeEvent( keycode:uint ,event:KeyEvent):Boolean
		{
			if(Global.isDebugModle)
			{
				CONFIG::Debug
				{
					if(keycode == KeyCode.I)
					{
						debug();
					}
					if(keycode == KeyCode.N)
					{
						if (Global.isDebugModle)
						{
							if (!_testPanel)
							{
								_testPanel=new TestPanel();
							}
							popupView(_testPanel);
						}
					}
				}
			}
			
			if (keycode == KeyCode.F2)
			{
				if (Global.isDebugModle)
				{
					popupView(DebugWindow.instance);
					return true;
				}
			}
			else if(keycode ==  KeyCode.ESCAPE)
			{
				if( ThingUtil.selectEntity )
				{
					ThingUtil.selectEntity = null;
				}
				else
				{
					PopupManager.closeTopWindow();
				}
				
				return true;
			}
			//全屏
			else if(keycode ==  KeyCode.F8)
			{
				JSASSender.instance.callMapResize(1);
				Dispatcher.dispatchEvent(new DataEvent(EventName.StageResizeF8));
				return true;
			}
			//屏蔽玩家宠物——F9
			else if(keycode == KeyCode.F9)
			{
//				SystemSetter.setShowHideValue();
//				ThingUtil.isEntitySort=true;
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ScreenOrShowPlayer, SystemSetter.currentSetter.hideNearPlayerPet));
//				Dispatcher.dispatchEvent(new DataEvent(EventName.SaveForSliderChange));
				return true;
			}
			//空格翻滚
			else if( keycode ==  KeyCode.SPACE)
			{
				if(!Cache.instance.cd.somersaultCd.isCoolDown)
				{
					var scene:GameScene3D = GameScene3D(Device3D.scene);
					var camerax:Number = GameCamera(scene.camera).x2d;
					var cameray:Number = GameCamera(scene.camera).y2d;
					var mouseX:Number = Global.stage.mouseX + camerax;
					var mouseY:Number = Global.stage.mouseY + cameray;
					
					var dir:Number = MathUitl.getRadiansByXY(RolePlayer.instance.x2d,RolePlayer.instance.y2d,mouseX,mouseY);
					//获取最远的一个点
					var distance:int = GameConst.somersaultDistance;
					var toX:Number = RolePlayer.instance.x2d + (distance - 1) * Math.cos(dir) ;
					var toY:Number = RolePlayer.instance.y2d + (distance - 1) * Math.sin(dir) ;
					Dispatcher.dispatchEvent(new DataEvent(EventName.SceneSomersault,new Point(toX,toY)));
				}
				else
				{
					MsgManager.showRollTipsMsg("翻滚冷却时间未到");
				}
				return true;
			}
			else if( keycode ==  KeyCode.ENTER)
			{
				(GameController.chat.view as ChatModule).setChatInputFocus();
				KeyBoardManager.instance.changeImeEnable(true);
				return true;
			}
			return false;
		}
		
		/**
		 * 映射 
		 * 
		 */		
		private function KeyEventHandler( keycode:Object,event:KeyEvent ):void
		{
			if (keycode == ModuleType.Test) //测试面板
			{
				if (Global.isDebugModle)
				{
//					if (!_testPanel)
//					{
//						_testPanel=new TestPanel();
//					}
//					popupView(_testPanel);
				}
			}
			else if (keycode >= 1 && keycode <= 20) //自定义快捷键
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarKeyDown, keycode));
			}
			else
			{
				popupWindow(keycode);
			}
		}
		
		/**
		 * 调试 
		 * 
		 */
		private function debug():void
		{
			return;
		}
		
		private function onTimerEvent(e:Event):void
		{
			SoundManager.instance.soundPlay(SoundTypeConst.Fireworks);
		}
		
		/**
		 *
		 * @param type
		 *
		 */

		public function popupWindow(type:Object):void
		{
			_soundPlayed = false;
			
			switch (type)
			{
				//切换目标——Tab
				case ModuleType.SwitchTarget: //切换目标
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.TabKeyChangeTarget));
					break;
				}
				case ModuleType.AutoFight:
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_A));
					break;
				}
				case ModuleType.DownUpMounts:
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.RideMount));
					break;
				}
				case ModuleType.PetsRest:
				{
					Dispatcher.dispatchEvent( new DataEvent(EventName.PetOutOrInByShortCut));
					break;
				}
				case ModuleType.PickBox:
				{
					Dispatcher.dispatchEvent( new DataEvent(EventName.KeyPickDropItem));
					break;
				}
				case ModuleType.XP:
				{
					MsgManager.showRollTipsMsg("释放XP技能");
					break;
				}
				case ModuleType.Rest:
				{
					MsgManager.showRollTipsMsg("打坐");
					break;
				}
				case ModuleType.Players: //人物
				{
					popupView(GameController.player.view);
					break;
				}
				//背包——B
				case ModuleType.Pack: //背包
				{
//					if(GameController.pack.view.isHide)
//					{
//						playSound(SoundTypeConst.OpenBackpack);
//					}
					popupView(GameController.pack.view);
					break;
				}
				case ModuleType.Wizard:
				{
					popupView(GameController.wizard.view);
					break;
				}
			    case ModuleType.ShopMall: // 商城
				{
					popupView(GameController.shopMall.view);
					break;
				}
				case ModuleType.Shops: // 商店
				{
					popupView(GameController.shop.view);
					break;
				}	
				case ModuleType.GroupAvatar: // 组队头像
				{
					popupView(GameController.groupAvatarController.view);
					break;
				}
				case ModuleType.Group: // 组队
				{
					popupView(GameController.group.view);
					break;
				}	
				//技能——V
				case ModuleType.Skills: //技能
				{
					popupView(GameController.skill.view);
					break;
				}
				//任务——Q
				case ModuleType.Tasks: //任务
				{
					playSound(SoundTypeConst.OpenTaskPane);
//					popupView(GameController.task.taskMoudle);
					Dispatcher.dispatchEvent(new DataEvent(EventName.TaskShowHideModule));
					break;
				}
				//宠物——W
				case ModuleType.Pets: //宠物
				{
					popupView(GameController.pet.view);
					break;
				}
				//坐骑：
				case ModuleType.Mounts:
				{
					popupView(GameController.mount.view);
					break;
				}
				//充值
				case ModuleType.Pay:
				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.GotoPay));
					break;
				}
				//仙盟——G 
				case ModuleType.Guild:
				{
					popupView(GameController.guild.view);
					break;
				}
				//好友——F
				case ModuleType.Friend: //好友
				{
					popupView(GameController.friend.view);
					break;
				}
				//打造——K
				case ModuleType.Build: //锻造
				{
					popupView(GameController.forging.view);
					break;
				}
				//市场——Y
				case ModuleType.Market: //市场
				{
					popupView(GameController.market.view);
					break;
				}
				case ModuleType.Trade: //交易
				{
					popupView(GameController.trade.view);
					break;
				}
				//地图——M
				case ModuleType.SmallMap: //地图
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapShowHide));
					break;
				}
				//信件——E
				case ModuleType.Mail: //邮件
				{
					popupView(GameController.mail.view);
					break;
				}
				case ModuleType.SysSet: //系统设置
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_ShowHide));
					popupView(GameController.systemSetting.view);
					break;
				}
				default:
				{
				}
			}
			
			if(!_soundPlayed)
			{
				playSound(SoundTypeConst.UIclick);
			}
			
		}

		/**
		 * 根据功能id获取副本id
		 * @param funId
		 * @return
		 *
		 */
		private function getCopyId(funId:int):int
		{
			var temstr:String=funId.toString().substring(2);
			return int(temstr);
		}

		public function popupView(view:IView):void
		{
			if (view.isHide)
			{
				//Log.debug("显示："+view);
				view.show();
			}
			else
			{
				view.hide();
					//Log.debug("隐藏："+view);
			}
		}
		
		/**
		 * 标识是否已播放声音
		 */		
		private var _soundPlayed:Boolean;
		private function playSound(type:String):void
		{
			SoundManager.instance.soundPlay(type);
			_soundPlayed = true;
		}


	}
}
