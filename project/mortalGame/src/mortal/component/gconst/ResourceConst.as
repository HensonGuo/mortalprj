package mortal.component.gconst
{
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import mortal.game.resource.ImagesConst;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 静态资源 
	 * @author jianglang
	 * 
	 */	
	public class ResourceConst
	{
		private static var _defaultRec:Rectangle = new Rectangle(0,0,1,1);
		
		// 196 72
		public static var _scaleMap:Object = {
			WindowBg:new Rectangle(164,114,1,1),
			WindowBg2:new Rectangle(45,52,1,1),
			WindowBgSmall:new Rectangle(115,75,1,1),
			WindowCenterA:new Rectangle(20,31,36,37),
			ChatWindowBg:new Rectangle(30,38,1,1),
			WindowCenterB:new Rectangle(4,4,66,124),
			WindowCenterB2:new Rectangle(75,58,1,1),
			InputBg:new Rectangle(15,10,1,4),
			ToolTipBg:new Rectangle(10, 10, 9, 19),
			ToolTipBgBai:new Rectangle(51, 76, 1, 1),
			ToolTipBgHong:new Rectangle(51, 76, 1, 1),
			ToolTipBgLv:new Rectangle(51, 76, 1, 1),
			ToolTipBgLan:new Rectangle(51, 76, 1, 1),
			ToolTipBgZi:new Rectangle(51, 76, 1, 1),
			ToolTipBgCheng:new Rectangle(51, 76, 1, 1),
			MenuBg:new Rectangle(16,18,1,1),
			SplitLine:new Rectangle(83,0,1,2),
			ComboBg:new Rectangle(18,10,1,4),
			ComboboxCell_over:new Rectangle(46,10,1,1),
			expBg:new Rectangle(36,1,70,4),
			expBar:new Rectangle(15,3,20,1),
			DisabledBg:new Rectangle(15,3,50,1),
			Disable2:new Rectangle(26,12,1,1),
			RoleBarBg:new Rectangle(15,3,50,1),
			ShenminBar:new Rectangle(10,3,1,1),
			LanBar:new Rectangle(10,3,20,1),
			JinyanBar:new Rectangle(10,3,20,1),
			RoleInfoBg:new Rectangle(37,66,1,1),
			AvatarXueBar:new Rectangle(10,3,1,1),
			AvatarLanBar:new Rectangle(15,3,50,1),
			ShopMallBg:new Rectangle(135,110,2,2),
			GroupBtn:new Rectangle(10,10,2,2),
			LimitBuyBg:new Rectangle(70,115,2,2),
			GoodsBg:new Rectangle(30,30,2,2),
			DisabledBg:new Rectangle(10,10,2,2),
			PetLifeBg:new Rectangle(17,6,1,1),//血管底
			PetNameBg:new Rectangle(63,13,1,1),//名字底
			SelectBg:new Rectangle(40,10,1,1),
			selectedBg:new Rectangle(20,20,1,1),
			ComboBox:new Rectangle(10,10,2,2),
			InputDisablBg:new Rectangle(10,10,2,2),
			ChatSendBg:new Rectangle(55,15,2,2),
			ChatPanelBg:new Rectangle(70,35,1,1),
			selectFilter:new Rectangle(17,15,1,1),//选择滤镜
			WindowBgC:new Rectangle(30,30,15,15),//大喇叭背景
			StrengthenBarBg:new Rectangle(14,2,1,1),
			StrengthenBar:new Rectangle(14,2,1,1),
			ChatMenuBg:new Rectangle(27,30,2,2),//聊天背景
			ChatNotesBg:new Rectangle(5,5,1,1),//聊天历史信息背景
			Menu_overSkin:new Rectangle(23,7,1,1),//
			Menu2_overSkin:new Rectangle(20,10,1,1),//聊天选择背景
			ChatOtherTalkBg:new Rectangle(30,12,1,1),//聊天别人说话背景
			ChatSelfTalkBg:new Rectangle(20,12,1,1),//聊天自己说话背景
			TextBg2:new Rectangle(25,14,1,1),
			MarketCatogeryBtn:new Rectangle(44,12,1,1),
			guildNoticeBg:new Rectangle(70,35,1,1),
			WindowBgLine:new Rectangle(74,2,1,1),
			SceneTalkOtherBg:new Rectangle(47, 28, 1, 1),
			SceneTalkSelfBg:new Rectangle(47, 28, 1, 1),
			taskItemSelected:new Rectangle(20, 10, 1, 1),
			petSealUpBg:new Rectangle(33, 41, 1, 1),
			petSealDownBg:new Rectangle(33, 41, 1, 1),
			JinbiBig:new Rectangle(30,30,1,1),
			YuanbaoBig:new Rectangle(30,30,1,1),
			PanelBg:new Rectangle(22,11,1,1),
			Call2Bg:new Rectangle(58,10,1,1),
			RolePowerBg:new Rectangle(43,11,1,1),
			PackBtn:new Rectangle(12,12,1,1),
			
			
			//血管
			PetLifeBg:new Rectangle(17,6,1,1),
			PetExp:new Rectangle(50,1,1,9),
			lifeBg:new Rectangle(4,3,17,2),
			lifeTop:new Rectangle(4,3,17,2),
			PetLife:new Rectangle(48,5,1,1),
			EnterCopyBtn:new Rectangle(44, 17, 1, 1),
			EnterCopyBtn_upSkin:new Rectangle(44, 17, 1, 1),
			EnterCopyBtn_overSkin:new Rectangle(44, 17, 1, 1),
			RedButton:new Rectangle(30, 14, 2, 2),
			GreenProcessPoint:new Rectangle(2, 3, 3, 6),
			SystemSetBarBg:new Rectangle(15, 5, 1, 1),
			SelsetBg:new Rectangle(21,19,1,1),
			
			//ItemBg
			shortcutItemBg:new Rectangle(5,4,29,30),
			TextBg:new Rectangle(45, 10, 4, 2),
			TextBgDisable:new Rectangle(45, 10, 4, 2),
			LevelBg:new Rectangle(8, 8, 4, 4),
			SkillRuneBg:new Rectangle(10, 10, 20, 20),
			SkillRuneBgDisable:new Rectangle(10, 10, 20, 20),
			RegionTitleBg:new Rectangle(45,10, 1, 1)
		};

		
		public function ResourceConst()
		{
			
		}
		
		/**
		 * 获取一个纯色的ScaleBitmap 
		 * @param color
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function getScaleColor(color:uint,x:Number = 0,y:Number = 0,width:Number = -1,height:Number = -1,parent:DisplayObjectContainer = null):ScaleBitmap
		{
			var rec:Rectangle = new Rectangle(1,1,1,1);
			
			var sb:ScaleBitmap;
			var bmd:BitmapData = GlobalClass.getBitmapDataByColor(color);
			if(bmd != null)
			{
				sb = UICompomentPool.getUICompoment(ScaleBitmap) as ScaleBitmap;
				sb.bitmapData = bmd.clone();
				sb.createDisposeChildren();
				sb.scale9Grid = rec;
			}
			
			sb.x = x;
			sb.y = y;
			if(width > 0)
			{
				sb.width = width;
			}
			if(height > 0)
			{
				sb.height = height;
			}
			if(parent != null)
			{
				parent.addChild(sb);
			}
			return sb;
		}
		
		public static function getScaleBitmap( className:String ,x:Number = 0,y:Number = 0,width:Number = -1,height:Number = -1,parent:DisplayObjectContainer = null):ScaleBitmap
		{
			var rec:Rectangle = getRectangle(className);
			var sb:ScaleBitmap = GlobalClass.getScaleBitmap(className,rec);
			sb.x = x;
			sb.y = y;
			if(width > 0)
			{
				sb.width = width;
			}
			if(height > 0)
			{
				sb.height = height;
			}
			if(parent != null)
			{
				parent.addChild(sb);
			}
			return sb;
		}
		
		public static function getRectangle(className:String):Rectangle
		{
			var rec:Rectangle = _scaleMap[className] as Rectangle;
			if(!rec)
			{
				rec = _defaultRec;
			}
			return rec;
		}
	}
}