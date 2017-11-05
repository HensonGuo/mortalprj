package
{
	import com.media.SoundManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import utils.RandomName;
	import utils.StringUtil;
	
	import view.PlayerInfo;
	import view.TipPanel;
	
	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	/**
	 * 
	 * @author Administrator
	 */
	public class CreateRole_v2 extends MovieClip
	{
		private const overFilter:GlowFilter = new GlowFilter(0xffff00,1,10);
		private const downFilter:GlowFilter = new GlowFilter(0xffff00,1,10);
		private const btnFilter:GlowFilter = new GlowFilter(0xffff00,1,6,6);
		private const glowFilter:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
		//		private const nameExp:RegExp = /^[A-Za-z0-9]+$|[\一-\龥]/;//英文数字中文 
		private const nameExp:RegExp = /^[A-Za-z0-9\一-\龥]+$/;//英文数字中文 
		
		private var _createRoleMC:CreateRoleMC_v2;
		private var _roleImg:Loader;
		
		private var _submitFun:Function;
		
		private var _camp:int = -1;
		private var _sex:int = -1;
		private var _name:String;
		
		private var _tipPanel:TipPanel;
		private var _errorTxt:TextField;
		
		private var _glowStep:Number = 0.7;
		
		private var _infoSprite:Sprite;
		private var _playerInfo:PlayerInfo;
		
		private var _randomNameUrl:String;
		
		public var mainPath:String = "";
		public var version:String = "";
		
		public function CreateRole_v2()
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
		
		/**
		 * 添加到舞台 
		 * @param event
		 * 
		 */
		private function onAddToStage(event:Event):void
		{
			SoundManager.instance.startBackgroundMusic(mainPath);
			
			_roleImg = new Loader();
			_roleImg.contentLoaderInfo.addEventListener(Event.COMPLETE,onRoleImgComHandler);
			_roleImg.load(new URLRequest(mainPath + "assets/role/roleImg.swf?v=" + version));
			addChild(_roleImg);
			
			_createRoleMC = new CreateRoleMC_v2();
			addChild(_createRoleMC);
			_createRoleMC.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			
			stage.focus = _createRoleMC.nameTxt;
			_createRoleMC.nameTxt.text = "";
			_createRoleMC.nameTxt.maxChars = 7;
			_createRoleMC.addEventListener(Event.CHANGE,onRoleNameChange);
			
			_createRoleMC.createNameTxt.htmlText = "<a href='event:0'><u>随机取名</u><a>";
			_createRoleMC.createNameTxt.selectable = false;
			var createNameTf:TextFormat = new TextFormat("",16,0xffff00);
			_createRoleMC.createNameTxt.setTextFormat(createNameTf);
			var filterArr:Array = [glowFilter];
			_createRoleMC.createNameTxt.filters = filterArr;
			_createRoleMC.createNameTxt.addEventListener(TextEvent.LINK, onLinkCreateNameHandler);
			
			_tipPanel = new TipPanel();
			_createRoleMC.addChild(_tipPanel);
			_tipPanel.visible = false;
			
			_errorTxt = new TextField();
			_errorTxt.width = 300;
			_errorTxt.selectable = false;
			_errorTxt.defaultTextFormat = new TextFormat("",14,0xff0000,true,null,null,null,null,TextFormatAlign.CENTER);
			
			_infoSprite = new Sprite();
			_infoSprite.x = 100;
			_infoSprite.y = stage.stageHeight - 200;
			addChild(_infoSprite);
			
			_playerInfo = new PlayerInfo();
			_infoSprite.addChild(_playerInfo);
			
			stage.addEventListener(Event.RESIZE,onStageResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			addEventListener(Event.ENTER_FRAME,onBtnEnterFrame);
			onStageResize(null);
			
			changeSelect(1,1);
		}
		
		
		/**
		 * 舞台大小改变 
		 * @param event
		 * 
		 */
		private function onStageResize(event:Event):void
		{
			if(stage)
			{
				_createRoleMC.x = (stage.stageWidth - 336)/2;
				_createRoleMC.y = (stage.stageHeight - 350)/2;
				_roleImg.x = _createRoleMC.x - _roleImg.width/2;
				_roleImg.y = _createRoleMC.y - 80;
				_errorTxt.x = (stage.stageWidth - _errorTxt.width) / 2;
				_infoSprite.x = 100;
				_infoSprite.y = stage.stageHeight - 200;
			}
		}
		
		/**
		 * 美女下载完成 
		 * @param event
		 * 
		 */
		private function onRoleImgComHandler(event:Event):void
		{
			_roleImg.x = _createRoleMC.x - _roleImg.width/2;
			_roleImg.y = _createRoleMC.y - 80;
		}
		
		/**
		 * 鼠标点击事件 
		 * @param event
		 * 
		 */
		private function onMouseClickHandler(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.camp_1:
					changeSelect(1,_sex);
					break;
				case _createRoleMC.camp_2:
					changeSelect(2,_sex);
					break;
				case _createRoleMC.camp_3:
					changeSelect(3,_sex);
					break;
				case _createRoleMC.sex_0:
					changeSelect(_camp,0);
					break;
				case _createRoleMC.sex_1:
					changeSelect(_camp,1);
					break;
				case _createRoleMC.randomName:
					//随机起名
					loadRandomNameFromPhp();
					break;
				case _createRoleMC.submitBtn:
					createRoleReq();
					break;
			}
		}
		
		/**
		 * 鼠标移上事件 
		 * @param event
		 * 
		 */
		private function onMouseOverHandler(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.camp_1:
				case _createRoleMC.camp_2:
				case _createRoleMC.camp_3:
					if(_camp != -1 && _camp == parseInt(target.name.split("_")[1]))//是当前选择的阵营
					{
						
					}
					else
					{
						target.filters = [overFilter];
					}
					break;
			}
		}
		
		/**
		 * 鼠标移出事件 
		 * @param event
		 * 
		 */
		private function onMouseOutHandler(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.camp_1:
				case _createRoleMC.camp_2:
				case _createRoleMC.camp_3:
					if(_camp != -1 && _camp == parseInt(target.name.split("_")[1]))//是当前选择的阵营
					{
						
					}
					else
					{
						target.filters = null;
					}
					break;
			}
		}
		
		/**
		 * 键盘事件 
		 * @param event
		 * 
		 */
		private function onKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)//enter
			{
				createRoleReq();
			}
		}
		
		
		/**
		 * 失去焦点 
		 * @param event
		 * 
		 */
		private function onNameFocusOut(event:FocusEvent):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(MouseEvent.CLICK,onNameTxtMouseClick);
		}
		
		protected var _nameChange:Boolean;
		
		/**
		 * 输入改变 
		 * @param event
		 * 
		 */
		private function onRoleNameChange(event:Event):void
		{
			clearTimeout(_tipPanelTimeKey);
			_nameChange = true;
			checkTipPanel();
		}
		
		/**
		 * 帧频 
		 * @param event
		 * 
		 */
		private function onEnterFrame(event:Event):void
		{
			_createRoleMC.nameTxt.setSelection(0,_createRoleMC.nameTxt.text.length);
		}
		
		/**
		 * 名字点击事件 
		 * @param event
		 * 
		 */
		private function onNameTxtMouseClick(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		/**
		 * 更新选择 
		 * @param camp
		 * @param sex
		 * 
		 */
		private function changeSelect(camp:int,sex:int):void
		{
			if( camp <= 0 || camp >3  ) camp = 1;
			if( sex <0 || sex > 1) sex = 0;
			
			_createRoleMC.sex_0.gotoAndStop(1);
			_createRoleMC.sex_1.gotoAndStop(1);
			(_createRoleMC["sex_"+sex] as MovieClip).gotoAndStop(2);
			if(_camp != -1 && _camp != camp)
			{
				(_createRoleMC["camp_"+_camp] as SimpleButton).filters = null;	
			}
			(_createRoleMC["camp_"+camp] as SimpleButton).filters = [downFilter];
			
			if( _sex != sex )
			{
				_sex = sex;
				if(!_nameChange)
				{
					loadRandomNameFromPhp();
				}
			}
			
			_camp = camp;
			_sex = sex;
		}
		
		/**
		 * 检查是否要显示tips 
		 * 
		 */
		private function checkTipPanel():Boolean
		{
			_tipPanel.visible = false;
			var nameTxt:String = StringUtil.trim(_createRoleMC.nameTxt.text);
			if(nameTxt == "")
			{
				_tipPanel.x = _createRoleMC.nameTxt.x + _createRoleMC.nameTxt.width + _createRoleMC.randomName.width;
				_tipPanel.y = _createRoleMC.nameTxt.y + _createRoleMC.nameTxt.height/2;
				_tipPanel.updateTips("请输入角色名");
				_tipPanel.visible = true;
			}
			else if(!nameExp.test(nameTxt))
			{
				_tipPanel.x = _createRoleMC.nameTxt.x + _createRoleMC.nameTxt.width + _createRoleMC.randomName.width;
				_tipPanel.y = _createRoleMC.nameTxt.y + _createRoleMC.nameTxt.height/2;
				_tipPanel.updateTips("输入的角色名含非法字符，如&，#，@");
				_tipPanel.visible = true;
			}
			else if(nameTxt.length < 2)
			{
				_tipPanel.x = _createRoleMC.nameTxt.x + _createRoleMC.nameTxt.width + _createRoleMC.randomName.width;
				_tipPanel.y = _createRoleMC.nameTxt.y + _createRoleMC.nameTxt.height/2;
				_tipPanel.updateTips("角色名必须为2~7个字符");
				_tipPanel.visible = true;
			}
			else
			{
				_tipPanel.x = _createRoleMC.submitBtn.x + _createRoleMC.submitBtn.width;
				_tipPanel.y = _createRoleMC.submitBtn.y + _createRoleMC.submitBtn.height/2;
				_tipPanel.updateTips("点击进入游戏");
				_tipPanel.visible = true;
				return true;
			}
			return false;
		}
		
		/**
		 * 进入游戏按钮的发光效果 
		 * @param event
		 * 
		 */
		private function onBtnEnterFrame(event:Event):void
		{
			if(btnFilter.blurX > 40 || btnFilter.blurX < 3)
			{
				_glowStep *= -1;
			}
			btnFilter.blurX += _glowStep;
			btnFilter.blurY += _glowStep;
			_createRoleMC.submitBtn.filters = [btnFilter];
		}
		
		/**
		 * 请求创建角色 
		 * 
		 */
		private function createRoleReq():void
		{
			if(!_createRoleMC.submitBtn.enabled)
			{
				return;
			}
			
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
				_submitFun.call(null,{camp:_camp,sex:_sex,name:_name});
			}
			_createRoleMC.submitBtn.enabled = false;
			setTimeout(
				function submitBtnEnable():void{
					_createRoleMC.submitBtn.enabled = true;
			},1000);
			
			trace("请求创建角色");
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
			_createRoleMC.submitBtn.enabled = true;
			
			_tipPanel.x = _createRoleMC.nameTxt.x + _createRoleMC.nameTxt.width + _createRoleMC.randomName.width;
			_tipPanel.y = _createRoleMC.nameTxt.y + _createRoleMC.nameTxt.height/2;
			_tipPanel.updateTips("<font color='#ff0000'>"+error+"</font>");
			_tipPanel.visible = true;
			
			if(code == 32002 && !_nameChange)//角色名已经存在
			{
				_tipPanelTimeKey = setTimeout(onTipPanelTimeOut,1000);
			}
			
//			if(!_errorTxt.parent)
//			{
//				addChild(_errorTxt);
//			}
//			_errorTxt.text = error;
//			_errorTxt.y = 100;
//			_errorTxt.alpha = 1;
//			_errorTxt.removeEventListener(Event.ENTER_FRAME,onErrorEnterFrame);
//			_errorTxt.addEventListener(Event.ENTER_FRAME,onErrorEnterFrame);
		}
		
		private function onTipPanelTimeOut():void
		{
			_tipPanel.visible = false;
			loadRandomNameFromPhp();
		}
		
		private function onErrorEnterFrame(event:Event):void
		{
			_errorTxt.y -= 1;
			_errorTxt.alpha -= 0.02;
			if(_errorTxt.y <= 0 || _errorTxt.alpha <= 0)
			{
				_errorTxt.removeEventListener(Event.ENTER_FRAME,onErrorEnterFrame);
				removeChild(_errorTxt);
			}
		}
		
		public function set randomNameUrl(str:String):void
		{
			_randomNameUrl = str;
		}
		
		/**
		 * 设置默认参数
		 * @param name
		 * @param sex
		 * @param camp
		 * 
		 */
		public function setDefaultParams(name:String,sex:int,camp:int):void
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
			changeSelect(camp,sex);
		}
		
		private function loadRandomNameFromPhp():void
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
		
		private function onLinkCreateNameHandler(e:TextEvent):void
		{
			loadRandomNameFromPhp();
		}
		
		/**
		 * 停止播放背景音乐
		 * 
		 */		
		public function stopBackgroundMusic():void
		{
			SoundManager.instance.stopBackgroundMusic();
		}
	}
}