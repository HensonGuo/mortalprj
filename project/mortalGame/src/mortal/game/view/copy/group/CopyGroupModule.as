/**
 * 2014-3-17
 * @author chenriji
 **/
package mortal.game.view.copy.group
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TCopy;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.BaseWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.BossConfig;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.view.common.ItemCellRenderer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.GLabelButton;
	import mortal.game.view.copy.group.view.render.CopyGroupInCopyReander;
	import mortal.game.view.copy.group.view.render.CopyGroupOutCopyRender;
	import mortal.game.view.copy.group.view.render.CopyTeamateRender;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class CopyGroupModule extends BaseWindow
	{
		private var _txtTitle:GTextFiled;
	
		private var _bg1:ScaleBitmap;
		private var _bg2:ScaleBitmap;
		private var _copyBg:GBitmap;
		private var _bmpInfo:GBitmap;
		
		private var _titleBg1:ScaleBitmap;
		private var _titleBg2:ScaleBitmap;
		
		private var _cbb:GComboBox;
//		private var _txtTitle2:GTextFiled;
//		private var _txtTeamInfo:GTextFiled;
	
		private var _txtdwrs:GTextFiled;
		private var _txtfbjd:GTextFiled;
		private var _txtpjzdl:GTextFiled;
		private var _txtcz:GTextFiled;
		private var _txtDesc:GTextFiled;
		private var _bonusList:GTileList;
		
		//按钮
		private var _btnEnter:GLabelButton; // 进入副本
		private var _btnGather:GLabelButton; // 队伍集合
		private var _btnInvite:GLabelButton; // 招募队友
		
		// 显示中的副本信息
		private var _info:TCopy;
		
		// 所有队伍的列表
		private var _groupsList:GTileList;
		// 我当前队伍的信息
		private var _myGroupList:GTileList;
		
		private var _teamMode:int;
		public static const Mode_Inteam:int = 0;
		public static const Mode_NoTeam:int = 1;
		
		private var _mode:int;
		private var _resGot:Boolean=false;
		private var _npcPlayer:ActionPlayer
		private var _cbbData:Array = [
			{"name":0, "label":Language.getString(20185)},
			{"name":1, "label":Language.getString(20186)}
		];
		
		private var _isDisposed:Boolean = false;
		
		public function CopyGroupModule($layer:ILayer=null)
		{
			super($layer);
			super.setSize(717, 524);
			this.titleHeight = 45;
			
			this.layer = LayerManager.windowLayer3D;
		}
		
		public function updateTitle(title:String):void
		{
			_txtTitle.text = title;
		}
		
		public function updateCopyInfo(info:TCopy):void
		{
			_info = info;
			_txtTitle.text = info.name;
			if(info.desc != null)
			{
				_txtDesc.htmlText = info.desc;
			}
			else
			{
				_txtDesc.htmlText = "策划没配置副本描述：策划没配置副本本描述策划没述策划没配置副本描述";
			}
			
			// 更新副本奖励
			var arr:Array = info.rewardShow.split("#");
			var datas:DataProvider = new DataProvider();
			for(var i:int = 0; i < arr.length; i++)
			{
				var code:int = int(arr[i]);
				if(code <= 0)
				{
					continue;
				}
				var data:ItemData = new ItemData(code);
				datas.addItem(data);
			}
			_bonusList.dataProvider = datas;
			_bonusList.drawNow();
		}
		
		public function updateTeamsData(data:DataProvider):void
		{
			_groupsList.dataProvider = data;
			_groupsList.drawNow();
		}
		
		public function updateMyTeamData(data:DataProvider):void
		{
			_myGroupList.dataProvider = data;
			_myGroupList.drawNow();
		}
		
		private function tabChangeHandler(evt:Event):void
		{
			if(_cbb.selectedIndex == 0)
			{
				setOutCopyMode();
			}
			else
			{
				setInCopyMode();
			}
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.CopyGroupTabChange, _cbb.selectedIndex));
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			_isDisposed = false;
			super.createDisposedChildrenImpl();
			_mode = Mode_NoTeam;
			_txtTitle = UIFactory.titleTextField("背包");
			super.title = _txtTitle;
			
			_bg1 = UIFactory.bg(14, 50, 489, 210, this);
			_bg2 = UIFactory.bg(_bg1.x + _bg1.width, _bg1.y, 205, 463, this);
			_copyBg = UIFactory.gBitmap(null, _bg1.x + 2, _bg1.y + _bg1.height + 2, this);
			LoaderHelp.setBitmapdata(ImagesConst.CopyGroupBg + ".swf", _copyBg);
			
			_titleBg1 = UIFactory.bg(_bg1.x + 2, _bg1.y + 2, _bg1.width - 4, 26, this, ImagesConst.RegionTitleBg);
			_titleBg2 = UIFactory.bg(_bg2.x + 2, _bg2.y + 2, _bg2.width - 5, 26, this, ImagesConst.RegionTitleBg);
			_bmpInfo = UIFactory.gBitmap(null, 515, 59, this);
			
			var color:uint = GlobalStyle.colorAnjinUint; 
			_cbb = UIFactory.gComboBox(_titleBg1.x+12, _titleBg1.y + 2, 115, 22, new DataProvider(_cbbData), this);
			_cbb.textColor = color;

			// 所有队伍的列表
			_groupsList = UIFactory.tileList(16, 75, 481, 181, this);
			_groupsList.columnWidth = 170;
			_groupsList.rowHeight = 30;
			_groupsList.direction = GBoxDirection.VERTICAL;
			
			_txtdwrs = UIFactory.gTextField(Language.getString(20188), 0, 54, 80, 20, this);
			_txtdwrs.textColor = color;
			
			_txtfbjd = UIFactory.gTextField(Language.getString(20189), 0, 54, 80, 20, this);
			_txtfbjd.textColor = color;
			
			_txtpjzdl = UIFactory.gTextField(Language.getString(20190), 0, 54, 80, 20, this);
			_txtpjzdl.textColor = color;
			
			_txtcz = UIFactory.gTextField(Language.getString(20191), 427, 54, 80, 20, this);
			_txtcz.textColor = color;
			
			// 我的队伍
			_myGroupList = UIFactory.tileList(_titleBg2.x + 4, _titleBg2.y + _titleBg2.height, 196, 375, this);
			_myGroupList.columnWidth = 194;
			_myGroupList.rowHeight = 71;
			_myGroupList.verticalGap = 2;
			_myGroupList.direction = GBoxDirection.VERTICAL;
			_myGroupList.setStyle("cellRenderer", CopyTeamateRender);
			
			// 副本描述
			var tf:TextFormat = GlobalStyle.textFormatPutong;
			tf.leading = 3;
			_txtDesc = UIFactory.gTextField("", 22, 273, 273, 160, this, tf);
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			// 副本奖励列表
			_bonusList = UIFactory.tileList(28, 382, 260, 90, this);
			_bonusList.rowHeight = 45;
			_bonusList.columnWidth = 45;
			_bonusList.direction = GBoxDirection.HORIZONTAL;
			_bonusList.rowCount = 6;
			_bonusList.setStyle("cellRenderer", ItemCellRenderer);
			
			// 按钮
			_btnEnter = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.EnterCopyBtn_upSkin, 342, 465, 107, 35, contentTopOf3DSprite);
			_btnGather = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.RedButton_upSkin, 514, 469, 91, 29, this);
			_btnInvite = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.RedButton_upSkin, 606, 469, 91, 29, this);
			
			LoaderHelp.addResCallBack(ResFileConst.copyGroup, resGotHandler);
			
			setOutCopyMode();
			
			// 监听事件
			_btnEnter.configEventListener(MouseEvent.CLICK, enterCopyHandler);
			_btnGather.configEventListener(MouseEvent.CLICK, gatherHandler);
			_btnInvite.configEventListener(MouseEvent.CLICK, inviteHandler);
			_cbb.configEventListener(Event.CHANGE, tabChangeHandler);
		}
		
		private function enterCopyHandler(evt:MouseEvent):void
		{
//			if(!Cache.instance.group.isCaptain)
//			{
//				MsgManager.showRollTipsMsg(Language.getStringByParam(20198, Language.getString(20199)));
//				return;
//			}
			Dispatcher.dispatchEvent(new DataEvent(EventName.CopyGroupEnterCopyReq, _info));
		}
		
		private function gatherHandler(evt:MouseEvent):void
		{
			if(_mode == Mode_Inteam) // 队伍集合
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.CopyGroupGatherReq, _info));
			}
			else // 创建队伍
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.CreateGroup));
			}
		}
		
		private function inviteHandler(evt:MouseEvent):void
		{
			if(_mode == Mode_Inteam) // 招募队友
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.CopyGroupInviteReq, _info));
			}
			else // 快速组队
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.CopyGroupQuickReq, _info));
			}
		}
		
		private function resGotHandler():void
		{
			if(_isDisposed)
			{
				return;
			}
			_resGot = true;
			_btnEnter.label = ImagesConst.Copy_Enter;
			_bmpInfo.bitmapData = GlobalClass.getBitmapData(ImagesConst.Copy_TeamInfo);
			setInTeamMode(Mode_NoTeam);
			addNpc3d();
		}
		
		public function setOutCopyMode():void
		{
			_txtdwrs.x = 194;
			_txtpjzdl.x = 294;
			DisplayUtil.removeMe(_txtfbjd);
			_groupsList.setStyle("cellRenderer", CopyGroupOutCopyRender);
			//
		}
		
		public function setInCopyMode():void
		{
			_txtdwrs.x = 158;
			_txtfbjd.x = 235;
			_txtpjzdl.x = 320;
			_groupsList.setStyle("cellRenderer", CopyGroupInCopyReander);
			this.addChild(_txtfbjd);
		}
		
		public function setInTeamMode(mode:int):void
		{
			_mode = mode;
			updateInTeamView();
		}
		
		private function updateInTeamView():void
		{
			if(!_resGot)
			{
				return;
			}
			switch(_mode)
			{
				case Mode_NoTeam:
					_btnGather.label = ImagesConst.Copy_CreateTeam;
					_btnInvite.label = ImagesConst.Copy_QuickCreate;
//					if(_myGroupList.parent == null)
//					{
//						this.addChild(_myGroupList);
//					}
					break;
				case Mode_Inteam:
					_btnGather.label = ImagesConst.Copy_Gather;
					_btnInvite.label = ImagesConst.Copy_Request;
//					DisplayUtil.removeMe(_myGroupList);
					break;
			}
		}
		
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			_isDisposed = true;
			super.disposeImpl(isReuse);
			_resGot = false;
			_bg1.dispose(isReuse);
			_bg1 = null;
			_bg2.dispose(isReuse);
			_bmpInfo.dispose(isReuse);
			_bg2 = null;
			_btnEnter.dispose(isReuse);
			_btnEnter = null;
			_btnGather.dispose(isReuse);
			_btnGather = null;
			_btnInvite.dispose(isReuse);
			_btnInvite = null;
			_cbb.dispose(isReuse);
			_cbb = null;
		
			_txtcz.dispose(isReuse);
			_txtcz = null;
			_txtDesc.dispose(isReuse);
			_txtDesc = null;
			_txtdwrs.dispose(isReuse);
			_txtdwrs = null;
			_txtfbjd.dispose(isReuse);
			_txtfbjd = null;
			_txtpjzdl.dispose(isReuse);
			_txtpjzdl = null;
//			_txtTeamInfo.dispose(isReuse);
//			_txtTeamInfo = null;
			_txtTitle.dispose(isReuse);
			_txtTitle = null;
//			_txtTitle2.dispose(isReuse);
//			_txtTitle2 = null;
			
			_copyBg.dispose(isReuse);
			_copyBg = null;
			_titleBg1.dispose(isReuse);
			_titleBg1 = null;
			_titleBg2.dispose(isReuse);
			_titleBg2 = null;
			
			_groupsList.dispose(isReuse);
			_groupsList = null;
			_myGroupList.dispose(isReuse);
			_myGroupList = null;
			
			if(_npcPlayer != null)
			{
				_npcPlayer.dispose(isReuse);
				_npcPlayer = null;
			}
		}
		
		private var _npc3d:Rect3DObject;
		private var _img2d:Img2D;
		protected function addNpc3d():void
		{
			if(_info == null || !DisplayUtil.isBitmapDataUsable(_copyBg.bitmapData))
			{
				return;
			}
			
			_npc3d = Rect3DManager.instance.registerWindow(new Rectangle(_copyBg.x + 282, _copyBg.y + 3, 203, 246), this);//new Rectangle(_bg.x, _bg.y - 40, 231, 262)
			
			Rect3DManager.instance.windowShowHander(null, this);

			_npc3d.removeImg(_img2d);
			_img2d=new Img2D(null,_copyBg.bitmapData,new Rectangle(282, 0,203,246));
			_npc3d.addImg(_img2d);
			updateToCurNpc();
		}
		
		protected function updateToCurNpc():void
		{
			if(_npc3d && _info)
			{
				var _bossInfo:TBoss = BossConfig.instance.getInfoByCode(parseInt(_info.bossShow));
				var meshUrl:String=_bossInfo.mesh + ".md5mesh";
				var boneUrl:String=_bossInfo.bone + ".skeleton";
				if(_npcPlayer && _npcPlayer.meshUrl==meshUrl && _npcPlayer.animUrl==boneUrl)
				{
					return;
				}
				_npcPlayer = ObjectPool.getObject(ActionPlayer);
				_npcPlayer.load(meshUrl,boneUrl,_bossInfo.texture,_npc3d.renderList);
				_npc3d.addObject3d(_npcPlayer, 102, 200);//140,215是相对于窗口的位置
			}
		}
	}
}