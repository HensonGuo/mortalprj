/**
 * @date 2011-4-11 下午04:40:39
 * @author  wyang
 * 
 */  

package mortal.game.view.common.pageSelect
{
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.TextBox;
	import mortal.game.view.common.guide.AutoGuideClickChildNames;
	
	public class PageSelecter extends GSprite
	{
		public static const SingleMode:String = "简单状态";
		public static const CompleteMode:String = "完整状态";
		public static const InputMode:String = "带输入框的状态";
		
		protected var _mode:String = SingleMode;
		
		protected var _firstPageBtn:GButton;
		protected var _prevPageBtn:GButton;
		protected var _pageText:TextBox;
		protected var _nextPageBtn:GButton;
		protected var _lastPageBtn:GButton;
		
		protected var _spInputContainer:Sprite;
		protected var _tf1:GTextFiled;
		protected var _tf2:GTextFiled;
		protected var _tiPage:GTextInput;
		protected var _btnJump:GButton;
		
		protected var _currentPage:int = 1;
		protected var _maxPage:int = 1;
		
		protected var _pageTextBoxSize:int = 40;
		public function PageSelecter()
		{
			super();
		}
		
		public function get maxPage():int
		{
			return _maxPage;
		}

		public function set maxPage(value:int):void
		{
			_maxPage = value;
			if(_maxPage <= 0)
			{
				_maxPage = 1;
			}
			
			if(_currentPage > _maxPage)
			{
				_currentPage = _maxPage;
			}
			if(_pageText)
			{
				updateText();
			}
		}

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			_currentPage = value > 0?value:1;
			_currentPage = value < maxPage?_currentPage:maxPage;
			if(_pageText)
			{
				updateText();
			}
		}
		
		public function updatePageTxt(value:int):void
		{
			gotoPage(value);
		}
		
		protected function updateText():void
		{
			_pageText.textField.text = _currentPage + "/" + _maxPage;
			_nextPageBtn.enabled = currentPage < maxPage;
			_prevPageBtn.enabled = currentPage > 1;
			_firstPageBtn.enabled = currentPage > 1;
			_lastPageBtn.enabled = currentPage < maxPage;
		}
		
		override protected function createDisposedChildrenImpl():void
		{	
			super.createDisposedChildrenImpl();
			_firstPageBtn = UIFactory.gButton("",0,0,17,17,this,"FirstPageButton");
			_firstPageBtn.configEventListener(MouseEvent.CLICK, firstPage);

			_prevPageBtn = UIFactory.gButton("",0,0,17,17,this,"PrevPageButton");
			_prevPageBtn.configEventListener(MouseEvent.CLICK, prevPage);
			
			_pageText = UICompomentPool.getUICompoment(TextBox) as TextBox;
			_pageText.createDisposedChildren();
			_pageText.bgWidth = _pageTextBoxSize;
			_pageText.bgHeight = 20;
			_pageText.htmlText = "";
			var textformat:TextFormat = GlobalStyle.textFormatBai;
			textformat.align = TextFormatAlign.CENTER;
			_pageText.textField.defaultTextFormat = textformat;
			this.addChild(_pageText);
			
			_nextPageBtn = UIFactory.gButton("",0,0,17,17,this,"NextPageButton");
			_nextPageBtn.configEventListener(MouseEvent.CLICK, nextPage);
			_nextPageBtn.name = AutoGuideClickChildNames.PageSelector_BtnNextName;
			
			_lastPageBtn = UIFactory.gButton("",0,0,17,17,this,"LastPageButton");
			_lastPageBtn.configEventListener(MouseEvent.CLICK, lastPage);
			
			_spInputContainer = UICompomentPool.getUICompoment(Sprite) as Sprite;
			_tf1 = UIFactory.gTextField(Language.getString(41614),0,2,30,20,_spInputContainer,GlobalStyle.textFormatAnjin);
			_tiPage = UIFactory.gTextInput(30,1,75,20,_spInputContainer);
			_tiPage.restrict = "0-9";
			_tf2 = UIFactory.gTextField(Language.getString(41615),107,2,18,20,_spInputContainer,GlobalStyle.textFormatAnjin);
			_btnJump = UIFactory.gButton(Language.getString(41616),125,-1,59,22,_spInputContainer);
			
			_tiPage.configEventListener(Event.CHANGE,tiChangeHandler);
			_btnJump.configEventListener(MouseEvent.CLICK,onJump);
			
			drawNow();
			updateText();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_firstPageBtn.dispose();
			_prevPageBtn.dispose();
			_pageText.dispose();
			_nextPageBtn.dispose();
			_lastPageBtn.dispose();
			_tiPage.dispose();
			_btnJump.dispose();
			_tf1.dispose();
			_tf2.dispose();
			UIFactory.disposeSprite(_spInputContainer);
			
			_firstPageBtn = null;
			_prevPageBtn = null;
			_pageText = null;
			_nextPageBtn = null;
			_lastPageBtn = null;
			_tiPage = null;
			_btnJump = null;
			_tf1 = null;
			_tf2 = null;
			_spInputContainer = null;
			
			super.disposeImpl(isReuse);
		}
		
		protected function drawNow():void
		{
			removeAll();
			var objAry:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			if(_mode == CompleteMode || _mode == InputMode)
			{
				objAry.push(_firstPageBtn);
				objAry.push(_prevPageBtn);
				objAry.push(_pageText);
				objAry.push(_nextPageBtn);
				objAry.push(_lastPageBtn);
				
				if(_mode == InputMode)
				{
					objAry.push(_spInputContainer);
				}
			}
			else
			{
				objAry.push(_prevPageBtn);
				objAry.push(_pageText);
				objAry.push(_nextPageBtn);
			}
			var objX:int = 0;
			for(var i:int = 0;i<objAry.length;i++)
			{
				objAry[i].x = objX;
				objAry[i].y = objAry[i] is TextBox?-2:0;
				objX += objAry[i].width + 1;
				if(objAry[i] is GButton)
				{
					(objAry[i] as GButton).drawNow();
				}
				this.addChild(objAry[i]);
			}
		}
		
		protected function removeAll():void
		{
			var len:int = this.numChildren;
			for(var i:int = len - 1;i>=0;i--)
			{
				this.removeChildAt(i);
			}
		}
		
		protected function prevPage(e:MouseEvent):void
		{
			gotoPage(_currentPage - 1);
		}
		
		protected function nextPage(e:MouseEvent):void
		{
			gotoPage(_currentPage + 1);
		}

		protected function firstPage(e:MouseEvent):void
		{
			gotoPage(1);
		}
		
		protected function lastPage(e:MouseEvent):void
		{
			gotoPage(_maxPage);
		}
		
		protected function tiChangeHandler(e:Event):void
		{
			var iPage:int = int(_tiPage.text);
			iPage = iPage > maxPage?maxPage:iPage;
			iPage = iPage < 1?1:iPage;
			_tiPage.text = iPage.toString();
		}
		
		protected function onJump(e:MouseEvent):void
		{
			gotoPage(int(_tiPage.text));
		}
		
		protected function gotoPage(iPage:int):void
		{
			iPage = iPage<1?1:iPage;
			iPage = iPage>_maxPage?_maxPage:iPage;
			if(_currentPage != iPage)
			{
				_currentPage = iPage;
				this.dispatchEvent(new Event(Event.CHANGE,true));
				updateText();
			}
		}
		
		public function get mode():String
		{
			return _mode;
		}

		public function set mode(value:String):void
		{
			_mode = value;
			drawNow();
		}

		public function get pageTextBoxSize():int
		{
			return _pageTextBoxSize;
		}

		public function set pageTextBoxSize(value:int):void
		{
			_pageTextBoxSize = value;
			_pageText.bgWidth = _pageTextBoxSize;
			this.drawNow();
		}
		
		public function setbgStlye(url:String,formate:GTextFormat):void
		{
			_pageText.setbgStlye(url,formate);
		}

	}
}