package mortal.game.view.common
{
	import Message.Public.EKickOutReason;
	
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.manager.BrowerManager;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.utils.HTMLUtil;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.utils.Dictionary;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ImagesConst;
	import mortal.mvc.core.View;

	public class KillUserView extends View
	{
		private var _avatar:Bitmap;
		private var _bg:Bitmap;
		private var _line:Bitmap;
		private var _tipTxt:TextField;
		private var _contentTxt:TextField;
		private var _reLoginTxt:TextField;
		
		public function KillUserView()
		{
			init();
		}
		
		private function init():void
		{
			_avatar = new Bitmap();
			this.addChild(_avatar);
			
			UIFactory.bg(110,45,329,150,this,ImagesConst.KillUserBg); 
			
			UIFactory.bg(115,160,320,2,this,ImagesConst.KillUserLine);
			
			_tipTxt = UIFactory.textField("",140,50,290,135,this); 
			_tipTxt.autoSize = TextFieldAutoSize.LEFT;
			_tipTxt.multiline = true;
//			_tipTxt.htmlText = "<textFormat leading='5'>"+HTMLUtil.addColor("亲爱的仙友，您暂时与服务器失去了连接\n可能是出于下面的原因：\n①.您的账号重复登录了\n②.您掉线了••••••\n③.您的网络不稳定••••••\n④.服务器维护中••••••\n请放心，我们已经保存了您的数据，请重新载入\n","#ffffff")+"</textFormat>";
			_tipTxt.htmlText = "<textFormat leading='5'>"+HTMLUtil.addColor(Language.getString(10008),"#ffffff")+"</textFormat>";
			
			_contentTxt = UIFactory.textField("",140,105,290,135,this,new GTextFormat(FontUtil.songtiName,12,0xffffff)); 
			_contentTxt.multiline = true;
			
			_reLoginTxt = UIFactory.textField("",315,170,220,30,this,new GTextFormat(FontUtil.songtiName,16,0x60e71e));
			_reLoginTxt.htmlText = "<a href='event:1'>"+ Language.getString(10009) +"</a>";
			_reLoginTxt.addEventListener(TextEvent.LINK,onReloadClickHandler);
			
			LoaderManager.instance.load("zhiyin.png",onAvatarLoaded);
			
		}
		
		private function getErrorStrByType( value:int ):String
		{
			var ary:Array = Language.getArray(10007);
			var obj:Object;
			for( var i:int=0;i<ary.length;i++ )
			{
				obj = ary[i];
				if( obj.name == value.toString() )
				{
					return obj.label;
				}
			}
			return "";
		}
		
		/**
		 *更新踢出内容 
		 * @param type
		 * 
		 */		
		public function updateContentByType(type:int):void
		{
			var content:String = getErrorStrByType(type);
			var tip:String = Language.getString(10006);//"\n\n请放心，我们已经保存了您的数据，请重新载入";
//			if(type == EKickOutReason._EKickOutReasonByCloseGate)
//			{
//				content = "重启网关服务器！";
//			}
//			else if(type == EKickOutReason._EKickOutReasonByCloseCell)
//			{
//				content = "重启CELL服务器！";
//			}
//			else if(type == EKickOutReason._EKickOutReasonByCloseGateMgr)
//			{
//				content = "重启网关服务器！";
//			}
//			else if(type == EKickOutReason._EKickOutReasonByCloseInterMgr)
//			{
//				content = "共用服务器关闭！";
//			}
//			else if(type == EKickOutReason._EKickOutReasonByCloseDbApp)
//			{
//				content = "数据库关闭！";
//			}
//			else if(type == EKickOutReason._EKickOutReasonByElseLogin)
//			{
//				content = "你的账号在其他客户端登录！";
//			}
			_contentTxt.htmlText = "<textFormat leading='5'>"+HTMLUtil.addColor(content,"#f0ea3f")+tip+"</textFormat>";
		}
		
		private function onAvatarLoaded( imageInfo:ImageInfo ):void
		{
			_avatar.bitmapData = imageInfo.bitmapData;
		}
		
		public override function hide():void
		{
			LayerManager.highestLayer.removePopup(this);
		}

		public override function show(x:int=0, y:int=0):void
		{
			LayerManager.highestLayer.addPopUp(this,true);
			LayerManager.highestLayer.centerPopup(this);
			EffectManager.addUIMask([],0);
			KeyBoardManager.instance.cancelListener();
		}
		
		private function onReloadClickHandler(e:TextEvent):void
		{
			BrowerManager.instance.reload();
		}
	}
}