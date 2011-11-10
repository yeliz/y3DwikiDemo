package com.yogurt3d.test
{
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.managers.tickmanager.TickManager;
	import com.yogurt3d.core.managers.tickmanager.TimeInfo;
	import com.yogurt3d.core.objects.interfaces.ITickedObject;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class TargetCamera extends Camera implements ITickedObject
	{
		private var m_rotX:Number = 0;
		private var m_rotY:Number = 0;
		private var m_rotZ:Number = 0;
		private var m_dist:Number = 10;
		
		private var m_targetRotX:Number = 0;
		private var m_targetRotY:Number = 0;
		private var m_targetRotZ:Number = 0;
		private var m_targetDist:Number = 10;
		
		private var m_lastUpdateTime:uint = 0;
		
		private var m_limitEnabled:Boolean = false;
		
		private var m_limitRotXMin:Number = 0;
		
		private var m_limitRotXMax:Number = 90;
		
		private var m_matrix3d:Matrix3D;
		
		public function TargetCamera(_initInternals:Boolean=true)
		{
			super(_initInternals);
			TickManager.registerObject( this );
		}

		

		public function get limitRotXMax():Number
		{
			return m_limitRotXMax;
		}

		public function set limitRotXMax(value:Number):void
		{
			m_limitRotXMax = value;
		}

		public function get limitRotXMin():Number
		{
			return m_limitRotXMin;
		}

		public function set limitRotXMin(value:Number):void
		{
			m_limitRotXMin = value;
		}

		public function get limitEnabled():Boolean
		{
			return m_limitEnabled;
		}

		public function set limitEnabled(value:Boolean):void
		{
			m_limitEnabled = value;
		}

		public function get dist():Number
		{
			return m_targetDist;
		}

		public function set dist(value:Number):void
		{
			m_targetDist = value;
		}
		
		public function get rotZ():Number
		{
			return m_targetRotZ;
		}
		
		public function set rotZ(value:Number):void
		{
			m_targetRotZ = value;
		}

		public function get rotY():Number
		{
			return m_targetRotY;
		}

		public function set rotY(value:Number):void
		{
			m_targetRotY = value;
		}

		public function get rotX():Number
		{
			return m_targetRotX;
		}

		public function set rotX(value:Number):void
		{
			if( m_limitEnabled )
			{
				if( value > m_limitRotXMax )
					m_targetRotX = m_limitRotXMax;
				else if( value < m_limitRotXMin )
					m_targetRotX = m_limitRotXMin;
				else
					m_targetRotX = value;
			}else{
				m_targetRotX = value;
			}
			
		}
		public function updateWithTimeInfo(_timeInfo:TimeInfo):void{
			m_matrix3d = new Matrix3D();
					
			var _ease:Number = 0.1;
			
			var _dx:Number = m_targetRotX - m_rotX;
			var _dy:Number = m_targetRotY - m_rotY;
			var _dz:Number = m_targetRotZ - m_rotZ;
			
			var _dist:Number = _dx*_dx + _dy*_dy + _dz*_dz;
			
			var _dDist:Number = m_targetDist - m_dist;
			
			var _distDist:Number = _dDist * _dDist;
			
			if( _distDist < 0.0001 )
			{
				m_dist = m_targetDist;
			}else{
				m_dist += _dDist * _ease;
			}
			
			if( _dist < 0.0001 )
			{
				m_rotX = m_targetRotX;
				m_rotY = m_targetRotY;
				m_rotZ = m_targetRotZ;
			}else{
				m_rotX += _dx * _ease;
				m_rotY += _dy * _ease;
				m_rotZ += _dz * _ease;
			}
			
			
			m_matrix3d.identity();
			m_matrix3d.appendTranslation( 0, 0, m_dist);
			m_matrix3d.appendRotation( m_rotX, Vector3D.X_AXIS );
			m_matrix3d.appendRotation( m_rotY, Vector3D.Y_AXIS );
			m_matrix3d.appendRotation( m_rotZ, Vector3D.Z_AXIS );
			
			
			transformation.position = m_matrix3d.position;
			transformation.lookAt( new Vector3D );
			
		}

	}
}