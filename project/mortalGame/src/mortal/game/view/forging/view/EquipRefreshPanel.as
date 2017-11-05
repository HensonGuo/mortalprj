package mortal.game.view.forging.view
{
	import Message.Game.EOperType;
	import Message.Game.EPriorityType;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import frEngine.loaders.resource.info.image.Image;
	
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.Window;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.renderer.RefreshPropCellRenderer;
	import mortal.game.view.palyer.PlayerEquipItem;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 装备洗练面板
	 * @date   2014-4-30 上午11:46:33
	 * @author dengwj
	 */	 
	public class EquipRefreshPanel extends ForgingPanelBase
	{
		private var _leftBorder:ScaleBitmap;
		private var _rightBorder:ScaleBitmap;
		private var _currPropList:GTileList;
		private var _newPropList:GTileList;
		private var _refreshBtn:GButton;
		private var _replaceBtn:GButton;
		private var _batRefreshBtn:GButton;
		private var _autoBuy:GCheckBox;
		
		private var _currWashEquip:PlayerEquipItem;
		private var _lockDic:Dictionary;
		
		private var _leftImg2d:Img2D;
		
		public function EquipRefreshPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_currWashEquip = UICompomentPool.getUICompoment(PlayerEquipItem);
			_currWashEquip.setItemStyle(ItemStyleConst.Small,ImagesConst.StrengSpecialGrid,13,13);
			_currWashEquip.x = 60;
			_currWashEquip.y = 40;
			this.addChild(_currWashEquip);
			
			_lockDic = new Dictionary();
			
			_leftBorder = UIFactory.bg(10,300-126,147,147,this);
			_rightBorder = UIFactory.bg(195,300-126,147,147,this);
			
			_currPropList = UIFactory.tileList(12,182,137,126,this);
			_currPropList.columnWidth = 127;
			_currPropList.rowHeight = 20;
			_currPropList.horizontalGap = 0;
			_currPropList.verticalGap = 0;
			_currPropList.setStyle("skin", new Bitmap());
			_currPropList.setStyle("cellRenderer", RefreshPropCellRenderer);
			_currPropList.configEventListener(MouseEvent.CLICK, onLockClickHandler);
			
			_newPropList = UIFactory.tileList(200,182,137,126,this);
			_newPropList.columnWidth = 127;
			_newPropList.rowHeight = 20;
			_newPropList.horizontalGap = 0;
			_newPropList.verticalGap = 0;
			_newPropList.setStyle("skin", new Bitmap());
			_newPropList.setStyle("cellRenderer", RefreshPropCellRenderer);
			
			_refreshBtn = UIFactory.gButton("洗练",60,356,74,24,this);
			_replaceBtn = UIFactory.gButton("替换",142,356,74,24,this);
			_batRefreshBtn = UIFactory.gButton("批量洗练",224,356,74,24,this);
			_autoBuy = UIFactory.checkBox("道具不足，自动购买",194,383,140,28,this);
			this.configEventListener(MouseEvent.CLICK,onClickHandler);
		}
		
		override public function updateUI():void
		{
			add3DModel();
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if(e.target is GButton && !_currWashEquip.itemData)
			{
				MsgManager.showRollTipsMsg("请放入装备！");
				return;
			}
			if(e.target == _refreshBtn)
			{
				var obj:Object = {};
				var operType:EOperType     = new EOperType(EOperType._EOperTypeSimple);
				var priority:EPriorityType = new EPriorityType(EPriorityType._EProiorityTypeBindFirst);
				obj.equipUid 	  = _currWashEquip.itemData.uid;
				obj.type		  = operType;
				obj.autoBuy 	  = ClientSetting.local.getIsDone(IsDoneType.AutoBuyStrengProp);
				obj.priority 	  = priority;
				obj.lockDict      = _lockDic;
				obj.expectAttr    = new Dictionary();
				obj.expectAttrAll = 0;
				
				Dispatcher.dispatchEvent(new DataEvent(EventName.EquipRefresh,obj));
			}
			
			if(e.target == _replaceBtn)
			{
				
			}
			
			if(e.target == _batRefreshBtn)
			{
				
			}
			
			if(e.target == _autoBuy)
			{
				if(_autoBuy.selected == true)
				{
					ClientSetting.local.setIsDone(true, IsDoneType.AutoBuyStrengProp);
				}
				else
				{
					ClientSetting.local.setIsDone(false, IsDoneType.AutoBuyStrengProp);
				}
			}
		}
		
		/**
		 * 点击洗练锁的处理 
		 * @param e
		 */		
		private function onLockClickHandler(e:MouseEvent):void
		{
			//TODO=============== 洗练属性重新排序
		}
		
		/**
		 * 添加待洗练的装备 
		 */		
		public function addRefreshEquip(equip:PlayerEquipItem):void
		{
			if(equip && equip.itemData)
			{
				_currWashEquip.itemData = equip.itemData;
				updateRefreshInfo();
			}
		}
		
		/**
		 * 更新洗练信息
		 */		
		public function updateRefreshInfo():void
		{
			if(_currWashEquip && _currWashEquip.itemData)
			{
				// TODO ==============更新洗练信息
			}
		}
		
		private function set isReplacable(value:Boolean):void
		{
			if(value)
			{
				_replaceBtn.filters       = [];
				_replaceBtn.mouseEnabled  = true;
				_replaceBtn.mouseChildren = true;
			}
			else
			{
				_replaceBtn.filters       = [FilterConst.colorFilter2];
				_replaceBtn.mouseEnabled  = false;
				_replaceBtn.mouseChildren = false;
			}
		}
		
		private function clear():void
		{
			
		}
		
		override protected function add3DModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d != null)
			{
				Rect3DManager.instance.windowShowHander(null, _window);
				if(!_leftImg2d)
				{
					if(!bg3d)
					{
						bg3d = GlobalClass.getBitmapData(ImagesConst.GemBgPurple);
					}
					_leftImg2d = new Img2D(null,bg3d,new Rectangle(0, 0,347,413));
				}
				rect3d.addImg(_leftImg2d);
			}
		}
		
		private function remove3DModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d)
			{
				rect3d.removeImg(_leftImg2d);
				this._leftImg2d = null;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_refreshBtn.dispose(isReuse);
			_replaceBtn.dispose(isReuse);
			_batRefreshBtn.dispose(isReuse);
			_leftBorder.dispose(isReuse);
			_rightBorder.dispose(isReuse);
			_currPropList.dispose(isReuse);
			_newPropList.dispose(isReuse);
			_currWashEquip.dispose(isReuse);
			_autoBuy.dispose(isReuse);
			
			_refreshBtn = null;
			_replaceBtn = null;
			_batRefreshBtn = null;
			_leftBorder = null;
			_rightBorder = null;
			_currPropList = null;
			_newPropList = null;
			_currWashEquip = null;
			_autoBuy = null;
			_lockDic = null;
			remove3DModel();
		}
	}
}