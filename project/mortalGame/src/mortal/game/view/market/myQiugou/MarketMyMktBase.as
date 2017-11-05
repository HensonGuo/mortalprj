package mortal.game.view.market.myQiugou
{
	import Message.Game.SSeqMarketItem;
	
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import fl.data.DataProvider;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.SmallWindow;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.market.sale.MktMoneys;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 我的寄售，我的求购基类
	 * @author lizhaoning
	 */
	public class MarketMyMktBase extends SmallWindow 
	{
		protected var _bgTitle1:ScaleBitmap;
		protected var _title1:GTextFiled;
		protected var _title2:GTextFiled;
		protected var _title3:GTextFiled;
		protected var _list:GTileList;
		protected var _pageSelect:PageSelecter;
		
		protected var _moneys:MktMoneys;
		
		public function MarketMyMktBase($layer:ILayer=null)
		{
			super($layer);
			setSize(368,420);
			_titleHeight = 29;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			var _tfAnjin:GTextFormat = GlobalStyle.textFormatAnjin;
			_bgTitle1 = UIFactory.bg(13,34,350,25,this,"RegionTitleBg");
			_title1 = UIFactory.textField("",40,0,90,20,this,_tfAnjin);  //我寄售的物品
			_title1.y = _bgTitle1.y+(_bgTitle1.height-_title1.height)/2;
			_title2 = UIFactory.textField("总价",190,0,50,20,this,_tfAnjin);
			_title2.y = _bgTitle1.y+(_bgTitle1.height-_title2.height)/2;
			_title3 = UIFactory.textField("操作",304,0,50,20,this,_tfAnjin);
			_title3.y = _bgTitle1.y+(_bgTitle1.height-_title3.height)/2;
			
			//背包格子部分
			_list = UIFactory.tileList(25,65,342,258,this);
			_list.rowHeight = 50;
			_list.columnWidth = 342;
			_list.horizontalGap = 0;
			_list.verticalGap = 0;
			_list.setStyle("cellRenderer", MktMyCellRenderner);
			_list.rowCount = 5;
			
			_pageSelect = UIFactory.pageSelecter(0,337,this,PageSelecter.CompleteMode);	
			_pageSelect.x = 140;
			_pageSelect.setbgStlye(ImagesConst.ComboBg,new GTextFormat);
			_pageSelect.maxPage = 1;
			_pageSelect.pageTextBoxSize = 36;
			
			_moneys = UICompomentPool.getUICompoment(MktMoneys);
			_moneys.createDisposedChildren();
			_moneys.x = 71; 
			_moneys.y = 366;
			addChild(_moneys);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_bgTitle1.dispose(isReuse);
			_title1.dispose(isReuse);
			_title2.dispose(isReuse);
			_title3.dispose(isReuse);
			_list.dispose(isReuse);
			_pageSelect.dispose(isReuse);
			_moneys.dispose(isReuse);
			
			
			_bgTitle1 = null;
			_title1 = null;
			_title2 = null;
			_title3 = null;
			_list = null;
			_pageSelect = null;
			_moneys = null;
		}
		
		protected function resetUI():void
		{
			
		}
		
		
		protected function getDataProvider(arr:Array):DataProvider
		{
			var dp:DataProvider = new DataProvider();
			
			if(arr == null)
			{
				return dp;
			}
			
			var count:int = _list.rowCount * _list.columnCount;
			var startIndex:int = (_pageSelect.currentPage-1) * count;
			var endIndex:int = Math.min(startIndex + count,arr.length);
			
			for (var j:int = startIndex; j < endIndex; j++)
			{
				dp.addItem(arr[j]);
			}
			
			this._pageSelect.currentPage = Math.ceil((startIndex+1)/count);
			this._pageSelect.maxPage = Math.ceil(arr.length/count);
			
			return dp;
		}
		
		public function updatePanel(obj:SSeqMarketItem):void
		{
			this._list.dataProvider = this.getDataProvider(obj.marketItems);
			this._list.drawNow();
		}
		
		override protected function configParams():void
		{
			// TODO Auto Generated method stub
			super.configParams();
			
			paddingBottom = 65;
		}
		
		
	}
}