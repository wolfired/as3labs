package idiot.molehill {

	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import idiot.molehill.model.Obj;

	public class Molehill {
		private static const TRIGGER:Shape = new Shape();

		public function Molehill(stage:Stage) {
			_stage = stage;
		}

		public var obj:Obj;
		public var bd:BitmapData;

		private var _stage:Stage;
		private var _stage3d:Stage3D;
		private var _context3d:Context3D;

		private var vertexbuffer:VertexBuffer3D;
		private var indexbuffer:IndexBuffer3D;
		private var program:Program3D;
		private var texture:Texture;

		public function boot(index:uint):void {
			if(_stage.stage3Ds.length <= index) {
				return;
			}
			_stage3d = _stage.stage3Ds[index];
			_stage3d.addEventListener(Event.CONTEXT3D_CREATE, onCreate);
			_stage3d.requestContext3D();
		}

		private function onCreate(event:Event):void {
			_context3d = _stage3d.context3D;
			_context3d.configureBackBuffer(_stage.stageWidth, _stage.stageHeight, 1, true);
			_context3d.setCulling(Context3DTriangleFace.FRONT);

			var vertices:Vector.<Number> = null; //obj.getVertices(Obj.FLAG_V | Obj.FLAG_VT);

			vertexbuffer = _context3d.createVertexBuffer(vertices.length / 5, 5);
			vertexbuffer.uploadFromVector(vertices, 0, vertices.length / 5);

			var indices:Vector.<uint> = null; //obj.getIndices();

			indexbuffer = _context3d.createIndexBuffer(indices.length);
			indexbuffer.uploadFromVector(indices, 0, indices.length);

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
										   "m44 op, va0, vc0\n" + // pos to clipspace
										   "mov v0, va1" // copy color
										   );

			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
											 "tex ft1, v0, fs0 <2d>\n" +
											 "mov oc, ft1"
											 );

			program = _context3d.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);

			texture = _context3d.createTexture(bd.width, bd.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bd);

			TRIGGER.addEventListener(Event.ENTER_FRAME, onRender);
		}

		private function onRender(event:Event):void {
			_context3d.clear(1, 1, 1, 0.6);

			// vertex position to attribute register 0
			_context3d.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// color to attribute register 1
			_context3d.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);

			_context3d.setTextureAt(0, texture);

			// assign shader program
			_context3d.setProgram(program);

			var m:Matrix3D = new Matrix3D();
			m.appendRotation(getTimer() / 40, Vector3D.X_AXIS);
			m.appendRotation(getTimer() / 40, Vector3D.Y_AXIS);
			m.appendRotation(getTimer() / 40, Vector3D.Z_AXIS);
//			m.appendRotation(45, Vector3D.X_AXIS);
			m.appendScale(0.25, 0.25, 0.25);
			m.appendTranslation(0.0, 0.0, 0.0);

			_context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);

			_context3d.drawTriangles(indexbuffer);

			_context3d.present();
		}
	}
}
