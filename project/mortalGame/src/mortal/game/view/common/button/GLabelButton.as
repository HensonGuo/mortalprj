/**
 * 2014-3-17
 * @author chenriji
 **/
package mortal.game.view.common.button
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUI;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import fl.controls.Button;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.view.common.UIFactory;
	

	/**
	 * label为美术字的按钮
	 * @author chenriji
	 * 
	 */	
	public class GLabelButton extends GSprite implements IToolTipItem,IFrUI
	{
		private var _bmpLabel:GBitmap;
		private var _btn:Button;
		
		private var _paddingBottom:Number = 0;
		
		public static const gButton:int = 0;
		public static const gLoadedButton:int = 1;
		public static const gLoadingButton:int = 2;
		
		public function GLabelButton()
		{
			super();
			this.buttonMode = true;
			this.useHandCursor = true;
			//			this.focusEnabled = false;
			//_styleName = CLASSNAME;
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		/**
		 * 可以设置为GButton，GLoadingButton，GLoadedButton 
		 * @param $labelImgName 美术字对应的资源名字
		 * @param type
		 * @param buttonStyle, 对应按钮的styleName或者GLoadedButton的xx_upSkin, 或者GLoadingButton的xx
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * 
		 */		
		public function setParams(labelResName:String=null, type:int=0, buttonStyle:String="Button", width:int=49, height:int=22):void
		{
			switch(type)
			{
				case gButton:
					_btn = UIFactory.gButton("", 0, 0, width, height, this, buttonStyle);
					break;
				case gLoadedButton:
					_btn = UIFactory.gLoadedButton(buttonStyle, 0, 0, width, height, this);
					break;
				case gLoadingButton:
					_btn = UIFactory.gLoadingButton(buttonStyle, 0, 0, width, height, this);
					break;
			}
			_bmpLabel = UIFactory.gBitmap(labelResName, 0, 0, this);
			updateLayout();
		}
		
		public function set label(labelResName:String):void
		{
			_bmpLabel.bitmapData = GlobalClass.getBitmapData(labelResName);
			updateLayout();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
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
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_btn != null)
			{
				(_btn as IDispose).dispose(isReuse);
				_btn = null;
			}
			if(_bmpLabel != null)
			{
				_bmpLabel.dispose(isReuse);
				_bmpLabel = null;
			}
			
			_paddingBottom = 0;
			
			this.mouseChildren = true;
		}
		
		public function updateLayout():void
		{
			if(_btn == null)
			{
				return;
			}
			_bmpLabel.x = (_btn.width - _bmpLabel.width)/2;
			_bmpLabel.y = (_btn.height - _bmpLabel.height - _paddingBottom)/2;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
			updateLayout();
		}
		
	}
}