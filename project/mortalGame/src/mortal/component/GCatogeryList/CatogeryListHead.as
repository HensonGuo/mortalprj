/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.component.GCatogeryList
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class CatogeryListHead extends CatogeryListHeadBase
	{
		private var _btnBg:GLoadingButton;
		private var _bmpAdd:GBitmap;
		private var _bmpMinus:GBitmap;
		private var _txtExpandTitle:GTextFiled;
		private var _txtUnExpandTitle:GTextFiled;
		private var _titleText:String;
		
		public function CatogeryListHead()
		{
		}
		
		public override function expand():void
		{
			_btnBg.enabled = false;
			_btnBg.mouseEnabled = true;
			super.isExpanding = true;
//			_btnBg.selected = true;
			_bmpAdd.visible = false;
			_bmpMinus.visible = true;
			
			this.mouseEnabled = true;
//			this.buttonMode = true;
			this.mouseChildren = true;
			
			_txtExpandTitle.visible = true;
			_txtUnExpandTitle.visible = false;
		}
		
		public override function updateData(obj:Object):void
		{
			_titleText = String(obj);
			_txtExpandTitle.text = _titleText;
			_txtUnExpandTitle.text = _titleText;
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
			_bmpAdd.visible = true;
			_bmpMinus.visible = false;
		
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
			
			_btnBg = UIFactory.gLoadingButton("TaskCatogeryBtn", 0, 0, 128, 23, this);
			
			_bmpMinus = UIFactory.gBitmap(ImagesConst.Plus, 12, 4, this);
			_bmpMinus.x = 7;
			_bmpMinus.y = 9;
			this.addChild(_bmpMinus);
			
			_bmpAdd = UIFactory.gBitmap(ImagesConst.Add, 12, 12, this);
			_bmpAdd.x = 6;
			_bmpAdd.y = 6;
			this.addChild(_bmpAdd);
			
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
			
//			updateTxtsPlace();
		}
		
//		private function updateTxtsPlace():void
//		{
//			_txtExpandTitle.y = (_btnBg.height - _txtExpandTitle.height)/2;
//			_txtUnExpandTitle.y = (_btnBg.height - _txtUnExpandTitle.height)/2;
//		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_btnBg.dispose(isReuse);
			_btnBg = null;
			_bmpMinus.dispose(isReuse);
			_bmpMinus = null;
			_bmpAdd.dispose(isReuse);
			_bmpAdd = null;
			_txtExpandTitle.dispose(isReuse);
			_txtExpandTitle = null;
			_txtUnExpandTitle.dispose(isReuse);
			_txtUnExpandTitle = null;
		}
	}
}