package mortal.game.view.mount.panel
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mount.data.MountToolData;
	
	public class LineageCellRenderer extends GCellRenderer
	{
		private var _level:GTextFiled;
		
		private var _typeIcon:GBitmap;
		
		private var _exp:GBitmap;
		
		private var _mountToolData:MountToolData;
		
		private var _testTxt:GTextFiled;
		
		public function LineageCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.LineageBall,0,0,this));
			
			_level = UIFactory.gTextField("",20,50,50,20,this,GlobalStyle.textFormatAnjin);
			
			_typeIcon = UIFactory.gBitmap("",17,15,this);
			
			_testTxt = UIFactory.gTextField("",15,-5,50,20,this,GlobalStyle.textFormatAnjin);
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_level.dispose(isReuse);
			_typeIcon.dispose(isReuse);
			_testTxt.dispose(isReuse);
			
			_level = null;
			_typeIcon = null;
			_testTxt = null;
			
		}
		
		override public function set data(arg0:Object):void
		{
			_mountToolData = arg0.data;
			
			_level.text = "Lv." + _mountToolData.level;
			
			_typeIcon.bitmapData = GlobalClass.getBitmapData(_mountToolData.name + "Title");
			
			var maxLevel:int = _mountToolData.level + 1 > 50? 50:_mountToolData.level + 1;
			_testTxt.text = _mountToolData.exp + "/" + MountConfig.instance.getMountToolLevel(maxLevel).experience;
			
		}
		
	}
}