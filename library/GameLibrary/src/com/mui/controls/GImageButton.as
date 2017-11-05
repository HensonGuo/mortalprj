package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.core.IFrUI;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class GImageButton extends Button implements IToolTipItem,IFrUI
	{
		private static var _bitmapDataMap:Dictionary = new Dictionary();
		
		public function GImageButton()
		{
			super();
			this.buttonMode = true;
			this.useHandCursor = true;
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		private var _overSkinUrl:String;
		private var _upSkinUrl:String;
		private var _downSkinUrl:String;
		private var _disabledSkinUrl:String;
		
		/**
		 * overSKin 
		 * @param url
		 * 
		 */		
		public function set overSkin(url:String):void
		{
			setSkin("overSkin",url);
		}
		
		public function set upSkin(url:String):void
		{
			setSkin("upSkin",url);
		}
		
		public function set disabledSkin(url:String):void
		{
			setSkin("disabledSkin",url);
		}
		
		public function set downSkin(url:String):void
		{
			setSkin("downSkin",url);
		}
		
		/**
		 * overSKin 
		 * @param url
		 * 
		 */		
		public function setSkin(type:String,url:String):void
		{
			if(!( url in _bitmapDataMap))
			{
				LoaderManager.instance.load(url,onLoadedSkin);
			}
			else
			{
				setStyle(type,new Bitmap(_bitmapDataMap[url] as BitmapData));
			}
			
			function onLoadedSkin(info:ImageInfo):void
			{
				_bitmapDataMap[url] = info.bitmapData;
				setStyle(type,new Bitmap(info.bitmapData));
			}
		}
		
		protected var _toolTipData:*;
		
		public function get toolTipData():*
		{
			return _toolTipData;
		}
		
		public function set toolTipData( value:* ):void
		{
			_toolTipData = value;
			judgeToolTip();
		}
		
		protected function judgeToolTip(e:Event = null):void
		{
			if(e && e.type == Event.ADDED_TO_STAGE && toolTipData 
				|| !e && toolTipData && Global.stage.contains(this))
			{
				ToolTipsManager.register(this);
			}
			else
			{
				ToolTipsManager.unregister(this);
			}
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
			clearStyle("overSkin");
			clearStyle("upSkin");
			clearStyle("disabledSkin");
			clearStyle("downSkin");
			ObjEventListerTool.delObjEvent(this);
			var childrenLength:int = this.numChildren;
			var i:int;
			var o:DisplayObject;
			for(i = childrenLength - 1;i>=0;i-- )
			{
				o = this.getChildAt(i);
				if(o is IDispose)
				{
					this.removeChild(o);
					(o as IFrUI).dispose(isReuse);
				}
			}
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