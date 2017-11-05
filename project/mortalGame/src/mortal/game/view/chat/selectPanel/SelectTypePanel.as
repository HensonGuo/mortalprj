/**
 * @date 2011-3-11 下午12:10:38
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.selectPanel
{
	import com.mui.controls.GButton;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	
	public class SelectTypePanel extends CallSprite
	{
		private var _dataArray:Array;
		private var _aryBtn:Array = [];
		public function SelectTypePanel(dataArray:Array)
		{
			super();
			_dataArray = dataArray;
			createChildren();
		}
		
		private function createChildren():void
		{
			//背景
			var	scaleBg:ScaleBitmap = ResourceConst.getScaleBitmap(ImagesConst.ToolTipBg);
			scaleBg.width = 55;
			scaleBg.height = _dataArray.length*23 + 10;
			this.addChild(scaleBg);
			
			//按钮
			for(var i:int = 0;i<_dataArray.length;i++)
			{
				createButton(i,_dataArray[i]);
			}
		}
		
		private function createButton(i:int,data:Object):void
		{
			var btn:GButton = new GButton();
			btn.x = 6;
			btn.y = i*23 + 5;
			btn.width = 43;
			btn.height = 22;
			btn.styleName = "ChatBtn";
			btn.name = data["name"];
			btn.label = data["label"];
			btn.textField.filters = [FilterConst.glowFilter];
			btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			this.addChild(btn);
			_aryBtn.push(btn);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			callAll((e.target as GButton).name);
		}
		
		public function updateData(dataArray:Array):void
		{
			_dataArray = dataArray;
			//按钮
			for(var i:int = 0;i<_dataArray.length;i++)
			{
				(_aryBtn[i] as GButton).label = _dataArray[i]["label"];
			}
		}
	}
}