package
{
	import core.BaseMovieClip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import view.FriendList;

	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	public class CreateRole_v1 extends BaseMovieClip
	{
		public function CreateRole_v1()
		{
			super();
		}
		
		override protected function onAddToStage(event:Event):void
		{
			_createRoleMC = new CreateRoleMC_v1();
			addChild(_createRoleMC);
			
			_createRoleMC.sex_0.buttonMode = true;
			_createRoleMC.sex_1.buttonMode = true;
			_createRoleMC.career_1.buttonMode = true;
			_createRoleMC.career_2.buttonMode = true;
			_createRoleMC.career_3.buttonMode = true;
			_createRoleMC.career_4.buttonMode = true;
			
			super.onAddToStage(event);
			randomcareer();
			
		
		}
		
		/**
		 * 随机排列阵营 
		 * 
		 */
		private function randomcareer():void
		{
			var nums:Array = [1,2,3,4];
			var randomNums:Array = [];
			while(nums.length > 0)
			{
				var index:int = Math.floor(Math.random() * nums.length);
				randomNums.push(nums[index]);
				nums.splice(index,1);
			}
			
			var num1:int = _createRoleMC["career_" + randomNums[0]].y;
			var num2:int = _createRoleMC["career_" + randomNums[1]].y;
			var num3:int = _createRoleMC["career_" + randomNums[2]].y;
			var num4:int = _createRoleMC["career_" + randomNums[3]].y;
			
			_createRoleMC["career_1"].y = num1;
			_createRoleMC["career_2"].y = num2;
			_createRoleMC["career_3"].y = num3;
			_createRoleMC["career_4"].y = num4;
			
			_sex = int(Math.random()*2);
			_career = int(Math.random()*4 + 1);
			trace("aa",_sex,_career);
			changeSelect(_career,_sex);
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
				case _createRoleMC.career_1:
					_career = 1;
					changeSelect(_career,_sex);
					break;
				case _createRoleMC.career_2:
					_career = 2;
					changeSelect(_career,_sex);
					break;
				case _createRoleMC.career_3:
					_career = 3;
					changeSelect(_career,_sex);
					break;
				case _createRoleMC.career_4:
					_career = 4;
					changeSelect(_career,_sex);
					break;
				case _createRoleMC.sex_0:
					trace(_career);
					changeSelect(_career,0);
					
					break;
				case _createRoleMC.sex_1:
					changeSelect(_career,1);
					break;
				case _createRoleMC.randomName:
					//随机起名
					loadRandomNameFromPhp();
					break;
				case _createRoleMC.submitBtn:
					createRoleReq();
					trace(Math.pow(2,_career - 1));
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
		override protected function changeSelect(career:int,sex:int):void
		{
//			if( career <= 0 || career >4  )
//			{
//				career = Math.random()*3+1;
//			}
//			if( sex < 0 || sex > 1)
//			{
//				sex = 0;
//			}
			
			super.changeSelect(career,sex);
			
			_createRoleMC.sex_0.gotoAndStop(1);
			_createRoleMC.sex_1.gotoAndStop(1);
			
			_createRoleMC.career_1.gotoAndStop(1);
			_createRoleMC.career_2.gotoAndStop(1);
			_createRoleMC.career_3.gotoAndStop(1);
			_createRoleMC.career_4.gotoAndStop(1);
			
			(_createRoleMC["sex_"+sex] as MovieClip).gotoAndStop(3);
			(_createRoleMC["career_"+career] as MovieClip).gotoAndStop(2);
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