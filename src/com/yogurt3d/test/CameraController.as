package com.yogurt3d.test
{
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import org.osmf.net.SwitchingRuleBase;

	public class CameraController implements ITickedObject
	{

		private static var m_stage:Stage;

		private static var m_camera:Camera;
		
		private static var m_isCtrlDown:Boolean;
		private static var m_isShiftDown:Boolean;
		private static var m_isLookAtLocked:Boolean = false;
		
		private static var m_mouseLastX:Number;
		private static var m_mouseLastY:Number;
		
		private static var m_cameraLastX:Number;
		private static var m_cameraLastY:Number;
		private static var m_cameraLastZ:Number;
		
		private static var m_cameraLastRotX:Number;
		private static var m_cameraLastRotY:Number;
		private static var m_cameraLastRotZ:Number;
		
		private static var m_moveRatio:Number = 0.2;
		private static var m_rotateRatio:Number = 0.2;
		
		private static var m_leftKey		:Boolean = false;
		private static var m_rightKey		:Boolean = false;
		private static var m_upKey			:Boolean = false;
		private static var m_downKey		:Boolean = false;
		
		public static var m_moveCamera:Boolean = true;
		public static var lookAtTarget:Vector3D = new Vector3D();
		
		public static function get camera():Camera
		{
			return m_camera;
		}

		public static function set camera(value:Camera):void
		{
			m_camera = value;
		}

		public static function get rotateRatio():Number
		{
			return m_rotateRatio;
		}

		public static function set rotateRatio(value:Number):void
		{
			m_rotateRatio = value;
		}

		public static function get moveRatio():Number
		{
			return m_moveRatio;
		}

		public static function set moveRatio(value:Number):void
		{
			m_moveRatio = value;
		}

		public static function init(_stage:Stage, _camera:Camera):void {
			
			TickManager.registerObject( new CameraController() );
			
			m_stage = _stage;
			m_camera = _camera;
			
			addEventListeners();
		}
		
		private static function addEventListeners():void
		{
			m_stage.addEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDown);
			m_stage.addEventListener(MouseEvent.MOUSE_UP, 		onMouseUp);
			m_stage.addEventListener(KeyboardEvent.KEY_DOWN, 	onKeyDown);
			m_stage.addEventListener(KeyboardEvent.KEY_UP, 		onKeyUp );
			m_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			m_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		protected static function onMouseDown(event:MouseEvent):void
		{
			
			
		}
		
		protected static function onMouseUp(event:MouseEvent):void
		{
			
		}
		
		public static function set moveCamera(_value:Boolean):void{
			m_moveCamera = _value;
		}
		
		protected static function onMouseWheel(event:MouseEvent):void
		{
			
			if(m_moveCamera){
				if ( m_camera is TargetCamera )
				{
					TargetCamera( m_camera ).dist += event.delta * m_moveRatio;
				}
			}
			
		}
		
		public static function onMouseMove(event:MouseEvent):void
		{
			var _offsetX:Number 	= m_mouseLastX - event.localX;
			var _offsetY:Number 	= m_mouseLastY - event.localY;
						
			if (event.buttonDown && m_camera is TargetCamera)
			{
				TargetCamera( m_camera ).rotY += _offsetX * m_rotateRatio;
				TargetCamera( m_camera ).rotX += _offsetY * m_rotateRatio;
			}
			if (event.buttonDown && m_camera is FreeFlightCamera)
			{
				FreeFlightCamera( m_camera ).transformation.rotationY += _offsetX * m_rotateRatio;
				FreeFlightCamera( m_camera ).transformation.rotationX += _offsetY * m_rotateRatio;
			}
			
			m_mouseLastX 	= event.localX;
			m_mouseLastY 	= event.localY;
			
			
		}
		protected static function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 65: // A key
					m_leftKey = true;
					break;
				case 68: // D Key
					m_rightKey = true;
					break;
				case 83: // S Key
					m_downKey = true;
					break;
				case 87: // W Key
					m_upKey = true;
					break;
				case 76: // L Key
					break;
				
				case 16: // SHIFT key
					if (!m_isShiftDown) {
						m_isShiftDown = true;
					}
					
					break;
				
				case 17: // CTRL key
					if (!m_isCtrlDown) {
						m_isCtrlDown = true;
					}
					break;	
				
			}

			

		}
		
		protected static function onKeyUp(event:KeyboardEvent):void
		{
			m_mouseLastX = m_stage.mouseX;
			m_mouseLastY = m_stage.mouseY;
			
			switch(event.keyCode)
			{
				case 65: // A key
					m_leftKey = false;
					break;
				case 68: // D Key
					m_rightKey = false;
					break;
				case 83: // S Key
					m_downKey = false;
					break;
				case 87: // W Key
					m_upKey = false;
					break;
				
				case 16: // SHIFT key
					m_isShiftDown = false;
					break;
				
				case 17: // CTRL Key
					m_isCtrlDown = false;
					break;	
				
			}
		}
		
		protected function disable():void {
			m_stage.removeEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDown);
			m_stage.removeEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
			m_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			m_stage.removeEventListener(KeyboardEvent.KEY_UP, 	onKeyUp );
		}
		
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			if( m_leftKey && m_camera is FreeFlightCamera )
			{
				FreeFlightCamera( m_camera ).moveLocalX( -5 );
			}
			if( m_rightKey && m_camera is FreeFlightCamera )
			{
				FreeFlightCamera( m_camera ).moveLocalX( 5 );
			}
			if( m_downKey && m_camera is FreeFlightCamera )
			{
				FreeFlightCamera( m_camera ).moveLocalZ( 5 );
			}
			if( m_upKey && m_camera is FreeFlightCamera )
			{
				FreeFlightCamera( m_camera ).moveLocalZ( -5 );
			}
		}
		
	}
}