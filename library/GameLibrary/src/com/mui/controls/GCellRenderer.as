/**
 * @date	2011-3-3 下午07:30:01
 * @author  jianglang
 *
 */

package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.mui.core.IFrUIContainer;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * 
	 * @author huangliang
	 */
	public class GCellRenderer extends CellRenderer implements ICellRenderer,IToolTipItem,IFrUIContainer
	{
//		protected var _listData:ListData;
//		protected var _selected:Boolean ; 
//		protected var _data:Object;
		
		private var _uiDisposeVec:Vector.<IDispose> = new Vector.<IDispose>();
		
		protected var _disposed:Boolean = true;
		
		public function GCellRenderer()
		{
			super();
			super.configUI();
			initSkin();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);
//			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
//			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		protected function initSkin():void
		{
			var emptyBmp:Bitmap=new Bitmap()
			this.setStyle("downSkin",emptyBmp);
			this.setStyle("overSkin",emptyBmp);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",emptyBmp);
			this.setStyle("selectedOverSkin",emptyBmp);
			this.setStyle("selectedUpSkin",emptyBmp);
		}
		
		protected function judgeToolTip(e:Event = null):void
		{
//			if(e && e.type == Event.ADDED_TO_STAGE && toolTipData 
//				|| !e && toolTipData && Global.stage.contains(this))
//			{
//				ToolTipsManager.register(this);
//			}
//			else
//			{
//				ToolTipsManager.unregister(this);
//			}
		}
		
		protected function onAddedToStageHandler( event:Event ):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
//		public function setSize(arg0:Number, arg1:Number):void
//		{
//			// TODO Auto-generated method stub
//		}

//		override protected function configUI():void
//		{
//			super.configUI();
//		}
		
//		protected function draw():void
//		{
//			
//		}

		override public function set listData(arg0:ListData):void
		{
			// TODO Auto-generated method stub
			_listData = arg0;
			label = _listData.label;
			setStyle("icon", _listData.icon);
		}


		override public function get selected():Boolean
		{
			// TODO Auto-generated method stub
			return _selected;
		}

		override public function set selected(arg0:Boolean):void
		{
			// TODO Auto-generated method stub
//			_selected = arg0;
			super.selected = arg0;
		}

//		public function setMouseState(arg0:String):void
//		{
//			// TODO Auto-generated method stub
//		}

		public function get toolTipData():*
		{
			// TODO Auto-generated method stub
			return _toolTipData;
		}

		private var _toolTipData:*;
		public function set toolTipData(value:*):void
		{
			_toolTipData = value;
			judgeToolTip();
		}
		
//		public function setStyle(style:String, value:Object):void 
//		{
//			
//		}
		
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
		
		
		public function dispose(isReuse:Boolean=true):void
		{
			disposeChildren();
			ObjEventListerTool.delObjEvent(this);

			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(isReuse)
			{
				UICompomentPool.disposeUICompoment(this);
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
		
//		override public function set label(arg0:String):void
//		{
//			
//		}
		
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
		
	}
	
}