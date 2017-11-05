package
{
	import com.media.SoundManager;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import utils.RandomName;
	import utils.StringUtil;
	
	import view.IntroTipPanel;
	import view.PlayerInfo;
	import view.TipPanel;
	
	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	public class CreateRole_v3 extends MovieClip
	{
		private const btnFilter:GlowFilter = new GlowFilter(0xfff600,1,6,6);
		private const nameExp:RegExp = /^[A-Za-z0-9\一-\龥]+$/;//英文数字中文 
		private var _createRoleMC:CreateRoleMC_v3;
		
		private var _submitFun:Function;
		
		private var _camp:int = -1;
		private var _sex:int = -1;
		private var _name:String;
		
		private var _glowStep:Number = 0.7;
		
		private var _clickBorder:Bitmap;
		private var _overBorder:Bitmap;
		private var _tipPanel:TipPanel;
		private var _introTip:IntroTipPanel;
		
		private var _infoSprite:Sprite;
		private var _playerInfo:PlayerInfo;
		
		private var _randomNameUrl:String;
		
		public var mainPath:String = "";
		public var version:String = "";
		
		public function CreateRole_v3()
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
		private function onAddToStage(e:Event):void
		{
			SoundManager.instance.startBackgroundMusic(mainPath);

			_createRoleMC = new CreateRoleMC_v3();
			addChild(_createRoleMC);
			_createRoleMC.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_createRoleMC.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			
			stage.focus = _createRoleMC.nameTxt;
			_createRoleMC.nameTxt.text = "";
			_createRoleMC.nameTxt.maxChars = 7;
			_createRoleMC.addEventListener(Event.CHANGE,onRoleNameChange);
			
			_clickBorder = new Bitmap(new RoleBorder());
			_overBorder = new Bitmap(new RoleBorder());
			
			_clickBorder.x = _createRoleMC.camp_1_0.x-5;
			_clickBorder.y = _createRoleMC.camp_1_0.y-5;
			_createRoleMC.addChild(_clickBorder);
			
			_tipPanel = new TipPanel();
			_createRoleMC.addChild(_tipPanel);
			_tipPanel.visible = false;
			
			_introTip = new IntroTipPanel();
			
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
			
			changeSelect(1,0);
		}
		
		private function onMouseClickHandler(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.camp_1_0:
				case _createRoleMC.camp_1_1:
				case _createRoleMC.camp_2_0:
				case _createRoleMC.camp_2_1:
				case _createRoleMC.camp_3_0:
				case _createRoleMC.camp_3_1:
					var arr:Array = target.name.split("_");
					changeSelect(arr[1],arr[2]);
					break;
				case _createRoleMC.submitBtn:
					createRoleReq();
					break;
				case _createRoleMC.randomName:
					//随机起名
					loadRandomNameFromPhp();
					break;
			}
		}
		
		private function onMouseOverHandler(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.camp_1_0:
				case _createRoleMC.camp_1_1:
				case _createRoleMC.camp_2_0:
				case _createRoleMC.camp_2_1:
				case _createRoleMC.camp_3_0:
				case _createRoleMC.camp_3_1:
					var arr:Array = target.name.split("_");
					if(_camp != -1 && _camp == arr[1] && _sex == arr[2])//是当前选择的阵营的角色
					{
						
					}
					else
					{
						if(_overBorder!=null && _overBorder.parent)
						{
							_createRoleMC.removeChild(_overBorder);
						}
						_overBorder.x = target.x-5;
						_overBorder.y = target.y-5;
						_createRoleMC.addChild(_overBorder);
					}
					
					_introTip.x = e.currentTarget.mouseX+5;
					_introTip.y = e.currentTarget.mouseY+5;
					_introTip.updateIntro(arr[1]);
					_createRoleMC.addChild(_introTip);
					break;
			}
		}
		
		private function onMouseOutHandler(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.camp_1_0:
				case _createRoleMC.camp_1_1:
				case _createRoleMC.camp_2_0:
				case _createRoleMC.camp_2_1:
				case _createRoleMC.camp_3_0:
				case _createRoleMC.camp_3_1:
					var arr:Array = target.name.split("_");
					if(_camp != -1 && _camp == arr[1] && _sex == arr[2])//是当前选择的阵营的角色
					{
						
					}
					else
					{
						if(_overBorder!=null && _overBorder.parent)
						{
							_createRoleMC.removeChild(_overBorder);
						}
					}
					
					if(_introTip!=null && _introTip.parent)
					{
						_createRoleMC.removeChild(_introTip);
					}
					break;
			}
		}
		
		protected var _nameChange:Boolean;
		
		/**
		 * 输入改变 
		 * @param event
		 * 
		 */
		private function onRoleNameChange(e:Event):void
		{
			clearTimeout(_tipPanelTimeKey);
			_nameChange = true;
			checkTipPanel();
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
			_camp = camp;
			if( _sex != sex )
			{
				_sex = sex;
				if(!_nameChange)
				{
					loadRandomNameFromPhp();
				}
			}
			if(_clickBorder!=null&&_clickBorder.parent)
			{
				_createRoleMC.removeChild(_clickBorder);
			}
			if(_overBorder!=null && _overBorder.parent)
			{
				_createRoleMC.removeChild(_overBorder);
			}
			_clickBorder.x = (_createRoleMC["camp_"+camp+"_"+sex] as SimpleButton).x-5;
			_clickBorder.y = (_createRoleMC["camp_"+camp+"_"+sex] as SimpleButton).y-5;
			_createRoleMC.addChild(_clickBorder);
			
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
				var colorArr:Array = ["#00ff00"];
				_tipPanel.updateTips("以[默认名字]进入游戏",colorArr);
				_tipPanel.visible = true;
				return true;
			}
			return false;
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
				_infoSprite.x = 100;
				_infoSprite.y = stage.stageHeight - 200;
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
				_sex = sex;
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
	}
}