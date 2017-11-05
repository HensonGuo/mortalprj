package mortal.game.view.common.alertwins
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.mui.controls.Alert;
	import com.mui.controls.GAlertWin;
	import com.mui.controls.GButton;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.WindowEvent;
	import mortal.game.resource.ImagesConst;
	
	public class TimerAlertWin extends GAlertWin
	{
		private var _secTimer:SecTimer;
		private var _btnLabel:String;
		private var _timeNO:Boolean;
		
		public function TimerAlertWin(stageWidth:Number,stageHeight:Number)
		{
			super(stageWidth,stageHeight);

			addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStageHandler);
		}
		
		/**
		 * 设置时间 
		 * 
		 */
		private function createTimer():void
		{
			if(Alert.timerOut <= 0)
			{
				return;
			}
			
			if(!_secTimer)
			{
				_secTimer = new SecTimer(1,Alert.timerOut);
				_secTimer.addListener(TimerType.COMPLETE,onTimerCompleteHandler);
				_secTimer.addListener(TimerType.ENTERFRAME,onEnterFrameHandler);
			}
			
			_secTimer.repeatCount = Alert.timerOut;
			
			if(!_secTimer.running)
			{
				_secTimer.start();
			}
			
		}
		
		/**
		 * 时间完成 
		 * @param timer
		 * 
		 */
		private function onTimerCompleteHandler(timer:SecTimer):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			
			if(closeHandler != null)
			{
				if(_timeNO)
				{
					if(extendObj != null)
					{
						closeHandler(Alert.CANCEL,extendObj);
					}
					else
					{
						closeHandler(Alert.CANCEL);
					}
				}
				else
				{
					if(extendObj != null)
					{
						closeHandler(Alert.OK,extendObj);
					}
					else
					{
						closeHandler(Alert.OK);
					}
				}
			}
		}
		
		/**
		 * 时间触发间隔
		 * @param timer
		 * 
		 */
		private function onEnterFrameHandler(timer:SecTimer):void
		{
			var targetBtn:GButton;
			if(_timeNO)
			{
				targetBtn = getBtnByName(Alert.CANCEL);
			}
			else
			{
				targetBtn = getBtnByName(Alert.OK);
			}
			
			if(targetBtn != null)
			{
				targetBtn.label = _btnLabel + "(" + timer.repeatCount + ")";
			}
		}
		
		/**
		 * 移除 
		 * @param event
		 * 
		 */
		private function onRemovedFromStageHandler(event:Event):void
		{
			if(_secTimer && _secTimer.running)
			{
				_secTimer.stop();
				_secTimer.isDelete = false;
			}
		}
		
		/**
		 * 返回某个按钮 
		 * @param name
		 * @return 
		 * 
		 */
		private function getBtnByName(name:int):GButton
		{
			var button:GButton;
			for each(button in allButtons)
			{
				if(button.name == "btn_" + name)
				{
					return button;
				}
			}
			return null;
		}
		
		override protected function createChildren():void
		{
			if(Alert.title == null)
			{
				title = GlobalClass.getBitmap(ImagesConst.Title_Tips);
			}
			
			_timeNO = Alert.timerNO;
			
			if(_timeNO)
			{
				_btnLabel = Alert.calcelLabel;
				Alert.calcelLabel += "(" + Alert.timerOut + ")";
			}
			else
			{
				_btnLabel = Alert.okLabel;
				Alert.okLabel += "(" + Alert.timerOut + ")";
			}
			super.createChildren();
		}
		
		override protected function childrenCreated():void
		{
			if(Alert.title is String)
			{
				//(title as TextField).htmlText = Alert.title;
			}
			else
			{
				if(!Alert.title)
				{
					title = GlobalClass.getBitmap("Title_Tips");
				}
				else
				{
					title = Alert.title;
				}
			}
			
			message.multiline = true;
			message.htmlText = Alert.text;
			
			var buttonContainer:Sprite = new Sprite();
			var j:int = allButtons.length;
			for (var i:int = 0; i < j; i++)
			{
				var vButton:DisplayObject = allButtons[i];
				vButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);
				buttonContainer.addChild(vButton);
				
				vButton.x = i * (Alert.buttonWidth + 25);
			}
			
			var iconAndMessage:Sprite = new Sprite();
			iconAndMessage.addChild(message);
			if (icon)
			{
				iconAndMessage.addChild(icon);
				message.x = icon.width + 15;
			}
			
			
			var vTotalBoderWidth:int = boarderWidth * 2 + 10;
			var myWidth:Number = Math.max(title.width + vTotalBoderWidth, message.width + vTotalBoderWidth, buttonContainer.width + vTotalBoderWidth, minWidth);
			if(myWidth < 260)
			{
				myWidth = 260;
			}
			
			var myHeight:Number = 60 + message.height + Alert.buttonHeight + 45;

			var middlePaneBg:ScaleBitmap = ResourceConst.getScaleBitmap("WindowCenterB");
			middlePaneBg.width = myWidth - 34;
			middlePaneBg.height =  myHeight - 52;
			middlePaneBg.x = 17;
			middlePaneBg.y = 41;
			
			message.x = middlePaneBg.x + middlePaneBg.width / 2 - message.width / 2;
			message.y = 55;
			buttonContainer.x = (myWidth - (Alert.buttonWidth + 25)* allButtons.length + 25) / 2;
			buttonContainer.y = 60 + message.height + 15;//message.y + message.height + 20;
			boarder.width = myWidth;
			boarder.height = 150;
			
			_promptBackground = new BaseWindow();
			(_promptBackground as BaseWindow).titleHeight = 30;
			(_promptBackground as BaseWindow).closeBtn.visible = false;
			
			var flagsList:Array = getButtonFlagsList();
			if(flagsList[3] == 1)
			{
				//winBg._closeBtn.visible = true;
			}
			
			prompt = new Sprite();
			prompt.addChild(_promptBackground);
			//			prompt = winBg;
			title.y = (30 - title.height)/2;
			title.x = (myWidth - title.width)/2;
			(_promptBackground as BaseWindow).setSize(myWidth, myHeight);
			if(Alert.title is String)
			{
				(_promptBackground as BaseWindow).title = Alert.title;
			}
			
			addChild(background);
			prompt.addChild(title);
			prompt.addChild(middlePaneBg);
			prompt.addChild(message);
			if (icon)
			{
				addChild(icon);
			}
			prompt.addChild(buttonContainer);
			addChild(prompt);
			
			prompt.x = (stageWidth - prompt.width) / 2;
			prompt.y = (stageHeight - prompt.height) / 2;
			
			createTimer();
		}
		
		override protected function createButtons():Vector.<GButton>
		{
			var allButtons:Vector.<GButton> = new Vector.<GButton>;
			var flagsList:Array = getButtonFlagsList();
			
			if (flagsList[0] == 1)
			{
				allButtons.push(CreateButton(Alert.yesLabel,Alert.YES));
			}
			
			if (flagsList[1] == 1)
			{
				allButtons.push(CreateButton(Alert.noLabel,Alert.NO));
			}
			
			if (flagsList[2] == 1)
			{
				allButtons.push(CreateButton(Alert.okLabel,Alert.OK));
			}
			
			if (flagsList[3] == 1)
			{
				allButtons.push(CreateButton(Alert.calcelLabel,Alert.CANCEL));
			}
			return allButtons;
		}
		
		private function CreateButton(label:String,iFlag:int):GButton
		{
			var btn:GButton = new GButton();
			btn.label = label;
			btn.width = Alert.buttonWidth;
			btn.height = Alert.buttonHeight;
			btn.name = "btn_" + iFlag;
			Alert.buttonStyleName = "Button";
			btn.styleName = Alert.buttonStyleName;
			return btn;
		}
	}
}