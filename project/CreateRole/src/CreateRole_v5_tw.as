package
{
	import core.BaseError;
	import core.BaseMovieClip;
	import core.Effect;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import utils.RandomName_tw;
	
	[SWF(width=1000,height=580,frameRate=24,backgroundColor=0)]
	public class CreateRole_v5_tw extends BaseMovieClip
	{
		public function CreateRole_v5_tw()
		{
			super();
		}
		
		/**
		 * 添加到舞台 
		 * @param event
		 * 
		 */
		override protected function onAddToStage(event:Event):void
		{
			_createRoleMC = new CreateRoleMC_v5_tw();
			addChild(_createRoleMC);
			
			_createRoleMC.role_1_0.buttonMode = true;
			_createRoleMC.role_1_1.buttonMode = true;
			_createRoleMC.role_2_0.buttonMode = true;
			_createRoleMC.role_2_1.buttonMode = true;
			_createRoleMC.role_3_0.buttonMode = true;
			_createRoleMC.role_3_1.buttonMode = true;
			
			super.onAddToStage(event);
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
				case _createRoleMC.role_1_0:
					changeSelect(1,0);
					break;
				case _createRoleMC.role_1_1:
					changeSelect(1,1);
					break;
				case _createRoleMC.role_2_0:
					changeSelect(2,0);
					break;
				case _createRoleMC.role_2_1:
					changeSelect(2,1);
					break;
				case _createRoleMC.role_3_0:
					changeSelect(3,0);
					break;
				case _createRoleMC.role_3_1:
					changeSelect(3,1);
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
				case _createRoleMC.role_1_0:
					mouseOver(1,0,target);
					break;
				case _createRoleMC.role_1_1:
					mouseOver(1,1,target);
					break;
				case _createRoleMC.role_2_0:
					mouseOver(2,0,target);
					break;
				case _createRoleMC.role_2_1:
					mouseOver(2,1,target);
					break;
				case _createRoleMC.role_3_0:
					mouseOver(3,0,target);
					break;
				case _createRoleMC.role_3_1:
					mouseOver(3,1,target);
					break;
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
				case _createRoleMC.role_1_0:
					mouseOver(1,0,target,false);
					break;
				case _createRoleMC.role_1_1:
					mouseOver(1,1,target,false);
					break;
				case _createRoleMC.role_2_0:
					mouseOver(2,0,target,false);
					break;
				case _createRoleMC.role_2_1:
					mouseOver(2,1,target,false);
					break;
				case _createRoleMC.role_3_0:
					mouseOver(3,0,target,false);
					break;
				case _createRoleMC.role_3_1:
					mouseOver(3,1,target,false);
					break;
			}
		}
		
		/**
		 * 鼠标mc的处理 
		 * @param camp
		 * @param sex
		 * @param target
		 * @param over
		 * 
		 */
		private function mouseOver(camp:int,sex:int,target:DisplayObject,over:Boolean=true):void
		{
			if(_sex != sex || _camp != camp)
			{
				if(over)
				{
					(target as MovieClip).gotoAndStop(1);
					target.filters = [Effect.overFilter];
				}
				else
				{
					(target as MovieClip).gotoAndStop(2);
					target.filters = null;
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
			
			_createRoleMC.role_1_0.gotoAndStop(2);
			_createRoleMC.role_1_1.gotoAndStop(2);
			_createRoleMC.role_2_0.gotoAndStop(2);
			_createRoleMC.role_2_1.gotoAndStop(2);
			_createRoleMC.role_3_0.gotoAndStop(2);
			_createRoleMC.role_3_1.gotoAndStop(2);
			
			_createRoleMC.role_1_0.filters = null;
			_createRoleMC.role_1_1.filters = null;
			_createRoleMC.role_2_0.filters = null;
			_createRoleMC.role_2_1.filters = null;
			_createRoleMC.role_3_0.filters = null;
			_createRoleMC.role_3_1.filters = null;
			
			(_createRoleMC["role_"+camp+"_"+sex] as MovieClip).gotoAndStop(1);
			(_createRoleMC["role_"+camp+"_"+sex] as MovieClip).filters = [Effect.overFilter];
		}
		
		override protected function loadRandomNameFromPhp():void
		{
			_createRoleMC.nameTxt.text = RandomName_tw.getName( _sex );
			checkTipPanel();
		}
		
		override protected function getErrorStr(errorCode:int):String
		{
			return BaseError.getErrorStr_tw(errorCode);
		}
	}
}