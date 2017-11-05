package mortal.game.view.mail.view
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextArea;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.DisplayObjectContainer;
	
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MTextAreaBox extends GSprite
	{
		//显示对象
		private var _ta:GTextArea;
		private var _bg:ScaleBitmap;
		
		
		private var _text:String;
		/*private var __x:int;
		private var __y:int;
		private var __width:int;
		private var __height:int;
		private var _parent:DisplayObjectContainer;*/
		private var _styleName:String;
		private var _bgStyleName:String;
		
		public function MTextAreaBox()/*text:String = "",x:int = 0,y:int = 0,width:int = 300,height:int = 300,
									 parent:DisplayObjectContainer = null,
									 styleName:String = "GTextArea",
									 bgStyleName:String = "WindowCenterB")*/
		{
			super();
			/*this._text = text;
			this.__x = x;
			this.__y = y;
			this._width = width;
			this._height = height;
			this._parent = parent;
			this._styleName = styleName;
			this._bgStyleName = bgStyleName;*/
			
			this.isHideDispose  = true;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			/*_ta = UIFactory.textArea(_text,__x,__y,_width,_height,_parent,_styleName);
			
			_bg = UIFactory.bg(_ta.x,_ta.y,_ta.width,_ta.height,null,_bgStyleName);*/
			
			_ta = UIFactory.textArea("",0,0,300,300,this);
			
			_bg = UIFactory.bg(_ta.x,_ta.y,_ta.width,_ta.height,this,"InputBg");
			this.addChildAt(_bg,0);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_text = null;
			_styleName = null;
			_bgStyleName = null;
			
			if(_bg)
			{
				this._bg.dispose(isReuse);
				
			}
			if(_ta)
			{
				this._ta.dispose(isReuse);
				_ta = null;
			}
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.dispose(isReuse);
			
			if(_bg)
			{
				this._bg.dispose(isReuse);
				
			}
			if(_ta)
			{
				this._ta.dispose(isReuse);
				_ta = null;
			}
		}
		
		public function get bg():ScaleBitmap
		{
			return _bg;
		}
		
		public function get ta():GTextArea
		{
			return _ta;
		}
	}
}