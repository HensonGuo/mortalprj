package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.core.call.Caller;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.info.ResourceInfo;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUI;
	import com.mui.events.LibraryEvent;
	import com.mui.events.MuiEvent;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 本按钮负责自动帮忙加载并显示， 对应的资源在uifla/button/ooxx中
	 * 资源包里面至少需要有一个 _resName + _upSkin的图片 
	 * upSkin 对应 upSkin的图片
	 * overSkin对应overSkin的图片 否则用upSkin的图片
	 * disabledSkin对应disabledSkin的图片 否则用upSkin的图片
	 * downSkin对应downSkin的图片 否则用upSkin的图片
	 * @author heartspeak
	 * 
	 */	
	public class GLoadingButton extends Button implements IToolTipItem,IFrUI
	{
		public var extName:String;
		//是否在不可选择的时候用over那张图
		public var isDisableOverSkin:Boolean = false;
		
		private var _my9Gride:Rectangle;
		
		public function GLoadingButton()
		{
			super();
			this.buttonMode = true;
			this.useHandCursor = true;
			
			setStyle("overSkin",new Bitmap());
			setStyle("upSkin",new Bitmap());
			setStyle("downSkin",new Bitmap());
			setStyle("disabledSkin",new Bitmap());
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
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
		
		public function get my9Gride():Rectangle
		{
			return _my9Gride;
		}
		
		public function set my9Gride(value:Rectangle):void
		{
			_my9Gride = value;
		}
		
		//加载资源的caller
		private static var _loadCaller:Caller = new Caller();
		//已经加载过的资源名字列表
		private static var _aryResLoaded:Array = new Array();
		//正在加载的资源名字列表
		private static var _aryResLoading:Array = new Array();
		//外部提供的获取资源路径的方法
		private static var _getPath:Function;
		
		protected var _resName:String;
		
		protected var _isHasInitStyle:Boolean = false;
		/**
		 * 是否加载过这个资源包 
		 * @param resName
		 * @return 
		 * 
		 */
		private static function isResLoaded(resName:String):Boolean
		{
			return _aryResLoaded.indexOf(resName) > -1;
		}
		
		/**
		 * 是否在加载中 
		 * @param resName
		 * @return 
		 * 
		 */		
		private static function isResLoading(resName:String):Boolean
		{
			return _aryResLoading.indexOf(resName) > -1;
		}
		
		/**
		 * 让外部提供一个获取资源路径的方法
		 * @param fun
		 * 
		 */		
		public static function setGetPath(getPath:Function):void
		{
			_getPath = getPath;
		}
		
		/**
		 * 获取资源路径 
		 * @return 
		 * 
		 */	
		protected function getPath():String
		{
			if(_getPath == null)
			{
				return _resName;
			}
			else
			{
				return _getPath.call(null,_resName);
			}
		}
		
		/**
		 * 获取资源名字 
		 * @return 
		 * 
		 */		
		public function get styleName():String
		{
			return _resName;
		}
		
		/**
		 * 加载资源
		 * @param resName
		 * 
		 */
		public function set styleName(resName:String):void
		{
			addListener();
			if(!resName)
			{
				return;
			}
			
			_resName = resName;
			
			if(isResLoaded(_resName))
			{
				setStyles();
			}
			else if(isResLoading(_resName))
			{
				_loadCaller.addCall(_resName,setStyles);
			}
			else
			{
				_loadCaller.addCall(_resName,setStyles);
				_aryResLoading.push(_resName);
				GlobalClass.libaray.loadSWF(getPath(),_resName);
			}
		}
		
		private static var _isAddLis:Boolean = false;
		
		private static function addListener():void
		{
			if(!_isAddLis)
			{
				GlobalClass.libaray.addEventListener(LibraryEvent.SINGLELOAD_COMPLETE, onlibraryCompleteHandler);
				_isAddLis = true;
			}
		}
		
		/**
		 * 加载结束 
		 * @param event
		 * 
		 */
		private static function onlibraryCompleteHandler(event:LibraryEvent):void
		{
			var resName:String = String(event.data);
			_loadCaller.call(resName);
			_loadCaller.removeCallByType(resName);
			//添加到已加载列表中
			_aryResLoaded.push(resName);
			//从加载中的列表中移除
			if(isResLoading(resName))
			{
				_aryResLoading.splice(_aryResLoading.indexOf(resName),1);
			}
		}
		
		/**
		 * 设置样式
		 * 
		 */		
		protected function setStyles():void
		{
			//没有资源,return
			if(!GlobalClass.hasRes(_resName + "_upSkin"))
			{
				return;
			}
			setStyle("overSkin",getBimap("_overSkin"));
			setStyle("upSkin",getBimap("_upSkin"));
			setStyle("downSkin",getBimap("_downSkin"));
			setStyle("disabledSkin",getBimap("_disabledSkin"));
			
			_isHasInitStyle = true;
			this.dispatchEvent( new MuiEvent(MuiEvent.GLOADEDBUTTON_STYLE_COMPLETE));
		}
		
		/**
		 * 是否已经初始化样式了 
		 * @return 
		 * 
		 */		
		public function get isHasInitStyle():Boolean
		{
			return _isHasInitStyle;
		}
		
		/**
		 * 通过后缀获取Bitmap 
		 * @param suffix
		 * @return 
		 * 
		 */		
		protected function getBimap(suffix:String):Bitmap
		{
			var bmpName:String = _resName + suffix;
			
			if(GlobalClass.hasRes(bmpName))
			{
				if(_my9Gride != null)
				{
					return GlobalClass.getScaleBitmap(bmpName, _my9Gride);
				}
				else
				{
					return GlobalClass.getBitmap(bmpName);
				}
			}
			else
			{
				var endStr:String = "_upSkin";
				if(suffix == "_disabledSkin" && isDisableOverSkin)
				{
					endStr = "_overSkin";
				}
				
				if(_my9Gride != null)
				{
					return GlobalClass.getScaleBitmap(_resName + endStr, _my9Gride);
				}
				else
				{
					return GlobalClass.getBitmap(_resName + endStr);
				}
			}
		}
		
		private static const colorFilter2:ColorMatrixFilter = new ColorMatrixFilter([ //灰色滤镜
			0.5086,0.2094,0.082,0,0,
			0.5086,0.2094,0.082,0,0,
			0.5086,0.2094,0.082,0,0,
			0,0,0,1,0
		]);
		
		/**
		 * 设置按钮Enabled，带滤镜
		 * @param $value
		 * 
		 */		
		public function set filterEnabled( $value:Boolean ):void
		{
			this.enabled = $value;
			this.filters = $value ? null : [ colorFilter2 ];
		}
		
		protected var _toolTipData:*;
		
		/**
		 * 获取toolTipData 
		 * @return 
		 * 
		 */		
		public function get toolTipData():*
		{
			return _toolTipData;
		}
		
		/**
		 * 设置toolTipData 
		 * @param value
		 * 
		 */		
		public function set toolTipData( value:* ):void
		{
			_toolTipData = value;
			judgeToolTip();
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
			_isHasInitStyle = false;
			_resName = "";
			extName = "";
			isDisableOverSkin = false;
			setStyle("overSkin",new Bitmap());
			setStyle("upSkin",new Bitmap());
			setStyle("downSkin",new Bitmap());
			setStyle("disabledSkin",new Bitmap());
			ObjEventListerTool.delObjEvent(this);
//			var childrenLength:int = this.numChildren;
//			var i:int;
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