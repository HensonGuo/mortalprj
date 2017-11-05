package mortal.game.view.forging.view
{
	import Message.DB.Tables.TPlayerModel;
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.DragEvent;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemExInfo;
	import mortal.game.resource.tableConfig.PlayerModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.scene3D.player.entity.RoleModelPlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.common.display.NumberManager;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.game.view.palyer.EquipsPanel;
	import mortal.game.view.palyer.PlayerEquipItem;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 锻造界面的右侧装备展示部分
	 * @date   2014-3-17 下午2:47:24
	 * @author dengwj
	 */	 
	public class EquipDisplaySpr extends GSprite
	{
		/** 标题底子 */
		private var _titleBg:ScaleBitmap;
		/** 标题 */
		private var _titleLabel:GBitmap;
		
		private var _equipPanel:EquipsPanel;
		
		private var _leftBtn:GLoadedButton;
		
		private var _rightBtn:GLoadedButton;
		
		private var _roleModelPlayer:RoleModelPlayer;
		
		private var _frameTimer:FrameTimer;
		
		private var _img2d:Img2D;
		
		protected var _window:Window;
		
		private var turnValue:int;
		
		/** 技能格子 */
		private var _skillGrids:GBitmap;
		/** 战斗力底子 */

		private var _fightBg:GBitmap;
		/** 战斗力文字 */
		private var _fightText:BitmapText;
		/** 当前选中装备 */
		private var _currSelEquip:PlayerEquipItem;
		
		public function EquipDisplaySpr(window:Window)
		{
			_window = window;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this._titleBg = UIFactory.bg(3,56,286,26,this,ImagesConst.RegionTitleBg);
			this._titleLabel = UIFactory.gBitmap("",10,63,this);
			
			_leftBtn = UIFactory.gLoadedButton(ImagesConst.TurnLeft_upSkin,192,320,40,36,this);
			_leftBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			_leftBtn.configEventListener(MouseEvent.MOUSE_UP,stopTurning);
			
			_rightBtn = UIFactory.gLoadedButton(ImagesConst.TurnRight_upSkin,58,320,40,36,this);
			_rightBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			_rightBtn.configEventListener(MouseEvent.MOUSE_UP,stopTurning);
			
			createSkillList();
			
			_equipPanel = UICompomentPool.getUICompoment(EquipsPanel);
			_equipPanel.createDisposedChildren();
			_equipPanel.x = 5;
			_equipPanel.y = 20;
			this.addChild(_equipPanel);
			_equipPanel.configEventListener(MouseEvent.CLICK,onClickHandler);
			this.configEventListener(DragEvent.Event_Move_In,moveInHandler);
			this._skillGrids = UIFactory.gBitmap(ImagesConst.TargetIcon,32,333+58,this);
			this._fightBg = UIFactory.gBitmap(ImagesConst.CombatBg2,60,430,this);
			this._fightText = UICompomentPool.getUICompoment(BitmapText);
			this._fightText.createDisposedChildren();
			this._fightText.x = 133;
			this._fightText.y = 422;
			this.addChild(this._fightText);
			this._fightText.setFightNum(NumberManager.COLOR3,"99999",5);
			
			add3DRole();
			
		}
		
		/** 更新界面,资源加载完时调用此处 */
		public function updateUI():void
		{
			this._titleLabel.bitmapData = GlobalClass.getBitmapData(ImagesConst.SelEquipLabel);
		}
		
		protected function onClickTurnBtn(e:MouseEvent):void
		{
			if(_roleModelPlayer)
			{
				if(e.currentTarget == _leftBtn)
				{
					turnValue = 2;
				}
				if(e.currentTarget == _rightBtn)
				{
					turnValue = -2;
				}
				start();
				
			}
		}
		
		protected function stopTurning(e:MouseEvent = null):void
		{
			if(_frameTimer)
			{
				_frameTimer.stop();
			}
		}
		
		protected function onTurning(e:FrameTimer):void
		{
			if(_roleModelPlayer)
			{
				_roleModelPlayer.rotationY += turnValue;
			}
		}
		
		private function start():void
		{
			if(!_frameTimer)
			{
				_frameTimer = new FrameTimer(1, int.MAX_VALUE, true);
				_frameTimer.addListener(TimerType.ENTERFRAME,onTurning);
			}
			_frameTimer.start();
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var forging:ForgingModule = GameController.forging.view as ForgingModule;
			var equip:PlayerEquipItem = e.target as PlayerEquipItem;
			if(equip.itemData)
			{
				if(equip != this._currSelEquip)
				{
					if(this._currSelEquip != null)
					{
						this._currSelEquip.setSelEffect(false);
					}
					this._currSelEquip = equip;
					equip.setSelEffect(true);
					switch(forging.currSelPage)
					{
						case 0:
							Dispatcher.dispatchEvent(new DataEvent(EventName.AddEquipStrengthen,equip));
							break;
						case 1:
						case 2:
							Dispatcher.dispatchEvent(new DataEvent(EventName.AddEquipEmbedGem,equip));	
							break;
						case 3:
							Dispatcher.dispatchEvent(new DataEvent(EventName.AddEquipRefresh,equip));
							break;
					}
				}
			}
		}
		
		private function moveInHandler(e:DragEvent):void
		{
			var dragItem:BaseItem = e.dragItem as BaseItem;
			var dropItem:BaseItem = e.dropItem as BaseItem;
			
			if(dragItem && dragItem.itemData.serverData.posType != EPlayerItemPosType._EPlayerItemPosTypeRole)
			{
				var vDragType:int = dragItem.itemData.itemInfo.type;
				var vDragCategory:int = dragItem.itemData.itemInfo.category;
				
				var vUid:String = "";
				var vIndex:int  = -1;
				if(dropItem)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Equip,dragItem.itemData));
				}
				else
				{
					//如果直接放到人物窗口上面,不作处理，留后面根据类型判断位置
				}
				
				//				this.dispatchEvent(new DataEvent(GModuleEvent.Event_Dress,{posType:dragItem.posType, uid:dragItem.itemData.uid, index:vIndex},false, true));
			}
		}
		
		private function createSkillList():void
		{
			
		}
		
		protected function add3DRole():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d == null)
			{
				rect3d = Rect3DManager.instance.registerWindow(new Rectangle(21, 71, 635, 413), _window);
				(_window as ForgingModule).rect3d = rect3d;
			}
			
			Rect3DManager.instance.windowShowHander(null, _window);

			
			rect3d.removeImg(_img2d);
			
			var bmpdata:BitmapData = GlobalClass.getBitmapData(ImagesConst.RoleBg2);
			_img2d=new Img2D(null,bmpdata,new Rectangle(0, 0,288,413));
			rect3d.addImg(_img2d);
			_img2d.x=346;

			updateRoleModel();
			
		}
		
		protected function updateRoleModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d)
			{
				_roleModelPlayer = ObjectPool.getObject(RoleModelPlayer);
				_roleModelPlayer.entityInfo = Cache.instance.role.roleEntityInfo;
				_roleModelPlayer.scaleAll = 1.8;
				_roleModelPlayer.setRenderList(rect3d.renderList);
				
				rect3d.addObject3d(_roleModelPlayer,145+345,330-45);
			}
		}
		
		/**
		 * 更新战斗力 
		 */		
		public function updateComBat():void
		{
			if(Cache.instance.role.entityInfo.combat)
			{
				_fightText.setFightNum(NumberManager.COLOR3,Cache.instance.role.entityInfo.combat.toString(),5);
			}
		}
		
		/**
		 * 更新所有装备镶嵌状态 
		 */		
		public function updateEmbedState():void
		{
			for each(var equip:PlayerEquipItem in _equipPanel.equipmentList)
			{
				setEquipEmbedState(equip);
			}
		}
		
		/**
		 * 设置装备镶嵌状态
		 */		
		private function setEquipEmbedState(equip:PlayerEquipItem):void
		{
			if(equip && equip.itemData)
			{
				var exinfo:ItemExInfo = equip.itemData.extInfo;
				for(var i:int = 1; i <= 8; i++)
				{
					if(exinfo["h"+i] == "0")
					{
						equip.isCanEmbed = true;
						return;
					}
				}
				equip.isCanEmbed = false;
			}
		}
		
		/**
		 * 根据装备uid得装备 
		 * @return PlayerEquipItem
		 */		
		public function getEquipById(uid:String):PlayerEquipItem
		{
			for each(var equip:PlayerEquipItem in _equipPanel.equipmentList)
			{
				if(equip.itemData && equip.itemData.uid == uid)
				{
					return equip;
				}
			}
			return null;
		}
		
		/**
		 * 根据装备类型得装备 
		 * @param type
		 * @return 
		 */		
		public function getEquipByType(type:int):PlayerEquipItem
		{
			return _equipPanel.getEquipByType(type);
		}
		
		public function clear():void
		{
			for each(var equip:PlayerEquipItem in _equipPanel.equipmentList)
			{
				equip.isCanEmbed = true;
			}
		}
		
		public function upDateEquipByType(type:int):void
		{
			_equipPanel.upDateEquipByType(type);
		}
		
		public function upDateAllEquip():void
		{
			_equipPanel.upDateAllEquip();
		}
		
		
		public function set currSelEquip(item:PlayerEquipItem):void
		{
			this._currSelEquip = item;
		}
		
		public function get currSelEquip():PlayerEquipItem
		{
			return this._currSelEquip;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			this._titleBg.dispose(isReuse);
			this._titleLabel.dispose(isReuse);
			this._equipPanel.dispose(isReuse);
			this._leftBtn.dispose(isReuse);
			this._rightBtn.dispose(isReuse);
			this._skillGrids.dispose(isReuse);
			this._fightBg.dispose(isReuse);
			this._fightText.dispose(isReuse);
			
			this._titleBg = null;
			this._titleLabel = null;
			this._equipPanel = null;
			this._leftBtn = null;
			this._rightBtn = null;
			this._skillGrids = null;
			this._fightBg = null;
			this._fightText = null;
			
			_roleModelPlayer = null;
			
			stopTurning();
			
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stopTurning);
		}
		
	}
}