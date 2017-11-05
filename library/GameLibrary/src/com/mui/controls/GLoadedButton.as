/**
 * 2014-1-10
 * @author chenriji
 **/
package com.mui.controls
{
	import com.gengine.core.call.Caller;
	import com.gengine.global.Global;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUI;
	import com.mui.events.LibraryEvent;
	import com.mui.events.MuiEvent;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.Button;
	import fl.controls.ButtonLabelPlacement;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	
	/**
	 * 已经加载完资源的按钮， 使用之前确保肌肤都已经加载 
	 * @author hdkiller
	 * 
	 */	
	public class GLoadedButton extends Button implements IToolTipItem, IFrUI
	{
		private var _my9Gride:Rectangle;
		
		public function GLoadedButton()
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
		
		public function get my9Gride():Rectangle
		{
			return _my9Gride;
		}

		public function set my9Gride(value:Rectangle):void
		{
			_my9Gride = value;
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
		
		//外部提供的获取资源路径的方法
		private static var _getPath:Function;
		
		protected var _resName:String;
		
		protected var _isHasInitStyle:Boolean = false;
		
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
			return _resName + "_upSkin";
		}
		
		/**
		 * 加载资源
		 * @param resName
		 * 
		 */
		public function set styleName(resName:String):void
		{
			if(!resName)
			{
				return;
			}
			
			_resName = resName.replace("_upSkin","");
			setStyles();
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
				if(_my9Gride != null)
				{
					return GlobalClass.getScaleBitmap(_resName + "_upSkin", _my9Gride);
				}
				else
				{
					return GlobalClass.getBitmap(_resName + "_upSkin");
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
			_my9Gride = null;
			_isHasInitStyle = false;
			_resName = "";
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