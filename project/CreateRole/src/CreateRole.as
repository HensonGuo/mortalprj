package
{
	import com.media.SoundManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	import view.PlayerInfo;
	import utils.RandomName;
	import view.TipPanel;
	import utils.StringUtil;
	
	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	public class CreateRole extends MovieClip 
	{
		private const overFilter:GlowFilter = new GlowFilter(0xffff00);
		private const downFilter:GlowFilter = new GlowFilter(0xffff00);
		private const btnFilter:GlowFilter = new GlowFilter(0xffff00,1,6,6);
		private const glowFilter:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
		private const nameExp:RegExp = /^[A-Za-z0-9\一-\龥]+$/;//英文数字中文 
	
		private var _glowStep:Number = 0.7;
		
		private var _createRoleMC:CreateRoleMC;
		private var _bgImg:Bitmap;
		private var _roleBg:Sprite;
		private var _roleLoader:Loader;
		private var _currentCountry:int = -1;
		private var _currentSex:int = -1; 
		private var _currentName:String;
		private var _createNameTxt:TextField;
		private var _roleNameTxt:TextField;
		private var _submitBtn:SimpleButton;
		private var _tipPanel:TipPanel;
		
		private var _randomNameUrl:String;
		
		public var mainPath:String = "";
		public var version:String = "";
		
		private var _infoSprite:Sprite;
		private var _playerInfo:PlayerInfo;
		
		public function CreateRole()
		{
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
			_createRoleMC = new CreateRoleMC();
			_bgImg = new Bitmap(new BgImg(0,0));
			_roleBg = new Sprite();
			
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			_createRoleMC.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			
			addChild(_bgImg);
			addChild(_createRoleMC);
			_createRoleMC.addChild(_roleBg);

			_roleNameTxt = _createRoleMC.roleNameTxt;
			_roleNameTxt.text = "";
			_roleNameTxt.maxChars = 7;
			stage.focus = _roleNameTxt;
			_roleNameTxt.addEventListener(Event.CHANGE,onRoleNameChange);
			
			_createNameTxt = _createRoleMC.createNameTxt;
			_createNameTxt.htmlText = "<a href='event:0'><u>随机取名</u><a>";
			_createNameTxt.selectable = false;
			var createNameTf:TextFormat = new TextFormat("",16,0xffff00);
			_createNameTxt.setTextFormat(createNameTf);
			var filterArr:Array = [glowFilter];
			_createNameTxt.filters = filterArr;
			_createNameTxt.addEventListener(TextEvent.LINK, onLinkCreateNameHandler);
			
			_submitBtn = _createRoleMC.submit;
			
			_tipPanel = new TipPanel();
			_createRoleMC.addChild(_tipPanel);
			_tipPanel.visible = false;
			checkTipPanel();
			
			_infoSprite = new Sprite();
			_infoSprite.x = 100;
			_infoSprite.y = stage.stageHeight - 200;
			addChild(_infoSprite);
			
			_playerInfo = new PlayerInfo();
			_infoSprite.addChild(_playerInfo);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(Event.RESIZE,onStageResize);
			addEventListener(Event.ENTER_FRAME,onBtnEnterFrame);
			onStageResize(null);
			
			changeSelect(1,1);
		}
		
		/**
		 * 舞台改变大小 
		 * @param event
		 * 
		 */
		private function onStageResize(event:Event):void
		{
			if( stage )
			{
				_createRoleMC.x = (stage.stageWidth - _createRoleMC.width)/2;
				_createRoleMC.y = (stage.stageHeight - _createRoleMC.height)/2;
				_bgImg.x = (stage.stageWidth - _bgImg.width)/2;
				_bgImg.y = (stage.stageHeight - _bgImg.height)/2;
				_infoSprite.x = 100;
				_infoSprite.y = stage.stageHeight - 200;
			}
		}
		
		/**
		 * 鼠标移上 
		 * @param event
		 * 
		 */
		private function onMouseOverHandler(event:MouseEvent):void
		{
			var roleMc:DisplayObject = event.target as DisplayObject;
			if(roleMc == null || roleMc.name.split("_")[0] != "smallRole")
			{
				return;
			}
			roleMc.filters = [overFilter];
		}
		
		/**
		 * 鼠标移出 
		 * @param event
		 * 
		 */
		private function onMouseOutHandler(event:MouseEvent):void
		{
			var roleMc:DisplayObject = event.target as DisplayObject;
			if(roleMc == null || roleMc.name.split("_")[0] != "smallRole")
			{
				return;
			}
			
			if(roleMc.name != "smallRole_" + _currentCountry + _currentSex)
			{
				roleMc.filters = null;
			}
			else
			{
				roleMc.filters = [downFilter];
			}
		}
		
		/**
		 * 鼠标点击 
		 * @param event
		 * 
		 */
		private function onMouseClickHandler( event:MouseEvent ):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var nameList:Array = target.name.split("_");
			if(nameList[0] == "smallRole")//小头像
			{
				changeSelect(int(nameList[1].charAt(0)),int(nameList[1].charAt(1)));
			}
			else if(target.name == "submit")//请求创建角色
			{
				parseCreateRole();
			}
		}
		
		/**
		 * 输入名字改变 
		 * @param event
		 * 
		 */
		private function onRoleNameChange(event:Event):void
		{
			checkTipPanel();
		}
		
		/**
		 * 随机取名 
		 * @param e
		 * 
		 */
		private function onLinkCreateNameHandler(e:TextEvent):void
		{
			loadRandomNameFromPhp();
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
			_submitBtn.filters = [btnFilter];
		}
		
		/**
		 * 切换选择
		 * @param name
		 * 
		 */
		private function changeSelect(selectCountry:int,selectSex:int):void
		{
			if( selectCountry <= 0 || selectCountry >3  )
			{
				selectCountry = 1;
			}
			
			if( selectSex <0 || selectSex > 1)
			{
				selectSex = 0;
			}
			
			if(selectCountry != _currentCountry)
			{
				_createRoleMC.infoMc.gotoAndStop(selectCountry);
			}
			else if(selectSex == _currentSex)
			{
				return;
			}
		
			var lastRole:DisplayObject = _createRoleMC["smallRole_"+_currentCountry+_currentSex] as DisplayObject;
			if(lastRole != null)
			{
				lastRole.filters = null;
			}
			if( _currentSex != selectSex )
			{
				_currentSex = selectSex;
				loadRandomNameFromPhp();
			}
			
			_currentCountry = selectCountry;
			_currentSex = selectSex;
			(_createRoleMC["smallRole_"+_currentCountry+_currentSex] as DisplayObject).filters = [downFilter];
			loadRoleSwf("role"+_currentCountry+_currentSex);
		}
		
		/**
		 * 下载选中的角色swf 
		 * @param selectRole
		 * 
		 */
		private function loadRoleSwf(selectRole:String):void
		{
			if(_roleLoader == null)
			{
				_roleLoader = new Loader();
				if(_roleLoader.parent != null)
				{
					_roleBg.removeChild(_roleLoader);
				}
			}
			
			_roleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onRoleLoadComHandler);
			_roleLoader.name = selectRole;
			_roleLoader.load(new URLRequest(mainPath + "assets/role/"+selectRole+".swf"));
		}
		
		/**
		 * 角色swf下载完成 
		 * @param event
		 * 
		 */
		private function onRoleLoadComHandler(event:Event):void
		{
			_roleLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onRoleLoadComHandler);
			if(_roleLoader.name == "role"+_currentCountry+_currentSex)
			{
				_roleBg.addChild(_roleLoader);
				_roleLoader.x = (_createRoleMC.width - _roleLoader.width)/2 - 100;
			}
		}
		
		/**
		 * 键盘事件 
		 * @param event
		 * 
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)//enter
			{
				parseCreateRole();
			}
		}
		
		/**
		 * 请求创建角色 
		 * 
		 */
		private function parseCreateRole():void
		{
			_currentName = _roleNameTxt.text;
			
			if(!checkTipPanel())
			{
				return;
			}
			if(!_submitBtn.enabled)
			{
				return;
			}
			if(_submitFun!=null)
			{
				_submitFun.call(null,{camp:_currentCountry,sex:_currentSex,name:_currentName});
			}
			_submitBtn.enabled = false;
			setTimeout(
				function submitBtnEnable():void{
					_submitBtn.enabled = true;
				},1000);
			
			trace("请求创建角色");
		}
		
		/**
		 * 检查是否要显示tips 
		 * 
		 */
		private function checkTipPanel():Boolean
		{
			_tipPanel.visible = false;
			var nameTxt:String = StringUtil.trim(_roleNameTxt.text);
			if(nameTxt == "")
			{
				_tipPanel.x = _roleNameTxt.x + _roleNameTxt.width;
				_tipPanel.y = _roleNameTxt.y + _roleNameTxt.height/2;
				_tipPanel.updateTips("请输入角色名");
				_tipPanel.visible = true;
				return false;
			}
			else if(!nameExp.test(nameTxt))
			{
				_tipPanel.x = _roleNameTxt.x + _roleNameTxt.width;
				_tipPanel.y = _roleNameTxt.y + _roleNameTxt.height/2;
				_tipPanel.updateTips("输入的角色名含非法字符，如&，#，@");
				_tipPanel.visible = true;
				return false;
			}
			else if(nameTxt.length < 2)
			{
				_tipPanel.x = _roleNameTxt.x + _roleNameTxt.width;
				_tipPanel.y = _roleNameTxt.y + _roleNameTxt.height/2;
				_tipPanel.updateTips("角色名必须为2~7个字符");
				_tipPanel.visible = true;
				return false;
			}
			else
			{
				_tipPanel.x = _submitBtn.x + _submitBtn.width;
				_tipPanel.y = _submitBtn.y + _submitBtn.height/2;
				_tipPanel.updateTips("点击进入游戏");
				_tipPanel.visible = true;
				return true;
			}
			return true;
		}
		
		public function set randomNameUrl(str:String):void
		{
			_randomNameUrl = str;
		}
		
		private var _submitFun:Function;
		public function set submitFun(value:Function):void
		{
			_submitFun = value;
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
				if( _roleNameTxt )
				{
					_roleNameTxt.text = name; 
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
			_roleNameTxt.text = RandomName.getName( _currentSex );
			checkTipPanel();
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
		
		/**
		 * 显示异常信息 
		 * 
		 */
		public function showException(error:String,code:int=0):void
		{
			if(error == null)
			{
				return;
			}
			_submitBtn.enabled = true;
			
			_tipPanel.x = _roleNameTxt.x + _roleNameTxt.width;
			_tipPanel.y = _roleNameTxt.y + _roleNameTxt.height/2;
			_tipPanel.updateTips("<font color='#ff0000'>"+error+"</font>");
			_tipPanel.visible = true;
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