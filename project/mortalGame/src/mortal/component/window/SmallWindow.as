/**
 * @heartspeak
 * 2014-1-21 
 */   	

package mortal.component.window
{
	import flash.events.MouseEvent;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.interfaces.ILayer;
	
	public class SmallWindow extends BaseWindow
	{
		public function SmallWindow($layer:ILayer=null)
		{
			super($layer);
			_titleHeight = 29;
		}
		
		override protected function configParams():void
		{
			paddingBottom = 45;
			paddingLeft = 7;
			blurTop = 4;
			blurBottom = 4;
			blurLeft = 6;
			blurRight = 5;
			_contentX = blurLeft;
			_contentY = blurTop;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			addWindowCenter2();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			paddingBottom = 45;
			paddingLeft = 7;
			blurTop = 4;
			blurBottom = 4;
			blurLeft = 6;
			blurRight = 5;
			_contentX = blurLeft;
			_contentY = blurTop;
		}
		
		override protected function setWindowCenter():void
		{
			
		}
		
		override protected function addWindowCenter2():void
		{
			_windowCenter2 = UIFactory.bg(0,0,-1,-1,this,ImagesConst.WindowCenterB2);
			this.addChild(_windowCenter2);
		}
		
		override protected function updateWindowCenterSize(  ):void
		{
			var w:Number = this.width - paddingLeft - paddingRight - blurLeft - blurRight;
			var h:Number = this.height - _titleHeight - paddingBottom - blurTop - blurBottom;
			if( _windowCenter )
			{
				_windowCenter.setSize(w,h);
				_windowCenter.x = paddingLeft + blurLeft;
				_windowCenter.y = _titleHeight + blurTop;
			}	
			
			if (_windowCenter2)
			{
				_windowCenter2.x = paddingLeft + blurLeft;
				_windowCenter2.y = _titleHeight + blurTop;
				_windowCenter2.width = w;
				_windowCenter2.height = h + 40;
			}
		}
		
		override protected function addCloseButton():void
		{
			_closeBtn = UIFactory.gLoadedButton("CloseButtonSmall",0,0,22,22,null);
			_closeBtn.focusEnabled = true;
			_closeBtn.name = "Window_Btn_Close";
			_closeBtn.configEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			$addChild(_closeBtn);
		}
		
		override protected function updateBtnSize():void
		{
			if( _closeBtn )
			{
				_closeBtn.x = this.width - _closeBtn.width - 7;
				_closeBtn.y = 10;
			}
		}
		
		override protected function updateDisplayList():void
		{
			if(_titleChange)
			{
				_titleChange = false;
				if( _title )
				{
					_title.y = 5;
					_title.x = (this.width - _title.width)/2;
				}
			}
		}
		
		override protected function addWindowLine():void
		{
			
		}
		
		override protected function setWindowBgName():void
		{
			_windowBgName = ImagesConst.WindowBgSmall;
		}
	}
}