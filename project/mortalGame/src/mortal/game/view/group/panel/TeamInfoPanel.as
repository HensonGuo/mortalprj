package mortal.game.view.group.panel
{
	import Message.Public.SGroupPlayer;
	import Message.Public.SGroupSetting;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.scene3D.player.entity.RoleModelPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.group.cellRenderer.TeamMateCellRenderer;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.mvc.core.Dispatcher;
	
	public class TeamInfoPanel extends GSprite
	{
		//数据
		
		
		//显示对象
		private var _temaMateList:GTileList;  //队伍列表
		
		private var _changeCaptainBtn:GButton;  
		
		private var _disbandTeamBtn:GButton;
		
		private var _leaveTeamBtn:GButton;
		
		private var _teamName:GTextInput;
		
		private var _btnBox:GSprite;
		
		private var _memberInvite:GCheckBox;  //是否允许队员邀请玩家
		
		private var _autoEnter:GCheckBox;   //是否允许申请者直接加入
		
		//3D模型
		protected var _rect3d:Rect3DObject;
		
		protected var _window:Window;
		
		public function TeamInfoPanel(window:Window)
		{
			_window = window;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
//			this.pushUIToDisposeVec(UIFactory.bg(17,90,773,346,this,ImagesConst.RoleInfoBg));
			
			_btnBox = UICompomentPool.getUICompoment(GSprite);
			_btnBox.createDisposedChildren();
			_btnBox.x = 167;
			_btnBox.y = 396;
			_window.contentTopOf3DSprite.addChild(_btnBox);
			_btnBox.configEventListener(MouseEvent.CLICK,operHandler);
			
			_temaMateList =  UIFactory.tileList(20,93,765,310,_window.contentTopOf3DSprite);
			_temaMateList.rowHeight = 290;
			_temaMateList.columnWidth = 153;
			_temaMateList.horizontalGap = 0;
			_temaMateList.verticalGap = 0;
			_temaMateList.setStyle("skin", new Bitmap());
			_temaMateList.setStyle("cellRenderer", TeamMateCellRenderer);
			_window.contentTopOf3DSprite.addChild(_temaMateList);
			//			_temaMateList.getItemAt(1);
			
			_changeCaptainBtn = UIFactory.gButton(Language.getString(30202),100,0,65,22,_btnBox);
			_disbandTeamBtn = UIFactory.gButton(Language.getString(30203),200,0,65,22,_btnBox);
			_leaveTeamBtn = UIFactory.gButton(Language.getString(30204),300,0,65,22,_btnBox);
			
			_teamName = UIFactory.gTextInput(80,67,120,22,this);
			_teamName.maxChars = 7;
			_teamName.configEventListener(FocusEvent.FOCUS_OUT,changeTeamName);
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30205),20,68,80,20,this,GlobalStyle.textFormatBai));
//			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30206),620,68,70,20,this,GlobalStyle.textFormatHuang));
			
			_memberInvite = UIFactory.checkBox(Language.getString(30207),625,384,130,28,_window.contentTopOf3DSprite);
			_memberInvite.configEventListener(Event.CHANGE,canInviteSelectedChanged);
			
			_autoEnter = UIFactory.checkBox(Language.getString(30208),625,404,130,28,_window.contentTopOf3DSprite);
			_autoEnter.configEventListener(Event.CHANGE,canJoinFreeSelectedChanged);
		
			playerVec = new Vector.<RoleModelPlayer>;
			img2Vec = new Vector.<Img2D>();
			
			add3DRole();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_btnBox.dispose(isReuse);
			_temaMateList.dispose(isReuse);
			_changeCaptainBtn.dispose(isReuse);
			_disbandTeamBtn.dispose(isReuse);
			_leaveTeamBtn.dispose(isReuse);
			_teamName.dispose(isReuse);
			_memberInvite.dispose(isReuse);
			_autoEnter.dispose(isReuse);
			
			_btnBox = null;
			_temaMateList = null;
			_changeCaptainBtn = null;
			_disbandTeamBtn = null;
			_leaveTeamBtn = null;
			_teamName = null;
			_memberInvite = null;
			_autoEnter = null;
			
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
				
			}
			
			if(_img2d)
			{
				_img2d.dispose(isReuse);
				_img2d=null;
			}
			
			clear3d();
			
			super.disposeImpl(isReuse);
		}
		
		private function getDataProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var teamMates:Array = Cache.instance.group.players;
			
			clear3d();
			
			for(var i:int ; i < 5 ; i++)
			{
				var teamMateInfo:SGroupPlayer;
				if(!Cache.instance.group.isInGroup && i == 0)
				{
					teamMateInfo = Cache.instance.group.selfInfo;
				}
				else
				{
					teamMateInfo = teamMates[i]? teamMates[i]:null;
				}
				
				updateRoleModel(teamMateInfo,i);
				
				var obj:Object = new Object();
				obj.data = teamMateInfo;
				dataProvider.addItem(obj);
			}
			
			return dataProvider;
		}
		
		private function operHandler(e:MouseEvent):void   //队伍操作
		{
			if(e.target == _disbandTeamBtn)  //解散队伍
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.DisbanGroup));
			}
			else if(e.target == _leaveTeamBtn)  //离开队伍
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.LeaveGroup));
			}
			else if(e.target == _changeCaptainBtn)  //切换队长
			{
				var index:int = _temaMateList.selectedIndex;
				if(index >= 0)
				{
					var obj:Object = _temaMateList.getItemAt(index);
					if(obj.data)
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.ModifyCaptain, (obj.data as SGroupPlayer).player.entityId));
						return;
					}
				}
				
				MsgManager.showRollTipsMsg(Language.getString(30248));
			}
			
		}
		
		private function getSetting():SGroupSetting
		{
			var setting:SGroupSetting = new SGroupSetting();
			setting.name = _teamName.text;
			setting.memberInvite = _memberInvite.selected;
			setting.autoEnter = _autoEnter.selected;
			return setting;
		}
		
		private function changeTeamName(e:FocusEvent):void
		{
			if(_teamName.text == Cache.instance.group.groupName)
			{
				return ;
			}
			else
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GroupSetting,getSetting()));
			}
		}
		
		private function canInviteSelectedChanged(evt:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupSetting,getSetting()));
		}
		
		private function canJoinFreeSelectedChanged(evt:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupSetting,getSetting()));
		}
		
		/**
		 * 根据队伍情况,重新设置底部按钮的显示和位置 
		 * 
		 */		
		private function resetBtnPos():void    
		{
			if(Cache.instance.group.isInGroup) //是否在队伍里
			{
				_btnBox.visible = true;
				if(Cache.instance.group.isCaptain) //是否是队长
				{
					_changeCaptainBtn.visible = true;
					_disbandTeamBtn.visible = true;
					_btnBox.x = 168;
				}
				else
				{
					_changeCaptainBtn.visible = false;
					_disbandTeamBtn.visible = false;
					_btnBox.x = 70;
				}
			}
			else
			{
				_btnBox.visible = false;
			}
		}
		
		/**
		 * 更新队伍状态 
		 * 
		 */		
		public function updateTeamMate():void
		{
			_temaMateList.dataProvider = getDataProvider();
			
			_temaMateList.selectedIndex = -1;
			
			_temaMateList.drawNow();
			resetBtnPos();
			
			_memberInvite.mouseEnabled = true;
			_memberInvite.selected = Cache.instance.group.memberInvite;
			_autoEnter.mouseEnabled = true;
			_autoEnter.selected = Cache.instance.group.autoEnter;
			
			if(Cache.instance.group.isInGroup)
			{
				_teamName.text = Cache.instance.group.groupName ;
				if(!Cache.instance.group.isCaptain)  //是否为队长
				{
					_teamName.editable = false;
					_memberInvite.mouseEnabled = false;
					_autoEnter.mouseEnabled = false;
				}
				else
				{
					_teamName.editable = true;
				}
			}
			else
			{
				_teamName.text = "";	
				_teamName.editable = false;
				_memberInvite.mouseEnabled = false;
				_memberInvite.selected = false;
				_autoEnter.mouseEnabled = false
				_autoEnter.selected = false;
				
			}
		}
		
		/**
		 * 更新系统设置 
		 * 
		 */		
		public function updateSetting():void
		{
			_memberInvite.selected = Cache.instance.group.memberInvite;
			_autoEnter.selected = Cache.instance.group.autoEnter;
			_teamName.text = Cache.instance.group.groupName ;
		}
		
		private var _img2d:Img2D;
		protected function add3DRole():void
		{
			_rect3d = Rect3DManager.instance.registerWindow(new Rectangle(17, 90, 773, 346), _window);
			
			Rect3DManager.instance.windowShowHander(null, _window);
			
			
			_rect3d.removeImg(_img2d);
			
			var scaleBmpp:ScaleBitmap = ResourceConst.getScaleBitmap(ImagesConst.RoleInfoBg);
			scaleBmpp.setSize(773,346);
			var bmpdata:BitmapData = scaleBmpp.bitmapData;
		
			_img2d=new Img2D(null,bmpdata,new Rectangle(0, 0, 773, 346));
			_rect3d.addImg(_img2d,Layer3DManager.backGroudImgLayer);
			
		}
		
		private var playerVec:Vector.<RoleModelPlayer>;
		private var img2Vec:Vector.<Img2D>;
		protected function updateRoleModel(info:SGroupPlayer,index:int):void
		{
			if(info == null)
			{
				return;
			}
			
			if(_rect3d)
			{
				var roleModelPlayer:RoleModelPlayer;
				roleModelPlayer = ObjectPool.getObject(RoleModelPlayer);
				roleModelPlayer.entityInfo = Cache.instance.role.roleEntityInfo;
				roleModelPlayer.scaleAll = 1.4;
				roleModelPlayer.setRenderList(_rect3d.renderList);
				_rect3d.addObject3d(roleModelPlayer,index*153 + 76,240);
				playerVec.push(roleModelPlayer);
				
				var bmpdata:BitmapData = GlobalClass.getBitmapData(ImagesConst.GroupInBg);
				var imag2d:Img2D;
				imag2d = new Img2D(null,bmpdata,new Rectangle(0, 0,150,287));
				imag2d.x = index*153 + 5;
				imag2d.y = 5;
				_rect3d.addImg(imag2d,Layer3DManager.BackGroudEffectLayer);
				img2Vec.push(imag2d);
			}
		}
		
		private function clear3d():void
		{
			for each(var i:RoleModelPlayer in playerVec)
			{
				i.dispose(true);
				i = null;
			}
			playerVec.length = 0;
			
			for each(var n:Img2D in img2Vec)
			{
				n.dispose(true);
				n = null;
			}
			img2Vec.length = 0;
		}
		
		
	}
}