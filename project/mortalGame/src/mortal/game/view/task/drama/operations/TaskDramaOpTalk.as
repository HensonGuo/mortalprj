/**
 * 2014-4-11
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TNpc;
	import Message.DB.Tables.TTaskDrama;
	import Message.Public.ECamp;
	import Message.Public.ESex;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.SWFInfo;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.common.swfPlayer.SWFPlayer;
	import mortal.common.swfPlayer.data.ModelType;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.window3d.Npc3D;
	import mortal.game.manager.window3d.Npc3DManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.NPCConfig;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.player.entity.RoleModelPlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.npc.render.NpcChooseRender;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	import mortal.game.view.task.drama.operations.npctalk.TaskDramaTalkData;
	import mortal.game.view.task.drama.operations.npctalk.TaskDramaTalkMaskText;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	/**
	 * 屏幕下方的npc说话， 带一个黑色背景，3dnpc 
	 * @author hdkiller
	 * 
	 */	
	public class TaskDramaOpTalk extends Window implements ITaskDramaStepCommand
	{
		private var _data:TaskDramaTalkData;
		private var _config:TTaskDrama;
		
		private var _text:TaskDramaTalkMaskText;
		
		private var _txtName:GTextFiled;
		
		private var _callback:Function;
		private var _isShowing:Boolean;
		private var _lastIconName:String;
		
		private const BgHeight:int = 216;
		private const BgWidth:int = 1179;
		
		private var _isKepping:Boolean;
		
		private var _mouse:GBitmap;
		private var _bg:GBitmap;
		
		private var _isLoading:Boolean = false;
		
		// 3d模型
		private var _roleModel:RoleModelPlayer;
		private var _npcPlayer:ActionPlayer;
		private var _npc3d:Npc3D;
		
		public function TaskDramaOpTalk()
		{
			super();
			isHideDispose = false;
			_isShowing = false;
			_isKepping = false;
			this.layer = LayerManager.windowLayer3D;
		}
		
		public function call(config:TTaskDrama, callback:Function=null):void
		{
			if(config == null)
			{
				if(_callback != null)
				{
					_callback.apply();
					_callback = null;
				}
				return;
			}
			_mouse.visible = false;
			_config = config;
			_callback = callback;
			if(_isShowing)
			{
				stopCall(); // 强制停止之前的
			}
			_isShowing = true;
			_data = getNpcTalkData(config);
			
			_mouse.visible = true;
			if(0)
			{
				_txtName.htmlText = Cache.instance.role.playerInfo.name + ":";
			}
			else
			{
				_txtName.htmlText = "讲话的是小狗:";//_config. + ":";
			}
			
			_text.show(_data, onShowEnd);
			
			this.show();
			addNpc3d();
		}
		
		public function cancel(config:TTaskDrama, callback:Function=null):void
		{
			stopCall();
			this.hide();
			if(callback != null)
			{
				callback.apply();
			}
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			super.show(x, y);
			onStageResize();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			if(_closeBtn != null)
			{
				DisplayUtil.removeMe(_closeBtn);
				_closeBtn = null;
			}
			
			_bg = UIFactory.gBitmap(null, 0, 0, this);
			
			_txtName = UIFactory.gTextField("", 500, 12, 100, 20, this);
			_txtName.textColor = 0x00FE2A;
			var tf:TextFormat = _txtName.defaultTextFormat;
			tf.size = 16;
			tf.bold = true;
			_txtName.defaultTextFormat = tf;
		
			_text = new TaskDramaTalkMaskText();
			_text.x = 230;
			_text.y = 50;
			this.addChild(_text);
			
			_mouse = UIFactory.gBitmap(null, 0, 0, this);
			
			_isLoading = true;
			LoaderHelp.addResCallBack(ResFileConst.dramaTalk, resGotHandler);
		}
		
		private function resGotHandler():void
		{
			_isLoading = false;
			_mouse.bitmapData = GlobalClass.getBitmapData(ImagesConst.Drama_Mouse);
			_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.Drama_bg);
			if(_config != null)
			{
				addNpc3d();
				onStageResize();
			}
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_mouse != null)
			{
				_mouse.dispose(isReuse);
				_mouse = null;
			}
			_callback = null;
		}
		
		/**
		 * 是否保留在屏幕中
		 */
		public function get isKepping():Boolean
		{
			return _isKepping;
		}
		
		/**
		 * @private
		 */
		public function set isKepping(value:Boolean):void
		{
			_isKepping = value;
		}
		
		/**
		 * 舞台大小改变，要重置
		 */
		public function onStageResize():void
		{
			if(_isLoading)
			{
				return;
			}
			if(this.parent == null)
			{
				return;
			}
			if(_text != null)
			{
				_text.resize(Global.stage.stageWidth - 700);
			}
			this.y = Global.stage.stageHeight - BgHeight;
			this.x = (Global.stage.stageWidth - _bg.width)/2;
		}
		
		public function stopCall():void
		{
			_text.stopShow();
			_isShowing = false;
		}
		
		private function resetIconPlaces():void
		{
			
		}
		
		private function getNpcTalkData(config:TTaskDrama):TaskDramaTalkData
		{
			var res:TaskDramaTalkData = new TaskDramaTalkData();
			res.popupTime = 0;
			res.rowWidth = Global.stage.stageWidth - 700;
			res.speed = 4;
			res.talk = config.talkText;
			if(res.talk == null)
			{
				res.talk = "策划没配置剧情的对话";
			}
			res.showTime = 4000;
			res.talkFontLeading = 8;
			res.talkFontSize = 16;
				
			return res;
		}
				
		private function onShowEnd():void
		{
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
//			if(this.parent != null && !_isKepping)
//			{
//				this.parent.removeChild(this);
//			}
//			this.hide();
			_isShowing = false;
		}		
		
		protected function addNpc3d():void
		{
			if(_isLoading)
			{
				return;
			}
			_npc3d = Npc3DManager.instance.getRect3dByWindow(this);
			if (!_npc3d)
			{
				_npc3d = Npc3DManager.instance.registerWindow(this);
			}
			
			Npc3DManager.instance.windowShowHander(null, this);
			_npc3d.setBackImg(_bg.bitmapData);
			updateToCurNpc();
		}
		
		protected function updateToCurNpc():void
		{
			if(_npc3d && _config)
			{
				var tnpc:TNpc = NPCConfig.instance.getInfoByCode(_config.talkNpc);
				if(tnpc != null)
				{
					_mouse.x = 100;
					_mouse.y = 50;
					_npcPlayer = ObjectPool.getObject(ActionPlayer);
					_npcPlayer.load(tnpc.mesh, tnpc.bone, tnpc.texture,_npc3d.renderList);
					_npcPlayer.play();
					_npc3d.setTargetMesh(_npcPlayer, 2, 1060, 215, false);//140,215是相对于窗口的位置
				}
				else// 显示自己
				{
					_mouse.x = 900;
					_mouse.y = 50;
					_roleModel =ObjectPool.getObject(RoleModelPlayer);
					_roleModel.entityInfo = Cache.instance.role.roleEntityInfo;
					_roleModel.scaleAll = 2.0;
					_roleModel.setRenderList(_npc3d.renderList);
					_npc3d.setTargetMesh(_roleModel.bodyPlayer, 2, 140, 215, false);
				}
			}
		}
	}
}