/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.view.task.view.track
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GLoadedButton;
	
	import extend.language.Language;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class BtnShowTaskDetial extends Sprite
	{
		private var _openBtn:GLoadedButton;
		private var _closeBtn:GLoadedButton;
		private var _status:int;//当前状态 1=关闭 -1=开启
		
		public function BtnShowTaskDetial()
		{
			super();
			
			buttonMode = true;
			
			_openBtn = UIFactory.gLoadedButton(ImagesConst.SubBtn_upSkin, 0, 0, 22, 22, this);
			_openBtn.toolTipData = HTMLUtil.addColor(Language.getString(20138),"#ffffff");//隐藏任务详情

			_closeBtn = UIFactory.gLoadedButton(ImagesConst.AddBtn_upSkin, 0, 0, 24, 22, this);
			_closeBtn.toolTipData = HTMLUtil.addColor(Language.getString(20139),"#ffffff");//显示任务详情
			
			
			open();
			
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		/**
		 * 开启 
		 * 
		 */
		private function open():void
		{
			if(_closeBtn.parent)
			{
				removeChild(_closeBtn);
			}
			if(!_openBtn.parent)
			{
				addChild(_openBtn);
			}
			_status = -1;
		}
		
		/**
		 * 关闭 
		 * 
		 */
		private function close():void
		{
			if(_openBtn.parent)
			{
				removeChild(_openBtn);
			}
			if(!_closeBtn.parent)
			{
				addChild(_closeBtn);
			}
			_status = 1;
		}
		
		/**
		 * 鼠标点击
		 * @param event
		 * 
		 */
		private function onMouseClick(event:MouseEvent):void
		{
			if(_status == 1)
			{
				open();
			}
			else
			{
				close();
			}
		}
		
		public function get isClose():Boolean
		{
			return _status == 1;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_closeBtn.width = value;
			_openBtn.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_closeBtn.height = value;
			_openBtn.height = value;
		}
	}
}