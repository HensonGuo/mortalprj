package mortal.game.view.shopMall.view
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.pack.CanDropTabBar;
	
	public class AddvertismentPanel extends GSprite
	{
		private var _tabarVec:Vector.<GLoadedButton>;
		
		private var _bmVec:Vector.<GBitmap>;
		
		private var _btnSprite:GSprite;
		
		private var _totalNum:int;
		
		public function AddvertismentPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tabarVec = new Vector.<GLoadedButton>();
			_bmVec = new Vector.<GBitmap>();
			
			_btnSprite = UICompomentPool.getUICompoment(GSprite);
			this.addChild(_btnSprite);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_btnSprite.dispose(isReuse);
			_btnSprite = null;
		}
		
		public function setTabStyle(style:String):void
		{
			
		}
		
		public function setImageList(arr:Array):void
		{
			_totalNum = arr.length;
			
			for each(var i:String in arr)
			{
				var bm:GBitmap = UIFactory.gBitmap(i,0,0,null);
				_bmVec.push(bm);
			}
			
			for(var n:int; n < _totalNum ; n ++)
			{
				var btn:GLoadedButton = UIFactory.gLoadedButton(ImagesConst.brownBtn_upSkin,n*25,0,20,20,_btnSprite);
			}
			
			reSetPos();
		}
		
		private function reSetPos():void
		{
			
		}
		
		
	}
}