package mortal.game.view.mainUI.roleAvatar
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class FightModeCellRenderer extends GCellRenderer
	{
		private var _icon:GBitmap;
		
		private var _fightModeDec:GTextFiled;
		
		private var _fightMode:int;
		
		public function FightModeCellRenderer()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			var selectSkin:ScaleBitmap = UIFactory.bg(0,0,140,138,null,ImagesConst.Menu_overSkin);
			this.setStyle("downSkin",emptyBmp);
			this.setStyle("overSkin",selectSkin);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override protected function configUI():void
		{
			_icon = UIFactory.gBitmap("",5,2,this);
			
			_fightModeDec = UIFactory.gTextField("",30,4,250,20,this);
			
			this.addEventListener(MouseEvent.CLICK,setMode);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
		}
		
		override public function set data(arg0:Object):void
		{
			_fightMode = arg0.data;
			
			_icon.bitmapData = GlobalClass.getBitmapData("FightMode" + (_fightMode + 1) + "_upSkin");
			
			_fightModeDec.htmlText = Language.getString(30150 + _fightMode);
		}
		
		private function setMode(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.FightSetMode,_fightMode));
		}
	}
}