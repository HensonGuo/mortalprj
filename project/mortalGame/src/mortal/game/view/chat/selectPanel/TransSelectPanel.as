/**
 * @date 2011-4-14 下午03:03:48
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.selectPanel
{
	import com.mui.controls.GButton;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.view.common.UIFactory;

	public class TransSelectPanel extends CallSprite
	{
//		
//		private var _dataArray:Array = new Array["50%透明","完全透明","隐藏面板"];
		
		public static function get partTrans():String
		{
			return "50%透明";
		}
		
		public static function get littleTrans():String
		{
			return "75%透明";
		}
		
		public static function get allTrans():String
		{
			return "完全透明";
		}
		
		public static function get hidePanel():String
		{
			return "隐藏面板";
		}
		
		public static function get showPanel():String
		{
			return "显示面板";
		}
//		public static const partTrans:String = "50%透明";
//		public static const littleTrans:String = "75%透明";
//		public static const allTrans:String = "完全透明";
//		public static const hidePanel:String = "隐藏面板";
//		public static const showPanel:String = "显示面板";
		
		private var _btnPartTrans:GButton;
		private var _btnlittleTrans:GButton;
		private var _btnAllTrans:GButton;
		private var _btnHide:GButton;
		private var _btnShow:GButton;
		public function TransSelectPanel()
		{
			super();
			initChildren();
		}
		
		private function initChildren():void
		{
			//背景
			var	scaleBg:ScaleBitmap = ResourceConst.getScaleBitmap("ToolTipBg");
			scaleBg.width = 82;
			scaleBg.height = 4*25 + 12;
			this.addChild(scaleBg);
			
			//按钮	
			_btnlittleTrans = createButton(0,littleTrans);
			_btnPartTrans = createButton(1,partTrans);
			_btnAllTrans = createButton(2,allTrans);
			_btnHide = createButton(3,hidePanel);
			_btnShow = createButton(3,showPanel);
			_btnShow.visible = false;
		}
		
		private function createButton(i:int,text:String):GButton
		{
			var button:GButton = UIFactory.gButton(text,6,5 + i*25,70,24,this,"ChatTabBtn");
			button.addEventListener(MouseEvent.CLICK,clickHandler);
			return button;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var button:GButton = (e.currentTarget as GButton);
			if(button == _btnHide)
			{
				_btnHide.visible = false;
				_btnShow.visible = true;
			}
			if(button == _btnShow)
			{
				_btnHide.visible = true;
				_btnShow.visible = false;
			}
			this.callAll(button.label);
		}
	}
}