package mortal.game.view.market.alert
{
	import Message.Game.EMarketRecordType;
	import Message.Game.SMarketItem;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import flash.events.Event;
	
	import mortal.game.resource.GameDefConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.alertwins.CheckBoxWin;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MktTodayNoTipAlert extends CheckBoxWin
	{
		private var _moneyIcon:GBitmap;
		private var _txt:GTextFiled;
		
		public var data:Object;
		public function MktTodayNoTipAlert(stageWidth:Number, stageHeight:Number)
		{
			super(stageWidth, stageHeight);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.dispose();
		}
		
		private function dispose():void
		{
			// TODO Auto Generated method stub
			data = null;
			
			_moneyIcon.dispose(true);
			_txt.dispose(true);
			_moneyIcon = null;
			_txt = null;
		}
		
		override protected function childrenCreated():void
		{
			// TODO Auto Generated method stub
			super.childrenCreated();
			
			_moneyIcon = UIFactory.gBitmap("",135,185,prompt);
			_txt = UIFactory.textField("",150,181,40,20,prompt);
			
			updateViewByData();
		}
		
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
		}
		
		
		
		private function updateViewByData():void
		{
			data = Alert.extendObj;
			
			_moneyIcon.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getMoneyIcon(data.unit));
			_txt.text = data.str;
		}
		
	}
}
