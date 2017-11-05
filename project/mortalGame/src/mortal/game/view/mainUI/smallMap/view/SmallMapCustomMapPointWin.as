/**
 * 2014-1-23
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import Message.Public.SCustomPoint;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.SmallWindow;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.scene3D.map3D.MapNodeType;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapCustomXYFixer;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class SmallMapCustomMapPointWin extends SmallWindow
	{
		private var _bg:ScaleBitmap;
		private var _txt1:GTextFiled;
		private var _txt2:GTextFiled;
		private var _btnSave:GButton;
		private var _btnCancel:GButton;
		private var _list:GTileList;
		private var _items:Array;
		
		
		public function SmallMapCustomMapPointWin($layer:ILayer=null)
		{
			super($layer);
			setSize(427, 269);
			this.title = Language.getString(20078);
		}
		
		public function updateData(data:Array):void
		{
//			_list.dataProvider = data;
//			_list.drawNow();
			for(var i:int = 0; i < 5; i++)
			{
				var item:SmallMapCustomXYFixer = _items[i] as SmallMapCustomXYFixer;
				item.data = data[i];
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.bg(10, 27, 408, 182, this);
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.bold = true;
			tf.color = 0xF9BB8C;
			_txt1 = UIFactory.gTextField(Language.getString(20076), 42, 34, 200, 20, this, tf);
			_txt2 = UIFactory.gTextField(Language.getString(20077), 356, 34, 80, 20, this, tf);
			_btnSave = UIFactory.gButton(Language.getString(20083), 141, 230, 50, 20, this);
			_btnCancel = UIFactory.gButton(Language.getString(20084), 228, 230, 50, 20, this);
			
			_items = [];
			for(var i:int = 0; i < 5; i++)
			{
				var item:SmallMapCustomXYFixer = new SmallMapCustomXYFixer(i);// ObjectPool.getObject(SmallMapCustomXYFixer);
				item.x = 16;
				item.y = 54 + 32 * i;
				this.addChild(item);
				_items.push(item);
			}
			
			// 监听事件
			_btnSave.configEventListener(MouseEvent.CLICK, saveHandler);
			_btnCancel.configEventListener(MouseEvent.CLICK, cancelHandler);
		}
		
		private function saveHandler(evt:MouseEvent):void
		{
			var isNotWalk:Boolean = false;
			for(var i:int = 0; i < 5; i++)
			{
				var item:SmallMapCustomXYFixer = _items[i];
				if(item == null)
				{
					continue;
				}
				var data:SCustomPoint = item.getChangeData();
				if(data == null)
				{
					continue;
				}
				
				// 检查是否可走
				if(!MapNodeType.isWalk(GameMapUtil.getPointValueByMapId(data.mapId, 
					data.point.x/Game.mapInfo.pieceWidth, data.point.y/Game.mapInfo.pieceHeight)))
				{
					MsgManager.showRollTipsMsg(Language.getStringByParam(20114, data.name, data.point.x, data.point.y));
					isNotWalk = true;
					continue;
				}
				
				var str:String = Language.getStringByParam(20080, data.index + 1);
				if(str == data.name)
				{
					data.name = Language.getStringByParam(20115, data.index + 1);
				}
				
				if(data.name == null || data.name.length > 8)
				{
					MsgManager.showRollTipsMsg(Language.getString(20116));
					isNotWalk = true;
					continue;
				}
				
				Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapSaveCustomPoint, data));
//				GameProxy.sceneProxy.saveCustomMapPoint(data.index, data.name, data.mapId, data.point);
			}
			if(!isNotWalk)
			{
				this.hide();
			}
		}
		
		private function cancelHandler(evt:MouseEvent):void
		{
			this.hide();
		}
		
		protected override function setWindowCenter():void
		{
			
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_bg.dispose(isReuse);
			_txt1.dispose(isReuse);
			_txt2.dispose(isReuse);
			_btnSave.dispose(isReuse);
			_btnCancel.dispose(isReuse);
//			_list.dispose(isReuse);
			for each(var item:SmallMapCustomXYFixer in _items)
			{
				item.dispose(isReuse);
			}
			
			_txt1 = null;
			_txt2 = null;
			_bg = null;
			_btnSave = null;
			_btnCancel = null;
//			_list = null;
			_items = null;
		}
	}
}