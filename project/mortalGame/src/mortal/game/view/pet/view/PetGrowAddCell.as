/**
 * @heartspeak
 * 2014-3-3 
 */   	

package mortal.game.view.pet.view
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	
	public class PetGrowAddCell extends GSprite
	{
		private var _isSelected:Boolean = false;
		private var _isResCompl:Boolean = false;
		private var _level:int = 1;
		
		private var _selectedBg:ScaleBitmap;
		private var _bg:GBitmap;
//		private var _targetText:GTextFiled;
//		private var _gradeBitmap:GBitmap;
//		private var _perText:GTextFiled;
		
		public function PetGrowAddCell()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_selectedBg = UIFactory.bg(-3,-3,111,50,this,"selectFilter");
			_selectedBg.visible = false;
			_bg = UIFactory.gBitmap("",0,0,this);
//			_gradeBitmap = UIFactory.gBitmap("",30,3,this);
//			_targetText = UIFactory.gTextField("目标",18,1,85,24,this,GlobalStyle.textFormatBai);
//			pushUIToDisposeVec(UIFactory.gTextField("属性加成",15,21,55,20,this,GlobalStyle.textFormatBai));
//			_perText = UIFactory.gTextField("",65,21,40,20,this,GlobalStyle.textFormatLv);
			
			LoaderHelp.addResCallBack(ResFileConst.petGrowPanel,onResCompl);
		}
		
		/**
		 * 资源加载完成 
		 * 
		 */
		protected function onResCompl():void
		{
			_isResCompl = true;
			if(!isDisposed)
			{
				updateView();
			}
		}
		
		override protected function updateView():void
		{
			_selectedBg.visible = _isSelected;
//			_bg.bitmapData = _isSelected?GlobalClass.getBitmapData(ImagesConst.petGrowGradeBgCurrent):GlobalClass.getBitmapData(ImagesConst.petGrowGradeBgNormal);
			switch(_level)
			{
				case 1:
//					_targetText.htmlText = "<font color='#42e554' size='13'>目标</font>[16-23]";
					_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGradeBgGreen);
//					_gradeBitmap.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGrade1);
//					_perText.text = "20%";
					break;
				case 2:
//					_targetText.htmlText = "<font color='#114ef7' size='13'>目标</font>[24-31]";
					_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGradeBgBlue);
//					_gradeBitmap.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGrade2);
//					_perText.text = "40%";
					break;
				case 3:
//					_targetText.htmlText = "<font color='#f72ef0' size='13'>目标</font>[32-39]";
					_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGradeBgPurple);
//					_gradeBitmap.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGrade3);
//					_perText.text = "60%";
					break;
				case 4:
//					_targetText.htmlText = "<font color='#FF5a00' size='13'>目标</font>[40]";
					_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGradeBgOrange);
//					_gradeBitmap.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowGrade4);
//					_perText.text = "80%";
					break;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_selectedBg.dispose(isReuse);
			_bg.dispose();
//			_gradeBitmap.dispose();
//			_targetText.dispose();
//			_perText.dispose();
			
			_selectedBg = null;
			_bg = null;
//			_gradeBitmap = null;
//			_targetText = null;
//			_perText = null;
			
			_isSelected = false;
			_isResCompl = false;
		}
		
		/**
		 * 更新成长等级 
		 * @param value
		 * 
		 */		
		public function updateGrowGrade(value:int):void
		{
			_level = value;
			if(_isResCompl)
			{
				updateView();
			}
		}
		
		public function set selected(value:Boolean):void
		{
			_isSelected = value;
			if(_isResCompl)
			{
				updateView();
			}
		}
	}
}