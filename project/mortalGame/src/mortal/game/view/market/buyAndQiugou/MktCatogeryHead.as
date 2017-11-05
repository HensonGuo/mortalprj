package mortal.game.view.market.buyAndQiugou
{
	import Message.DB.Tables.TMarket;
	
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GTextFiled;
	
	import fl.data.DataProvider;
	
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.GCatogeryList.CatogeryListHeadBase;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MktCatogeryHead extends CatogeryListHeadBase
	{
		private var _btnBg:GLoadingButton;
		private var _txtExpandTitle:GTextFiled;
		private var _txtUnExpandTitle:GTextFiled;
		private var _titleText:String;
		
		public function MktCatogeryHead()
		{
		}
		
		public override function expand():void
		{
			_btnBg.enabled = false;
			_btnBg.mouseEnabled = true;
			super.isExpanding = true;
			//			_btnBg.selected = true;
			
			this.mouseEnabled = true;
			//			this.buttonMode = true;
			this.mouseChildren = true;
			
			_txtExpandTitle.visible = true;
			_txtUnExpandTitle.visible = false;
		}
		
		public override function updateData(obj:Object):void
		{
			_titleText = obj.label;
			/*_txtExpandTitle.text = obj.label;
			_txtUnExpandTitle.text = obj.label;*/
		}
		
		public override function setSize($width:Number, $height:Number):void
		{
			_txtExpandTitle.width = $width;
			_txtUnExpandTitle.width = $width;
			_btnBg.setSize($width, $height);
			
			//			updateTxtsPlace();
		}
		
		public override function unexpand():void
		{
			super.isExpanding = false;
			_btnBg.enabled = true;
			
			_txtExpandTitle.visible = false;
			_txtUnExpandTitle.visible = true;
		}
		
		public override function set dataProvider(value:DataProvider):void
		{
			super.dataProvider = value;
			_txtExpandTitle.text = _titleText;// + "(" + value.length.toString() + ")";
			_txtUnExpandTitle.text = _txtExpandTitle.text;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_btnBg = UIFactory.gLoadingButton(ResFileConst.MarketCatogeryBtn, 0, 0, 128, 23, this);
			
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 14;
			tf.color = 0xfeefec;
			_txtExpandTitle = UIFactory.gTextField("", 0, -2, 180, 22, this, tf);
			
			tf = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			_txtUnExpandTitle = UIFactory.gTextField("", 0, 1, 180, 22, this, tf);
			
			_txtExpandTitle.mouseEnabled = false;
			_txtUnExpandTitle.mouseEnabled = false;
			_txtExpandTitle.visible = false;
			
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_btnBg.dispose(isReuse);
			_btnBg = null;
			_txtExpandTitle.dispose(isReuse);
			_txtExpandTitle = null;
			_txtUnExpandTitle.dispose(isReuse);
			_txtUnExpandTitle = null;
		}
	}
}