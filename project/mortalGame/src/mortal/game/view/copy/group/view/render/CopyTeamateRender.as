/**
 * 2014-3-18
 * @author chenriji
 **/
package mortal.game.view.copy.group.view.render
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.LoaderHelp;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.copy.group.view.data.CopyTeamateData;
	import mortal.mvc.core.Dispatcher;
	
	public class CopyTeamateRender extends GCellRenderer
	{
		private var _icon:GBitmap;
		private var _txtName:GTextFiled;
		private var _txtCarrer:GTextFiled;
		private var _txtStrength:GTextFiled;
		private var _txtNum:GTextFiled;
		private var _leadIcon:GBitmap;
		private var _btnClose:GLoadedButton;
		
		private var _myData:CopyTeamateData;
		
		public function CopyTeamateRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_myData = value as CopyTeamateData;
			var camp:int = _myData.player.camp;
			_icon.bitmapData = GlobalClass.getBitmapData(AvatarUtil.getPlayerAvatar(_myData.player.career, _myData.player.sex, 2));//GlobalClass.getBitmapData(GameDefConfig.instance.getECarrerSmallPic(_myData.player.career));
			_txtName.text = _myData.player.name;
			_txtCarrer.htmlText = HTMLUtil.addColor(GameDefConfig.instance.getECamp(camp).text,
				GameDefConfig.instance.getECamp(camp).text1);
			_txtStrength.text = Language.getStringByParam(20195) + _myData.player.combat.toString();
			_txtNum.htmlText = Language.getStringByParam(20196, _myData.todayNum.toString() + "/" + _myData.maxNum.toString());
			
			if(_myData.isCaptin)
			{
//				if(_myData.player.name != Cache.instance.role.entityInfo.name)
//				{
//					if(_btnClose == null)
//					{
//						_btnClose = UIFactory.gLoadedButton("CloseButtonSmall", 166, 0, 22, 22, null);
//						_btnClose.focusEnabled = true;
//						_btnClose.configEventListener(MouseEvent.CLICK, kickTeamateHandler);
//					}
//					this.addChild(_btnClose);
//				}
//				else
//				{
//					DisplayUtil.removeMe(_btnClose);
//				}
				if(_leadIcon == null)
				{
					_leadIcon = UIFactory.bitmap(ImagesConst.SmallCatain, 0, 0, this);
				}
				this.addChild(_leadIcon);
			}
			else
			{
				DisplayUtil.removeMe(_btnClose);
				DisplayUtil.removeMe(_leadIcon);
			}
			
			// 玩家离线，远离
			if(!_myData.player.online)
			{
				this.filters = [FilterConst.colorFilter];
			}
			if(!_myData.isInRange)
			{
				this.filters = [FilterConst.colorFilter];
			}
			else
			{
				this.filters = [];
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl(); 
			_icon = UIFactory.gBitmap(null, 10, 10, this);
			_txtName = UIFactory.gTextField("", 78, 3, 200, 20, this);
			_txtCarrer = UIFactory.gTextField("", 78, 18, 200, 20, this);
			_txtStrength = UIFactory.gTextField("", 78, 33, 200, 20, this);
			_txtNum = UIFactory.gTextField("", 78, 48, 200, 20, this);
			
			LoaderHelp.addResCallBack(ResFileConst.petNavBg, resGotHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_icon.dispose(isReuse);
			_icon = null;
			
			_txtName.dispose(isReuse);
			_txtName = null;
			
			_txtCarrer.dispose(isReuse);
			_txtCarrer = null;
			
			_txtStrength.dispose(isReuse);
			_txtStrength = null;
			
			_txtNum.dispose(isReuse);
			_txtNum = null;
			
			if(_leadIcon != null)
			{
				_leadIcon.dispose(isReuse);
				_leadIcon = null;
			}
			
			if(_btnClose != null)
			{
				_btnClose.dispose(isReuse);
				_btnClose = null;
			}
			
			_myData = null;
		}
		
		private function kickTeamateHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.KickOut, _myData.player.entityId));
		}
		
		public override function set selected(arg0:Boolean):void
		{
			super.selected = arg0;
			if(arg0 && _myData.amICaptin && _myData.player.name != Cache.instance.role.entityInfo.name)
			{
				if(_btnClose == null)
				{
					_btnClose = UIFactory.gLoadedButton("CloseButtonSmall", 167, 0, 22, 22, null); 
					_btnClose.configEventListener(MouseEvent.CLICK, kickTeamateHandler);
				}
				this.addChild(_btnClose);
			}
			else
			{
				DisplayUtil.removeMe(_btnClose);
			}
		}
		
		private static var rect:Rectangle = new Rectangle(78, 35, 1, 1);
		private function resGotHandler():void
		{
			this.setStyle("downSkin",GlobalClass.getScaleBitmap(ImagesConst.PetNav_overSkin, rect));
			this.setStyle("overSkin",GlobalClass.getScaleBitmap(ImagesConst.PetNav_overSkin, rect));
			this.setStyle("upSkin",GlobalClass.getScaleBitmap(ImagesConst.PetNav_upSkin, rect));
			this.setStyle("selectedDownSkin",GlobalClass.getScaleBitmap(ImagesConst.PetNav_overSkin, rect));
			this.setStyle("selectedOverSkin",GlobalClass.getScaleBitmap(ImagesConst.PetNav_overSkin, rect));
			this.setStyle("selectedUpSkin",GlobalClass.getScaleBitmap(ImagesConst.PetNav_overSkin, rect));
		}
	}
}