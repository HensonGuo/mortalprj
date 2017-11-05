/**
 * @date 2011-3-11 下午05:44:51
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.selectPanel
{
	import com.mui.controls.GButton;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.mvc.core.Dispatcher;

	public class ShieldTypePanel extends CallSprite
	{
		private var _dataArray:Array;
		private var _dicBtnShieldObj:Dictionary;
		public function ShieldTypePanel(dataArray:Array)
		{
			super();
			_dicBtnShieldObj = new Dictionary();
			_dataArray = dataArray;
			for(var i:int = 0;i<_dataArray.length;i++)
			{
				(_dataArray[i] as Object).isShield = false;
			}
			createChildren();
		}
		
		private function createChildren():void
		{
			//背景
			var	scaleBg:ScaleBitmap = ResourceConst.getScaleBitmap("ToolTipBg");
			scaleBg.width = 72;
			scaleBg.height = _dataArray.length*25 + 10;
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
			btn.y = i*25 + 5;
			btn.width = 60;
			btn.height = 24;
			btn.styleName = "ChatTabBtn";
			btn.name = data["name"];
			btn.label = data["label"];
			btn.textField.filters = [FilterConst.glowFilter];
			btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			this.addChild(btn);
			
			var	gag:Bitmap = GlobalClass.getBitmap("Gag");
			gag.x = 6;
			gag.y = 5;
			gag.width = 14;
			gag.height = 14;
			gag.visible = false;
			btn.addChild(gag);
			
			_dicBtnShieldObj[btn] = gag;
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var obj:Object = getObjByName((e.target as GButton).name);
			if(obj)
			{
				if(obj["isShield"])
				{
					obj["isShield"] = false;
					(_dicBtnShieldObj[e.target] as DisplayObject).visible = false;
					(e.target as GButton).label = obj["label"];
				}
				else
				{
					obj["isShield"] = true;
					(_dicBtnShieldObj[e.target] as DisplayObject).visible = true;
					(e.target as GButton).label = "    " + obj["label"];
				}
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChatShield,{label:obj["label"],isShield:obj["isShield"]}));
			}
//			CallAll((e.target as GButton).label);
//			this.visible = false;
		}
		
		public function getNotShieldNameList():Array
		{
			var shieldList:Array = new Array();
			for each(var obj:Object in _dataArray)
			{
				if(!obj["isShield"])
				{
					shieldList.push(obj["name"]);
				}
			}
			return shieldList;
		}
		
		private function getObjByName(name:String):Object
		{
			for each(var obj:Object in _dataArray)
			{
				if(obj.hasOwnProperty("name") && obj["name"] == name)
				{
					return obj;
				}
			}
			return null;
		}
	}
}