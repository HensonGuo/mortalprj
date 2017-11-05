package
{
	import core.BaseMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import view.FriendList;

	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	public class CreateRole_v4 extends BaseMovieClip
	{
		public function CreateRole_v4()
		{
			super();
		}
		
		override protected function onAddToStage(event:Event):void
		{
			_createRoleMC = new CreateRoleMC_v4();
			addChild(_createRoleMC);
			
			_createRoleMC.sex_0.buttonMode = true;
			_createRoleMC.sex_1.buttonMode = true;
			_createRoleMC.camp_1.buttonMode = true;
			_createRoleMC.camp_2.buttonMode = true;
			_createRoleMC.camp_3.buttonMode = true;
			
			super.onAddToStage(event);
			randomCamp();
		}
		
		/**
		 * 随机排列阵营 
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
			_createRoleMC["camp_3"].y = num3;;
		}
		
		override protected function createRoleMcResize():void
		{
			if(_friendPanel && !_friendPanel.isHide)
			{
				_createRoleMC.x = (stage.stageWidth - 453)/2;
				_createRoleMC.y = (stage.stageHeight - 310)/2 - 40;
			}
			else
			{
				_createRoleMC.x = (stage.stageWidth - 453)/2;
				_createRoleMC.y = (stage.stageHeight - 238)/2;
			}
		}
		
		/**
		 * 鼠标点击事件 
		 * @param event
		 * 
		 */
		override protected function onMouseClickHandler(event:MouseEvent):void
		{
			super.onMouseClickHandler(event);
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
		override protected function onMouseOverHandler(event:MouseEvent):void
		{
			super.onMouseOverHandler(event);
			var target:DisplayObject = event.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.sex_0:
					mouseOverSexGotoFrame(0,_createRoleMC.sex_0);
					break;
				case _createRoleMC.sex_1:
					mouseOverSexGotoFrame(1,_createRoleMC.sex_1);
					break;
//				case _createRoleMC.camp_1:
//				case _createRoleMC.camp_2:
//				case _createRoleMC.camp_3:
//					if(_camp != -1 && _camp == parseInt(target.name.split("_")[1]))//是当前选择的阵营
//					{
//						
//					}
//					else
//					{
//						target.filters = [overFilter];
//					}
//					break;
			}
		}
		
		/**
		 * 鼠标移出事件 
		 * @param event
		 * 
		 */
		override protected function onMouseOutHandler(event:MouseEvent):void
		{
			super.onMouseOutHandler(event);
			var target:DisplayObject = event.target as DisplayObject;
			switch(target)
			{
				case _createRoleMC.sex_0:
					mouseOverSexGotoFrame(0,_createRoleMC.sex_0,false);
					break;
				case _createRoleMC.sex_1:
					mouseOverSexGotoFrame(1,_createRoleMC.sex_1,false);
					break;
//				case _createRoleMC.camp_1:
//				case _createRoleMC.camp_2:
//				case _createRoleMC.camp_3:
//					if(_camp != -1 && _camp == parseInt(target.name.split("_")[1]))//是当前选择的阵营
//					{
//						
//					}
//					else
//					{
//						target.filters = null;
//					}
//					break;
			}
		}
		
		/**
		 * 鼠标移上移出性别mc的处理 
		 * @param sex
		 * @param over
		 * 
		 */
		private function mouseOverSexGotoFrame(sex:int,target:MovieClip,over:Boolean=true):void
		{
			if(_sex != sex)
			{
				if(over)
				{
					target.gotoAndStop(2);
				}
				else
				{
					target.gotoAndStop(1);
				}
			}
		}
		
		/**
		 * 更新选择 
		 * @param camp
		 * @param sex
		 * 
		 */
		override protected function changeSelect(camp:int,sex:int):void
		{
			if( camp <= 0 || camp >3  )
			{
				camp = Math.random()*2+1;
			}
			if( sex < 0 || sex > 1)
			{
				sex = 0;
			}
			
			super.changeSelect(camp,sex);
			
			_createRoleMC.sex_0.gotoAndStop(1);
			_createRoleMC.sex_1.gotoAndStop(1);
			
			_createRoleMC.camp_1.gotoAndStop(1);
			_createRoleMC.camp_2.gotoAndStop(1);
			_createRoleMC.camp_3.gotoAndStop(1);
			
			(_createRoleMC["sex_"+sex] as MovieClip).gotoAndStop(3);
			(_createRoleMC["camp_"+camp] as MovieClip).gotoAndStop(2);
		}
		
		override protected function whoPlayGameShow():void
		{
			_friendPanel = new FriendList(this);
			_friendPanel.addEventListener(Event.ADDED_TO_STAGE,onFriendListAddHandler)
			_friendPanel.addEventListener(Event.REMOVED_FROM_STAGE,onFriendListRemoveHandler)
			_friendPanel.show();
			_friendPanel.updateUrl(_friendPlayGameUrl,_whoPlayGameUrl);
			onStageResize(null);
		}
	}
}