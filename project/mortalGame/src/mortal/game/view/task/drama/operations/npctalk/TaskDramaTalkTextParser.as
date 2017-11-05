package mortal.game.view.task.drama.operations.npctalk
{
	import Message.Public.ESex;
	
	import com.mui.controls.GTextFiled;
	
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import mortal.common.DisplayUtil;
	import mortal.game.cache.Cache;
	import mortal.game.view.common.UIFactory;
	
	public class TaskDramaTalkTextParser
	{
		public const Label_UserName:String = "{name}";
		public const Label_Choose:String = "{A,B}={";
		public const Label_Face:String = "   ";
		
		public function TaskDramaTalkTextParser()
		{
		}
		
		public function parse(txt:String, leading:int, size:int, width:int):Array
		{
			var res:Array = [];
			var text:String = txt;
			while(text.indexOf(Label_UserName) >= 0)
				text = text.replace(Label_UserName, "<font color='#00FE2A'>" + Cache.instance.role.playerInfo.name + "</font>");
			
			while(text.indexOf(Label_Choose) >= 0)
			{
				var arr:Array = []
				var index:int = text.indexOf(Label_Choose);
				arr[0] = text.substr(0, index);
				arr[1] = text.substr(index + Label_Choose.length);
				
				var textPre:String = arr[0];
				var textOff:String = arr[1];
				
				index = textOff.indexOf("}");
	
				var textOffPre:String = textOff.substr(0, index);
				var textOffOff:String = textOff.substr(index + 1);
				
				arr = textOffPre.split(",");
				if(Cache.instance.role.entityInfo.sex == ESex._ESexMan)
				{
					textOff = arr[0] + textOffOff;
				}
				else
				{
					textOff = arr[1] + textOffOff;
				}

				text = textPre + textOff;
			}
			
//			res.push(text); // 文本内容
			
			var tryText:GTextFiled = UIFactory.gTextField("", 0, 0, width, 400);
			var tf:TextFormat = tryText.defaultTextFormat;
			tf.leading = leading;
			tf.size = size;
			tryText.defaultTextFormat = tf;
			tryText.width = width;
			tryText.multiline = true;
			tryText.wordWrap = true;
			
			var faces:Array = [];
			for(var i:int = 0; i < text.length; i++)
			{
				if(text.charAt(i) != "/")
					continue;
				var len:int = 1;
				var faceId:int = -1;
				var str2:String = text.charAt(i + 1);
				var str3:String = text.charAt(i + 2);
				if(isNum(str2))
				{
					len++;
					faceId = parseInt(str2);
					if(isNum(str3))
					{
						len++;
						faceId = faceId * 10 + parseInt(str3);
					}
				}
				
				if(faceId >= 0 && faceId <= 71) // 表情范围
				{
					var arrStr1:String = text.substr(0, i);
					var arrStr2:String = text.substr(i + len);

					tryText.htmlText = arrStr1;
					var lineNum:int = tryText.numLines;
					var lineText:String = tryText.getLineText(lineNum - 1);
					var lastLineMetrics:TextLineMetrics = tryText.getLineMetrics(lineNum - 1);

					var face:TaskDramaTalkFaceData = new TaskDramaTalkFaceData();
					face.faceId = faceId;
					face.faceX = DisplayUtil.getStringPixes(lineText, size) + 3;
					face.faceY = (lineNum - 1) * (size + leading) - (22 - size)/2 + 1;
					faces.push(face);
					
					if(arrStr1 != null)
						text = arrStr1 + Label_Face;
					else
						text = Label_Face;
					if(arrStr2 != null)
						text += arrStr2;
				}
			}
			
			res.push(text);
			res.push(faces);
			return res;
		}
		
		private function isNum(str:String):Boolean
		{
			if(str < "0")
				return false;
			if(str > "9")
				return false;
			return true;
		}
	}
}