package mortal.game.scene3D.player.item
{
	import com.gengine.debug.Log;
	import com.mui.controls.GTextFiled;
	
	import flash.text.TextFieldAutoSize;
	
	import Message.BroadCast.SDropEntityInfo;
	import Message.DB.Tables.TMoneyConfig;
	import Message.Public.SPlayerItem;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.tableConfig.MoneyConfig;
	import mortal.game.scene3D.display3d.icon3d.Icon3D;
	import mortal.game.scene3D.display3d.icon3d.Icon3DFactory;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3D;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3DFactory;
	import mortal.game.scene3D.player.entity.Game2DOverPriority;
	import mortal.game.scene3D.player.entity.Game2DPlayer;
	import mortal.game.view.common.UIFactory;

	/**
	 * 掉落物品类
	 *
	 */
	public class ItemPlayer extends Game2DPlayer
	{
		protected var _dropEntityInfo:SDropEntityInfo;

		protected var icon:Icon3D;
		
		private var _textField:GTextFiled;
		private var _text3D:Text3D;
		
		public function ItemPlayer()
		{
			super();
			overPriority = Game2DOverPriority.Drop;
		}

		public function get dropEntityInfo():SDropEntityInfo
		{
			return _dropEntityInfo;
		}
		
		public function set dropEntityInfo(value:SDropEntityInfo):void
		{
			_dropEntityInfo = value;
			this.x2d = value.point.x;
			this.y2d = value.point.y;
			
			//显示图片、特效、文字等
			var playerItem:SPlayerItem = value.playerItems[0];
			var dropIcon:String;
			var name:String;
			if(playerItem)
			{
				var itemInfo:ItemInfo = ItemConfig.instance.getConfig(playerItem.itemCode);
				dropIcon = itemInfo.dropIcon;
				name = itemInfo.name;
			}
			else
			{
				//显示掉落金币
				name = "铜钱";
				var moneyInfo:TMoneyConfig = MoneyConfig.instance.getInfoByUint(value.unit);
				dropIcon = moneyInfo.icon;
			}
			
			if(dropIcon)
			{
				var isSWF:Boolean = dropIcon.indexOf(".swf") > -1;
				if (!isSWF)
				{
					var iconParams:Array = dropIcon.split("#");
	//				Log.debug("物品位置：" + this.x2d,this.y2d,iconParams);
					addIcon3D(iconParams[0] + ".png",iconParams[1],iconParams[2]);
				}
			}
			
			addTitle(name);
		}
		
		protected function addIcon3D(url:String,x:int,y:int):void
		{
			if(!icon)
			{
				Log.debug(url,x,y);
				icon = Icon3DFactory.instance.createicon3D(url, x, y);
			}
			this.addChild(icon);
		}

		/**
		 * 添加标题 
		 * @param value
		 * 
		 */
		protected function addTitle(value:String):void
		{
			if(!_textField)
			{
				_textField = UIFactory.textField("",0,0,-1,-1,null,GlobalStyle.textFormatItemWhite);
				_textField.autoSize = TextFieldAutoSize.LEFT;
				_textField.htmlText = value;
				
				_text3D = Text3DFactory.instance.createtext3D(_textField);
			}
			else
			{
				_textField.htmlText = value;
				Text3DFactory.instance.updateText3D(_text3D,_textField);
			}
			_text3D.x = -_text3D.textWidth/1.7;
			_text3D.y = 40;
			this.addChild(_text3D);
		}
		
		override public function hoverTest(disPlayX:Number,disPlayY:Number,mouseX:Number,mouseY:Number):Boolean
		{
			var recWidth:Number = 30;
			var recHeight:Number = 30;
			_displayRec.x = this.x2d - disPlayX - recWidth/2;
			_displayRec.y = this.y2d - disPlayY - recHeight/2;
			_displayRec.width = recWidth;
			_displayRec.height = recHeight;
			return _displayRec.contains(mouseX,mouseY);
		}
		
		
		override public function dispose(isReuse:Boolean = true):void
		{
			super.dispose(isReuse);
			_dropEntityInfo = null;
			if (icon)
			{
				Icon3DFactory.instance.disposeIcon3D(icon);
				icon = null;
			}
			if(_text3D)
			{
				Text3DFactory.instance.disposeText3D(_text3D);
				_text3D = null;
			}
			if(_textField)
			{
				_textField.dispose();
				_textField = null;
			}
		}
	}
}
