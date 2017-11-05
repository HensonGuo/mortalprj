package mortal.game.view.common
{
	import com.gengine.global.Global;
	import com.mui.utils.UICompomentPool;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.LayerManager;
	import mortal.mvc.core.View;
	
	public class LeftTimeView extends View
	{
		private var _parse:String;
		private var _tfLeftTime:SecTimerView;
		
		public function LeftTimeView(parse:String = "mm:ss")
		{
			super();
			_parse = parse;
			this.layer = LayerManager.msgTipLayer;
			resetPosition();
			this.mouseEnabled = false;
			this.mouseChildren = false;
			init();
		}
		
		public function setParse(strParse:String = "mm:ss"):void
		{
			_parse = strParse;
			_tfLeftTime.setParse(_parse);
		}
		
		private function init():void
		{
			_tfLeftTime = UICompomentPool.getUICompoment(SecTimerView) as SecTimerView;
			_tfLeftTime.filters = [FilterConst.glowFilter];
			_tfLeftTime.mouseEnabled = false;
			var textFormat:TextFormat = new GTextFormat(FontUtil.songtiName,16,0xfcff00);
			textFormat.align = TextFormatAlign.RIGHT;
			textFormat.bold = true;
			_tfLeftTime.defaultTextFormat = textFormat;
			_tfLeftTime.filters = [FilterConst.glowFilter];
			_tfLeftTime.setParse(_parse);
			UIFactory.setObjAttri(_tfLeftTime,-300,0,300,22,this);
		}
		
		public function updateLeftTime(iCount:int):void
		{
			_tfLeftTime.setLeftTime(iCount);
		}
		
		public function get tfLeftTime():SecTimerView
		{
			return _tfLeftTime;
		}
		
		public function resetPosition():void
		{
			this.x = Global.stage.stageWidth - 380;
			this.y = 100;
		}
		
		public function clean():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			_tfLeftTime.dispose(false);
			_tfLeftTime = null;
		}
	}
}