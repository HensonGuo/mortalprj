package frEngine.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.loaders.away3dMd5.JointPose;
	import frEngine.math.Quaternion;
	import frEngine.shader.filters.FilterName_ID;

	public class SwordLightSurface extends FrSurface3D
	{
		private var splitNum:int=10;
		public var totalNumLine:int=0;
		public var totalTriangle:Number=0;

		public function SwordLightSurface(name:String,framesPoseList:Vector.<JointPose>,swordLightLen:int,offsetY:int,$splitNum:int)
		{
			super(name);
			splitNum=$splitNum;
			init(framesPoseList,swordLightLen,offsetY);
			
		}

		private function init(framesPoseList:Vector.<JointPose>,swordLightLen:int,offsetY:int):void
		{
			
			var len:int=framesPoseList.length;
			totalNumLine=(len-1)*splitNum;
			totalTriangle=(totalNumLine-1)*2;
			var p1:Vector3D=new Vector3D(0,swordLightLen/2+offsetY,0);
			var p2:Vector3D=new Vector3D(0,-swordLightLen/2+offsetY,0);
			var preMatrix3d:Matrix3D=Md5SkinAnimateControler.defaultOffsetMatrix3d;
			p1=preMatrix3d.transformVector(p1);
			p2=preMatrix3d.transformVector(p2);
			
			var f1:FrVertexBuffer3D = addVertexData(FilterName_ID.POSITION_ID, 3, true, null);
			var resultVector:Vector.<Number> = f1.vertexVector;
			//var debug:Array=[];
			createPointList(framesPoseList,p1,resultVector);
			createPointList(framesPoseList,p2,resultVector);

			createUV();
			createTriangleIndex();
			
			this.numTriangles=0;
			
			/*var frame:DebugWireframe=new DebugWireframe(debug,0xff0000);
			Device3D.scene.addChild(frame);*/
		}
		//debug:Array
		private function createPointList(framesPoseList:Vector.<JointPose>,point:Vector3D,resultVector:Vector.<Number>):void
		{
			var scaleValue:Number=2;
			var len:int=framesPoseList.length;
			var targetPointList:Vector.<Vector3D> = new Vector.<Vector3D>();
			var rp:Vector3D=new Vector3D();
			var bone:JointPose=framesPoseList[0];
			var lastOr:Quaternion=bone.orientation;
			var lastTr:Vector3D=bone.translation;
			lastOr.rotatePoint(point,rp);
			var lastPoint:Vector3D=new Vector3D(rp.x+lastTr.x,rp.y+lastTr.y,rp.z+lastTr.z);
			targetPointList.push(lastPoint);
			
			
			bone=framesPoseList[1];
			var midOr:Quaternion=bone.orientation;
			var midTr:Vector3D=bone.translation;
			
			midOr.rotatePoint(point,rp);
			var midPoint:Vector3D=new Vector3D(rp.x+midTr.x,rp.y+midTr.y,rp.z+midTr.z);
			targetPointList.push(midPoint);

			var normalList:Vector.<Vector3D>=new Vector.<Vector3D>();
			var curBeiser:Vector.<Number>=new Vector.<Number>();
			var headOr:Quaternion;
			var headTr:Vector3D;
			var lastLineDir:Vector3D;
			var preFaceNormal:Vector3D=new Vector3D();
			for(var i:int=2;i<len;i++)
			{
				bone=framesPoseList[i];
				headOr=bone.orientation;
				headTr=bone.translation;
				headOr.rotatePoint(point,rp);
				var headPoint:Vector3D=new Vector3D(rp.x+headTr.x,rp.y+headTr.y,rp.z+headTr.z);
				targetPointList.push(headPoint);
				
				var _p1:Vector3D=lastPoint.subtract(midPoint);
				var _p2:Vector3D=headPoint.subtract(midPoint);
				var len1:Number=_p1.normalize();
				var len2:Number=_p2.normalize();
				
				var rate1:Number=0.5-len1/(len1+len2);
				var _temp1:Vector3D=_p1.add(_p2);
				var faceNormal:Vector3D=_p1.crossProduct(_p2);
				faceNormal.normalize();
				_temp1.normalize();
				
				var midNormal:Vector3D=_temp1.crossProduct(faceNormal);
				var disAngle:Number=_p1.dotProduct(_p2);
				disAngle=1-Math.acos(disAngle)/Math.PI;

				_temp1.scaleBy(rate1*disAngle*disAngle*10);
				midNormal=midNormal.add(_temp1);

				midNormal.normalize();
				midNormal.w=len1;
				normalList.push(midNormal);
				
				lastPoint=midPoint;
				midPoint=headPoint;
			}
			
			headPoint=targetPointList[0];
			midNormal=lastPoint.subtract(headPoint);
			len1=midNormal.normalize();
			midNormal.w=len1;
			normalList.push(midNormal);
			
			lastPoint=midPoint;
			midPoint=headPoint;
			headPoint=targetPointList[1];
			midNormal=headPoint.subtract(lastPoint);
			len1=midNormal.normalize();
			midNormal.w=len1;
			normalList.unshift(midNormal);
			
			var preNormal:Vector3D=normalList[0];
			var prePoint:Vector3D=targetPointList[0];
			
			var resultPoint:Vector3D=new Vector3D();
			for(i=1;i<len;i++)
			{
				var curNormal:Vector3D=normalList[i];
				var curPoint:Vector3D=targetPointList[i];
				len1=curNormal.w;
				
				var rate:Number=Math.acos(curNormal.dotProduct(preNormal))/Math.PI;

				len1*=rate*rate*0.37+0.31;

				curBeiser.push(prePoint.x-preNormal.x*len1,prePoint.y-preNormal.y*len1,prePoint.z-preNormal.z*len1);
				curBeiser.push(curPoint.x+curNormal.x*len1,curPoint.y+curNormal.y*len1,curPoint.z+curNormal.z*len1);
				
				preNormal=curNormal;
				prePoint=curPoint;
				
			}
			
			curNormal=normalList[0];
			curPoint=targetPointList[0];
			len1=curNormal.w;

			curBeiser.push(prePoint.x-preNormal.x*len1,prePoint.y-preNormal.y*len1,prePoint.z-preNormal.z*len1);
			curBeiser.push(curPoint.x+curNormal.x*len1,curPoint.y+curNormal.y*len1,curPoint.z+curNormal.z*len1);
			
			
			var firstP:Vector3D=targetPointList[0];
			
			var secondP:Vector3D=new Vector3D();

			var curN:int=0;

			var end:int=len-1;
			
			for(i=0;i<end;i++)
			{
				bone=framesPoseList[i];
				headOr=bone.orientation;
				secondP=targetPointList[i+1];
				
				var fx:Number=curBeiser[curN++];
				var fy:Number=curBeiser[curN++]
				var fz:Number=curBeiser[curN++]

				var sx:Number=curBeiser[curN++];
				var sy:Number=curBeiser[curN++];
				var sz:Number=curBeiser[curN++];

				var px:Number=firstP.x;
				var py:Number=firstP.y;
				var pz:Number=firstP.z;
				
				var qx:Number=secondP.x;
				var qy:Number=secondP.y;
				var qz:Number=secondP.z;
				
				/*debug && debug.push([px,py,pz,fx,fy,fz,fx+5,fy+5,fz+5]);
				debug && debug.push([qx,qy,qz,sx,sy,sz,sx+5,sy+5,sz+5]);*/
				for(var j:int=0;j<splitNum;j++)
				{
					var t:Number=j/splitNum;
					var t2:Number=t*t;
					var t3:Number=t2*t;
					var n:Number=1-t;
					var n2:Number=n*n;
					var n3:Number=n2*n;
					
					var t0n2:Number=3*t*n2;
					var t2n0:Number=3*t2*n;
					
					var rx:Number=px*n3+fx*t0n2+sx*t2n0+qx*t3;
					var ry:Number=py*n3+fy*t0n2+sy*t2n0+qy*t3;
					var rz:Number=pz*n3+fz*t0n2+sz*t2n0+qz*t3;

					resultVector.push(rx,ry,rz);
				}
				firstP=secondP;
			}
		}
		private function createUV():void
		{
			var uvvector:Vector.<Number> = new Vector.<Number>;
			var perData1:Number = 1 / totalNumLine;
			var uValue:Number;
			for (var i:int = 0; i < totalNumLine; i++)
			{
				uValue = i * perData1;
				uvvector.push(uValue, 1);
			}
			for (i = 0; i < totalNumLine; i++)
			{
				uValue = i * perData1;
				uvvector.push(uValue, 0);
			}
			var f1:FrVertexBuffer3D = addVertexData(FilterName_ID.UV_ID, 2, true, null);
			f1.vertexVector = uvvector;
		}
		
		private function createTriangleIndex():void
		{
			var triangleNum:int=totalNumLine-1;
	
			var indexVector:Vector.<uint> = new Vector.<uint>;
			var i:int, n:int;
			
			for (i = 0; i < triangleNum; i++)
			{
				
				n = i+totalNumLine;
				indexVector.push(i);
				indexVector.push(i+1);
				indexVector.push(n);
				
				indexVector.push(i + 1);
				indexVector.push(n + 1);
				indexVector.push(n );
			}

			indexBufferFr.indexVector = indexVector;
		}
	}
}