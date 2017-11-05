/**
 * 2014-1-23
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.render
{
	import Message.Public.SCustomPoint;
	import Message.Public.SPoint;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLabel;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextInput;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.Game;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapCustomXYData;
	
	public class SmallMapCustomXYFixer extends GCellRenderer
	{
		private var _index:int;
		private var _line:ScaleBitmap;
		private var _txtName:GTextInput;
		private var _txtMapName:GTextInput;
		private var _lX:GLabel;
		private var _txtX:GTextInput;
		private var _lY:GLabel;
		private var _txtY:GTextInput;
		private var _btnCur:GLoadedButton;
		
		
		private var _myData:SmallMapCustomXYData;
		
		public function SmallMapCustomXYFixer(index:int)
		{
			super();
			_index = index;
		}
		
		override public function set label(arg0:String):void
		{
		}
		
		public function getChangeData():SCustomPoint
		{
			var xx:int = int(_txtX.text);
			var yy:int = int(_txtY.text);
			if(xx <= 0 && yy <= 0)
			{
				return null;
			}
			var p:SCustomPoint = new SCustomPoint();
			p.point = new SPoint();
			p.point.x = xx;
			p.point.y = yy;
			p.index = _index;
			p.mapId = _myData.mapId;
			if(_myData.mapId == 0)
			{
				p.mapId = Game.mapInfo.mapId;
			}
			p.name = _txtName.text;
			
			// 有更改才返回
			if(p.mapId != _myData.mapId)
			{
				return p;
			}
			if(p.name != _myData.name)
			{
				return p;
			}
			if(p.point.x != _myData.x)
			{
				return p;
			}
			if(p.point.y != _myData.y)
			{
				return p;
			}
			return null;
		}
		
		public override function set data(value:Object):void
		{
			if(_txtX == null)
			{
				createDisposedChildrenImpl();
			}
			_myData= value as SmallMapCustomXYData;
			
			if(_myData.isNotSet)
			{
				_txtName.defaultText = _myData.name;
			}
			else
			{
				_txtName.text = _myData.name;
			}
			
			_txtMapName.text = _myData.mapName;
			_txtX.text = _myData.x.toString();
			_txtY.text = _myData.y.toString();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_line = UIFactory.bg(-8, 0, 392, 1, this, ImagesConst.SplitLine);
			
			_txtName = UIFactory.gTextInput(0, 6, 116, 22, this);
			_txtName.maxChars = 8;
			_txtMapName = UIFactory.gTextInput(124, 6, 84, 22, this);
			_txtMapName.mouseEnabled = false;
			_lX = UIFactory.label("X:", 217, 7, 30, 24, TextFormatAlign.LEFT, this);
			_txtX = UIFactory.gTextInput(230, 6, 50, 22, this);
			_lY = UIFactory.label("Y:", 290, 7, 30, 24, TextFormatAlign.LEFT, this);
			_txtY = UIFactory.gTextInput(310, 6, 50, 22, this);
			_btnCur = UIFactory.gLoadedButton(ImagesConst.MapBtnPlaceXY_upSkin, 360, 3, 26, 26, this);
			
			DisplayUtil.setEnabled(_txtX, false);
			DisplayUtil.setEnabled(_txtY, false);
			DisplayUtil.setEnabled(_txtMapName, false);
			DisplayUtil.setEnabled(_lX, false);
			DisplayUtil.setEnabled(_lY, false);
			
			_btnCur.configEventListener(MouseEvent.CLICK, curPointHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_txtName.dispose(isReuse);
			_txtMapName.dispose(isReuse);
			_lX.dispose(isReuse);
			_txtX.dispose(isReuse);
			_lY.dispose(isReuse);
			_txtY.dispose(isReuse);
			_btnCur.dispose(isReuse);
			
			_txtName = null;
			_txtMapName = null;
			_lX = null;
			_txtX = null;
			_lY = null;
			_txtY = null;
			_btnCur = null;
		}
		
		private function curPointHandler(evt:MouseEvent):void
		{
			_txtX.text = RolePlayer.instance.x2d.toFixed();
			_txtY.text = RolePlayer.instance.y2d.toFixed();
			_txtMapName.text = GameMapConfig.instance.getMapInfo(Game.mapInfo.mapId).name;
			_myData.mapId = Game.mapInfo.mapId;
		}
	}
}