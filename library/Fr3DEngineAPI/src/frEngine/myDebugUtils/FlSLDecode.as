package frEngine.myDebugUtils
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class FlSLDecode
	{
		private var decodeAgale:DecodeAGAL;
		private var getCharByNum:Dictionary=new Dictionary(false);
		public static var instance:FlSLDecode=new FlSLDecode();
		private var isVertextCode:Boolean=false;
		public function FlSLDecode()
		{
			getCharByNum[0]="x";
			getCharByNum[1]="y";
			getCharByNum[2]="z";
			getCharByNum[3]="w";

		}
		public   function decode(agalcode:ByteArray,$isVertextCode:Boolean,offCompile:Boolean,traceEmitCode:Boolean):void
		{
			isVertextCode=$isVertextCode;
			if(!decodeAgale)
			{
				decodeAgale=new DecodeAGAL();
			}
			var debugLine:String="";
			var dbgLine:String = "";
			var agalLength:uint = agalcode.length;
			for ( var index:uint = 0; index < agalLength; index++ )
			{
				var byteStr:String = agalcode[ index ].toString( 16 );
				if ( byteStr.length < 2 )
					byteStr = "0" + byteStr;
				
				dbgLine += byteStr;
			}
			var version:String = "a001000000a100";
			var startN:int=version.length;
			var endN:int=dbgLine.length;
			var source:String=isVertextCode?"vertexCode:\n":"fragmentCode:\n";
			var targetObject:Object={"resultStr":source,"debugLine":"emitCode:\n"};

			for(var i:int=startN;i<endN;i+=48)
			{
				getLineFormat(dbgLine.substr(i,48),targetObject,offCompile,traceEmitCode);
			}
			
			if(traceEmitCode)
			{
				trace(targetObject.debugLine);
			}
			if(offCompile)
			{
				trace(targetObject.resultStr);
			}
		}
		private  function getLineFormat(str:String,targetObject:Object,offCompile:Boolean,traceEmitCode:Boolean):void
		{
			var arr:Array=[8,4,2,2,4,2,2,2,2,4,4,2,2,2,2,4];
			var funList:Array=[parasCommand,
								parasDestRegistIndex,	parasDestRegistXYZW,	parasDestRegistName,
								parasSourceRelativeRegistIndex,parasSourceRelativeOffset,parasSourceRegistXYZW,parasSourceRegistName,parasSourceRelativeRegistName,parasSourceRegistRelativXYZW,
								parasSourceRelativeRegistIndex,parasSourceRelativeOffset,parasSourceRegistXYZW,parasSourceRegistName,parasSourceRelativeRegistName,parasSourceRegistRelativXYZW
								];
			var formatlist:Array=["	","	","		","		","	","	","		"," 	","	","	","	","		","		"," ","	",""];
			var parasFunList:Array=[];
			var len:int=arr.length;
			var _str:String="";
			
			var curStartN:int=0;
			var resultArr:Array=[];
			var _debugline:String="";
			for(var i:int=0;i<len;i++)
			{
				var charLen:int=arr[i];
				var emitCode:String=str.substr(curStartN,charLen);
				if(offCompile)
				{
					var fun:Function=funList[i];
					if(fun!=null)
					{
						var tempstr:String=fun.apply(null,[emitCode]);
						resultArr.push(tempstr);
					}else
					{
						resultArr.push("");
					}
				}
				if(traceEmitCode)
				{
					_debugline=_debugline+emitCode+formatlist[i];
				}
				
				curStartN+=charLen;
			}
			if(offCompile)
			{
				var commandName:String=resultArr[0];
				var desIndex:String=resultArr[1];
				var desRegistName:String=resultArr[3];
				var numRegister:int=decodeAgale.commandMap[commandName].numRegister;
				var flags:int=decodeAgale.commandMap[commandName].flags;
				var dest:String;
				var op_no_dest:int=decodeAgale.OP_NO_DEST_Flag
				var no_dest:Boolean=(op_no_dest & flags)==op_no_dest;
				if(no_dest){
					dest="";
				}else
				{
					var range:int=decodeAgale.REGMAP_Flag[desRegistName].range;
					if(Number(desIndex)>range-1)
					{
						desIndex="";
					}
					dest=getFormat(desRegistName+desIndex+resultArr[2]);
				}
				if(numRegister<=2)
				{
					_str=getFormat(commandName)+dest+
						getSourceRegistString(resultArr[7],	resultArr[8],	resultArr[9],	resultArr[4],	resultArr[5],	resultArr[6]);
				}else
				{
					_str=getFormat(commandName)+dest+
						getSourceRegistString(resultArr[7],	resultArr[8],	resultArr[9],	resultArr[4],	resultArr[5],	resultArr[6])+
						getSourceRegistString(resultArr[13],	resultArr[14],	resultArr[15],	resultArr[10],	resultArr[11]	,resultArr[12]);
				}
				

				targetObject.resultStr+=_str+"\n";
			}
			if(traceEmitCode)
			{
				targetObject.debugLine=targetObject.debugLine+_debugline+"\n";
			}
			
		}
		private function getFormat(str:String):String
		{
			var format:String="              ";
			var len:int=format.length;
			var strLen:int=str.length;
			for(var i:int=strLen;i<len;i++)
			{
				str+=" ";
			}
			return str;
		}
		private function getSourceRegistString(sourceRegistName:String,
											   relativeRegistName:String,
											   relativeRegistXYZW:String,
											   registIndex:String,
											   relativeOffset:String,
											   sourceRegistXYZW:String):String
		{
			
			var restultStr:String="";
			var index1:String=relativeRegistXYZW.charAt(0);
			var index2:String=relativeRegistXYZW.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var paramStr:String="";
			if(isVertextCode)
			{
				if(relativeRegistXYZW!="0000")
				{
					var num:int=num1*16+num2;
					paramStr="."+getCharByNum[num];
				}
			}
			
			var range:int;
			if(sourceRegistName=="fs")
			{
				var index3:String=relativeRegistXYZW.charAt(2);
				var index4:String=relativeRegistXYZW.charAt(3);
				var num3:int=changeCharToNumber(index3);
				var num4:int=changeCharToNumber(index4);
				
				var repeatOrNo:String=decodeAgale.getRepeatOrNoByemitCode[num1].name;
				var linearOrNearest:String=decodeAgale.getLinearOrNearestByemitCode[num3].name;
				var miplinear:String=decodeAgale.getMiplinearByemitCode[num4].name;
				var samplemapParams:String=linearOrNearest+","+miplinear+","+repeatOrNo+","+int(Number(relativeOffset)/8);
				
				range=decodeAgale.REGMAP_Flag[sourceRegistName].range;
				if(Number(registIndex)>range-1)
				{
					registIndex="";
				}
				restultStr = sourceRegistName+registIndex+" <"+relativeRegistName+","+samplemapParams+">";
			}else
			{
				if(paramStr=="")
				{
					range=decodeAgale.REGMAP_Flag[sourceRegistName].range;
					if(Number(registIndex)>range-1)
					{
						registIndex="";
					}
					restultStr = sourceRegistName+registIndex+sourceRegistXYZW;
				}else
				{
					range=decodeAgale.REGMAP_Flag[relativeRegistName].range;
					if(Number(registIndex)>range-1)
					{
						registIndex="";
					}
					restultStr = sourceRegistName+"["+relativeRegistName+registIndex+paramStr+"+"+relativeOffset+"]";
				}
				
			}
				
			
			return getFormat(restultStr);
		}
		private  function parasCommand(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var regist:Object=decodeAgale.getOpCodeByemitCode[num1*16+num2];
			if(regist)
			{
				return regist.name
			}else
			{
				return "";
			}
		}
		
		
		private  function parasDestRegistIndex(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var num:int=num1*16+num2;
			return String(num);
		}
		private  function parasDestRegistName(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var obj:Object;
			if(isVertextCode)
			{
				obj=decodeAgale.getVertextRegisterByemitCode[num1*16+num2];
				if(obj)
				{
					return obj.name;
				}else
				{
					return "";
				}
				
			}else
			{
				
				obj=decodeAgale.getFragmentRegisterByemitCode[num1*16+num2];
				if(obj)
				{
					return obj.name;
				}else
				{
					return "";
				}
			}
			
		}
		private  function parasDestRegistXYZW(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var num:int=num1*16+num2;
			
			if(num==0xf)
			{
				return ""
			}else
			{
				
				var X:int=num&1;
				var Y:int=(num>>1)&1;
				var Z:int=(num>>2)&1;
				var W:int=(num>>3)&1;
				var __x:String=X==1?"x":"";
				var __y:String=Y==1?"y":"";
				var __z:String=Z==1?"z":"";
				var __w:String=W==1?"w":"";
				return "."+__x+__y+__z+__w;
			}
			
		}
		private  function parasSourceRegistName(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var num:int=num1*16+num2
			if(isVertextCode)
			{
				return decodeAgale.getVertextRegisterByemitCode[num].name;
			}else
			{
				if(num==0)
				{
					return "";
				}else
				{
					return decodeAgale.getFragmentRegisterByemitCode[num1*16+num2].name;
				}
				
			}
		}
		
		private  function parasSourceRelativeRegistName(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			if(isVertextCode)
			{
				return decodeAgale.getVertextRegisterByemitCode[num1*16+num2].name;
			}else
			{
				return decodeAgale.getD2ByemitCode[num1].name;
			}
		}
		
		private  function parasSourceRegistIndex(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			return String(num1*16+num2);
			return null;
		}
		private  function parasSourceRelativeRegistIndex(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			return String(num1*16+num2);
		}
		
		private  function parasSourceRelativeOffset(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var num:int=num1*16+num2;
			if(num==0)
			{
				return "";
			}else
			{
				return String(num1*16+num2);
			}
			
		}
		
		private  function parasSourceRegistXYZW(emitCode:String):String
		{
			var index1:String=emitCode.charAt(0);
			var index2:String=emitCode.charAt(1);
			var num1:int=changeCharToNumber(index1);
			var num2:int=changeCharToNumber(index2);
			var num:int=num1*16+num2;
			if(num==0xe4)return "";
			var X:int=num&3;
			var Y:int=(num>>2)&3;
			var Z:int=(num>>4)&3;
			var W:int=(num>>6)&3;
			var str:String=getCharByNum[X]+getCharByNum[Y]+getCharByNum[Z]+getCharByNum[W];
			var len:int=str.length;
			var lastflag:String=str.charAt(len-1);
			for(var i:int=len-2;i>=0;i--)
			{
				var char:String=str.charAt(i);
				if(char==lastflag)
				{
					str=str.substring(0,i+1);
				}else
				{
					break;
				}
			}
			return "."+str;
		}
		private  function parasSourceRegistRelativXYZW(emitCode:String):String
		{
			return emitCode;
		}
		

		private  function changeCharToNumber(value:String):int{
			
			var str:String=value.toLowerCase();
			if(isNaN(Number(value)))
			{
				str=str.toLocaleLowerCase();
				return 10+str.charCodeAt(0)-97;
			}else
			{
				return Number(value);
			}
			
			
			
		}
	}
}