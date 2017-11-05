package mortal.game.view.friend
{
	import Message.Game.SFriendRecord;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;

	/**
	 * 选择待删除列表中的好友项
	 * @date   2014-2-26 上午9:50:29
	 * @author dengwj
	 */	 
	public class SelectedCellRenderer extends GCellRenderer
	{
		/** 等级 */
		private var _roleLevel:GTextFiled;
		/** 职业 */
		private var _roleCareer:GTextFiled;
		/** 阵营 */
		private var _roleCamp:GTextFiled;
		/** 名字 */
		private var _roleName:GTextFiled;
		/** 战斗力 */
		private var _fightValue:GTextFiled;
		private var _spr:Sprite;
		/** 是否已被选择 */
		private var _isSelected:Boolean;
		/** 好友记录ID */
		private var _recordId:Number;
		/** 玩家ID */
		private var _roleId:int;
		
		/** 数据 */
		private var _friendInfo:SFriendRecord;
		
		public function SelectedCellRenderer()
		{
			super();
			this.setSize(313, 24);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this._spr = new Sprite();
			this.addChild(_spr);
			
			_roleLevel  = UIFactory.gTextField("99级",15,2,32,20,this);
			_roleCareer = UIFactory.gTextField("狂战神",50,2,44,20,this);
			_roleCamp   = UIFactory.gTextField("神域",97,2,31,20,this);
			_roleName   = UIFactory.gTextField("玩家名字7个字",134,2,98,20,this);
			_fightValue = UIFactory.gTextField("999999",248,2,45,20,this);
			_fightValue.textColor = 0xff5a00;
			this.pushUIToDisposeVec(UIFactory.bg(0,25,306,1,this,ImagesConst.SplitLine));
			
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			var selectSkin:ScaleBitmap = UIFactory.bg(0,0,0,0,null,ImagesConst.SelectBg);
			this.setStyle("downSkin",selectSkin);
			this.setStyle("overSkin",selectSkin);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override public function set data(arg0:Object):void
		{
			super._data        = arg0;
			
			this._friendInfo   = arg0.data;
			_roleLevel.text    = _friendInfo.friendPlayer.level + "级";
			_roleCareer.text   = GameDefConfig.instance.getECareer(_friendInfo.friendPlayer.career).text;
			_roleCamp.htmlText = GameDefConfig.instance.getCampHtml(_friendInfo.friendPlayer.camp);
			_roleName.text     = _friendInfo.friendPlayer.name;
			_recordId          = _friendInfo.recordId;
			_fightValue.text   = "" + _friendInfo.friendPlayer.combat;
		}
		
		/**
		 * 设置选中后红色显示
		 */
		public function set isSelected(value:Boolean):void
		{
			this._isSelected = value;
			if(value)
			{
				_roleLevel.textColor  = 0xff0000;
				_roleCareer.textColor = 0xff0000;
				_roleCamp.textColor   = 0xff0000;
				_roleName.textColor   = 0xff0000;
				_fightValue.textColor = 0xff0000;
			}
			else
			{
				_roleLevel.textColor  = 0xB1efff;
				_roleCareer.textColor = 0xB1efff;
				_roleCamp.htmlText    = GameDefConfig.instance.getCampHtml(_friendInfo.friendPlayer.camp);
				_roleName.textColor   = 0xB1efff;
				_fightValue.textColor = 0xff5a00;
			}
		}
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function get roleName():String
		{
			return this._roleName.text;
		}
		
		public function get recordId():Number
		{
			return this._recordId;
		}
		
		public function get roleId():int
		{
			return this._roleId;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_roleLevel.dispose(isReuse);
			_roleCareer.dispose(isReuse);
			_roleCamp.dispose(isReuse);
			_roleName.dispose(isReuse);
			_fightValue.dispose(isReuse);
			
			_roleLevel = null;
			_roleCareer = null;
			_roleCamp = null;
			_roleName = null;
			_fightValue = null;
		}
		
	}
}