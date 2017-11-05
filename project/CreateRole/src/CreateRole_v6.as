package
{
	import core.BaseMovieClip;
	import core.Effect;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	public class CreateRole_v6 extends BaseMovieClip
	{
		private var _bg:Bitmap;
		private var _centerPoint:Point = new Point();
		private var _roleLoader:Loader;
		private var _processBg:Sprite;
		private var _processTxt:TextField;
		private var _frameCount:int;
		private var _ramdomVersion:int;
		
		public function CreateRole_v6()
		{
			super();
		}
		
		/**
		 * 随即排列阵营 
		 * 
		 */
		private function randomCamp():void
		{
			var nums:Array = [1,2,3];
			var randomNums:Array = [];
			while(nums.length > 0)
			{
				var index:int = Math.floor(Math.random() * nums.length);
				randomNums.push(nums[index]);
				nums.splice(index,1);
			}
			
			var num1:int = _createRoleMC["camp_" + randomNums[0]].y;
			var num2:int = _createRoleMC["camp_" + randomNums[1]].y;
			var num3:int = _createRoleMC["camp_" + randomNums[2]].y;
			
			_createRoleMC["camp_1"].y = num1;
			_createRoleMC["camp_2"].y = num2;
			_createRoleMC["camp_3"].y = num3;
		
			num1 = _createRoleMC["camp_" + randomNums[0]].x;
			num2 = _createRoleMC["camp_" + randomNums[1]].x;
			num3 = _createRoleMC["camp_" + randomNums[2]].x;
			
			_createRoleMC["camp_1"].x = num1;
			_createRoleMC["camp_2"].x = num2;
			_createRoleMC["camp_3"].x = num3;
		}
		
		/**
		 * 加载大图像 
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
					_roleLoader.parent.removeChild(_roleLoader);
				}
			}
			
			_processTxt.text = "0%";
			_roleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onRoleLoadComHandler);
			_roleLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onRoleLoadProcessHandler);
			_roleLoader.name = selectRole;
			_roleLoader.load(new URLRequest(mainPath + "assets/role_v6/"+selectRole+".swf?v="+_ramdomVersion));
			_frameCount = 0;
			addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(event:Event):void
		{
			_frameCount++;
			if(_frameCount > 20)
			{
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
				if(!_processBg.parent)
				{
					addChild(_processBg);
				}
			}
		}
		
		/**
		 * 角色swf下载中 
		 * @param event
		 * 
		 */
		private function onRoleLoadProcessHandler(event:ProgressEvent):void
		{
			if(_roleLoader.contentLoaderInfo)
			{
				_processTxt.text = int(Number(_roleLoader.contentLoaderInfo.bytesLoaded/_roleLoader.contentLoaderInfo.bytesTotal)*100) + "%";
			}
		}
		
		/**
		 * 角色swf下载完成 
		 * @param event
		 * 
		 */
		private function onRoleLoadComHandler(event:Event):void
		{
			_frameCount = 0;
			removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			
			if(_processBg.parent)
			{
				_processBg.parent.removeChild(_processBg);
			}
			
			_roleLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onRoleLoadComHandler);
			_roleLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onRoleLoadProcessHandler);
			if(_roleLoader.name == "role_6_" + _camp + "_" + _sex)
			{
				addChild(_roleLoader);
				_roleLoader.x = _centerPoint.x - 220;
				_roleLoader.y = _centerPoint.y + 150;
			}
		}
		
		override protected function onAddToStage(event:Event):void
		{
			_ramdomVersion = getTimer();
			
			_bg = new Bitmap(new Bg(0,0));
			addChild(_bg);

			_createRoleMC = new CreateRoleMC_v6();
			addChild(_createRoleMC);
			
			(_createRoleMC as CreateRoleMC_v6).camp_1.buttonMode = true;
			(_createRoleMC as CreateRoleMC_v6).camp_2.buttonMode = true;
			(_createRoleMC as CreateRoleMC_v6).camp_3.buttonMode = true;
			
			_processBg = new Sprite();
			_processBg.graphics.lineStyle(1,0xffffff,0.7);
			_processBg.graphics.beginFill(0xffffff,0.7);
			_processBg.graphics.drawRect(0,0,35,20);
			_processBg.graphics.endFill();
			
			_processTxt = new TextField();
			_processTxt.width = 40;
			_processTxt.height = 20;
			_processTxt.textColor = 0x00000;
//			_processTxt.filters = [Effect.glowFilter];
			_processTxt.x = 2;
			_processTxt.y = 0;
			_processBg.addChild(_processTxt);
			
			randomCamp();
			super.onAddToStage(event);
		}
		
		override protected function createRoleMcResize():void
		{
			_centerPoint.x = stage.stageWidth/2;
			_centerPoint.y = stage.stageHeight/2;
			
			_createRoleMC.x = (stage.stageWidth - 1000)/2;
			_createRoleMC.y = (stage.stageHeight - 580)/2;
			
			_bg.x = (stage.stageWidth - _bg.width)/2;
			_bg.y = (stage.stageHeight - _bg.height)/2;
			
			_processBg.x = _centerPoint.x - 220;
			_processBg.y = _centerPoint.y;
			
			if(_roleLoader && _roleLoader.parent)
			{
				_roleLoader.x = _centerPoint.x - 220;
				_roleLoader.y = _centerPoint.y + 150;
			}
		}
		
		override protected function changeSelect(camp:int, sex:int):void
		{
			if( camp <= 0 || camp > 3  )
			{
				camp = 1;
			}
			
			if( sex < 0 || sex > 1)
			{
				sex = 0;
			}
			
			if(camp == _camp && sex == _sex)
			{
				return;
			}
			
			_createRoleMC.camp_1.role_1_0.gotoAndStop(1);
			_createRoleMC.camp_1.role_1_1.gotoAndStop(1);
			_createRoleMC.camp_2.role_2_0.gotoAndStop(1);
			_createRoleMC.camp_2.role_2_1.gotoAndStop(1);
			_createRoleMC.camp_3.role_3_0.gotoAndStop(1);
			_createRoleMC.camp_3.role_3_1.gotoAndStop(1);
			
			_createRoleMC.camp_1.role_1_0.filters = null;
			_createRoleMC.camp_1.role_1_1.filters = null;
			_createRoleMC.camp_2.role_2_0.filters = null;
			_createRoleMC.camp_2.role_2_1.filters = null;
			_createRoleMC.camp_3.role_3_0.filters = null;
			_createRoleMC.camp_3.role_3_1.filters = null;
			
			super.changeSelect(camp,sex);
			
			var lastCamp:MovieClip = _createRoleMC["camp_" + _camp] as MovieClip;
			var lastRole:MovieClip = lastCamp["role_" + _camp + "_" + _sex] as MovieClip;
			lastRole.gotoAndStop(2);
			lastRole.filters = [Effect.downFilter];
			loadRoleSwf("role_6_" + _camp + "_" + _sex);
		}
		
		override protected function onMouseClickHandler(event:MouseEvent):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var nameList:Array = target.name.split("_");
			if(nameList[0] == "role")//小头像
			{
				changeSelect(int(nameList[1]),int(nameList[2]));
			}
			else if(target.name == "submitBtn")//请求创建角色
			{
				createRoleReq();
			}
			else if(target.name == "randomName")
			{
				loadRandomNameFromPhp();
			}
		}
		
		override protected function onMouseOverHandler(event:MouseEvent):void
		{
			var roleMc:DisplayObject = event.target as DisplayObject;
			if(roleMc == null || roleMc.name.split("_")[0] != "role")
			{
				return;
			}
			roleMc.filters = [Effect.overFilter];
		}
		
		override protected function onMouseOutHandler(event:MouseEvent):void
		{
			var roleMc:DisplayObject = event.target as DisplayObject;
			if(roleMc == null || roleMc.name.split("_")[0] != "role")
			{
				return;
			}
			
			if(roleMc.name != "role_" + _camp + "_" + _sex)
			{
				roleMc.filters = null;
			}
			else
			{
				roleMc.filters = [Effect.downFilter];
			}
		}
	}
}