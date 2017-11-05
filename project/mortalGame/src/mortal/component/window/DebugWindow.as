/**
 * @date	2011-2-23 下午01:54:56
 * @author  jianglang
 * 
 */	

package mortal.component.window
{
	import com.gengine.debug.ILog;
	import com.mui.controls.GButton;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextArea;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import mortal.component.gconst.StyleConst;
	import mortal.game.view.common.UIFactory;

	public class DebugWindow extends BaseWindow implements ILog
	{
		private var _tabBar:GTabBar;
		
		private var _textAreaPrint:GTextArea;
		
		private var _textAreaPool:GTextArea;
		
		private var _textAreaError:GTextArea;
		
		private var _clearBtn:GButton;
		
		private var _clearPool:GButton;
		
		private var _copyBtn:GButton;
		
		private static var _instance:DebugWindow;
		
		public function DebugWindow()
		{
			super();
			if( _instance )
			{
				throw new Error("DebugWindow 单例");
			}
			titleHeight = 55;
			this.setSize(400,500);
			title = "提示";
		}
		
		public static function get instance():DebugWindow
		{
			if( _instance == null)
			{
				_instance = new DebugWindow();
			}
			return _instance;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
//			addWindowCenter2();
			
			_tabBar = UIFactory.gTabBar(20,32,[{label:"调试信息",name:"print"},{label:"对象池信息",name:"pool"},{label:"错误信息",name:"error"}],70,22,this,onTabBarChange);
			
			UIFactory.bg(16,64,369,397,this);
			
			_textAreaPrint = UIFactory.textArea("",20,68,353,380,this);
			
			_textAreaPool = UIFactory.textArea("",20,68,353,380,this);
			
			_textAreaError = UIFactory.textArea("",20,68,353,380,this);
			
			_clearBtn = UIFactory.gButton("清除内容",287,463,70,22,this);
			_clearBtn.addEventListener(MouseEvent.CLICK,onClickHandler);

			_clearPool = UIFactory.gButton("清理池子",287,463,70,22,this);
			_clearPool.visible = false;
			_clearPool.addEventListener(MouseEvent.CLICK,onClearPoolHandler);
			
			_copyBtn = UIFactory.gButton("复制错误",287,463,70,22,this);
			_copyBtn.visible = false;
			_copyBtn.addEventListener(MouseEvent.CLICK,onCopyErrorHandler);
			
			this.addChild(_clearBtn);
			this.addEventListener(WindowEvent.SHOW,onShow);
		}
		
		private function onShow(e:WindowEvent):void
		{
			updatePrintMsg();
			updateErrorMsg();
		}
		
		private function onTabBarChange(e:MuiEvent):void
		{
			changToTabBar(e.selectedIndex);
		}
		
		private function changToTabBar(index:int):void
		{
			if(index >=0 && index < _tabBar.dataProvider.length)
			{
				hideAllPanel();
				_tabBar.selectedIndex = index;
				if(index == 0)
				{
					_textAreaPrint.visible = true;
					_clearBtn.visible = true;
				}
				if(index == 1)
				{
					_textAreaPool.visible = true;
					_clearPool.visible = true;
				}
				if(index == 2)
				{
					_textAreaError.visible = true;
					_copyBtn.visible = true;
				}
			}
		}
		
		private function hideAllPanel():void
		{
			_textAreaPrint.visible = false;
			_textAreaPool.visible = false;
			_textAreaError.visible = false;
			
			_clearBtn.visible = false;
			_clearPool.visible = false;
			_copyBtn.visible = false;
		}
		
		private function onClickHandler( event:MouseEvent ):void
		{
			_textAreaPrint.text = "";
			_textStr = "";
		}
		
		/**
		 * 复制最近一条错误记录 
		 * @param e
		 * 
		 */		
		private function onCopyErrorHandler(e:MouseEvent):void
		{
			if(_laseErrorStr)
			{
				System.setClipboard(_laseErrorStr);
			}
		}
		
		private function onClearPoolHandler(e:MouseEvent):void
		{
			UICompomentPool.clearPool();
		}
		
		private var _textStr:String = "";
		public function print( ...rest ):void
		{
			_textStr += rest.toString()+"\n";
			if( _textStr.length > 1000 )
			{
				_textStr = _textStr.substr(_textStr.length - 1000);
			}
			if(!this.isHide)
			{
				updatePrintMsg();
			}
		}
		
		private function updatePrintMsg():void
		{
			_textAreaPrint.text = _textStr;
			var isAtMaxVPos:Boolean = _textAreaPrint.verticalScrollPosition == _textAreaPrint.maxVerticalScrollPosition;
			if(isAtMaxVPos)
			{
				_textAreaPrint.verticalScrollPosition = _textAreaPrint.maxVerticalScrollPosition;
			}
		}
		
		private var _errorStr:String = "";
		private var _laseErrorStr:String;
		public function error(...rest):void
		{
			changToTabBar(2);
			var errorStr:String = rest.toString();
			if(errorStr == _laseErrorStr)
			{
				//同样的错误信息忽略
				return;
			}
			_laseErrorStr = errorStr;
			_errorStr += errorStr + "\n\n\n";
			if( _errorStr.length > 55000 )
			{
				_errorStr = _errorStr.substr(3000);
			}
			if(!this.isHide)
			{
				updateErrorMsg();
			}
		}
		
		private function updateErrorMsg():void
		{
			var isAtMaxVPos:Boolean = _textAreaError.verticalScrollPosition == _textAreaError.maxVerticalScrollPosition;
			_textAreaError.text = _errorStr;
			if(isAtMaxVPos)
			{
				_textAreaError.verticalScrollPosition = _textAreaError.maxVerticalScrollPosition;
			}
		}
	}
}
