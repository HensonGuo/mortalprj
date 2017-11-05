/**
 * 2014-2-20
 * @author chenriji
 **/
package mortal.game.view.task.view.render
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskItemCellrender extends GCellRenderer
	{
		private var _txtName:GTextFiled;
		private var _txtStatus:GTextFiled;
		private var _taskInfo:TaskInfo;
		private var _line:ScaleBitmap;
		
		public function TaskItemCellrender()
		{
			super();
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:Bitmap = new Bitmap();
			this.setStyle("downSkin", GlobalClass.getBitmap(ImagesConst.taskItemSelected));
			this.setStyle("overSkin", GlobalClass.getBitmap(ImagesConst.taskItemSelected));
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin", GlobalClass.getBitmap(ImagesConst.taskItemSelected));
			this.setStyle("selectedOverSkin", GlobalClass.getBitmap(ImagesConst.taskItemSelected));
			this.setStyle("selectedUpSkin", GlobalClass.getBitmap(ImagesConst.taskItemSelected));
		}
		
		public override function set data(value:Object):void
		{
			_taskInfo = value as TaskInfo;
			_txtName.text = _taskInfo.getName(false);
			_txtStatus.htmlText = _taskInfo.getStatusName();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_txtName = UIFactory.gTextField("", 12, 0, 160, 20, this);
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.RIGHT;
			_txtStatus = UIFactory.gTextField("", 12, 0, 160, 20, this, tf);
			_line = UIFactory.bg(0, 20, 180, 1, this, ImagesConst.SplitLine); 
			
			this.configEventListener(MouseEvent.CLICK, clickMeHandler);
		}
		
		private function clickMeHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.TaskMoudleViewTaskInfo, _taskInfo));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txtName.dispose(isReuse);
			_txtName = null;
			_line.dispose(isReuse);
			_line = null;
			_txtStatus.dispose(isReuse);
			_txtStatus = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}