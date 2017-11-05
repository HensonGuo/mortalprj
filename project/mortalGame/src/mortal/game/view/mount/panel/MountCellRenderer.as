package mortal.game.view.mount.panel
{
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.MountUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mount.MountCache;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;
	import mortal.mvc.core.Dispatcher;
	
	public class MountCellRenderer extends GCellRenderer
	{
		private var _level:GTextFiled;
		
		private var _name:GTextFiled;
		
		private var _lineage:GTextFiled;
		
		private var _mountData:MountData;
		
		private var _bg:GBitmap;
		
		private var _horseBitmap:GBitmap;
		
		private var _lockIcon:GBitmap;
		
		public function MountCellRenderer()
		{
			super();
			this.setSize(132,148);
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			var selectSkin:ScaleBitmap = UIFactory.bg(0,0,140,138,null,ImagesConst.selectedBg);
			this.setStyle("downSkin",selectSkin);
			this.setStyle("overSkin",selectSkin);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override protected function configUI():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.gBitmap(ImagesConst.MountCellBg,4,4,this);
			
			_horseBitmap = UIFactory.gBitmap("",4,30,this);
			
			_lockIcon = UIFactory.gBitmap(ImagesConst.MountLock,34,45,this);
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER
			_name = UIFactory.gTextField("",5,4,120,20,this,tf);
			
			tf.align = AlignMode.LEFT;
			_level = UIFactory.gTextField("",11,121,120,20,this,tf,true);
			
			tf.align = AlignMode.RIGHT;
			_lineage = UIFactory.gTextField("",90,121,30,20,this,tf);
			
			this.configEventListener(MouseEvent.CLICK,selectMountHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_name.dispose(isReuse);
			_level.dispose(isReuse);
			_lineage.dispose(isReuse);
			_bg.dispose(isReuse);
			_horseBitmap.dispose(isReuse);
			_lockIcon.dispose(isReuse);
			
			_name = null;
			_level = null;
			_lineage = null;
			_bg = null;
			_horseBitmap = null;
			_lockIcon = null;
			
			super.disposeImpl(isReuse);
		}
		
		
		override public function set data(arg0:Object):void
		{
			_mountData = arg0.data as MountData;
			
			var mountCache:MountCache = Cache.instance.mount;
			
			_name.htmlText = MountUtil.getItemName(_mountData);
			
			//资源图有了再用
//			_horseBitmap.bitmapData = GlobalClass.getBitmapData("horse_" + _mountData.itemMountInfo.species);
			_horseBitmap.bitmapData = GlobalClass.getBitmapData(ImagesConst.horse_150000000);
			
			if(_mountData.isOwnMount)
			{
				_level.text = "Lv." + _mountData.sPublicMount.level.toString();
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.MountCellBg);
				
				var totalLevel:int;
				for each(var i:MountToolData in _mountData.toolList)
				{
					totalLevel += i.level;
				}
				_lineage.text = totalLevel.toString();
				
				_lockIcon.visible = false;
				this.mouseEnabled = true;
				this.mouseChildren = true;
				_horseBitmap.filters = [];
				
//				if(mountCache.currentMount == null && _mountData.itemMountInfo.code == mountCache.mountList[0].itemMountInfo.code)
//				{
//					this.selected = true;
//				}
//				else if(mountCache.currentMount && mountCache.currentMount.itemMountInfo.code == _mountData.itemMountInfo.code)
//				{
//					this.selected = true;
//				}
//				else
//				{
//					this.selected = false;
//				}
				
			}
			else
			{
				_level.text = _mountData.itemMountInfo.code.toString();;
				_lineage.text = "";
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.MountDisopen);
				
				_lockIcon.visible = true;
				this.mouseEnabled = false;
				this.mouseChildren = false;
				_horseBitmap.filters = [FilterConst.colorFilter2];
			}
//			this.drawNow();
		}
		
		override public function get toolTipData():*
		{
			return new ItemData(_mountData.itemMountInfo.code);
		}
		
		override public function set toolTipData(value:*):void
		{
			
		}
		
		protected function onAddToStage(e:Event):void
		{
			ToolTipsManager.register(this);
		}
		
		protected function onRemoveFromStage(e:Event):void
		{
			ToolTipsManager.register(this);
		}
		
		public function selectMountHandler(e:MouseEvent = null):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.MountSelseced,_mountData));
		}
	}
}