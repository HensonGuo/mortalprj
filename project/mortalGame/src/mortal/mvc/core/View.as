/**
 * @date	2011-3-4 下午03:47:29
 * @author  jianglang
 * 
 */	

package mortal.mvc.core
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GUIComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mortal.mvc.events.ViewEvent;
	import mortal.mvc.interfaces.ILayer;
	import mortal.mvc.interfaces.IStageResize;
	import mortal.mvc.interfaces.IUIView;
	import mortal.mvc.interfaces.IView;
	
	public class View extends GSprite implements IUIView,IStageResize
	{
		public function View()
		{
			super();
			tabChildren = false;
			mouseEnabled = false;
			isDisposeRemoveSelf = false;
			isHideDispose = true;
		}
		
		protected var _layer:ILayer;
		
		protected var _isHide:Boolean = true; // 是否隐藏

		public function get isHide():Boolean
		{
			return _isHide;
		}

		public function set layer(value:ILayer):void
		{
			_layer = value;
		}

		public function get layer():ILayer
		{
			return _layer;
		}

		/**
		 * 更新各个类型的数据 
		 * @param data
		 * 
		 */		
		public function update(data:Object,...parameters):void
		{
			if( data is int )
			{
				
			}
			else if( data is Number )
			{
				
			}
		}
		
		public function hide():void
		{
			if( _layer )
			{
				_isHide = true;
				dispatchEvent(new ViewEvent(ViewEvent.Hide));
				_layer.removePopup(this);
			}
		}
		
		public function show(x:int=0,y:int=0):void
		{
			if( _layer )
			{
				_isHide = false;
				_layer.addPopUp(this);
				dispatchEvent(new ViewEvent(ViewEvent.Show));
				if(x != 0 && y != 0)
				{
					_layer.setPosition(this,x,y);
				}
			}
		}
		
		/**
		 * stage Resize 
		 * 
		 */		
		public function stageResize():void
		{
			
		}
		
	}
}
