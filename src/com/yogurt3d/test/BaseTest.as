package com.yogurt3d.test
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.events.Yogurt3DEvent;
	import com.yogurt3d.core.managers.contextmanager.Context;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	import com.yogurt3d.core.sceneobjects.Scene;
	import com.yogurt3d.core.viewports.Viewport;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BaseTest extends Sprite implements ITickedObject
	{
		private var 	m_camera		:Camera;
		private var 	m_scene		:Scene;
		private var 	m_viewport	:Sprite;;
		protected var 	m_textField	:TextField;
		private var 	m_context		:Context;
		
		private var m_timeInfo:TimeInfo;
		
		public function BaseTest()
		{
			Yogurt3D.instance.addEventListener( Yogurt3DEvent.READY, onContext3DReady );
			Yogurt3D.instance.init(stage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		public function get context():Context
		{
			return m_context;
		}

		public function set context(value:Context):void
		{
			m_context = value;
		}

		public function get viewport():Sprite
		{
			return m_viewport;
		}

		public function set viewport(value:Sprite):void
		{
			m_viewport = value;
		}

		public function get scene():Scene
		{
			return m_scene;
		}

		public function set scene(value:Scene):void
		{
			m_scene = value;
		}

		public function get camera():Camera
		{
			return m_camera;
		}

		public function set camera(value:Camera):void
		{
			if( m_camera != null )
			{
				m_scene.removeChild( m_camera );
				
			}
			m_camera = value;
			m_context.camera = value;
			m_scene.addChild( m_camera );
		}
		private function updateCamera():void{
			Yogurt3D.instance.defaultCamera.setProjectionPerspective( 45, stage.stageWidth/stage.stageHeight,0.1,10000);
		}
		protected function onContext3DReady(event:Event):void
		{
			stage.addEventListener( Event.RESIZE, function( _e:Event ):void{
				Yogurt3D.instance.defaultViewport.setViewport(0,0,stage.stageWidth, stage.stageHeight );
				updateCamera();
			});
			Yogurt3D.instance.defaultSetup(800, 600);
			m_context			= Yogurt3D.instance.defaultContext;
			
			m_camera 			= Yogurt3D.instance.defaultCamera 		as Camera;
			
			m_scene				= Yogurt3D.instance.defaultScene 		as Scene;
			m_scene.sceneColor.setColorUint(0x333333);
			
			m_viewport			= Yogurt3D.instance.defaultViewport;
			
			addChildAt(m_viewport, 0);
			
			m_camera.transformation.z = 100;
			m_camera.transformation.y = 15;
			//m_camera.transformation.lookAt(new Vector3D(0,0,0) );
			
			camera = new FreeFlightCamera();
			updateCamera();
			
			CameraController.init(stage, m_camera);
			
			Yogurt3D.instance.enginePostUpdateCallback	= onPostUpdateCallback;
			
			TickManager.registerObject( this );
			
			loadObjects();
		}
		
		public function setupTargetCamera():void{
			camera = new TargetCamera();
			
			CameraController.camera = camera;
			updateCamera();
		}
		
		public function setupFreeFlightCamera():void{
			camera = new FreeFlightCamera();
			
			CameraController.camera = camera;
			updateCamera();
		}
		
		protected function loadObjects():void
		{
			createSceneObjects();
		}
		
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			m_timeInfo = _timeInfo;
			onUpdate( _timeInfo );
		}
		
		public function createSceneObjects(e:Event = null):void
		{
			
		}
		
		public function onUpdate(_timeInfo:TimeInfo):void
		{
			
		}
		
		
		private function onPostUpdateCallback():void
		{
			onPostUpdate( m_timeInfo );
		}
		
		public function onPostUpdate(_timeInfo:TimeInfo):void
		{
			
		}
		
		
		
		
	}
}