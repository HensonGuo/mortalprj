package mortal.game.view.relive
{
	import com.gengine.global.Global;
	import com.mui.controls.Alert;
	import com.mui.controls.GButton;
	import com.mui.controls.GLabel;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	public class RevivalPropWindow extends BaseWindow
	{
		private var _goldTxt:GTextFiled;
		private var _propTxt:GTextInput;
		public function RevivalPropWindow()
		{
			super();
			setSize(280,195);
//			var text:TextField = new TextField();
//			text.text = "生死轮回";
//			text.setTextFormat(new GTextFormat("",16,0xf6fffd));
			title = Language.getString(20812);//"购买";
			titleHeight = 30;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			var sprite:Sprite = new Sprite();
			sprite.x = 17;
			sprite.y = 42;
			addChild(sprite);
			
			var scaleBg:ScaleBitmap=ResourceConst.getScaleBitmap(ImagesConst.WindowCenterB);
			scaleBg.x=0;
			scaleBg.y=0;
			scaleBg.width=245;
			scaleBg.height=140;
			sprite.addChild(scaleBg);
			
			_goldTxt = UIFactory.gTextField("",82,36,30,20,sprite,new GTextFormat("",12,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER));
			_goldTxt.selectable = false;
			_goldTxt.text = "10";
			
			_propTxt = UIFactory.gTextInput(164,36,30,18,sprite);
			_propTxt.text = "1";
			_propTxt.restrict = "0-9";
			_propTxt.addEventListener(Event.CHANGE, onPropNumChangeHandler);
			
			var descLabel:GLabel=new GLabel();
			descLabel.x=0;
			descLabel.y=15;
			descLabel.width=240;
			descLabel.height=100;
			descLabel.mouseChildren=false;
			descLabel.mouseEnabled=false;
			descLabel.textField.defaultTextFormat=new GTextFormat(FontUtil.songtiName, 12, null, null, null, null, null, null, null, null, null, null, 6);
//			var str:String = "<p align='center'><font size='12'><font color='#ffffff'>抱歉！您的“生死轮回”道具不足。</font>\n";
//			str += "<font color='#f5ff00'>是否花费    元宝购买 		个</font>\n";
//			str += "<font color='#f5ff00'>“生死轮回”道具？</font>\n";
//			str += "<font color='#ffffff'>点击确定购买并使用</font><font></p>\n";
			var str:String = Language.getString(20813);
			descLabel.htmlText = str;
			sprite.addChild(descLabel);
			
			var sureBtn:GButton = UIFactory.gButton(Language.getString(69901),50,105,60,25,sprite,"Button");//"确定"
			sureBtn.addEventListener(MouseEvent.CLICK, onSureBtnClickHandler);
			
			var cancelBtn:GButton = UIFactory.gButton(Language.getString(69902),140,105,60,25,sprite,"Button");//"取消"
			cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnHandler);
		}
		
		private function onPropNumChangeHandler(e:Event):void
		{
			var propNum:int = parseInt(_propTxt.text);
			if(propNum <= 99)
			{
				_goldTxt.text = (propNum * 10).toString();
			}
			else
			{
				_goldTxt.text = "990";
				_propTxt.text = "99";
			}
		}
		
		private function onSureBtnClickHandler(e:Event):void
		{
			var propNum:int = parseInt(_propTxt.text);
			var gold:int = Cache.instance.role.money.gold + Cache.instance.role.money.goldBind;
			if(gold >= propNum*10)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.Role_Relive_SureBuyProp,propNum));
			}
			else
			{
				Alert.show(Language.getString(20814),null,Alert.OK|Alert.CANCEL,null,onClickHandler);//"抱歉，您的元宝不足，是否立即充值？"
				function onClickHandler(index:int):void
				{
					if(index==Alert.OK)
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.GotoPay));
						Alert.resetToDefault();
					}
				}
			}
		}
		
		private function onCancelBtnHandler(e:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.Role_Relive_CancelBuyProp));
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			super.show(x,y);
			_goldTxt.text = "10";
			_propTxt.text = "1";
		}
	}
}