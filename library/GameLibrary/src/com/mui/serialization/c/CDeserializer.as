package com.mui.serialization.c
{
	
	public class CDeserializer extends Object
	{
		
		public function CDeserializer()
		{
		}
		
		
		/**
		 * 
		 * @param code
		 * @return 
		 * 
		 */	
		public static function getCleanCode(code:String) : String
		{
			var reg:RegExp;
			var i:int;
			var indexStart:int;
			var indexEnd:int;
			var sLine:String;
			var arrUsed:Array;
			var sData:String = code;
			
			reg = new RegExp("\t", "/g");
			sData = sData.replace(reg, "");
			while (sData.indexOf("/*") != -1)
			{
				indexStart = sData.indexOf("/*");
				indexEnd = sData.indexOf("*/") + 2;
				sData = Remove(sData, indexStart, indexEnd);
			}
			
			var sLinesOri:Array = sData.split("\r\n");
			var sNew:String = "";
			while (i < sLinesOri.length)
			{
				sLine = sLinesOri[i].toString();
				if (sLine.length == 0)
				{
				}
				else
				{
					arrUsed = sLine.split("//");
					if (arrUsed.length > 0)
					{
						sNew = sNew + (arrUsed[0] + "\r\n");
					}
				}
				i++;
			}
			return sNew;
		}
		
		
		/**
		 * 
		 * @param code
		 * @return 
		 * 
		 */	
		public static function GetMethodDefineSegments(code:String) : Array
		{
			var sBody:String;
			var nNextSemicolon:int;
			var nBraceFirst:int;
			var nBraceLast:int;
			var sCmd:String;
			var sCode:String = code;
			var arrReturn:Array = [];
			var sTmp:String;
			while (sCode.length > 0)
			{
				nNextSemicolon = sCode.indexOf(";");
				if (nNextSemicolon == -1)
					break;
				
				while (sCode.substring(0, nNextSemicolon).indexOf("(") != -1
					&& sCode.substring(0, nNextSemicolon).indexOf(")") == -1)
				{
					nNextSemicolon = sCode.indexOf(";", nNextSemicolon + 1);
				}
				
				
				nBraceFirst = sCode.indexOf("{");
				
				//	xx{yy}
				if (nBraceFirst < nNextSemicolon 
					&& nBraceFirst != -1)
				{
					nBraceLast = sCode.indexOf("}");
					sCmd = sCode.substring(0, nBraceLast + 1);
					while (sCmd.split("{").length != sCmd.split("}").length)
					{
						nBraceLast = sCode.indexOf("}", nBraceLast + 1);
						sCmd = sCode.substring(0, nBraceLast + 1);
					}
					arrReturn.push(sCmd);
					sCode = Remove(sCode, 0, sCmd.length);
				}
				else
				{
					sBody = sCode.substring(0, nNextSemicolon);
					sCode = Remove(sCode, 0, nNextSemicolon + 1);
					arrReturn.push(sBody);
				}
			}
			return arrReturn;
		}
		
		
		/**
		 * 
		 * @param code
		 * @return 
		 * 
		 */	
		public static function GetClassDefineSegments(code:String) : Array
		{
			var iLineEnd:int;
			var sCut:String;
			var iBraceEnd:int;
			var iBraceStart:int;
			var sNewCut:String;
			var sData:String = code;
			var listLines:Array = [];
			while (sData.length > 0)
			{
				iLineEnd = sData.indexOf("\r\n");
				sCut = sData.substring(0, iLineEnd);
				sData = Remove(sData, 0, iLineEnd + 2);
				if (sCut.indexOf("void ") != -1)
				{
					iBraceEnd = sCut.indexOf("}");
					iBraceStart = sCut.indexOf("{") == -1 ? 0 : 1;
					if (iBraceEnd != -1)
					{
						listLines.push(sCut);
					}
					else
					{
						iBraceEnd = sData.indexOf("}");
						sNewCut = sData.substring(0, iBraceEnd + 1);
						
						while (iBraceStart + sNewCut.split("{").length 
							!= sNewCut.split("}").length)
						{
							iBraceEnd = sData.indexOf("}", iBraceEnd + 1);
							sNewCut = sData.substring(0, iBraceEnd + 1);
						}
						listLines.push(sCut + sNewCut);
						sData = Remove(sData, 0, sNewCut.length);
					}
				}
				else if (sCut.length > 0)
				{
					listLines.push(sCut);
				}
			}
			return listLines;
		}
		
		
		private static function Remove(param1:String, param2:int, param3:int) : String
		{
			param2 = Math.max(param2, 0);
			param3 = Math.min(param3, param1.length);
			var _loc_4:* = param1.substring(0, param2);
			var _loc_5:* = param1.substring(param3, param1.length);
			return _loc_4 + _loc_5;
		}// end function
		
	}
}
