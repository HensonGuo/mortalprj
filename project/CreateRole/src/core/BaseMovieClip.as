package core
{
	import com.media.SoundManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import model.FriendInfo;
	
	import utils.RandomName;
	
	import view.FriendList;
	import view.PlayerInfo;
	import view.TipPanel;
	
	public class BaseMovieClip extends MovieClip
	{
		
		protected var _createRoleTimer:Timer;
		
		protected var _createRoleMC:MovieClip;
		protected var _tipPanel:TipPanel;
		protected var _infoSprite:Sprite;
		protected var _playerInfo:PlayerInfo;
		protected var _friendPanel:FriendList;
		
		protected var _submitFun:Function;
		
		protected var _camp:int = -1;
		protected var _sex:int = -1;
		protected var _name:String;
		protected var _career:int = 0;
		
		protected var _glowStep:Number = 0.7;
		
		protected var _randomNameUrl:String;
		protected var _friendPlayGameUrl:String;
		protected var _whoPlayGameUrl:String;
		
		
		public var mainPath:String = "";
		public var version:String = "";
		public var isAutoEnterGame:Boolean;
		
		public function BaseMovieClip()
		{
			super();
			if(stage!=null)
			{
				onAddToStage(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			}
		}
		
		protected function onAddToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			SoundManager.instance.startBackgroundMusic(mainPath);
			
			stage.focus = _createRoleMC.nameTxt;
			
			_createRoleMC.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			
			_createRoleMC.nameTxt.restrict = RoleNameFilter.nameFilterRestrict;
			_createRoleMC.nameTxt.text = "";
			_createRoleMC.nameTxt.maxChars = 7;
			_createRoleMC.addEventListener(Event.CHANGE,onRoleNameChange);
			
			_tipPanel = new TipPanel();
			_createRoleMC.addChild(_tipPanel);
			_tipPanel.visible = false;
			
			_infoSprite = new Sprite();
			addChild(_infoSprite);
			
			_playerInfo = new PlayerInfo();
			_infoSprite.addChild(_playerInfo);
			
			stage.addEventListener(Event.RESIZE,onStageResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			stage.addEventListener(MouseEvent.CLICK,onStageClick);
			onStageResize(null);
			 
//			_sex = int(Math.random()*2 + 1);
//			_career = int(Math.random()*4 + 1);
//			changeSelect(_career,_sex);
//			changeSelect(1,1);
			
//			whoPlayGame("http://interface.game.renren.com/restServer.php?method=Game.getFriendPlayGames&limit=20&code=frxz","http://interface.game.renren.com/restServer.php?method=Game.getWhoPlayGames&limit=20&code=frxz");
			
			startCreateRoleTimer();
		}
		
		protected function onRemoveFromStage(e:Event):void
		{
			dispose();
		}
		
		protected function onStageResize(event:Event):void
		{
			if(stage)
			{
				createRoleMcResize();
				_infoSprite.x = 100;
				_infoSprite.y = stage.stageHeight - 200;
				if(_friendPanel && !_friendPanel.isHide)
				{
					_friendPanel.x = (stage.stageWidth - _friendPanel.width)/2;
					_friendPanel.y = stage.stageHeight/2 + 120;
				}
			}
		}
		
		protected function createRoleMcResize():void
		{
			_createRoleMC.x = (stage.stageWidth - 858)/2 + 25;
			_createRoleMC.y = (stage.stageHeight - 472)/2;
		}
		
		protected function onStageClick(e:MouseEvent):void
		{
			resetCreateRoleTimer();
		}
		
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)//enter
			{
				createRoleReq();
			}
		}
		
		protected function createRoleReq():void
		{
			if(!_createRoleMC.submitBtn.enabled)
			{
				return;
			}
			
			resetCreateRoleTimer();
			_name = _createRoleMC.nameTxt.text;
			if(!checkTipPanel())
			{
				return;
			}
			if(!_createRoleMC.submitBtn.enabled)
			{
				return;
			}
			if(_submitFun!=null)
			{
				_submitFun.call(null,{career:Math.pow(2,_career - 1),sex:_sex,name:_name});
			}
			_createRoleMC.submitBtn.enabled = false;
			setTimeout(
				function submitBtnEnable():void{
					_createRoleMC.submitBtn.enabled = true;
				},200);
		}
		
		protected function onMouseClickHandler(event:MouseEvent):void
		{
			
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
			
		}
		
		protected var _nameChange:Boolean;
		
		private function onRoleNameChange(event:Event):void
		{
			clearTimeout(_tipPanelTimeKey);
			_nameChange = true;
			checkTipPanel();
			
			resetCreateRoleTimer();
		}
		
		protected function changeSelect(career:int,sex:int):void
		{
			_career = career;
			if( _sex != sex )
			{
				_sex = sex;
				if(!_nameChange)
				{
					loadRandomNameFromPhp();
				}
			}
		}
		
		/**
		 * 检查是否要显示tips 
		 * 
		 */
		protected function checkTipPanel():Boolean
		{
			var errorCode:int = RoleNameFilter.filterName(_createRoleMC.nameTxt.text);
			var errorStr:String = getErrorStr(errorCode);
			_tipPanel.updateTips(errorStr);
			_tipPanel.visible = true;
			if(errorCode < 0)
			{
				_tipPanel.x = _createRoleMC.nameTxt.x + _createRoleMC.nameTxt.width + _createRoleMC.randomName.width;
				_tipPanel.y = _createRoleMC.nameTxt.y + _createRoleMC.nameTxt.height/2;
				return false;
			}
			_tipPanel.x = _createRoleMC.submitBtn.x + _createRoleMC.submitBtn.width;
			_tipPanel.y = _createRoleMC.submitBtn.y + _createRoleMC.submitBtn.height/2;
			return true;
		}
		
		protected function getErrorStr(errorCode:int):String
		{
			return BaseError.getErrorStr(errorCode);
		}
		
		protected function onFriendListAddHandler(event:Event):void
		{
			onStageResize(null);
		}
		
		protected function onFriendListRemoveHandler(event:Event):void
		{
			onStageResize(null);
		}
		
		private function startCreateRoleTimer():void
		{
			if(!isAutoEnterGame)
			{
				return;
			}
			
			if(!_createRoleTimer)
			{
				_createRoleTimer = new Timer(1000,60);
				_createRoleTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onCreateRoleTimerComplete);
			}
			_createRoleTimer.start();
		}
		private function resetCreateRoleTimer():void
		{
			if(!_createRoleTimer)
			{
				startCreateRoleTimer();
			}
			else
			{
				_createRoleTimer.reset();
				_createRoleTimer.start();
			}
			_autoCreateRole = false;
		}
		private function disposeCreateRoleTimer():void
		{
			if(_createRoleTimer)
			{
				_createRoleTimer.stop();
				_createRoleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onCreateRoleTimerComplete);
				_createRoleTimer = null;
			}
		}
		private function onCreateRoleTimerComplete(e:*):void
		{
			disposeCreateRoleTimer();
			doAutoCreateRole();
		}
		private var _autoCreateRole:Boolean;
		private function doAutoCreateRole():void
		{
			if(_submitFun!=null)
			{
				_submitFun.call(null,getCreateRoleInfo());
			}
			
			_autoCreateRole = true;
		}
		
		
		//----------------------- public function ---------------------
		
		/**
		 * 创号信息 
		 * @return 
		 * 
		 */		
		public function getCreateRoleInfo():Object
		{
			_name = _createRoleMC.nameTxt.text;
			if(_name == "" || _autoCreateRole)
			{
				_name = RandomName.getName( _sex );
				_createRoleMC.nameTxt.text = _name;
			}
			
			return {camp:_camp,sex:_sex,name:_name};
		}
		
		/**
		 * 创建角色的回调函数 
		 * @param callBack
		 * 
		 */
		public function set submitFun(callBack:Function):void
		{
			_submitFun = callBack;
		}
		
		/**
		 * 停止播放背景音乐
		 * 
		 */		
		public function stopBackgroundMusic():void
		{
			SoundManager.instance.stopBackgroundMusic();
		}
		
		/**
		 * 显示登陆消息
		 * @param info
		 */
		public function addShowInfo(camp:int, sex:int, name:String):void
		{
			if(_playerInfo)
			{
				_playerInfo.addInfo(camp, sex, name);
			}
		} 
		
		
		private var _tipPanelTimeKey:uint;
		
		/**
		 * 显示异常信息 
		 * 
		 */
		public function showException(error:String,code:int=0):void
		{
			clearTimeout(_tipPanelTimeKey);
			
			if(error == null)
			{
				return;
			}
			
			if(_autoCreateRole)
			{
				doAutoCreateRole();
				return;
			}
			
			_createRoleMC.submitBtn.enabled = true;
			
			_tipPanel.x = _createRoleMC.nameTxt.x + _createRoleMC.nameTxt.width + _createRoleMC.randomName.width;
			_tipPanel.y = _createRoleMC.nameTxt.y + _createRoleMC.nameTxt.height/2;
			_tipPanel.updateTips("<font color='#ff0000'>"+error+"</font>");
			_tipPanel.visible = true;
			
			if(code == 32002 && !_nameChange)//角色名已经存在
			{
				_tipPanelTimeKey = setTimeout(onTipPanelTimeOut,1000);
			}
		}
		
		private function onTipPanelTimeOut():void
		{
			_tipPanel.visible = false;
			loadRandomNameFromPhp();
		}
		
		public function set randomNameUrl(str:String):void
		{
			_randomNameUrl = str;
		}
		
		public function whoPlayGame(url1:String,url2:String):void
		{
			if(url1 && url1 != "")
			{
				_friendPlayGameUrl = url1;
			}
			if(url2 && url2 != "")
			{
				_whoPlayGameUrl = url2;
			}
			whoPlayGameShow();
		}
		
		/**
		 * 设置默认参数
		 * @param name
		 * @param sex
		 * @param camp
		 * 
		 */
		public function setDefaultParams(name:String,sex:int,career:int):void
		{
			if( name != null && name != ""  )
			{
				if( _createRoleMC.nameTxt )
				{
					_createRoleMC.nameTxt.text = name; 
				}
			}
			else
			{
				loadRandomNameFromPhp();
			}
			_sex = sex;
			_career = career;
			changeSelect(career,sex);
		}
		
		protected function loadRandomNameFromPhp():void
		{
			clearTimeout(_tipPanelTimeKey);
			_createRoleMC.nameTxt.text = RandomName.getName( _sex );
			checkTipPanel();
			_nameChange = false;
		}
		
		private function onRoleLoadErrorHandler(event:ErrorEvent):void
		{
			trace("onRoleLoadErrorHandler:"+event.text);
		}
		
		protected function whoPlayGameShow():void
		{
			
		}
		
		public function dispose():void
		{
			disposeCreateRoleTimer();
		}
		
	}
}