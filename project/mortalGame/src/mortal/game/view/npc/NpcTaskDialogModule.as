/**
 * 2014-3-1
 * @author chenriji
 **/
package mortal.game.view.npc
{
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.Window;
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.window3d.Npc3D;
	import mortal.game.manager.window3d.Npc3DManager;
	import mortal.game.model.NPCInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.player.entity.RoleModelPlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.npc.render.NpcChooseRender;
	import mortal.game.view.npc.render.NpcFunctionRender;
	import mortal.game.view.npc.render.NpcTaskListRender;
	import mortal.game.view.task.data.GLinkTextDataParser;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.view.TaskReward;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * Npc对话面板
	 * @author chenriji
	 * 
	 */	
	public class NpcTaskDialogModule extends Window
	{
		private var _bgBitmapData:BitmapData;
		private var _txtDialog:GTextFiled;
		private var _bmpBonus:GBitmap;
		private var _reward:TaskReward;
		private var _txtNpcName:GTextFiled;
		private var _btnFunc:GButton;
		
		private var _list:GTileList;
		
		public  var sx:int = 240;
		public var sy:int = 80;
		
		private var _taskInfo:TaskInfo;
		private var _npcInfo:NPCInfo;
		
		public static const ShowMode_TaskInfo:String = "0";
		public static const ShowMode_TaskList:String = "1";
		public var showMode:String = ShowMode_TaskInfo;
		private var _isResGot:Boolean = false;
		private var _roleModel:RoleModelPlayer;
		
		public function NpcTaskDialogModule()
		{
			super();
			this.layer = LayerManager.uiLayer;
		}
		
		public function get taskInfo():TaskInfo
		{
			return _taskInfo;
		}
		
		public function showChoose(datas:DataProvider, info:TaskInfo, npcInfo:NPCInfo, talk:String):void
		{
			updateList(datas, NpcChooseRender);
			updateTaskInfo(null);
			updateNpcInfo(npcInfo);
			updateTalk(talk);
			
			showMode = ShowMode_TaskInfo;
		}
		
		/**
		 * 显示单个任务，头像为自己 
		 * @param value
		 * @param talk
		 * 
		 */		
		public function showSelf(value:TaskInfo, talk:String=""):void
		{
			updateNpcInfo(null);
			updateTaskInfo(_taskInfo);
			updateTalk(talk);
			updateList();
			
			showMode = ShowMode_TaskInfo;
		}
		
		/**
		 * 显示单个任务 
		 * @param value
		 * @param info
		 * @param talk
		 * 
		 */		
		public function showTaskInfo(value:TaskInfo, info:NPCInfo, talk:String):void
		{
			updateNpcInfo(info);
			updateTaskInfo(value);
			updateTalk(talk);
			updateList();
			
			showMode = ShowMode_TaskInfo;
		}
		
		
		/**
		 * 显示任务列表 
		 * @param list
		 * @param npcInfo
		 * @param dialog
		 * 
		 */		
		public function showTaskList(datas:DataProvider, npcInfo:NPCInfo, dialog:String):void
		{
			updateNpcInfo(npcInfo);
			updateTalk(dialog);
			updateList(datas, NpcTaskListRender);
			updateTaskInfo(null);
			
			showMode = ShowMode_TaskList;
		}
		
		/**
		 * 显示功能列表 
		 * @param list
		 * @param info
		 * @param talk
		 * 
		 */		
		public function showNpcFunction(datas:DataProvider, info:NPCInfo, talk:String):void
		{
			updateNpcInfo(info);
			updateTalk(talk);
			updateList(datas, NpcFunctionRender);
			updateTaskInfo(null);

			showMode = ShowMode_TaskList;
		}
		
		/**
		 * 显示npc默认对话 
		 * @param info
		 * @param talk
		 * 
		 */		
		public function showNpcDefaultTalk(info:NPCInfo, talk:String):void
		{
			updateNpcInfo(info);
			updateTalk(talk);
			updateList();
			updateTaskInfo(null);
			
			showMode = ShowMode_TaskList;
		}
		
		public function updateList(data:DataProvider=null, render:Class=null):void
		{
			if(data == null)
			{
				DisplayUtil.removeMe(_list);
				return;
			}
			if(_list.parent == null)
			{
				contentSprite.addChild(_list);
			}
			_list.setStyle("cellRenderer", render);
			_list.dataProvider = data;
			_list.drawNow();
		}
		
		public function updateTaskInfo(info:TaskInfo=null):void
		{
			_taskInfo = info;
			if(_taskInfo == null)
			{
				DisplayUtil.removeMe(_reward);
				DisplayUtil.removeMe(_bmpBonus);
				DisplayUtil.removeMe(_btnFunc);
				return;
			}
			contentSprite.addChild(_btnFunc);
			if(_taskInfo.isCanget()) // 领取任务
			{
				_btnFunc.label = Language.getString(20167);
			}
			else if(_taskInfo.isDoing()) // 继续任务
			{
				_btnFunc.label = Language.getString(20169);
			}
			else if(_taskInfo.isComplete()) // 完成任务
			{
				_btnFunc.label = Language.getString(20165);
			}
			
			if(_taskInfo.isDoing())
			{
				DisplayUtil.removeMe(_reward);
				DisplayUtil.removeMe(_bmpBonus);
			}
			else
			{
				contentSprite.addChild(_bmpBonus);
				_reward.updateRewards(_taskInfo.stask.rewards);
				this.addChild(_reward);
			}
		}
		
		public function updateNpcInfo(info:NPCInfo):void
		{
			_npcInfo = info;
			if(info == null) // 显示自己的
			{
				_txtNpcName.text = Cache.instance.role.roleEntityInfo.entityInfo.name;
				addSelf();
			}
			else
			{
				_txtNpcName.text = info.tnpc.name;
				addNpc3d();
			}
			
		}
		
		public function updateTalk(talk:String):void
		{
			if(talk == null)
			{
				_txtDialog.htmlText = "";
			}
			else
			{
				_txtDialog.htmlText = GLinkTextDataParser.parseToHtmlFormat(talk);
			}
		}
		
		public function updateShowMode(mode:int):void
		{
			
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.leading = 5;
			_txtDialog = UIFactory.gTextField("", sx, sy, 360, 80, contentSprite, tf);
			_txtDialog.wordWrap = true;
			_txtDialog.multiline = true;
			
			_bmpBonus = UIFactory.gBitmap("", sx + 5, sy + 63, contentSprite);
			_reward = new TaskReward();
			_reward.x = sx;
			_reward.y = sy + 80;
			contentSprite.addChild(_reward);
			
			tf = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			_txtNpcName = UIFactory.gTextField("", sx - 154, sy + 138, 120, 20, contentSprite, tf);
			
			_btnFunc = UIFactory.gButton("", sx + 268, sy + 125, 80, 24, contentSprite);
			
			_list = UIFactory.tileList(sx + 5, sy + 63, 358, 86, contentSprite);
			_list.isCanSelect = false;
//			_list.mouseChildren = true;
//			_list.mouseEnabled = true;
			_list.direction = GBoxDirection.VERTICAL;
			_list.rowHeight = 20;
			_list.columnWidth = 280;
			_list.setStyle("cellRenderer", NpcTaskListRender);
			
			LoaderHelp.addResCallBack(ResFileConst.taskDialog, resGotHandler);
			_btnFunc.configEventListener(MouseEvent.CLICK, clickFuncBtnHandler);
			
			_closeBtn.x = sx + 346;
			_closeBtn.y = sy - 24;
		}
		
		protected override function updateBtnSize():void
		{
		}
		
		private function clickFuncBtnHandler(evt:MouseEvent):void
		{
			if(_taskInfo == null)
			{
				return;
			}
			Dispatcher.dispatchEvent(new DataEvent(EventName.TaskAskNextStep, [_taskInfo, _npcInfo]));
			hide();
		}
		
		protected function addSelf():void
		{
			if(!_isResGot)
			{
				return;
			}
			_npc3d = Npc3DManager.instance.getRect3dByWindow(this);
			if (!_npc3d)
			{
				_npc3d = Npc3DManager.instance.registerWindow(this);//new Rectangle(_bg.x, _bg.y - 40, 231, 262)
			}
			;
			Npc3DManager.instance.windowShowHander(null, this);
			_npc3d.setBackImg(_bgBitmapData);
			
			if(_roleModel == null)
			{
				_roleModel =ObjectPool.getObject(RoleModelPlayer);
				_roleModel.entityInfo = Cache.instance.role.roleEntityInfo;
				_roleModel.scaleAll = 1.4;
				_roleModel.setRenderList(_npc3d.renderList);
			}
			_npc3d.setTargetMesh(_roleModel.bodyPlayer, 2, 140, 215, false);
		}
		
		private var _npc3d:Npc3D;
		protected function addNpc3d():void
		{
			stageResize();
			if(_npcInfo == null || !DisplayUtil.isBitmapDataUsable(_bgBitmapData))
			{
				return;
			}
			_npc3d = Npc3DManager.instance.getRect3dByWindow(this);
			if (!_npc3d)
			{
				_npc3d = Npc3DManager.instance.registerWindow(this);//new Rectangle(_bg.x, _bg.y - 40, 231, 262)
			}
			
			Npc3DManager.instance.windowShowHander(null, this);
			_npc3d.setBackImg(_bgBitmapData);
			updateToCurNpc();
		}
		
		protected function updateToCurNpc():void
		{
			if(_npc3d && _npcInfo)
			{
				var _npcPlayer:ActionPlayer = ObjectPool.getObject(ActionPlayer);
				_npcPlayer.load(_npcInfo.tnpc.mesh, _npcInfo.tnpc.bone, _npcInfo.tnpc.texture,_npc3d.renderList);
//				_npcPlayer.setRotation(-30, 0, 0);
				_npcPlayer.play();
				_npc3d.setTargetMesh(_npcPlayer,2,140,215, false);//140,215是相对于窗口的位置
			}
		}
		
		private function resGotHandler():void
		{
			_bgBitmapData = GlobalClass.getBitmapData(ImagesConst.TaskDialog_bg);
			
			_bmpBonus.bitmapData = GlobalClass.getBitmapData(ImagesConst.TaskDialog_bonus);
			
			contentSprite.addChild(_closeBtn);
			
			_isResGot = true;
			
			if(this.isHide)
			{
				return;
			}
			
			updateNpcInfo(_npcInfo);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bgBitmapData=null;
			_bmpBonus.dispose(isReuse);
			_bmpBonus = null;
			_reward.dispose(isReuse);
			_reward = null;
			_btnFunc.dispose(isReuse);
			_btnFunc = null;
			_txtDialog.dispose(isReuse);
			_txtDialog = null;
			_txtNpcName.dispose(isReuse);
			_txtNpcName = null;
			_taskInfo = null;
			_npcInfo = null;
			
			if (_npc3d)
			{
				Npc3DManager.instance.unRegisterWindow(null, this);
				_npc3d = null;
			}

			if(_list != null)
			{
				_list.dispose(isReuse);
				_list = null;
			}
		}
		
		public override function stageResize():void
		{
			this.x = (Global.stage.stageWidth - 627)/2;
			this.y = (Global.stage.stageHeight - 246)/2;
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			super.show(x, y);
			stageResize();
		}
		
		public override function set x(arg0:Number):void
		{
			super.x = arg0;
			this.dispatchEvent(new WindowEvent(WindowEvent.POSITIONCHANGE));
		}
	}
}