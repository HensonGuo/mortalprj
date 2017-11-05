/**
 * @date	2012-11-10 上午11:51:34
 * @author	song
 *
 */
package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.core.IFrUIContainer;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GSprite extends Sprite implements IFrUIContainer
	{
		private var _uiDisposeVec:Vector.<IDispose> = new Vector.<IDispose>();
		
		protected var _disposed:Boolean = true;
		
		protected var isDisposeRemoveSelf:Boolean = true;
		
		protected var _isHideDispose:Boolean = false;
		
		public function GSprite()
		{
			super();
			this.mouseEnabled = false;
			configUI();
		}
		
		public function get isHideDispose():Boolean
		{
			return _isHideDispose;
		}

		public function set isHideDispose(value:Boolean):void
		{
			if(_isHideDispose == value)
			{
				return;
			}
			_isHideDispose = value;
			if(value)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,onAddToStageCreate);
				this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageDispose);
			}
			else
			{
				this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStageCreate);
				this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageDispose);
			}
		}

		protected function pushUIToDisposeVec(ui:IDispose):void
		{
			_uiDisposeVec.push(ui);
		}
		
		protected function onAddToStageCreate(e:Event):void
		{
			createDisposedChildren();
		}
		
		protected function onRemoveFromStageDispose(e:Event):void
		{
			disposeChildren();
		}
		
		public function configEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			ObjEventListerTool.addObjEvent(this,type,listener,useCapture);
			addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			ObjEventListerTool.removeObjEvent(this,type,listener,useCapture);
			super.removeEventListener(type,listener,useCapture);
		}
		
		public function get isDisposed():Boolean
		{
			return _disposed;
		}
		
		protected function configUI():void
		{
			createDisposedChildren();
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			disposeChildren();
			ObjEventListerTool.delObjEvent(this);
			if(isDisposeRemoveSelf)
			{
				if(this.parent)
				{
					this.parent.removeChild(this);
				}
				if(isReuse)
				{
					UICompomentPool.disposeUICompoment(this);
				}
			}
		}
		
		protected function disposeChildren(isReuse:Boolean = true):void
		{
			if(!_disposed)
			{
				_disposed = true;
				//释放UI
				for each(var obj:IDispose in _uiDisposeVec)
				{
					obj.dispose(isReuse);
				}
				_uiDisposeVec = new Vector.<IDispose>();
				disposeImpl(isReuse);
			}
		}
		
		public function createDisposedChildren():void
		{
			if(!_disposed)
			{
				return;
			}
			_disposed = false;
			createDisposedChildrenImpl();
		}
		
		
		/**提供复写*/
		protected function disposeImpl(isReuse:Boolean=true):void
		{
			
		}
		
		/**提供复写*/
		protected function createDisposedChildrenImpl():void
		{
			
		}
		
		
		//setSize相关
		protected var _width:Number = 0;
		
		protected var _height:Number = 0;
		
		public function setSize(width:Number,height:Number):void
		{
			this._width = width;
			this._height = height;
			if(!Global.instance.hasCallLater(updateView))
			{
				Global.instance.callLater(updateView);
			}
		}
		
		protected function updateView():void
		{
			
		}
		
		override public function get width():Number
		{
			if(_width)
			{
				return _width;
			}
			return super.width;
		}
		
		override public function set width(value:Number):void
		{
			if (_width == value) { return; }
			setSize(value, height);
		}
		
		override public function get height():Number
		{
			if(_height)
			{
				return _height;
			}
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			if (_height == value) { return; }
			setSize(width, value);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}