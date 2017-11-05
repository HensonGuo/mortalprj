/**
 * @date 2011-4-16 上午10:45:30
 * @author  wyang
 *  重写为了解决在tileList里面使用时，图片不能设置大小的问题,另外解决图片清除后，内存不会回收的问题
 */  

package com.mui.containers
{
	import com.gengine.core.IDispose;
	import com.mui.core.IFrUI;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.containers.UILoader;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class GUiLoader extends UILoader implements IFrUI
	{
		
		public function GUiLoader()
		{
			super();
		}
		
		override public function setSize(arg0:Number, arg1:Number):void
		{
			_width = arg0;
			_height = arg1;
		}
		
		override protected function drawLayout():void 
		{
			if (!contentInited) { return; }
			var resized:Boolean = false;
			
			var w:Number;
			var h:Number;			
			if (loader) {
				var cl:LoaderInfo = loader.contentLoaderInfo;
				w = cl.width;
				h = cl.height
			} else {
				w = contentClip.width;	
				h = contentClip.height;	
			}
			
			//如果有setSize，用set的尺寸
			if(_width && _height)
			{
				w= _width;
				h = _height;
			}
			
			var newW:Number = _width;
			var newH:Number = _height;
			if (!_scaleContent) {
				_width = contentClip.width;
				_height = contentClip.height;
			} else {
				sizeContent(contentClip, w, h, _width, _height);
			}
			
			if (newW!= _width || newH != _height) {
				dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, true));
			}
		}
		
		override protected function sizeContent(target:DisplayObject, contentWidth:Number, contentHeight:Number, targetWidth:Number, targetHeight:Number):void 
		{
			var w:Number = contentWidth;
			var h:Number = contentHeight;
			if (_maintainAspectRatio) { // Find best fit. Center vertically or horizontally
				var containerRatio:Number = targetWidth / targetHeight;
				var imageRatio:Number = contentWidth / contentHeight;
				
				if (containerRatio < imageRatio) {
					h = w / imageRatio;
				} else {
					w = h * imageRatio;
				}
			}
			target.width = w;
			target.height = h;
			//这里改为左上角对齐
			/*
			target.x = targetWidth/2 - w/2;
			target.y = targetHeight/2 - h/2;
			*/
		}
		
		override protected function _unload(throwError:Boolean=false):void
{
			if (loader != null) {
				clearLoadEvents();
				contentClip.removeChild(loader);
				try {
					//这里修改为flashPlayer10新加的命令，可以有效加收资源
					loader.unloadAndStop(true);
					//loader.close();
				} catch (e:Error) {
					// Don't throw close errors.
				}
				
				
				try {
					//loader.unload();
					loader.unloadAndStop(true);
				} catch(e:*) {
					// Do nothing on internally generated close or unload errors.	
					if (throwError) { throw e; }
				}
				
				loader = null;
				return;
			}
			
			contentInited = false;
			if (contentClip.numChildren) {
				contentClip.removeChildAt(0);
			}			
		}	
		
		override public function load(request:URLRequest=null, context:LoaderContext = null):void 
		{
			contentClip.scaleX = contentClip.scaleY = 1;
			super.load(request,context);
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
		
		public function dispose(isReuse:Boolean=true):void
		{
			ObjEventListerTool.delObjEvent(this);
//			var i:int;
//			/** 清理子对象 */
//			var childrenLength:int = this.numChildren;
//			var o:DisplayObject;
//			for(i = childrenLength - 1;i>=0;i-- )
//			{
//				o = this.getChildAt(i);
//				if(o is IDispose)
//				{
//					this.removeChild(o);
//					(o as IDispose).dispose(isReuse);
//				}
//			}
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
}